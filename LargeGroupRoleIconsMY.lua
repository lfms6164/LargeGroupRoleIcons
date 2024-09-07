LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.MY = {}

function LGRI.MY.UpdateMyRace(raceId)
    local my = LGRI.my

    local function ShowTooltip(LGRIRaceIcon)                    -- X  Y
        InitializeTooltip(InformationTooltip, LGRIRaceIcon, RIGHT, 0, 0, LEFT)
        SetTooltipText(InformationTooltip, my.race)
    end

    local function HideTooltip(LGRIRaceIcon)
        ClearTooltip(InformationTooltip)
    end

    -- Race
    local racesDict = {
        [1]  = { name = "Breton", icon = "esoui/art/charactercreate/charactercreate_bretonicon_down.dds" },
        [2]  = { name = "Redguard", icon = "esoui/art/charactercreate/charactercreate_redguardicon_down.dds", },
        [3]  = { name = "Orc", icon = "esoui/art/charactercreate/charactercreate_orcicon_down.dds" },
        [4]  = { name = "Dark Elf", icon = "esoui/art/charactercreate/charactercreate_dunmericon_down.dds", },
        [5]  = { name = "Nord", icon = "esoui/art/charactercreate/charactercreate_nordicon_down.dds" },
        [6]  = { name = "Argonian", icon = "esoui/art/charactercreate/charactercreate_argonianicon_down.dds" },
        [7]  = { name = "High Elf", icon = "esoui/art/charactercreate/charactercreate_altmericon_down.dds" },
        [8]  = { name = "Wood Elf", icon = "esoui/art/charactercreate/charactercreate_bosmericon_down.dds" },
        [9]  = { name = "Khajit", icon = "esoui/art/charactercreate/charactercreate_khajiiticon_down.dds" },
        [10] = { name = "Imperial", icon = "esoui/art/charactercreate/charactercreate_imperialicon_down.dds" },
    }

    local race = racesDict[raceId]
    if race then
        my.race = race.name
        my.raceIcon = race.icon

        LGRI.UI.MyRaceIcon:SetTexture(my.raceIcon)

        LGRI.UI.MyRaceIcon:SetHandler("OnMouseEnter", function(LGRIRaceIcon) ShowTooltip(LGRIRaceIcon) end)
        LGRI.UI.MyRaceIcon:SetHandler("OnMouseExit", function(LGRIRaceIcon) HideTooltip(LGRIRaceIcon) end)
    end
end

function LGRI.MY.UpdateMyClass(classId)
    --local unitTag = self:GetUnitTag()
    local my = LGRI.my

    -- Class
    local classIcons = {
        [1] = "esoui/art/icons/class/class_dragonknight.dds",
        [2] = "esoui/art/icons/class/class_sorcerer.dds",
        [3] = "esoui/art/icons/class/class_nightblade.dds",
        [4] = "esoui/art/icons/class/class_warden.dds",
        [5] = "esoui/art/icons/class/class_necromancer.dds",
        [6] = "esoui/art/icons/class/class_templar.dds",
        [117] = "esoui/art/icons/class/class_arcanist.dds",
    }

    -- Retrieve the icon path based on classId
    local classIcon = classIcons[classId]

    -- Check if the icon exists and update the texture
    if classIcon then
        my.classIcon = classIcon
        LGRI.UI.MyClassIcon:SetTexture(my.classIcon)
    end
end

function LGRI.MY.UpdateMyRole(eventId, unitTag)
    if unitTag and unitTag ~= GetGroupUnitTagByIndex(GetGroupIndexByUnitTag("player")) then
        return
    end

    local my = LGRI.my
    local roleId = GetGroupMemberSelectedRole("player")

    -- Role
    local roleIcons = {
        [1] = "esoui/art/lfg/lfg_icon_dps.dds",
        [2] = "esoui/art/lfg/lfg_icon_tank.dds",
        [4] = "esoui/art/lfg/lfg_icon_healer.dds"
    }

    local roleIcon = roleIcons[roleId] or "esoui/art/armory/builditem_icon.dds"
    my.roleIcon = roleIcon
    LGRI.UI.MyRoleIcon:SetTexture(my.roleIcon)
    LGRI.UI.MyRoleIcon:SetHidden(roleIcon == "esoui/art/armory/builditem_icon.dds")
end

function LGRI.MY.CreateMy()
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

    LGRI.MY.UpdateMyRace(LGRI.my.raceId)
    LGRI.MY.UpdateMyClass(LGRI.my.classId)
    LGRI.MY.UpdateMyRole()
end

function LGRI.MY.HideAndShowIcons()
    local isVisible = LGRI.savedVars.visible
    local action = isVisible and "Hiding" or "Showing"

    -- Toggle visibility
    LGRI.UI.MyFrame:SetHidden(isVisible)

    -- Update savedVars and print status
    LGRI.savedVars.visible = not isVisible
    d("LGRI: " .. action .. " icons.") --TODO: Fix this
end

SLASH_COMMANDS["/lgri"] = LGRI.MY.HideAndShowIcons
