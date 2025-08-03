-- Main frame for the music player
WORS_U_MusicBook.musicPlayer = CreateFrame("Frame", "WORS_U_MusicPlayerFrame", UIParent)
WORS_U_MusicBook.musicPlayer:SetSize(180, 330)
-- WORS_U_MusicBook.musicPlayer:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground1",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 32,
    -- insets = { left = 5, right = 5, top = 5, bottom = 5 }
-- })
WORS_U_MusicBook.musicPlayer:Hide()
WORS_U_MusicBook.musicPlayer:SetMovable(true)
WORS_U_MusicBook.musicPlayer:EnableMouse(true)
WORS_U_MusicBook.musicPlayer:RegisterForDrag("LeftButton")
WORS_U_MusicBook.musicPlayer:SetClampedToScreen(true)
local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
	local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
	WORS_U_MusicBook.musicPlayer:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
else
	WORS_U_MusicBook.musicPlayer:SetPoint("CENTER")
end	

WORS_U_MusicBook.musicPlayer:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_MusicBook.musicPlayer:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
	SaveFramePosition(self)
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
end)

local trackFrame = CreateFrame("Frame", nil, WORS_U_MusicBook.musicPlayer)
trackFrame:SetAllPoints(WORS_U_MusicBook.musicPlayer)
-- bump it 2 levels above the musicPlayer itself
trackFrame:SetFrameLevel(WORS_U_MusicBook.musicPlayer:GetFrameLevel() + 2)

WORS_U_MusicBook.trackLabel = trackFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_MusicBook.trackLabel:SetPoint("TOP", trackFrame, "TOP", 0, -10)
WORS_U_MusicBook.trackLabel:SetText("No track playing")
WORS_U_MusicBook.trackLabel:SetTextColor(1, 1, 1)

local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_MusicBook.musicPlayer, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(180, 240)
scrollFrame:SetPoint("TOP", WORS_U_MusicBook.trackLabel, "BOTTOM", 0, -10)
local scrollBar = scrollFrame.ScrollBar 
local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
scrollBar:Hide(); scrollBar:SetAlpha(0); scrollUpButton:Hide(); scrollDownButton:Hide(); scrollUpButton:SetAlpha(0); scrollDownButton:SetAlpha(0)
scrollBar:EnableMouse(false)  -- Disable mouse interaction on the bar itself

local contentFrame = CreateFrame("Frame", nil, scrollFrame)
contentFrame:SetSize(180, 500)  -- Adjust the height based on the number of tracks
scrollFrame:SetScrollChild(contentFrame)

-- Function to play the specified track
function WORS_U_MusicBook:PlayTrack(track)
    if track and track.file then
        StopMusic()
        PlayMusic(track.file)
        self.currentTrack = track
        self.trackLabel:SetText("" .. track.name)
    else
		print("|cff00ff00MicroMenu: |r" .. "|cffff0000Error M1 Message Untitled: |r Track: " .. track .. "|cff00ff00Invalid track file path or track is nil.|r")
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
        local button = CreateFrame("Button", nil, contentFrame, "OldSchoolButtonTemplate")
        button:SetText("Play " .. track.name)
        button:SetSize(150, 25)
        button:SetPoint("TOP", contentFrame, "TOP", 0, -30 * (i - 1))
		button:SetScript("OnClick", function()
            WORS_U_MusicBook:PlayTrack(track)
        end)
	end
	
-- Stop button positioned at the bottom of the main frame
local stopButton = CreateFrame("Button", nil, WORS_U_MusicBook.musicPlayer, "OldSchoolButtonTemplate")
stopButton:SetSize(150, 25)                            -- same size as Play buttons
stopButton:SetPoint("BOTTOM", WORS_U_MusicBook.musicPlayer, "BOTTOM", 0, 10)
stopButton:SetText("Stop")                             -- use the template’s built-in text
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
end
WORS_U_MusicBook.musicPlayer:SetScript("OnShow", UpdateButtonBackground)
WORS_U_MusicBook.musicPlayer:SetScript("OnHide", UpdateButtonBackground)

-- Update background color based on visibility
local function OnMusicClick(self)	
	MicroMenu_ToggleFrame(WORS_U_MusicBook.musicPlayer)--:Show()
end

MusicMicroButton:SetScript("OnClick", OnMusicClick)
MusicMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:Show()
    end
end)