-- Main frame for the music player
WORS_U_MusicBook.musicPlayer = CreateFrame("Frame", "WORS_U_MusicPlayerFrame", UIParent)
WORS_U_MusicBook.musicPlayer:SetSize(192, 280)
WORS_U_MusicBook.musicPlayer:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_MusicBook.musicPlayer:Hide()
WORS_U_MusicBook.musicPlayer:SetMovable(true)
WORS_U_MusicBook.musicPlayer:EnableMouse(true)
WORS_U_MusicBook.musicPlayer:RegisterForDrag("LeftButton")
WORS_U_MusicBook.musicPlayer:SetClampedToScreen(true)
tinsert(UISpecialFrames, "WORS_U_MusicPlayerFrame")
WORS_U_MusicBook.musicPlayer:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_MusicBook.musicPlayer:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
local closeButton = CreateFrame("Button", nil, WORS_U_MusicPlayerFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_MusicPlayerFrame, "TOPRIGHT", 4, 4)
WORS_U_MusicBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_MusicBook.musicPlayer:Hide()
    MusicMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	
end)
WORS_U_MusicBook.trackLabel = WORS_U_MusicBook.musicPlayer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_MusicBook.trackLabel:SetPoint("TOP", WORS_U_MusicBook.musicPlayer, "TOP", 0, -10)
WORS_U_MusicBook.trackLabel:SetText("No track playing")
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_MusicBook.musicPlayer, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(160, 180)
scrollFrame:SetPoint("TOP", WORS_U_MusicBook.trackLabel, "BOTTOM", 0, -10)
local scrollBar = scrollFrame.ScrollBar or _G[scrollFrame:GetName() .. "ScrollBar"]  -- Reference to the scrollbar
if scrollBar then
    scrollBar:DisableDrawLayer("BACKGROUND")  -- Hide the background
    scrollBar:GetThumbTexture():SetAlpha(0)  -- Make the thumb texture transparent
    local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
    local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
    scrollUpButton:GetNormalTexture():SetAlpha(0) -- Hide normal texture
    scrollUpButton:GetPushedTexture():SetAlpha(0) -- Hide pushed texture
    scrollUpButton:GetDisabledTexture():SetAlpha(0) -- Hide disabled texture
    scrollUpButton:GetHighlightTexture():SetAlpha(0) -- Hide highlight texture
    scrollDownButton:GetNormalTexture():SetAlpha(0) -- Hide normal texture
    scrollDownButton:GetPushedTexture():SetAlpha(0) -- Hide pushed texture
    scrollDownButton:GetDisabledTexture():SetAlpha(0) -- Hide disabled texture
    scrollDownButton:GetHighlightTexture():SetAlpha(0) -- Hide highlight texture
end
local contentFrame = CreateFrame("Frame", nil, scrollFrame)
contentFrame:SetSize(160, 500)  -- Adjust the height based on the number of tracks
scrollFrame:SetScrollChild(contentFrame)

-- Function to play the specified track
function WORS_U_MusicBook:PlayTrack(track)
    if track and track.file then
        StopMusic()
        PlayMusic(track.file)
        self.currentTrack = track
        self.trackLabel:SetText("" .. track.name)
    else
		print("|cff00ff00MicroMenu: |r" .. "|cffff0000Error: |r" .. "|cff00ff00Invalid track file path or track is nil.|r")
    end
end

-- Function to stop the currently playing track
function WORS_U_MusicBook:StopTrack()
    if self.currentTrack then
        StopMusic()
        self.trackLabel:SetText("No track playing")
        self.currentTrack = nil
    end
end

-- Create individual play buttons for each track inside the scrollable content frame
local function CreateMusicButtons()
    -- Buttons created for all WORS_U_MusicBook.tracks
	for i, track in ipairs(WORS_U_MusicBook.tracks) do
        local button = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
        button:SetText("Play " .. track.name)
        button:SetSize(150, 25)
        button:SetPoint("TOP", contentFrame, "TOP", 0, -30 * (i - 1))
        button:SetBackdrop({
            edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border", -- Border texture
            edgeSize = 8,  -- Border thickness
            insets = { left = 2, right = 2, top = 2, bottom = 2 },  -- Insets for border
        })
        button:SetNormalTexture(nil) -- Hide the default textures
        button:SetPushedTexture(nil) -- Hide the default textures
        button:SetHighlightTexture(nil) -- Hide the default textures
		button:SetScript("OnClick", function()
            WORS_U_MusicBook:PlayTrack(track)
        end)
	end
	
	-- Stop button positioned at the bottom of the main frame
	local stopButton = CreateFrame("Button", "WORS_U_MusicBook_StopButton", WORS_U_MusicBook.musicPlayer)
	stopButton:SetSize(150, 30)
	stopButton:SetPoint("BOTTOM", WORS_U_MusicBook.musicPlayer, "BOTTOM", 0, 10)
	stopButton:SetBackdrop({
		bgFile = "Interface\\WORS\\OldSchoolBackground2",  -- No background texture
		edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border", -- Border texture
		edgeSize = 8,  -- Border thickness
		insets = { left = 2, right = 2, top = 2, bottom = 2 },  -- Insets for border
	})
	stopButton:SetBackdropColor(1, 0, 0, 1) -- Red Background for Stop RGBA values (Red, Green, Blue, Alpha)
	stopButton.text = stopButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	stopButton.text:SetPoint("CENTER")  -- Center the text
	stopButton.text:SetText("Stop")  -- Set button text to "Stop"
	stopButton:SetScript("OnClick", function()
		WORS_U_MusicBook:StopTrack()
	end)


end
CreateMusicButtons()

-- Update background color based on visibility
local function UpdateButtonBackground()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
        MusicMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0)  -- Red color when open
    else
        MusicMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)  -- Default color when closed
    end
    LoadTransparency()
end
WORS_U_MusicBook.musicPlayer:SetScript("OnShow", UpdateButtonBackground)
WORS_U_MusicBook.musicPlayer:SetScript("OnHide", UpdateButtonBackground)

-- Toggle function with Alt key for transparency
local function OnMusicClick(self)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos then
		local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_MusicBook.musicPlayer:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_MusicBook.musicPlayer:SetPoint("CENTER")
	end	
    if IsAltKeyDown() then
		WORS_U_MusicBook.musicPlayer:Show()
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_MusicBook.musicPlayer:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()
    else
        if WORS_U_MusicBook.musicPlayer:IsShown() then
            WORS_U_MusicBook.musicPlayer:Hide()
        else
			MicroMenu_ToggleFrame(WORS_U_MusicBook.musicPlayer)--:Show()   
        end
    end
end
MusicMicroButton:SetScript("OnClick", OnMusicClick)
MusicMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("ALT + Click to change transparency.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)