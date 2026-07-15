local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("Notepad_Session") then
    return nil
end

local session = Instance.new("Folder")
session.Name = "Notepad_Session"
session.Parent = PlayerGui

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Notepad",
    Icon = "lucide:edit-3",
    Author = "v1.1.0",
    Folder = "Notepad_Pro",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Acrylic = true
})

return {Window = Window, WindUI = WindUI}
