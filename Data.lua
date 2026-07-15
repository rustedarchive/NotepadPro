local HttpService = game:GetService("HttpService")



local Data = {
  
    State = {
    
        Notes = {},
    
        CurrentNoteId = nil,
    
        AutoSave = true,
    
        SearchQuery = ""
    
  }
  
}



function Data:Save()
  
    if writefile then
    
        pcall(function()
        
            writefile("WindNotepad_Data.json", HttpService:JSONEncode(self.State.Notes))
        
      end)
    
  end
  
end



function Data:Load()
  
    if readfile and isfile and isfile("WindNotepad_Data.json") then
    
        local success, data = pcall(function()
        
            return HttpService:JSONDecode(readfile("WindNotepad_Data.json"))
        
      end)
    
        if success and type(data) == "table" then
      
            self.State.Notes = data
      
    end
    
  end
  
end



return Data





















