EMPGrenade = EMPGrenade or {}
EMPGrenade.Version = "1"

if SERVER then
    if JoeBase then
        JoeBase:RegisterProduct("EMP-Grenade", EMPGrenade.Version)
    else
        hook.Add("JoeBase:FinishedLoading", "EMPGrenade:Register", function()
            JoeBase:RegisterProduct("EMP-Grenade", EMPGrenade.Version)
        end)
    end
end

local mainfolder = "emp_grenade/"
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
