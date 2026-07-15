local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")



if PlayerGui:FindFirstChild("WindNotepad_Gui") then
  
    return
  
end



local WindUI

local success, err = pcall(function()
    
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
  end)



if not success or not WindUI then
  
    return
  
end



local Window = WindUI:CreateWindow({
    
    Title = "Notepad",
    
    Author = "v1.0.0",
    
    Icon = "lucide:edit-3",
    
    Theme = "Dark",
    
    Folder = "WindNotepadPro",
    
    Acrylic = true,
    
    Transparent = true,
    
    Resizable = true,
    
    MinSize = Vector2.new(700, 500),
    
    User = {
      
        Name = Player.Name,
      
        Title = "Premium User",
      
        Icon = "lucide:user"
      
    }
    
  })



Window.Gui.Name = "WindNotepad_Gui"



return Window, WindUI




















