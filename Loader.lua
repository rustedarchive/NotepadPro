local function LoadCog(url)
    local success, cog = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return success and cog or nil
end

local BaseUrl = "https://raw.githubusercontent.com/rustedarchive/NotepadPro/main/"

local Core = LoadCog(BaseUrl .. "Core.lua")
if not Core then warn("Notepad: Core failed to load.") return end

local Window, WindUI = Core.Window, Core.WindUI
if not Window or not WindUI then warn("Notepad: Window init failed.") return end

local Data = LoadCog(BaseUrl .. "Data.lua")
if not Data then warn("Notepad: Data failed to load.") return end

local Interface = LoadCog(BaseUrl .. "Interface.lua")
if not Interface then warn("Notepad: Interface failed to load.") return end

Data:Load()
Interface:Init(Window, WindUI, Data)
