-- WORS_U_MusicBook Addon
WORS_U_MusicBook = {}
WORS_U_MusicBook.tracks = {
    { name = "Sea Shanty", file = "Sound\\RuneScape\\Sea_Shanty_2.ogg" },
    { name = "Harmony", file = "Sound\\RuneScape\\Harmony.ogg" },
    { name = "Wilderness", file = "Sound\\RuneScape\\Wilderness.ogg" },
}

WORS_U_MusicBook.currentTrack = nil

-- Main frame for the music player
WORS_U_MusicBook.musicPlayer = CreateFrame("Frame", "WORS_U_MusicPlayerFrame", UIParent)
WORS_U_MusicBook.musicPlayer:SetSize(190, 260)  -- Increased size
WORS_U_MusicBook.musicPlayer:SetPoint("CENTER")
WORS_U_MusicBook.musicPlayer:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 6, top = 6, bottom = 5 }
})

WORS_U_MusicBook.musicPlayer:Hide()
WORS_U_MusicBook.musicPlayer:SetMovable(true)
WORS_U_MusicBook.musicPlayer:EnableMouse(true)
WORS_U_MusicBook.musicPlayer:RegisterForDrag("LeftButton")
WORS_U_MusicBook.musicPlayer:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_MusicBook.musicPlayer:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Text label to show the currently playing track
WORS_U_MusicBook.trackLabel = WORS_U_MusicBook.musicPlayer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_MusicBook.trackLabel:SetPoint("TOP", WORS_U_MusicBook.musicPlayer, "TOP", 0, -10)
WORS_U_MusicBook.trackLabel:SetText("No track playing")

-- Function to play the specified track
function WORS_U_MusicBook:PlayTrack(track)
    if track and track.file then
        StopMusic()
        --SetCVar("Sound_EnableMusic", 0)  -- Mute game music
        PlayMusic(track.file)
        self.currentTrack = track
        self.trackLabel:SetText("Now Playing: " .. track.name)
    else
        print("Invalid track file path or track is nil.")
    end
end
-- function WORS_U_MusicBook:PlayTrack(track)
    -- if track and track.file then
        -- StopMusic()  -- Stop any currently playing music
        -- PlayMusic(track.file)  -- Attempt to play the new track
        -- self.trackLabel:SetText("Now Playing: " .. track.name)  -- Update label
		-- self.currentTrack = track.name
    -- else
        -- print("Invalid track file path or track is nil.")
    -- end
-- end

-- Function to stop the currently playing track
function WORS_U_MusicBook:StopTrack()
    if self.currentTrack then
        StopMusic()
        --SetCVar("Sound_EnableMusic", 1)  -- Unmute game music
        self.trackLabel:SetText("No track playing")
        self.currentTrack = nil
    end
end

-- Create individual play buttons for each track
local function CreateMusicButtons()
    for i, track in ipairs(WORS_U_MusicBook.tracks) do
        local button = CreateFrame("Button", nil, WORS_U_MusicBook.musicPlayer, "UIPanelButtonTemplate")
        button:SetText("Play " .. track.name)
        button:SetSize(120, 30)  -- Button size
        button:SetPoint("TOP", WORS_U_MusicBook.musicPlayer, "TOP", 0, -30 * i)  -- Positioning buttons vertically
        button:SetScript("OnClick", function()
            WORS_U_MusicBook:PlayTrack(track)
        end)
    end

    local stopButton = CreateFrame("Button", nil, WORS_U_MusicBook.musicPlayer, "UIPanelButtonTemplate")
    stopButton:SetText("Stop")
    stopButton:SetSize(120, 30)  -- Stop button size
    stopButton:SetPoint("BOTTOM", WORS_U_MusicBook.musicPlayer, "BOTTOM", 0, 10)  -- Positioning at the bottom
    stopButton:SetScript("OnClick", function()
        WORS_U_MusicBook:StopTrack()
    end)
end

local function UpdateButtonBackground()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
        WORS_U_MusicBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
    else
        WORS_U_MusicBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
    end
end

-- Create the music buttons
CreateMusicButtons()

-- Movable button to toggle the music player frame
WORS_U_MusicBook.toggleButton = CreateFrame("Button", "WORS_U_MusicBookToggleButton", UIParent)
WORS_U_MusicBook.toggleButton:SetSize(30, 35)
WORS_U_MusicBook.toggleButton:SetMovable(true)
WORS_U_MusicBook.toggleButton:SetClampedToScreen(true)
WORS_U_MusicBook.toggleButton:EnableMouse(true)
WORS_U_MusicBook.toggleButton:RegisterForDrag("LeftButton")
WORS_U_MusicBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_MusicBook.toggleButton:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- Custom background texture for the toggle button
local bg = WORS_U_MusicBook.toggleButton:CreateTexture(nil, "BACKGROUND")
WORS_U_MusicBook.toggleButton:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 16,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
})

-- Icon for the toggle button
local icon = WORS_U_MusicBook.toggleButton:CreateTexture(nil, "ARTWORK")
icon:SetSize(25, 25)
icon:SetPoint("CENTER")
icon:SetTexture("Interface\\Icons\\bluephat")  -- Replace with your preferred icon

-- OnClick function to show/hide the music player frame
WORS_U_MusicBook.toggleButton:SetScript("OnClick", function()
    if WORS_U_MusicBook.musicPlayer:IsShown() then		
        WORS_U_MusicBook.musicPlayer:Hide()
    else		
        WORS_U_MusicBook.musicPlayer:Show()
    end
	UpdateButtonBackground()
end)




-- Initial setup to hide the player and set the toggle button position
WORS_U_MusicBook.toggleButton:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
WORS_U_MusicBook.musicPlayer:Hide()

-- Command to show/hide the music player
SLASH_WORSUMUSICBOOK1 = "/worsuplayer"
SlashCmdList["WORSUMUSICBOOK"] = function()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
		
        WORS_U_MusicBook.musicPlayer:Hide()
    else
		UpdateButtonBackground()
        WORS_U_MusicBook.musicPlayer:Show()
    end
end
