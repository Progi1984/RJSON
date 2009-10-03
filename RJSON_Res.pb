  
  Structure S_RJSON_Node
    Element.s
    nNodes.l
    *Superior.S_RJSON_Node
    *Siblings.S_RJSON_Node
    *Children.S_RJSON_Node
  EndStructure
  Structure S_RJSON_Tree 
    *Current.S_RJSON_Node
  EndStructure
  Structure S_RJSON
    ID.l
    XML.l
    CurrentNode.l
  EndStructure
  
  
  Macro RJSON_ID(object)
    Object_GetObject(RJSONObjects, object)
  EndMacro
  Macro RJSON_ISID(object)
    Object_IsObject(RJSONObjects, object) 
  EndMacro
  Macro RJSON_NEW(object)
    Object_GetOrAllocateID(RJSONObjects, object)
  EndMacro
  Macro RJSON_FREEID(object)
    If object <> #PB_Any And RJSON_IS(object) = #True
      Object_FreeID(RJSONObjects, object)
    EndIf
  EndMacro
  Macro RJSON_INITIALIZE(hCloseFunction)
    Object_Init(SizeOf(S_RJSON), 1, hCloseFunction)
  EndMacro
  
; IDE Options = PureBasic 4.20 (Windows - x86)
; Folding = A9
; EnableUnicode