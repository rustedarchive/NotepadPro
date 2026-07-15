local getgenv = getgenv or function() return _G end
if getgenv().NotepadRunning then return end
getgenv().NotepadRunning = true

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Notepad",
    Author = "v1.1.0",
    Icon = "lucide:edit-3",
    Theme = "Dark",
    Folder = "Notepad_Pro",
    Acrylic = true,
    Size = UDim2.fromOffset(580, 420)
})

if syn and syn.protect_gui then
    syn.protect_gui(Window.Instance)
end

local Core = {
    Window = Window,
    WindUI = WindUI,
    IsReady = true
}

return Core
