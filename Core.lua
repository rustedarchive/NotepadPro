local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("NotepadPro_Gui") then
    return nil
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Notepad",
    Author = "v1.1.0",
    Icon = "lucide:edit-3",
    Theme = "Dark",
    Folder = "NotepadPro",
    Acrylic = true,
    Transparent = true,
    Size = UDim2.fromOffset(600, 480)
})

Window.Gui.Name = "NotepadPro_Gui"

return {Window = Window, WindUI = WindUI}
