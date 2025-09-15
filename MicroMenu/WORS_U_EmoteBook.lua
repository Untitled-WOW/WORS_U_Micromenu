-- Create the main frame for the custom emote book
--WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent, "OldSchoolFrameTemplate")
WORS_U_EmoteBook.frame:SetSize(192, 304)

WORS_U_EmoteBook.frame:SetFrameStrata("LOW")
WORS_U_EmoteBook.frame:SetFrameLevel(5)

local bg = WORS_U_EmoteBook.frame:CreateTexture(nil, "LOW")
WORS_U_EmoteBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_EmoteBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)

WORS_U_EmoteBook.frame:Hide()
WORS_U_EmoteBook.frame:SetMovable(true)
WORS_U_EmoteBook.frame:EnableMouse(true)
WORS_U_EmoteBook.frame:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.frame:SetClampedToScreen(true)
--WORS_U_EmoteBook.frame:SetUserPlaced(false)
--tinsert(UISpecialFrames, "WORS_U_EmoteBookFrame")

WORS_U_EmoteBook.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving() 
end)
WORS_U_EmoteBook.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)


WORS_U_EmoteBook.frame.CloseButton:ClearAllPoints()
WORS_U_EmoteBook.frame.CloseButton:SetPoint("TOPRIGHT", WORS_U_EmoteBook.frame, "TOPRIGHT", 4, 4)	




-- Create a scrollable frame for the buttons
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_EmoteBook.frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(180, 290)  -- Size of the scrollable area
scrollFrame:SetPoint("TOPLEFT", 12, -5)  
local scrollBar = scrollFrame.ScrollBar 
local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
scrollBar:Hide(); scrollBar:SetAlpha(0); scrollUpButton:Hide(); scrollDownButton:Hide(); scrollUpButton:SetAlpha(0); scrollDownButton:SetAlpha(0)
scrollBar:EnableMouse(false)  -- Disable mouse interaction on the bar itself

-- Create a container for the buttons
local buttonContainer = CreateFrame("Frame", nil, scrollFrame)
buttonContainer:SetSize(180, 330)  -- Same size as scroll frame to avoid clipping
scrollFrame:SetScrollChild(buttonContainer)

local emoteButtons = {}

local function SetupEmoteButtons(XOffset, YOffset)
    local buttonWidth, buttonHeight = 40, 80
    local padding, columns = 5, 4
    local startX, startY = 2, -10

    for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
        local btn = emoteButtons[i]

        -- ✅ create button only once
        if not btn then
            btn = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
            btn:SetSize(buttonWidth, buttonHeight)
            btn:SetNormalTexture(nil)
            btn:SetPushedTexture(nil)
            btn:SetHighlightTexture(nil)

            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:SetText(emoteData.name, 1, 1, 1)
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", GameTooltip_Hide)

            emoteButtons[i] = btn
        end

        -- update position each call
        local row = math.floor((i - 1) / columns)
        local col = (i - 1) % columns
        local x = XOffset + startX + (buttonWidth + padding) * col
        local y = startY - YOffset - (buttonHeight + padding) * row
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", buttonContainer, "TOPLEFT", x, y)

        -- update background and click logic
        btn:SetBackdrop({ bgFile = emoteData.icon })
        if not emoteData.command or emoteData.command == "" then
            btn:SetBackdropColor(0.247, 0.220, 0.153, 1)
            btn:SetScript("OnClick", nil)
        else
            btn:SetBackdropColor(1, 1, 1, 1)
            btn:SetScript("OnClick", function()
                if emoteData.command:sub(1,1) == "_" then
                    SendChatMessage(emoteData.command, "SAY")
                else
                    DoEmote(emoteData.command)
                end
            end)
        end

        btn:Show()
    end

    -- hide leftover buttons if emote list shrinks
    for j = #WORS_U_EmoteBook.emotes + 1, #emoteButtons do
        if emoteButtons[j] then emoteButtons[j]:Hide() end
    end
end

WORS_U_EmoteBook.frame:HookScript("OnShow", function()
    SetupEmoteButtons(-8, -10)
end)

--Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_EmoteBook.frame:IsShown() then
		EmotesMicroButton:SetButtonState("PUSHED", true)
    else
		EmotesMicroButton:SetButtonState("NORMAL")
    end
end
WORS_U_EmoteBook.frame:HookScript("OnShow", UpdateButtonBackground)
WORS_U_EmoteBook.frame:HookScript("OnHide", UpdateButtonBackground)

hooksecurefunc("UpdateMicroButtons", function()
	UpdateButtonBackground()
end)

-- Loop through your existing emotes and dynamically register slash commands where commands are _
for _, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
    local cmd = emoteData.command
    if cmd:sub(1,1) == "_" then
        local slashCmd = cmd:sub(2) -- remove the leading underscore
        local slashCmdUpper = slashCmd:upper()

        -- Register the slash command globally
        _G["SLASH_" .. slashCmdUpper .. "1"] = "/" .. slashCmd

        -- Define the command function
        SlashCmdList[slashCmdUpper] = function(msg)
            SendChatMessage(cmd, "SAY")
        end
    end
end