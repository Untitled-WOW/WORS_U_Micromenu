WORS_U_EmoteBook = WORS_U_EmoteBook or {}
WORS_U_EmoteBook.emotes = {

    { name = "Yes", command = "nod" },
    { name = "No", command = "no" },
	{ name = "Dance", command = "dance" },
    { name = "Cheer", command = "cheer" },
    { name = "Poke", command = "poke" },
    { name = "Sniff", command = "sniff" },
	{ name = "Gasp", command = "gasp" },
    { name = "Bonk", command = "bonk" },
    { name = "Sorry", command = "apologize" },
    { name = "Bow", command = "bow" },
	{ name = "Clap", command = "clap" },
    { name = "Cry", command = "cry" },
    { name = "Bark", command = "bark" },
    { name = "Chicken", command = "chicken" },
	{ name = "Moo", command = "moo" },
    { name = "Purr", command = "purr" },
	
}

-- Initialize saved variables for transparency
WORS_U_EmoteBookSettings = WORS_U_EmoteBookSettings or {
    transparency = 1,  -- Default transparency value
}

-- Function to load transparency from saved variables
local function LoadTransparency()
    local savedAlpha = WORS_U_EmoteBookSettings.transparency or 1
    WORS_U_EmoteBook.frame:SetAlpha(savedAlpha)  -- Load the transparency value
    print("Transparency loaded:", savedAlpha * 100 .. "%")  -- Debug output
end

-- Function to save transparency on change or logout
local function SaveTransparency()
    WORS_U_EmoteBookSettings.transparency = WORS_U_EmoteBook.frame:GetAlpha()
    print("Transparency saved:", WORS_U_EmoteBookSettings.transparency * 100 .. "%")  -- Debug output
end

-- Create the main frame for the custom emote book
WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent)
WORS_U_EmoteBook.frame:SetSize(190, 260)
WORS_U_EmoteBook.frame:SetPoint("CENTER")
WORS_U_EmoteBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 6, top = 6, bottom = 5 }
})

WORS_U_EmoteBook.frame:Hide()
WORS_U_EmoteBook.frame:SetMovable(true)
WORS_U_EmoteBook.frame:EnableMouse(true)
WORS_U_EmoteBook.frame:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_EmoteBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Movable button to toggle prayer book
local function SaveButtonPosition()
    WORS_U_EmoteBookButtonPosition = { WORS_U_EmoteBook.toggleButton:GetPoint() }
end

-- Save settings on logout
local function OnLogout()
	SaveButtonPosition()
    SaveTransparency()
end

-- Register the logout event
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", OnLogout)

-- Initialize emote buttons
local emoteButtons = {}

local function SetupEmoteButtons()
    -- Clear existing buttons before creating new ones
    for _, button in pairs(emoteButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(emoteButtons)

    -- Button size configuration
    local buttonWidth = 35  -- Custom width for buttons
    local buttonHeight = 25  -- Custom height for buttons
    local padding = 10
    local columns = 4

    for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
        local emoteButton = CreateFrame("Button", nil, WORS_U_EmoteBook.frame, "UIPanelButtonTemplate")
        emoteButton:SetSize(buttonWidth, buttonHeight)

        -- Calculate position
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        emoteButton:SetPoint("TOPLEFT", padding + (buttonWidth + padding) * column, -padding - (buttonHeight + padding) * row)

        -- Set up the button label and text
        emoteButton:SetText(emoteData.name)
        emoteButton:SetNormalFontObject("GameFontNormalSmall")

        -- Set up button functionality
        emoteButton:SetScript("OnClick", function()
            print("Button clicked: " .. emoteData.name)  -- Debug output
            DoEmote(emoteData.command)  -- Use the actual command for each emote
        end)

        table.insert(emoteButtons, emoteButton)
    end

    LoadTransparency()  -- Load the saved transparency when buttons are set up
end



-- Movable button to toggle emote book
WORS_U_EmoteBook.toggleButton = CreateFrame("Button", "WORS_U_EmoteBookToggleButton", UIParent)
WORS_U_EmoteBook.toggleButton:SetSize(30, 35)
WORS_U_EmoteBook.toggleButton:SetMovable(true)
WORS_U_EmoteBook.toggleButton:SetClampedToScreen(true)
WORS_U_EmoteBook.toggleButton:EnableMouse(true)
WORS_U_EmoteBook.toggleButton:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_EmoteBook.toggleButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Custom background texture for the toggle button
WORS_U_EmoteBook.toggleButton:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 16,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
})

-- Icon texture for the toggle button
local icon = WORS_U_EmoteBook.toggleButton:CreateTexture(nil, "ARTWORK")
icon:SetSize(25, 25)
icon:SetPoint("CENTER")
icon:SetTexture("Interface\\Icons\\redhalloweenmask")  -- Replace with your emote icon

-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_EmoteBook.frame:IsShown() then
        WORS_U_EmoteBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
    else
        WORS_U_EmoteBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
    end
end

-- Transparency levels
local transparencyLevels = {1, 0.75, 0.5, 0.25}
local currentTransparencyIndex = 1

-- OnClick to toggle the emote book and transparency
WORS_U_EmoteBook.toggleButton:SetScript("OnClick", function(self)
    if IsAltKeyDown() then
        -- Cycle through transparency levels
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_EmoteBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()  -- Save transparency after change
        print("Emote Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100 .. "%")
    else
        -- Standard toggle functionality
        if WORS_U_EmoteBook.frame:IsShown() then
            print("Hiding Emote Book")  -- Debug output
            WORS_U_EmoteBook.frame:Hide()
        else
            print("Showing Emote Book")  -- Debug output
            SetupEmoteButtons()  -- Ensure buttons are set up
            WORS_U_EmoteBook.frame:Show()
        end
		UpdateButtonBackground()
    end
end)

-- Initial transparency load
LoadTransparency()

-- Position the toggle button
--WORS_U_EmoteBook.toggleButton:SetPoint("CENTER")
-- Initial highlight update
EmotesMicroButton:Hide()
UpdateButtonBackground()
WORS_U_EmoteBook.toggleButton:SetPoint(unpack(WORS_U_EmoteBookButtonPosition or {"CENTER"}))