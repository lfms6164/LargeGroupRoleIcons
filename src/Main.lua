LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.Main = {}

local EM = EVENT_MANAGER

local raceIcons = LGRI.icons.raceIcons
local classIcons = LGRI.icons.classIcons
local roleIcons = LGRI.icons.roleIcons

LGRI.Group = {}
LGRI.GroupDisplayNames = {}

local function GetRaceIcon(raceID, player)
    local raceIcon = raceIcons[raceID]
    if player then LGRI.UI.playerFrame.RaceIcon:SetTexture(raceIcon) end
    return raceIcon
end

local function GetClassIcon(classID, player)
    local classIcon = classIcons[classID]
    if player then LGRI.UI.playerFrame.ClassIcon:SetTexture(classIcon) end
    return classIcon
end

local function GetRoleIcon(roleID, player)
    local roleIcon = roleIcons[roleID]
    if player then
        LGRI.UI.playerFrame.RoleIcon:SetTexture(roleIcon)
        LGRI.UI.playerFrame.RoleIcon:SetHidden(roleID == 0)
    end
    return roleIcon
end

local function GetGroupMemberIndexByDisplayName(playerDisplayName)
    for i, displayName in ipairs(LGRI.GroupDisplayNames) do
        if displayName == playerDisplayName then
            return i
        end
    end
    return nil
end

local function AddGroupMemberByDisplayName(playerDisplayName)
    table.insert(LGRI.GroupDisplayNames, playerDisplayName)

    local i = GetGroupMemberIndexByDisplayName(playerDisplayName)
    if i ~= nil then d("Added " .. i .. playerDisplayName, "unitTag=" .. GetGroupUnitTagByIndex(i)) end
    local groupMember = {
        DisplayName = playerDisplayName,
        RaceID = GetUnitRaceId("group" .. i),
        RaceIcon = GetRaceIcon(GetUnitRaceId("group" .. i), false) or "",
        RaceName = GetUnitRace("group" .. i),
        ClassID = GetUnitClassId("group" .. i),
        ClassIcon = GetClassIcon(GetUnitClassId("group" .. i), false) or "",
        RoleID = GetGroupMemberSelectedRole("group" .. i),
        RoleIcon = GetRoleIcon(GetGroupMemberSelectedRole("group" .. i), false) or "",
    }

    table.insert(LGRI.Group, groupMember)

    LGRI.UI.AddGroupMemberIcons(i)
end

local function UpdateGroupMemberRoleByDisplayName(playerDisplayName, newRoleID)
    if not GetGroupMemberIndexByDisplayName(playerDisplayName) then table.insert(LGRI.GroupDisplayNames, playerDisplayName) end

    local index = GetGroupMemberIndexByDisplayName(playerDisplayName)
    d("update role index " .. tostring(index))
    if index ~= nil then
        LGRI.Group[index].RoleID = newRoleID
        LGRI.Group[index].RoleIcon = GetRoleIcon(newRoleID, false)

        d("Updated " .. playerDisplayName .. " role to: " .. newRoleID)

        LGRI.UI.UpdateGroupMemberRoleIcon(index)
    else
        d("Invalid groupIndex: " .. tostring(index))
    end
end

local function DeleteGroupMemberByDisplayName(playerDisplayName)
    local index = GetGroupMemberIndexByDisplayName(playerDisplayName)

    if index ~= nil and index <= #LGRI.Group then
        table.remove(LGRI.Group, index)
        table.remove(LGRI.GroupDisplayNames, index)
        d(playerDisplayName .. " removed from group.")
    else
        d("Invalid groupIndex: " .. tostring(index))
    end
end

local function CreateGroupTable(eventCode)
    LGRI.Group = {}
    LGRI.GroupDisplayNames = {}
    local groupSize = GetGroupSize()
    if groupSize == 0 then
        d("Not in group.")
        return
    end

    for i = 1, groupSize do
        local groupMember = {
            DisplayName = GetUnitDisplayName("group" .. i),
            RaceID = GetUnitRaceId("group" .. i),
            RaceIcon = GetRaceIcon(GetUnitRaceId("group" .. i), false) or "",
            RaceName = GetUnitRace("group" .. i),
            ClassID = GetUnitClassId("group" .. i),
            ClassIcon = GetClassIcon(GetUnitClassId("group" .. i), false) or "",
            RoleID = GetGroupMemberSelectedRole("group" .. i),
            RoleIcon = GetRoleIcon(GetGroupMemberSelectedRole("group" .. i), false) or "",
        }

        table.insert(LGRI.Group, groupMember)
        table.insert(LGRI.GroupDisplayNames, GetUnitDisplayName("group" .. i))
    end

    LGRI.UI.AddGroupIcons()
end

function LGRI.Main.CreatePlayerTable()
    LGRI.UI.BuildPlayerFrame()

    LGRI.Player = {
        DisplayName = GetUnitDisplayName("player"),
        RaceID = GetUnitRaceId("player"),
        RaceIcon = GetRaceIcon(GetUnitRaceId("player"), true),
        RaceName = GetUnitRace("player"),
        ClassID = GetUnitClassId("player"),
        ClassIcon = GetClassIcon(GetUnitClassId("player"), true),
        RoleID = GetGroupMemberSelectedRole("player"),
        RoleIcon = GetRoleIcon(GetGroupMemberSelectedRole("player"), true),
    }

    local inGroup = GetGroupSize() > 0 and true or false
    if inGroup then CreateGroupTable() end
end

function LGRI.Main.RegisterEvents()
    EM:RegisterForEvent(LGRI.name .. "JoinedGroup", EVENT_GROUP_MEMBER_JOINED,
        function(eventCode, memberCharacterName, memberDisplayName, isLocalPlayer)
            d("1E")
            if not isLocalPlayer then -- this only triggers when GroupSize > 2
                d(memberDisplayName .. " has joined the group.")
                AddGroupMemberByDisplayName(memberDisplayName)
            else
                d("1E else")
                GetRoleIcon(GetGroupMemberSelectedRole("player"), true)
            end
        end)
    EM:RegisterForEvent(LGRI.name .. "RoleChanged", EVENT_GROUP_MEMBER_ROLE_CHANGED,
        function(eventCode, unitTag, assignedRole)
            d("2E " .. GetUnitDisplayName(unitTag))
            CreateGroupTable()
            -- UpdateGroupMemberRoleByDisplayName(GetUnitDisplayName(unitTag), assignedRole)
            if unitTag == GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) then
                d('2E IF') -- not working currently
                GetRoleIcon(GetGroupMemberSelectedRole("player"), true)
            end
        end)
    EM:RegisterForEvent(LGRI.name .. "LeftGroup", EVENT_GROUP_MEMBER_LEFT,
        function(eventCode, memberCharacterName, groupLeaveReason, isLocalPlayer, isLeader, memberDisplayName,
                 actionRequiredVote)
            if not isLocalPlayer then
                DeleteGroupMemberByDisplayName(memberDisplayName)
                if GetGroupSize() == 4 then CreateGroupTable() end -- TODO - If transition from large group to small (if GetGroupSize() == 4) -> CreateGroupTable
                return
            end

            LGRI.Group = {}
            LGRI.GroupDisplayNames = {}
            GetRoleIcon(GetGroupMemberSelectedRole("player"), true)
        end)
    EM:RegisterForEvent(LGRI.name .. "GroupUpdate", EVENT_GROUP_UPDATE, CreateGroupTable) -- Triggers when someone joins group or changes location
end

local function HideAndShowIcons()
    local isVisible = LGRI.savedVars.visible
    local state = isVisible and "hidden." or "shown."

    -- Toggle visibility
    LGRI.UI.playerFrame.Frame:SetHidden(isVisible)

    -- Update savedVars and print status
    LGRI.savedVars.visible = not isVisible
    d("LGRI: PlayerPanel icons " .. state)
end

SLASH_COMMANDS["/lgri"] = HideAndShowIcons

local function testing()
    d("GROUP", LGRI.Group)
    d("NAMES", LGRI.GroupDisplayNames)
end
SLASH_COMMANDS["/teste"] = testing
SLASH_COMMANDS["/creategrouptable"] = CreateGroupTable
