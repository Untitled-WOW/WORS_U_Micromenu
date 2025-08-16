--	Emote Book init (no 'f' aliases)
WORS_U_EmoteBook = WORS_U_EmoteBook or {}

local function WORS_U_EmoteBook_Init()
	-- require the XML frame
	if not WORS_U_EmoteBookFrame then return end

	WORS_U_EmoteBook.frame = WORS_U_EmoteBookFrame

	-- restore saved position

	local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
	WORS_U_EmoteBook.frame:ClearAllPoints()
	if pos then
		local relativeTo = (pos.relativeTo and _G[pos.relativeTo]) or UIParent
		WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
	end


	-- ScrollFrame wiring (ButtonContainer is child of the ScrollFrame)
	local scrollFrame = WORS_U_EmoteBook.frame.ScrollFrame
	local buttonContainer = scrollFrame and scrollFrame.ButtonContainer
	if scrollFrame and buttonContainer then
		scrollFrame:SetScrollChild(buttonContainer)
		buttonContainer:ClearAllPoints()
		buttonContainer:SetPoint("TOPLEFT")
	end

	-- build emote buttons
	local emoteButtons = {}
	local function SetupEmoteButtons(XOffset, YOffset)
		for _, b in pairs(emoteButtons) do b:Hide(); b:SetParent(nil) end
		wipe(emoteButtons)

		local buttonWidth, buttonHeight = 40, 80
		local padding, columns = 5, 4
		local startX, startY = 2, -10

		for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
			local btn = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
			btn:SetSize(buttonWidth, buttonHeight)
			btn:SetBackdrop({ bgFile = emoteData.icon })
			btn:SetNormalTexture(nil); btn:SetPushedTexture(nil); btn:SetHighlightTexture(nil)

			local row = floor((i - 1) / columns)
			local col = (i - 1) % columns
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

			tinsert(emoteButtons, btn)
		end
	end
	SetupEmoteButtons(-8, -10)

	-- microbutton tinting
	local function UpdateButtonBackground()
		if WORS_U_EmoteBook.frame:IsShown() then
			EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0)
		else
			EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
		end
	end
	WORS_U_EmoteBook.frame:SetScript("OnShow", UpdateButtonBackground)
	WORS_U_EmoteBook.frame:SetScript("OnHide", UpdateButtonBackground)

	-- Emotes microbutton behavior
	local function OnEmoteClick(self)
		if IsShiftKeyDown() then
			WORS_U_EmoteBook.frame:ClearAllPoints()
			WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
			if SaveFramePosition then SaveFramePosition(WORS_U_EmoteBook.frame) end
		end

		local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
		WORS_U_EmoteBook.frame:ClearAllPoints()
		if pos then
			local relativeTo = (pos.relativeTo and _G[pos.relativeTo]) or UIParent
			WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
		else
			WORS_U_EmoteBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
			if SaveFramePosition then SaveFramePosition(WORS_U_EmoteBook.frame) end
		end

		if WORS_U_EmoteBook.frame:IsShown() then
			WORS_U_EmoteBook.frame:Hide()
		else
			WORS_U_EmoteBook.frame:Show()
			CloseBackpack()
			if not InCombatLockdown() then
				WORS_U_SpellBookFrame:Hide(); WORS_U_SpellBookFrame:SetAttribute("userToggle", nil)
				WORS_U_PrayBookFrame:Hide();  WORS_U_PrayBookFrame:SetAttribute("userToggle", nil)
				CombatStylePanel:Hide()
			end
		end
	end
	EmotesMicroButton:SetScript("OnClick", OnEmoteClick)
	EmotesMicroButton:HookScript("OnEnter", function(self)
		if GameTooltip:IsOwned(self) then GameTooltip:Show() end
	end)

	-- slash commands for "_" emotes
	for _, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
		local cmd = emoteData.command
		if cmd and cmd:sub(1,1) == "_" then
			local slash = cmd:sub(2)
			local U = slash:upper()
			_G["SLASH_"..U.."1"] = "/"..slash
			SlashCmdList[U] = function() SendChatMessage(cmd, "SAY") end
		end
	end
end

--	run now if the frame already exists, otherwise wait until the addon loads
if WORS_U_EmoteBookFrame then
	WORS_U_EmoteBook_Init()
else
	local __mm_emote_loader = CreateFrame("Frame")
	__mm_emote_loader:RegisterEvent("ADDON_LOADED")
	__mm_emote_loader:SetScript("OnEvent", function(_, addon)
		-- adjust addon name if your TOC name differs
		if WORS_U_EmoteBookFrame then
			__mm_emote_loader:UnregisterEvent("ADDON_LOADED")
			WORS_U_EmoteBook_Init()
		end
	end)
end
