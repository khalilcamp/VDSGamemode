BombSystem = BombSystem or {}
BombSystem.Version = "1.9.1"
local mainfolder = "bomb_system/"

if SERVER then
    if JoeBase then
        JoeBase:RegisterProduct("Bomb-System", BombSystem.Version)
    else
        hook.Add("JoeBase:FinishedLoading", "BombSystem:Register", function()
            JoeBase:RegisterProduct("Bomb-System", BombSystem.Version)
        end)
    end
end

-- sh files
for k,v in pairs(file.Find(mainfolder .. "sh_*", "LUA")) do
    include(mainfolder .. tostring(v))
    if SERVER then AddCSLuaFile(mainfolder .. tostring(v)) end
end
-- sv files
if SERVER then
    for k,v in pairs(file.Find(mainfolder .. "sv_*", "LUA")) do
        include(mainfolder .. tostring(v))
    end
end
-- cl files
for k,v in pairs(file.Find(mainfolder .. "cl_*", "LUA")) do
    if SERVER then AddCSLuaFile(mainfolder ..  tostring(v))
    else include(mainfolder .. tostring(v))
    end
end