  ;XIncludeFile "RJSON_Res.pb"
  CompilerIf #PB_Compiler_Thread = #True
    Import "C:\Program Files\PureBasic\Compilers\ObjectManagerThread.lib"
  CompilerElse
    Import "C:\Program Files\PureBasic\Compilers\ObjectManager.lib"
  CompilerEndIf
    Object_GetOrAllocateID  (Objects, Object.l) As "_PB_Object_GetOrAllocateID@8"
    Object_GetObject        (Objects, Object.l) As "_PB_Object_GetObject@8"
    Object_IsObject         (Objects, Object.l) As "_PB_Object_IsObject@8"
    Object_EnumerateAll     (Objects, ObjectEnumerateAllCallback, *VoidData) As "_PB_Object_EnumerateAll@12"
    Object_EnumerateStart   (Objects) As "_PB_Object_EnumerateStart@4"
    Object_EnumerateNext    (Objects, *object.Long) As "_PB_Object_EnumerateNext@8"
    Object_EnumerateAbort   (Objects) As "_PB_Object_EnumerateAbort@4"
    Object_FreeID           (Objects, Object.l) As "_PB_Object_FreeID@8"
    Object_Init             (StructureSize.l, IncrementStep.l, ObjectFreeFunction) As "_PB_Object_Init@12"
    Object_GetThreadMemory  (MemoryID.l) As "_PB_Object_GetThreadMemory@4"
    Object_InitThreadMemory (Size.l, InitFunction, EndFunction) As "_PB_Object_InitThreadMemory@12"
  EndImport

  Declare RJSONFree(ID.l)
    
  ProcedureDLL RJSON_Init()
    Global RJSONObjects 
    RJSONObjects = RJSON_INITIALIZE(@RJSONFree())
  EndProcedure
  ProcedureDLL RJSON_Create(ID.l, Encoding.l = #PB_UTF8)
    Protected *RObject.S_RJSON = RJSON_NEW(ID)
    With *RObject
      \ID   = *RObject
      \XML  = CreateXML(#PB_Any, Encoding)
      \CurrentNode  = RootXMLNode(\XML)
    EndWith
    ProcedureReturn *RObject
  EndProcedure
  ProcedureDLL RJSON_Is(ID.l)
    ProcedureReturn RJSON_ISID(ID)
  EndProcedure
  Procedure RJSONFree(ID.l)
    Protected *RObject.S_RJSON
  	If *RObject
      RJSON_FREEID(Id)
    EndIf
    ProcedureReturn #True
  EndProcedure
  ProcedureDLL RJSON_Free(ID.l)
    ProcedureReturn RJSONFree(ID.l)
  EndProcedure
  ProcedureDLL RJSON_Parse(ID.l, Content.s)
    Protected *RObject.S_RJSON = RJSON_ID(ID)
    If *RObject <>  #Null
      Protected c.s
      With *RObject
        While i < Len(Content)
          c = Mid(Content, i, 1)
          Select c
            Case "{" ; Ouverture d'un objet
              \CurrentNode = CreateXMLNode(\CurrentNode)
              SetXMLNodeName(\CurrentNode, "node")
              JustOpen = #True
            Case "[" ; Ouverture d'un tableau
              \CurrentNode = CreateXMLNode(\CurrentNode)
              SetXMLNodeName(\CurrentNode, "array")
              \CurrentNode = CreateXMLNode(\CurrentNode)
              SetXMLNodeName(\CurrentNode, "array_item")
              JustOpen = #True
              InArray = #True
            Case "}"; Fermeture d'un objet
              \CurrentNode = ParentXMLNode(\CurrentNode)
            Case "]"; Fermeture d'un tableau
              \CurrentNode = ParentXMLNode(\CurrentNode)
              \CurrentNode = ParentXMLNode(\CurrentNode)
              InArray = #False
            Case "," ; Element suivant dans l'objets
              \CurrentNode = CreateXMLNode(ParentXMLNode(\CurrentNode))
              ; si l'élément précédent était un tableau, on lui redonne le meme nom
              If Trim(GetXMLNodeName(ChildXMLNode(ParentXMLNode(\CurrentNode), XMLChildCount(ParentXMLNode(\CurrentNode))-1))) = "array_item"
                SetXMLNodeName(\CurrentNode, "array_item")
              Else
                SetXMLNodeName(\CurrentNode, "node")
              EndIf
              JustOpen = #True
            Case ":"
              If JustOpen = #True And InArray = #True
                ; Si on vient de rentrer dans un objet et dans un tableau
                ; Mais sans savoir que ce que l'on lisait était un nom d'élément
                ; on donne au nom le texte, et au texte rien
                SetXMLNodeName(\CurrentNode, GetXMLNodeText(\CurrentNode))
                SetXMLNodeText(\CurrentNode, "")
              EndIf
              JustOpen = #False
            Default
              If Not (c = Chr(34))
                If JustOpen = #False Or (JustOpen = #True And InArray = #True)
                  SetXMLNodeText(\CurrentNode, LTrim(GetXMLNodeText(\CurrentNode) + c))
                Else
                  If GetXMLNodeName(\CurrentNode) = "node"
                    SetXMLNodeName(\CurrentNode, c)
                  Else
                    If Len(Trim(GetXMLNodeName(\CurrentNode))) > 0
                      SetXMLNodeName(\CurrentNode, LTrim(GetXMLNodeName(\CurrentNode) + c))
                    Else
                      SetXMLNodeName(\CurrentNode, GetXMLNodeName(\CurrentNode) + c)
                    EndIf
                  EndIf
                EndIf
              EndIf
          EndSelect
          i + 1
        Wend
      ProcedureReturn \XML
      EndWith
    Else
      ProcedureReturn -1
    EndIf
  EndProcedure


;   ProcedureDLL RJSON_(ID.l)
;     Protected *RObject.S_RJSON = RJSON_ID(ID)
;     If *RObject <>  #Null
;       With *RObject
;   
;       EndWith
;       ProcedureReturn #True
;     Else
;       ProcedureReturn #False
;     EndIf
;   EndProcedure

