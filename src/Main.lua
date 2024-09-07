LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.Main = {}

local racesDict = LGRI.icons.racesDict
local classIcons = LGRI.icons.classIcons
local roleIcons = LGRI.icons.roleIcons

local function UpdateMyRace(raceId)
    local my = LGRI.my

    local function ShowTooltip(LGRIRaceIcon)                    -- X  Y
        InitializeTooltip(InformationTooltip, LGRIRaceIcon, RIGHT, 0, 0, LEFT)
        SetTooltipText(InformationTooltip, my.race)
    end

    local function HideTooltip(LGRIRaceIcon)
        ClearTooltip(InformationTooltip)
    end

    -- Race
    local race = racesDict[raceId]
    if race then
        my.race = race.name
        my.raceIcon = race.icon

        LGRI.UI.MyRaceIcon:SetTexture(my.raceIcon)

        LGRI.UI.MyRaceIcon:SetHandler("OnMouseEnter", function(LGRIRaceIcon) ShowTooltip(LGRIRaceIcon) end)
        LGRI.UI.MyRaceIcon:SetHandler("OnMouseExit", function(LGRIRaceIcon) HideTooltip(LGRIRaceIcon) end)
    end
end

local function UpdateMyClass(classId)
    --local unitTag = self:GetUnitTag()
    local my = LGRI.my

    -- Class
    -- Retrieve the icon path based on classId
    local classIcon = classIcons[classId]

    -- Check if the icon exists and update the texture
    if classIcon then
        my.classIcon = classIcon
        LGRI.UI.MyClassIcon:SetTexture(my.classIcon)
    end
end

local function UpdateMyRole(eventId, unitTag)
    if unitTag and unitTag ~= GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) then
        return
    end

    local my = LGRI.my
    local roleId = GetGroupMemberSelectedRole("player")

    -- Role
    local roleIcon = roleIcons[roleId] or "esoui/art/armory/builditem_icon.dds"
    my.roleIcon = roleIcon
    LGRI.UI.MyRoleIcon:SetTexture(my.roleIcon)
    LGRI.UI.MyRoleIcon:SetHidden(roleIcon == "esoui/art/armory/builditem_icon.dds")
end

function LGRI.Main.myPanel()
    LGRI.my = {
        raceId = nil,
        race = "",
        raceIcon = "",
        classId = nil,
        classIcon = "",
        roleId = LFG_ROLE_INVALID,
        roleIcon = "",
    }
    LGRI.my.raceId = GetUnitRaceId("player")
    LGRI.my.classId = GetUnitClassId("player")

    UpdateMyRace(LGRI.my.raceId)
    UpdateMyClass(LGRI.my.classId)
    UpdateMyRole()
end

local function HideAndShowIcons()
    local isVisible = LGRI.savedVars.visible
    local action = isVisible and "Hiding" or "Showing"

    -- Toggle visibility
    LGRI.UI.MyFrame:SetHidden(isVisible)

    -- Update savedVars and print status
    LGRI.savedVars.visible = not isVisible
    d("LGRI: " .. action .. " icons.") --TODO: Fix this
end

SLASH_COMMANDS["/lgri"] = HideAndShowIcons
