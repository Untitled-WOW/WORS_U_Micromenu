-- Create the main frame for the custom emote book
--WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent, "OldSchoolFrameTemplate")
WORS_U_EmoteBook.frame:SetSize(192, 304)


local bg = WORS_U_EmoteBook.frame:CreateTexture(nil, "BACKGROUND")
WORS_U_EmoteBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_EmoteBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)


local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
	local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
	WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
else
	WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
end	


WORS_U_EmoteBook.frame:SetFrameStrata("LOW")
WORS_U_EmoteBook.frame:SetFrameLevel(5)

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
WORS_U_EmoteBook.frame.CloseButton:SetScript("PostClick", function(self)
	RestoreMicroButtonsFromMicroMenu()	
end)	



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
	if IsShiftKeyDown() then 
		WORS_U_EmoteBook.frame:ClearAllPoints()
		WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
		SaveFramePosition(WORS_U_EmoteBook.frame)
	end	
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos then
		local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
		SaveFramePosition(WORS_U_EmoteBook.frame)
	end	
	if WORS_U_EmoteBook.frame:IsShown() then
		WORS_U_EmoteBook.frame:Hide()		
	else		
		WORS_U_EmoteBook.frame:Show()
		CloseBackpack()
		if not InCombatLockdown() then
			WORS_U_SpellBook.frame:Hide()
			WORS_U_SpellBook.frame:SetAttribute("userToggle", nil)
			WORS_U_PrayBook.frame:Hide()	
			WORS_U_PrayBook.frame:SetAttribute("userToggle", nil)			
			CombatStylePanel:Hide()		
		end
	end
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