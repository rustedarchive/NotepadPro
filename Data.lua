local HttpService = game:GetService("HttpService")

local Data = {}
Data.State = {
    Notes = {},
    CurrentNoteId = nil,
    SearchQuery = "",
    AutoSave = true,
    Theme = "Dark",
    Snippets = {
        {Name = "Greeting", Content = "Hello, I hope you are having a great day!"},
        {Name = "Discord", Content = "My Discord is: "},
        {Name = "Signature", Content = "\n\nBest regards,\n[Your Name]"}
    }
}

function Data:Save()
    if writefile then
        local success, err = pcall(function()
            writefile("Notepad_Data_Pro.json", HttpService:JSONEncode(self.State))
        end)
    end
end

function Data:Load()
    if readfile and isfile and isfile("Notepad_Data_Pro.json") then
        local success, content = pcall(function()
            return HttpService:JSONDecode(readfile("Notepad_Data_Pro.json"))
        end)
        if success and content then
            for k, v in pairs(content) do
                self.State[k] = v
            end
        end
    end
end

return Data
