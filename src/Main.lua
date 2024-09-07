LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.Main = {}

local EM = EVENT_MANAGER

local racesDict = LGRI.icons.racesDict
local classIcons = LGRI.icons.classIcons
local roleIcons = LGRI.icons.roleIcons

local function UpdateMyRace(raceId)
    local function ShowTooltip(LGRIRaceIcon) -- X  Y
        InitializeTooltip(InformationTooltip, LGRIRaceIcon, RIGHT, 0, 0, LEFT)
        SetTooltipText(InformationTooltip, LGRI.self.race)
    end

    local function HideTooltip(LGRIRaceIcon)
        ClearTooltip(InformationTooltip)
    end

    -- Race
    local race = racesDict[raceId]
    if race then
        LGRI.self.race = race.name
        LGRI.self.raceIcon = race.icon

        LGRI.UI.MyRaceIcon:SetTexture(LGRI.self.raceIcon)

        LGRI.UI.MyRaceIcon:SetHandler("OnMouseEnter", function(LGRIRaceIcon) ShowTooltip(LGRIRaceIcon) end)
        LGRI.UI.MyRaceIcon:SetHandler("OnMouseExit", function(LGRIRaceIcon) HideTooltip(LGRIRaceIcon) end)
    end
end

local function UpdateMyClass(classId)
    -- Class
    -- Retrieve the icon path based on classId
    local classIcon = classIcons[classId]

    -- Check if the icon exists and update the texture
    if classIcon then
        LGRI.self.classIcon = classIcon
        LGRI.UI.MyClassIcon:SetTexture(LGRI.self.classIcon)
    end
end

local function UpdateMyRole(eventId, unitTag)
    --local unitTag = self:GetUnitTag()
    if unitTag and unitTag ~= GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) then
        return
    end

    local roleId = GetGroupMemberSelectedRole("player")

    -- Role
    local roleIcon = roleIcons[roleId] or "esoui/art/armory/builditem_icon.dds"
    LGRI.self.roleIcon = roleIcon
    LGRI.UI.MyRoleIcon:SetTexture(LGRI.self.roleIcon)
    LGRI.UI.MyRoleIcon:SetHidden(roleIcon == "esoui/art/armory/builditem_icon.dds")
end

function LGRI.Main.RegisterUpdateMyRoleEvents(eventId, unitTag)
    EM:RegisterForEvent(LGRI.name .. "IJoinedGroup", EVENT_GROUP_MEMBER_JOINED,
        function(eventId, memberCharacterName, isLocalPlayer, memberDisplayName)
            if not isLocalPlayer then return end
            UpdateMyRole()
        end)
    EM:RegisterForEvent(LGRI.name .. "MyRoleChanged", EVENT_GROUP_MEMBER_ROLE_CHANGED, UpdateMyRole)
    EM:RegisterForEvent(LGRI.name .. "ILeftGroup", EVENT_GROUP_MEMBER_LEFT,
        function(eventId, memberCharacterName, groupLeaveReason, isLocalPlayer, isLeader, memberDisplayName,
                 actionRequiredVote)
            if not isLocalPlayer then return end
            UpdateMyRole()
        end)
end

function LGRI.Main.myPanel()
    LGRI.self = {
        raceId = nil,
        race = "",
        raceIcon = "",
        classId = nil,
        classIcon = "",
        roleId = LFG_ROLE_INVALID,
        roleIcon = "",
    }
    LGRI.self.raceId = GetUnitRaceId("player")
    LGRI.self.classId = GetUnitClassId("player")

    UpdateMyRace(LGRI.self.raceId)
    UpdateMyClass(LGRI.self.classId)
    UpdateMyRole()
end

local function HideAndShowIcons()
    local isVisible = LGRI.savedVars.visible
    local action = isVisible and "Hiding" or "Showing"

    -- Toggle visibility
    LGRI.UI.MyFrame:SetHidden(isVisible)

    -- Update savedVars and print status
    LGRI.savedVars.visible = not isVisible
    d("LGRI: " .. action .. " icons.")
end

SLASH_COMMANDS["/lgri"] = HideAndShowIcons
