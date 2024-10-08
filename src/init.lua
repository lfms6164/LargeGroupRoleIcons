LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons
LGRI.name = "LargeGroupRoleIcons"
LGRI.version = "0.2"

local EM = EVENT_MANAGER

local defaults = {
	visible = true,
	lockUI = true,
	defaultPos = true,
	MyFrameX = 0,
	MyFrameY = 100,
}

function LGRI.OnAddOnLoaded(event, addonName)
	if addonName ~= LGRI.name then return end
	EM:UnregisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED)

	LGRI.savedVars = ZO_SavedVars:NewAccountWide("LargeGroupRoleIconsVars", 1, nil, defaults)

	LGRI.Settings.CreateSettingsWindow()
	if LGRI.savedVars.visible then LGRI.UI.BuildPlayerFrame() end

	LGRI.Main.RegisterEvents()
end

EM:RegisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED, LGRI.OnAddOnLoaded)
