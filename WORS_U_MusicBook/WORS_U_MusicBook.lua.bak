-- WORS_U_MusicBook Addon
WORS_U_MusicBook = {}
WORS_U_MusicBook.tracks = {
    { name = "Sea Shanty", file = "Sound\\RuneScape\\Sea_Shanty_2.ogg" },
    { name = "Harmony", file = "Sound\\RuneScape\\Harmony.ogg" },
	{ name = "Harmony 2", file = "Sound\\RuneScape\\Harmony_2.ogg" },
	{ name = "Runescape Main", file = "Sound\\RuneScape\\Scape_Main.ogg" },
	{ name = "Runescape Theme", file = "Sound\\RuneScape\\Runescape_Theme.ogg" },
	{ name = "Wilderness", file = "Sound\\RuneScape\\Wilderness.ogg" },
	{ name = "Wilderness 2", file = "Sound\\RuneScape\\Wilderness_2.ogg" },

}

WORS_U_MusicBook.currentTrack = nil

-- Transparency settings for cycling
local transparencyLevels = {1, 0.75, 0.5, 0.25}
local currentTransparencyIndex = 1
WORS_U_MusicBookSettings = WORS_U_MusicBookSettings or {}
WORS_U_MusicBookSettings.transparency = WORS_U_MusicBookSettings.transparency or 1

-- Main frame for the music player
WORS_U_MusicBook.musicPlayer = CreateFrame("Frame", "WORS_U_MusicPlayerFrame", UIParent)
WORS_U_MusicBook.musicPlayer:SetSize(190, 260)
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

-- Scroll frame for the track buttons
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_MusicBook.musicPlayer, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(160, 180)
scrollFrame:SetPoint("TOP", WORS_U_MusicBook.trackLabel, "BOTTOM", 0, -10)
-- Hiding the scroll bar
local scrollBar = scrollFrame.ScrollBar or _G[scrollFrame:GetName() .. "ScrollBar"]  -- Reference to the scrollbar
if scrollBar then
    scrollBar:DisableDrawLayer("BACKGROUND")  -- Hide the background
    scrollBar:GetThumbTexture():SetAlpha(0)  -- Make the thumb texture transparent

    -- Hide the scroll buttons
    local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
    local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]

    -- Hide textures for scroll up button
    scrollUpButton:GetNormalTexture():SetAlpha(0) -- Hide normal texture
    scrollUpButton:GetPushedTexture():SetAlpha(0) -- Hide pushed texture
    scrollUpButton:GetDisabledTexture():SetAlpha(0) -- Hide disabled texture
    scrollUpButton:GetHighlightTexture():SetAlpha(0) -- Hide highlight texture

    -- Hide textures for scroll down button
    scrollDownButton:GetNormalTexture():SetAlpha(0) -- Hide normal texture
    scrollDownButton:GetPushedTexture():SetAlpha(0) -- Hide pushed texture
    scrollDownButton:GetDisabledTexture():SetAlpha(0) -- Hide disabled texture
    scrollDownButton:GetHighlightTexture():SetAlpha(0) -- Hide highlight texture
end



-- Content frame for track buttons inside the scroll frame
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

-- Create individual play buttons for each track inside the scrollable content frame
local function CreateMusicButtons()
    for i, track in ipairs(WORS_U_MusicBook.tracks) do
        local button = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
        button:SetText("Play " .. track.name)
        button:SetSize(150, 25)
        button:SetPoint("TOP", contentFrame, "TOP", 0, -30 * (i - 1))
        button:SetScript("OnClick", function()
            WORS_U_MusicBook:PlayTrack(track)
        end)
        -- Set up the button border
        button:SetBackdrop({
            edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border", -- Border texture
            edgeSize = 8,  -- Border thickness
            insets = { left = 2, right = 2, top = 2, bottom = 2 },  -- Insets for border
        })
        -- Hide the default textures
        button:SetNormalTexture(nil)
        button:SetPushedTexture(nil)
        button:SetHighlightTexture(nil)

	end
	
	

-- Stop button positioned at the bottom of the main frame
-- Stop button positioned at the bottom of the main frame
local stopButton = CreateFrame("Button", "WORS_U_MusicBook_StopButton", WORS_U_MusicBook.musicPlayer)
stopButton:SetSize(150, 30)
stopButton:SetPoint("BOTTOM", WORS_U_MusicBook.musicPlayer, "BOTTOM", 0, 10)

-- Set backdrop for the button
stopButton:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",  -- No background texture
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border", -- Border texture
    edgeSize = 8,  -- Border thickness
    insets = { left = 2, right = 2, top = 2, bottom = 2 },  -- Insets for border
})

-- Set the background color to red
stopButton:SetBackdropColor(1, 0, 0, 1)  -- RGBA values (Red, Green, Blue, Alpha)

-- Set up text on the button
stopButton.text = stopButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
stopButton.text:SetPoint("CENTER")  -- Center the text
stopButton.text:SetText("Stop")  -- Set button text to "Stop"

-- Remove button textures to show the backdrop color
--stopButton:SetNormalTexture(nil)
--stopButton:SetPushedTexture(nil)
--stopButton:SetHighlightTexture(nil)

-- OnClick function for the button
stopButton:SetScript("OnClick", function()
    WORS_U_MusicBook:StopTrack()
end)


end
CreateMusicButtons()

-- Transparency functions (Load and Save)
local function LoadTransparency()
    local savedAlpha = WORS_U_MusicBookSettings.transparency or 1
    WORS_U_MusicBook.musicPlayer:SetAlpha(savedAlpha)
    print("Transparency loaded:", savedAlpha * 100 .. "%")
end

local function SaveTransparency()
    WORS_U_MusicBookSettings.transparency = transparencyLevels[currentTransparencyIndex]
    print("Transparency saved:", WORS_U_MusicBookSettings.transparency * 100 .. "%")
end

-- Update background color based on visibility
local function UpdateButtonBackground()
    if WORS_U_MusicBook.musicPlayer:IsShown() then
        MusicMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0)  -- Red color when open
    else
        MusicMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)  -- Default color when closed
    end
    LoadTransparency()
end

-- Toggle function with Alt key for transparency
local function OnMusicClick(self)
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
        UpdateButtonBackground()
    end
end
MusicMicroButton:SetScript("OnClick", OnMusicClick)




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


-- **********************************************************************
-- **********************************************************************
-- ************************OLD CODE FOR TOGGLE BUTTON *******************
-- **********************************************************************
-- **********************************************************************




-- -- Create the toggle button only if it doesn't exist
-- if not WORS_U_MusicBook.toggleButton then
    -- WORS_U_MusicBook.toggleButton = CreateFrame("Button", "WORS_U_MusicBookToggleButton", UIParent)
    -- WORS_U_MusicBook.toggleButton:SetSize(30, 35)
    -- WORS_U_MusicBook.toggleButton:SetMovable(true)
    -- WORS_U_MusicBook.toggleButton:SetClampedToScreen(true)
    -- WORS_U_MusicBook.toggleButton:EnableMouse(true)
    -- WORS_U_MusicBook.toggleButton:RegisterForDrag("LeftButton")
    -- WORS_U_MusicBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
    -- WORS_U_MusicBook.toggleButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- -- Custom background texture for the button
    -- WORS_U_MusicBook.toggleButton:SetBackdrop({
        -- bgFile = "Interface\\WORS\\OldSchoolBackground2",
        -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
        -- tile = false, tileSize = 32, edgeSize = 16,
        -- insets = { left = 1, right = 1, top = 1, bottom = 1 }
    -- })

    -- -- Icon for the toggle button
    -- local icon = WORS_U_MusicBook.toggleButton:CreateTexture(nil, "ARTWORK")
    -- icon:SetSize(25, 25)
    -- icon:SetPoint("CENTER")
    -- icon:SetTexture("Interface\\Icons\\bluephat")  -- Replace with your preferred icon

    -- -- Set position if no saved position exists
    -- WORS_U_MusicBook.toggleButton:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
-- end

-- -- Toggle button functionality for transparency and frame show/hide
-- WORS_U_MusicBook.toggleButton:SetScript("OnClick", function()
    -- if IsAltKeyDown() then
        -- currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        -- WORS_U_MusicBook.musicPlayer:SetAlpha(transparencyLevels[currentTransparencyIndex])
        -- SaveTransparency()
        -- print("Music Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100 .. "%")
    -- else
        -- if WORS_U_MusicBook.musicPlayer:IsShown() then
            -- WORS_U_MusicBook.musicPlayer:Hide()
        -- else
            -- WORS_U_MusicBook.musicPlayer:Show()
        -- end
        -- UpdateButtonBackground()  -- Update the background color based on visibility
    -- end
-- end)

-- -- Load transparency and update button background on addon load
-- --MusicMicroButton:Hide()
-- LoadTransparency()
-- UpdateButtonBackground()  -- Ensure initial background color is correct