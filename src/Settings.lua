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
                LGRI.UI.playerFrame.Frame:ClearAnchors()
                LGRI.UI.playerFrame.Frame:SetAnchor(CENTER, GuiRoot, TOP, 0, 100)
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
                LGRI.UI.playerFrame.Frame:SetHidden(not value)
                LGRI.UI.HudToggle(value)
            end
        },
        {
            type = "checkbox",
            name = "Lock UI",
            tooltip = "Enables repositioning of my icons.",
            getFunc = function() return LGRI.savedVars.lockUI end,
            setFunc = function(value)
                LGRI.savedVars.lockUI = value
                LGRI.UI.playerFrame.Frame:SetMouseEnabled(not value)
                LGRI.UI.playerFrame.Frame:SetMovable(not value)
            end
        }
    }
    LAM2:RegisterAddonPanel(panelName, panelData)
    LAM2:RegisterOptionControls(panelName, optionsData)
end
