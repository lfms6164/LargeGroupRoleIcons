LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons
LGRI.name = "LargeGroupRoleIcons"
LGRI.version = "0.3"

local EM = EVENT_MANAGER

function LGRI.OnAddOnLoaded(event, addonName)
	if addonName ~= LGRI.name then return end
	EM:UnregisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED)

    if GetGroupSize() > 0 then LGRI.UI.AddGroupIcons() end

	LGRI.Main.RegisterEvents()
end

EM:RegisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED, LGRI.OnAddOnLoaded)
