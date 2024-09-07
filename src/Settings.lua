local LGRI = LargeGroupRoleIcons

LGRI.Settings = {}

local LAM2 = LibAddonMenu2

function LGRI.Settings.CreateSettingsWindow()
    local panelName = "LGRISettings"
    local panelData = {
        type = "panel",
        name = LGRI.name,
        author = "@SlLva",
        version = LGRI.version
    }

    local optionsData = {
        {
            type = "button",
            name = "Default location",
            tooltip = "Set my icons to default position.",
            func = function()
                LGRI.UI.MyFrame:ClearAnchors()
                LGRI.UI.MyFrame:SetAnchor(CENTER, GuiRoot, TOP, 0, 100)
                LGRI.savedVars.defaultPos = true
            end,
            isDangerous = true
        },
        {
            type = "checkbox",
            name = "My Icons",
            tooltip = "Show or Hide my icons.",
            getFunc = function() return LGRI.savedVars.visible end,
            setFunc = function(value)
                LGRI.savedVars.visible = value
                if value == false then
                    LGRI.UI.MyFrame:SetHidden(true)
                    LGRI.UI.HudToggle(false)
                else
                    LGRI.UI.MyFrame:SetHidden(false)
                    LGRI.UI.HudToggle(true)
                end
            end
        },
        {
            type = "checkbox",
            name = "Lock UI",
            tooltip = "Enables repositioning of my icons.",
            getFunc = function() return LGRI.savedVars.lockUI end,
            setFunc = function(value)
                LGRI.savedVars.lockUI = value
                if value == true then
                    LGRI.UI.MyFrame:SetMouseEnabled(false)
                    LGRI.UI.MyFrame:SetMovable(false)
                else
                    LGRI.UI.MyFrame:SetMouseEnabled(true)
                    LGRI.UI.MyFrame:SetMovable(true)
                end
            end
        }
    }
    LAM2:RegisterAddonPanel(panelName, panelData)
    LAM2:RegisterOptionControls(panelName, optionsData)
end
