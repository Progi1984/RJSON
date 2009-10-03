  Global FileRTF1.l
  Global FileRTF2.l
  Global Content1.s = ""
  Global Content2.s = ""
  
  FileRTF1 = OpenFile(#PB_Any, "Data\Sample_File1.json")
  Repeat
    Content1 + ReadString(FileRTF1, #PB_Ascii)
  Until Eof(FileRTF1) > 0  
  CloseFile(FileRTF1)
  
  FileRTF2 = OpenFile(#PB_Any, "Data\Sample_File2.json")
  Repeat
    Content2 + ReadString(FileRTF2, #PB_Ascii)
  Until Eof(FileRTF2) > 0  
  CloseFile(FileRTF2)
  
  RJSON_Create(1, #PB_UTF8)
  JSONSample1 = RJSON_Create(#PB_Any, #PB_UTF8)
  
    XML1 = RJSON_Parse(1, Content1)
    XML2 = RJSON_Parse(JSONSample1, Content2)
    
    FormatXML(XML1, #PB_XML_ReFormat|#PB_XML_ReIndent)
    FormatXML(XML2, #PB_XML_ReFormat|#PB_XML_ReIndent)
  
    SaveXML(XML1, "Data\RJSON_Sample1.xml")
    SaveXML(XML2, "Data\RJSON_Sample2.xml")
  
  RJSON_Free(1)
  RJSON_Free(JSONSample1)
  