-- WORS_U_MusicBook Addon
WORS_U_MusicBook = {}
WORS_U_MusicBook.tracks = {
    { name = "Sea Shanty", file = "Sound\\RuneScape\\Sea_Shanty_2.ogg" },
    { name = "Harmony", file = "Sound\\RuneScape\\Harmony.ogg" },
    { name = "Wilderness", file = "Sound\\RuneScape\\Wilderness.ogg" },
}

WORS_U_MusicBook.currentTrack = nil

-- Transparency settings for cycling
local transparencyLevels = {1, 0.75, 0.5, 0.25}
local currentTransparencyIndex = 1
WORS_U_MusicBookSettings = WORS_U_MusicBookSettings or {}
WORS_U_MusicBookSettings.transparency = WORS_U_MusicBookSettings.transparency or 1

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

-- Label to show the currently playing track
WORS_U_MusicBook.trackLabel = WORS_U_MusicBook.musicPlayer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_MusicBook.trackLabel:SetPoint("TOP", WORS_U_MusicBook.musicPlayer, "TOP", 0, -10)
WORS_U_MusicBook.trackLabel:SetText("No track playing")

-- Function to play the specified track
function WORS_U_MusicBook:PlayTrack(track)
    if track and track.file then
        StopMusic()
        PlayMusic(track.file)
        self.currentTrack = track
        self.trackLabel:SetText("Now Playing: " .. track.name)
    else
        print("Invalid track file path or track is nil.")
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

-- Create individual play buttons for each track
local function CreateMusicButtons()
    for i, track in ipairs(WORS_U_MusicBook.tracks) do
        local button = CreateFrame("Button", nil, WORS_U_MusicBook.musicPlayer, "UIPanelButtonTemplate")
        button:SetText("Play " .. track.name)
        button:SetSize(120, 30)  -- Button size
        button:SetPoint("TOP", WORS_U_MusicBook.musicPlayer, "TOP", 0, -30 * i)  -- Position vertically
        button:SetScript("OnClick", function()
            WORS_U_MusicBook:PlayTrack(track)
        end)
    end

    local stopButton = CreateFrame("Button", nil, WORS_U_MusicBook.musicPlayer, "UIPanelButtonTemplate")
    stopButton:SetText("Stop")
    stopButton:SetSize(120, 30)
    stopButton:SetPoint("BOTTOM", WORS_U_MusicBook.musicPlayer, "BOTTOM", 0, 10)
    stopButton:SetScript("OnClick", function()
        WORS_U_MusicBook:StopTrack()
    end)
end
CreateMusicButtons()

-- Functions for saving/loading transparency
-- Load transparency and set the current index based on the saved setting
-- Function to load transparency from saved variables
local function LoadTransparency()
    local savedAlpha = WORS_U_MusicBookSettings.transparency or 1
    WORS_U_MusicBook.musicPlayer:SetAlpha(savedAlpha)  -- Load the transparency value
    print("Transparency loaded:", savedAlpha * 100 .. "%")  -- Debug output
end



local function SaveTransparency()
    WORS_U_MusicBookSettings.transparency = transparencyLevels[currentTransparencyIndex]
    print("Transparency saved:", WORS_U_MusicBookSettings.transparency * 100 .. "%")
end

-- Define the function to update the background color of the toggle button
local function UpdateButtonBackground()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
        WORS_U_MusicBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
    else
        WORS_U_MusicBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
    end
	LoadTransparency()
end

-- Create the toggle button only if it doesn't exist
if not WORS_U_MusicBook.toggleButton then
    WORS_U_MusicBook.toggleButton = CreateFrame("Button", "WORS_U_MusicBookToggleButton", UIParent)
    WORS_U_MusicBook.toggleButton:SetSize(30, 35)
    WORS_U_MusicBook.toggleButton:SetMovable(true)
    WORS_U_MusicBook.toggleButton:SetClampedToScreen(true)
    WORS_U_MusicBook.toggleButton:EnableMouse(true)
    WORS_U_MusicBook.toggleButton:RegisterForDrag("LeftButton")
    WORS_U_MusicBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
    WORS_U_MusicBook.toggleButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- Custom background texture for the button
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

    -- Set position if no saved position exists
    WORS_U_MusicBook.toggleButton:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
end

-- Toggle button functionality for transparency and frame show/hide
WORS_U_MusicBook.toggleButton:SetScript("OnClick", function()
    if IsAltKeyDown() then
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_MusicBook.musicPlayer:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()
        print("Music Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100 .. "%")
    else
        if WORS_U_MusicBook.musicPlayer:IsShown() then
            WORS_U_MusicBook.musicPlayer:Hide()
        else
            WORS_U_MusicBook.musicPlayer:Show()
        end
        UpdateButtonBackground()  -- Update the background color based on visibility
    end
end)

-- Load transparency and update button background on addon load
LoadTransparency()
UpdateButtonBackground()  -- Ensure initial background color is correct

-- Command to show/hide the music player
SLASH_WORSUMUSICBOOK1 = "/worsuplayer"
SlashCmdList["WORSUMUSICBOOK"] = function()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
        WORS_U_MusicBook.musicPlayer:Hide()
    else
        WORS_U_MusicBook.musicPlayer:Show()
    end
    UpdateButtonBackground()  -- Update background when using the slash command
end
