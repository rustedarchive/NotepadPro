local function LoadCog(name, url)
    local success, cog = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success or not cog then
        warn("Failed to load cog: " .. name)
        return nil
    end
    return cog
end

local BaseUrl = "https://raw.githubusercontent.com/rustedarchive/NotepadPro/main/"

local Window, WindUI = LoadCog("Core", BaseUrl .. "Core.lua")
if not Window then return end

local Data = LoadCog("Data", BaseUrl .. "Data.lua")
if not Data then return end

local Interface = LoadCog("Interface", BaseUrl .. "Interface.lua")
if not Interface then return end

Data:Load()
Interface:Init(Window, WindUI, Data)
