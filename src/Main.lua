LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.Main = {}

local EM = EVENT_MANAGER

function LGRI.Main.RegisterEvents()
    EM:RegisterForEvent(LGRI.name .. "JoinedGroup", EVENT_GROUP_MEMBER_JOINED, LGRI.UI.AddGroupIcons) -- this only triggers when GroupSize > 2
    EM:RegisterForEvent(LGRI.name .. "RoleChanged", EVENT_GROUP_MEMBER_ROLE_CHANGED, LGRI.UI.AddGroupIcons)
    EM:RegisterForEvent(LGRI.name .. "LeftGroup", EVENT_GROUP_MEMBER_LEFT, LGRI.UI.AddGroupIcons)
    EM:RegisterForEvent(LGRI.name .. "GroupUpdate", EVENT_GROUP_UPDATE, LGRI.UI.AddGroupIcons) -- Triggers when someone joins group or changes location
end
