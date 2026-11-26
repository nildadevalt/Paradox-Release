-- Paradox: saveinstance
-- Saves the current place as <PlaceName>.rbxm in Paradox's workspace folder
-- (%APPDATA%\Paradox\workspace), the same folder the Finder's Workspace tab
-- lists. writefile is sandboxed to that folder by the module, so the file
-- lands there no matter what path the saver is given.
local ok, mod = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau")
    return assert(loadstring(src, "=saveinstance"))()
end)
if not ok or type(mod) ~= "function" then
    warn("saveinstance bootstrap failed: " .. tostring(mod))
    return
end
getgenv().saveinstance = mod
getgenv().saveplace    = mod

-- File name: the place's own name, minus anything Windows rejects in a path.
local placeName = "place_" .. tostring(game.PlaceId)
local okName, info = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if okName and type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" then
    placeName = info.Name
end
placeName = placeName:gsub('[<>:"/\\|%?%*%c]', ""):gsub("^%s+", ""):gsub("%s+$", "")
if placeName == "" then placeName = "place_" .. tostring(game.PlaceId) end

local fileName = placeName .. ".rbxm"

-- Suppress the "don't rejoin" prompt by silencing messagebox during the dump.
local _mb = getgenv().messagebox
getgenv().messagebox = function() return 1 end
local sok, serr = pcall(mod, {
    FilePath = fileName,  -- an explicit extension is kept as-is by the saver
    IsModel  = true,      -- model serialization, so .rbxm is the right container
    mode     = "full",    -- "optimized" is incompatible with model mode
})
getgenv().messagebox = _mb

if not sok then
    warn("saveinstance failed: " .. tostring(serr))
    return
end
print("[Paradox] saved " .. fileName .. " to the workspace folder")
