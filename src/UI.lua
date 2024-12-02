LargeGroupRoleIcons = LargeGroupRoleIcons or {}
local LGRI = LargeGroupRoleIcons

LGRI.UI = {}

local WM = WINDOW_MANAGER

local raceIcons = LGRI.icons.raceIcons
local classIcons = LGRI.icons.classIcons
local roleIcons = LGRI.icons.roleIcons

local function ShowTooltip(thisControl, tooltip, isTexture) -- X  Y
    InitializeTooltip(InformationTooltip, thisControl, RIGHT, 0, 0, LEFT)
    if isTexture then
        if type(tooltip) == "table" then
            -- For multiple textures, concatenate them into one string
            local textureString = ""
            for _, texturePath in ipairs(tooltip) do
                textureString = textureString .. "|t25:25:/" .. texturePath .. "|t "
            end
            SetTooltipText(InformationTooltip, textureString)
        else
            SetTooltipText(InformationTooltip, "|t25:25:/" .. tooltip .. "|t")
        end
    else
        SetTooltipText(InformationTooltip, tooltip)
    end
end

local function HideTooltip()
    ClearTooltip(InformationTooltip)
end

function LGRI.UI.AddGroupMemberIcons(index)
    if IsUnitOnline("group" .. index) then
        if (GetGroupSize() > SMALL_GROUP_SIZE_THRESHOLD) then
            -- Role
            local GroupMemberRoleIcon = _G["GroupFrameRoleIcon" .. index]

            if not GroupMemberRoleIcon then
                local raidParentControl = GetControl("ZO_RaidUnitFramegroup" .. index)
                if raidParentControl then
                    GroupMemberRoleIcon = WM:CreateControl("GroupFrameRoleIcon" .. index, raidParentControl, CT_TEXTURE)
                else
                    d("Error: Raid unit frame control " .. index .. " does not exist.")
                    return
                end
                GroupMemberRoleIcon:SetDimensions(20, 20)
                GroupMemberRoleIcon:SetAnchor(TOPRIGHT, raidParentControl, TOPRIGHT, -5, 5)
                GroupMemberRoleIcon:SetDrawLayer(DL_OVERLAY)
                GroupMemberRoleIcon:SetMouseEnabled(true)
                GroupMemberRoleIcon:SetHandler("OnMouseEnter",
                    function()
                        ShowTooltip(GroupMemberRoleIcon,
                            { raceIcons[GetUnitRaceId("group" .. index)], classIcons[GetUnitClassId("group" .. index)] },
                            true)
                    end)
                GroupMemberRoleIcon:SetHandler("OnMouseExit", function() HideTooltip() end)
            end
            GroupMemberRoleIcon:SetTexture(roleIcons[GetGroupMemberSelectedRole("group" .. index)])
        else
            local groupHPControl = GetControl("ZO_GroupUnitFramegroup" .. index .. "Hp")
            if groupHPControl then
                groupHPControl:SetDimensions(170, 15)
                local current, max, effectiveMax = GetUnitPower("group" .. index, POWERTYPE_HEALTH)
                groupHPControl:SetMouseEnabled(true)
                groupHPControl:SetHandler("OnMouseEnter",
                    function() ShowTooltip(groupHPControl, tostring(max) .. "HP") end)
                groupHPControl:SetHandler("OnMouseExit", function() HideTooltip() end)
            end

            local GroupMemberRaceIcon = _G["GroupFrameRaceIcon" .. index]
            local GroupMemberClassIcon = _G["GroupFrameClassIcon" .. index]

            if not GroupMemberRaceIcon and not GroupMemberClassIcon then
                local groupParentControl = GetControl("ZO_GroupUnitFramegroup" .. index .. "Name")

                if groupParentControl then
                    GroupMemberRaceIcon = WM:CreateControl("GroupFrameRaceIcon" .. index, groupParentControl, CT_TEXTURE)
                    GroupMemberClassIcon = WM:CreateControl("GroupFrameClassIcon" .. index, groupParentControl,
                        CT_TEXTURE)
                else
                    d("Error: Group unit frame control " .. index .. " does not exist.")
                    return
                end
                -- Race
                GroupMemberRaceIcon:SetDimensions(25, 25)
                GroupMemberRaceIcon:SetAnchor(LEFT, groupParentControl, LEFT, groupParentControl:GetTextWidth(), 0)
                GroupMemberRaceIcon:SetDrawLayer(DL_OVERLAY)
                GroupMemberRaceIcon:SetMouseEnabled(true)
                GroupMemberRaceIcon:SetHandler("OnMouseEnter",
                    function() ShowTooltip(GroupMemberRaceIcon, GetUnitDisplayName("group" .. index), false) end)
                GroupMemberRaceIcon:SetHandler("OnMouseExit", function() HideTooltip() end)

                -- Class
                GroupMemberClassIcon:SetDimensions(25, 25)
                GroupMemberClassIcon:SetAnchor(LEFT, groupParentControl, LEFT, groupParentControl:GetTextWidth() + 25, 0)
                GroupMemberClassIcon:SetDrawLayer(DL_OVERLAY)
            end

            GroupMemberRaceIcon:SetTexture(raceIcons[GetUnitRaceId("group" .. index)])

            GroupMemberClassIcon:SetTexture(classIcons[GetUnitClassId("group" .. index)])
        end
    end
end

function LGRI.UI.AddGroupIcons()
    for i = 1, GetGroupSize() do
        if not DoesUnitExist("group" .. i) then break end
        LGRI.UI.AddGroupMemberIcons(i)
    end
end
