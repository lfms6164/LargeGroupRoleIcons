LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.Main = {}

local EM = EVENT_MANAGER

local roleIcons = LGRI.icons.roleIcons

function LGRI.Main.RegisterEvents()
    EM:RegisterForEvent(LGRI.name .. "JoinedGroup", EVENT_GROUP_MEMBER_JOINED,
        function(eventCode, memberCharacterName, memberDisplayName, isLocalPlayer)
            if not isLocalPlayer then -- this only triggers when GroupSize > 2
                d(memberDisplayName .. " has joined the group.")
                LGRI.UI.AddGroupIcons()
                return
            end
            LGRI.UI.playerFrame.RoleIcon:SetTexture(roleIcons[GetGroupMemberSelectedRole("player")])
        end)
    EM:RegisterForEvent(LGRI.name .. "RoleChanged", EVENT_GROUP_MEMBER_ROLE_CHANGED,
        function(eventCode, unitTag, assignedRole)
            LGRI.UI.AddGroupIcons()
            if unitTag == GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) then
                LGRI.UI.playerFrame.RoleIcon:SetTexture(roleIcons[assignedRole])
                LGRI.UI.playerFrame.RoleIcon:SetHidden(assignedRole == 0)
            end
        end)
    EM:RegisterForEvent(LGRI.name .. "LeftGroup", EVENT_GROUP_MEMBER_LEFT,
        function(eventCode, memberCharacterName, groupLeaveReason, isLocalPlayer, isLeader, memberDisplayName,
                 actionRequiredVote)
            if not isLocalPlayer then
                if GetGroupSize() == 4 then LGRI.UI.AddGroupIcons() end
                return
            end
            LGRI.UI.playerFrame.RoleIcon:SetTexture(roleIcons[GetGroupMemberSelectedRole("player")])
        end)
    EM:RegisterForEvent(LGRI.name .. "GroupUpdate", EVENT_GROUP_UPDATE, LGRI.UI.AddGroupIcons) -- Triggers when someone joins group or changes location
end

local function HideAndShowIcons()
    local isVisible = LGRI.savedVars.visible
    local state = isVisible and "hidden." or "shown."

    -- Toggle visibility
    local playerFrame = _G["MyFrame"]
    if not playerFrame then LGRI.UI.BuildPlayerFrame() end
    LGRI.UI.playerFrame.Frame:SetHidden(isVisible)

    -- Update savedVars and print status
    LGRI.savedVars.visible = not isVisible
    d("LGRI: PlayerPanel icons " .. state)
end

SLASH_COMMANDS["/lgri"] = HideAndShowIcons
