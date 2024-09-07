LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons
LGRI.name = "LargeGroupRoleIcons"
LGRI.version = "1"

local EM = GetEventManager()

local defaults = {
	visible = true,
	lockUI = true,
	defaultPos = true,
	MyFrameX = 0,
	MyFrameY = 100,
}

function LargeGroupRoleIcons.Initialize()
	LGRI.savedVars = ZO_SavedVars:NewAccountWide("LargeGroupRoleIconsVars", 1, nil, defaults)

	LGRI.Settings.CreateSettingsWindow()
	LGRI.UI.BuildUI()
	LGRI.MY.CreateMy()
end

function LGRI.OnAddOnLoaded(event, addonName)
	if addonName ~= LGRI.name then return end
	EM:UnregisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED)

	LargeGroupRoleIcons.Initialize()

	EM:RegisterForEvent(LGRI.name .. "IJoinedGroup", EVENT_GROUP_MEMBER_JOINED,
		function(eventId, memberCharacterName, isLocalPlayer, memberDisplayName)
			if not isLocalPlayer then return end
			LGRI.MY.UpdateMyRole()
		end)
	EM:RegisterForEvent(LGRI.name .. "MyRoleChanged", EVENT_GROUP_MEMBER_ROLE_CHANGED, LGRI.MY.UpdateMyRole)
	EM:RegisterForEvent(LGRI.name .. "ILeftGroup", EVENT_GROUP_MEMBER_LEFT,
		function(eventId, memberCharacterName, groupLeaveReason, isLocalPlayer, isLeader, memberDisplayName,
				 actionRequiredVote)
			if not isLocalPlayer then return end
			LGRI.MY.UpdateMyRole()
		end)
end

EM:RegisterForEvent(LGRI.name, EVENT_ADD_ON_LOADED, LGRI.OnAddOnLoaded)
