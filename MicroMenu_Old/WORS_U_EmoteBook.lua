-- Create the main frame for the custom emote book
WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent)
WORS_U_EmoteBook.frame:SetSize(180, 330)
-- WORS_U_EmoteBook.frame:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground1",
	-- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 32,
    -- insets = { left = 5, right = 5, top = 5, bottom = 5 }
-- })
WORS_U_EmoteBook.frame:Hide()
WORS_U_EmoteBook.frame:SetMovable(true)
WORS_U_EmoteBook.frame:EnableMouse(true)
WORS_U_EmoteBook.frame:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.frame:SetClampedToScreen(true)

local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
	local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
	WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
else
	WORS_U_EmoteBook.frame:SetPoint("CENTER")
end	

WORS_U_EmoteBook.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving() 
end)
WORS_U_EmoteBook.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)

local closeButton = CreateFrame("Button", nil, WORS_U_EmoteBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EmoteBookFrame, "TOPRIGHT", 4, 4)
WORS_U_EmoteBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_EmoteBook.frame:Hide()
end)

-- Create a scrollable frame for the buttons
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_EmoteBook.frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(180, 330)  -- Size of the scrollable area
scrollFrame:SetPoint("TOPLEFT", 5, 10)  -- Position it below the title
local scrollBar = scrollFrame.ScrollBar 
local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
scrollBar:Hide(); scrollBar:SetAlpha(0); scrollUpButton:Hide(); scrollDownButton:Hide(); scrollUpButton:SetAlpha(0); scrollDownButton:SetAlpha(0)
scrollBar:EnableMouse(false)  -- Disable mouse interaction on the bar itself

-- Create a container for the buttons
local buttonContainer = CreateFrame("Frame", nil, scrollFrame)
buttonContainer:SetSize(180, 330)  -- Same size as scroll frame to avoid clipping
scrollFrame:SetScrollChild(buttonContainer)

-- Initialize emote buttons
local emoteButtons = {}


local function SetupEmoteButtons(XOffset, YOffset)
    -- Clear existing buttons before creating new ones
    for _, button in pairs(emoteButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(emoteButtons)

    local buttonWidth, buttonHeight = 40, 80
    local padding, columns = 5, 4
    local startX, startY = 2, -10

    for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
        local btn = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
        btn:SetSize(buttonWidth, buttonHeight)
        btn:SetBackdrop({ bgFile = emoteData.icon })
        btn:SetNormalTexture(nil)
        btn:SetPushedTexture(nil)
        btn:SetHighlightTexture(nil)

        -- compute row & col
        local row = math.floor((i - 1) / columns)
        local col = (i - 1) % columns

        -- apply X/Y offsets
        local x = XOffset + startX + (buttonWidth + padding) * col
        local y = startY - YOffset - (buttonHeight + padding) * row

        btn:SetPoint("TOPLEFT", buttonContainer, "TOPLEFT", x, y)

        if not emoteData.command or emoteData.command == "" then
            btn:SetBackdropColor(0.247, 0.220, 0.153, 1)
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

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            GameTooltip:SetText(emoteData.name, 1, 1, 1)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        table.insert(emoteButtons, btn)
    end
end
SetupEmoteButtons(-8, -10)



-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_EmoteBook.frame:IsShown() then
        EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red
    else
        EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
    end
end
WORS_U_EmoteBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_EmoteBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- function to replace EmotesMicroButton on click
local function OnEmoteClick(self)		
	MicroMenu_ToggleFrame(WORS_U_EmoteBook.frame)--:Show()
end

EmotesMicroButton:SetScript("OnClick", OnEmoteClick)

EmotesMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:Show()
    end
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