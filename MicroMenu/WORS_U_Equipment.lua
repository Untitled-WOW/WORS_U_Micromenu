--------------------------


-- WORS_U_Equipment.lua

-- CONFIGURATION CONSTANTS
local BUTTON_SIZE    = 36
local H_PADDING      = 30
local H_PADDING_ROW2 = 10    -- custom horizontal gap for row 2 (e.g., Neck, Back, Shoulder)
local V_PADDING      = 8
local V_PADDING_ROW2 = 8     -- custom vertical gap for rows 2 (between Head/Neck/Back/Shoulder)
local TOP_OFFSET     = 10    -- Offset from the top of the main frame to the first row of buttons

-- Data for each equipment slot, including its ID, grid position, and background texture
local slotData = {
    Head          = { id=1,  row=1, col=2, bg="Head_slot" },
    Neck          = { id=2,  row=2, col=2, bg="Neck_slot" },
    Shoulder      = { id=3,  row=2, col=3, bg="Ammo_slot" }, -- Note: Ammo_slot for Shoulder, common for classic
    Back          = { id=15, row=2, col=1, bg="Cape_slot" },
    Chest         = { id=5,  row=3, col=2, bg="Body_slot" },
    MainHand      = { id=16, row=3, col=1, bg="Weapon_slot" },
    SecondaryHand = { id=17, row=3, col=3, bg="Shield_slot" },
    Hands         = { id=10, row=4, col=1, bg="Hands_slot" },
    Legs          = { id=7,  row=4, col=2, bg="Legs_slot" },
    Finger0       = { id=11, row=4, col=3, bg="Ring_slot" },
    Wrist         = { id=9,  row=5, col=1, bg="2h_slot" },   -- Note: 2h_slot for Wrist, common for classic
    Feet          = { id=8,  row=5, col=2, bg="Feet_slot" },
    Finger1       = { id=12, row=5, col=3, bg="Ring_slot" },
}

-- Global table for the Equipment Book
WORS_U_EquipmentBook = {}

-- Create the main frame
WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "BackdropTemplate")
WORS_U_EquipmentBook.frame:SetSize(180, 330) -- Adjusted width for 3 columns + padding
WORS_U_EquipmentBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left=5, right=5, top=5, bottom=5 },
})
WORS_U_EquipmentBook.frame:Hide()
WORS_U_EquipmentBook.frame:SetMovable(true)
WORS_U_EquipmentBook.frame:EnableMouse(true)
WORS_U_EquipmentBook.frame:RegisterForDrag("LeftButton")
WORS_U_EquipmentBook.frame:SetClampedToScreen(true)

-- Try to load position from saved variables, otherwise center
local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
    local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
    WORS_U_EquipmentBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
else
    WORS_U_EquipmentBook.frame:SetPoint("CENTER")
end

-- Frame drag scripts
WORS_U_EquipmentBook.frame:SetScript("OnDragStart", function(self) 
    self:StartMoving() 
end)
WORS_U_EquipmentBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    -- Save the frame's position when dragging stops
    -- Assumes SaveFramePosition is defined elsewhere (e.g., in WORS_U_MicroMenuSettings)
    SaveFramePosition(self)
end)

-- Close button
local closeBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame)
closeBtn:SetSize(16,16)
closeBtn:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.frame, "TOPRIGHT", 4,4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() 
    WORS_U_EquipmentBook.frame:Hide() 
end)

-- Character button (opens default character frame)
local charBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "OldSchoolButtonTemplate")
charBtn:SetSize(80,20)
charBtn:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.frame, "BOTTOMLEFT", 5,5)
charBtn:SetText("Stats")
charBtn:SetScript("OnClick", function()
    ToggleCharacter("PaperDollFrame") -- This opens the default character pane
end)




-- VALUE FRAME (hidden by default)
WORS_U_EquipmentBook.valueFrame = CreateFrame("Frame", "WORS_U_EquipmentBookValueFrame", UIParent, "BackdropTemplate")
local vf = WORS_U_EquipmentBook.valueFrame
vf:SetSize(500, 400)
vf:SetBackdrop({
    bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile     = true, tileSize = 32, edgeSize = 32,
    insets   = { left=5, right=5, top=5, bottom=5 },
})
vf:SetPoint("CENTER", UIParent, "CENTER", 4, 4)
vf:EnableMouse(true)
vf:SetMovable(true)
vf:RegisterForDrag("LeftButton")
vf:SetClampedToScreen(true)
vf:Hide()

local closeButton = CreateFrame("Button", nil, vf)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", vf, "TOPRIGHT", 4, 4)
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
    vf:Hide()
end)


-- Drag handlers
vf:SetScript("OnDragStart", vf.StartMoving)
vf:SetScript("OnDragStop", vf.StopMovingOrSizing)

-- Title text (centered for whole frame)
vf.title = vf:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
vf.title:SetPoint("TOP", vf, "TOP", 0, -10)
vf.title:SetText("Items kept on Death")

-- ScrollFrame + content (leaving room on right for side panel)
vf.scroll = CreateFrame("ScrollFrame", nil, vf, "UIPanelScrollFrameTemplate")
vf.scroll:SetPoint("TOPLEFT",     vf, "TOPLEFT",     10,  -30)
vf.scroll:SetPoint("BOTTOMRIGHT", vf, "BOTTOMRIGHT", -160,  10)

-- hide the scrollframe borders/background
for _, region in ipairs({vf.scroll:GetRegions()}) do
    region:Hide()
end
-- hide the scrollbar and all of its textures
local sb = vf.scroll.ScrollBar
if sb then
    for _, region in ipairs({sb:GetRegions()}) do
        region:Hide()
    end
    sb:Hide()  -- hides the up/down buttons & thumb as well
end



vf.content = CreateFrame("Frame", nil, vf.scroll)
vf.content:SetSize(1,1)  -- will be resized dynamically
vf.scroll:SetScrollChild(vf.content)

vf.buttons = {}  -- pool of icon buttons

-- toggle state for prayer -- PK Skull and Killed‑By‑Player toggles
WORS_U_EquipmentBook.prayerActive = false
WORS_U_EquipmentBook.pkSkullActive       = false
WORS_U_EquipmentBook.killedByPlayerActive = false




-- side panel (inside the frame, to the right of scroll)
vf.side = CreateFrame("Frame", nil, vf)
vf.side:SetSize(150, 60)
vf.side:SetPoint("TOPRIGHT", vf, "TOPRIGHT", 20, -40)

vf.side.label = vf.side:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
vf.side.label:SetPoint("TOPLEFT", vf.side, "TOPLEFT", 0, 0)
vf.side.label:SetText("Showing info for:")


-- Protect item Prayer toggle button with green overlay when active
vf.side.prayerBtn = CreateFrame("Button", nil, vf.side, "OldSchoolButtonTemplate")
local pb = vf.side.prayerBtn
pb:SetSize(120, 40)
pb:SetPoint("TOP", vf.side.label, "BOTTOM", 0, -5)
pb:SetText("Protect item Prayer\nenabled")

-- create a semi‑transparent green background behind the button
pb.bg = pb:CreateTexture(nil, "BACKGROUND")
pb.bg:SetAllPoints(pb)
pb.bg:SetColorTexture(0, 1, 0, 0.3)  -- green with 30% alpha
pb.bg:Hide()

-- helper to show/hide the green overlay based on prayerActive
local function RefreshPrayerBtn()
    if WORS_U_EquipmentBook.prayerActive then
        pb.bg:Show()
    else
        pb.bg:Hide()
    end
end

-- hook up the toggle logic
pb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.prayerActive = not WORS_U_EquipmentBook.prayerActive
    RefreshPrayerBtn()
    WORS_U_EquipmentBook:UpdateValueFrame()
end)

-- PK Skull button
vf.side.pkSkullBtn = CreateFrame("Button", nil, vf.side, "OldSchoolButtonTemplate")
local pkb = vf.side.pkSkullBtn
pkb:SetSize(120, 40)
pkb:SetPoint("TOP", vf.side.prayerBtn, "BOTTOM", 0, -5)
pkb:SetText("PK Skull active")
-- green overlay
pkb.bg = pkb:CreateTexture(nil, "BACKGROUND")
pkb.bg:SetAllPoints(pkb)
pkb.bg:SetColorTexture(0,1,0,0.3)
pkb.bg:Hide()
local function RefreshPKBtn() if WORS_U_EquipmentBook.pkSkullActive then pkb.bg:Show() else pkb.bg:Hide() end end
pkb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.pkSkullActive = not WORS_U_EquipmentBook.pkSkullActive
    RefreshPKBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
RefreshPKBtn()

-- Killed‑By‑Player button
vf.side.killedBtn = CreateFrame("Button", nil, vf.side, "OldSchoolButtonTemplate")
local kb = vf.side.killedBtn
kb:SetSize(120, 40)
kb:SetPoint("TOP", pkb, "BOTTOM", 0, -5)
kb:SetText("Killed by player")
-- green overlay
kb.bg = kb:CreateTexture(nil, "BACKGROUND")
kb.bg:SetAllPoints(kb)
kb.bg:SetColorTexture(0,1,0,0.3)
kb.bg:Hide()
local function RefreshKilledBtn() if WORS_U_EquipmentBook.killedByPlayerActive then kb.bg:Show() else kb.bg:Hide() end end
kb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.killedByPlayerActive = not WORS_U_EquipmentBook.killedByPlayerActive
    RefreshKilledBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
RefreshKilledBtn()



-- 1) GatherAllItems: unchanged from before
function WORS_U_EquipmentBook:GatherAllItems()
    local items = {}
    -- Equipped
    for _, d in pairs(slotData) do
        local slotID = d.id
        local link = (slotID == 16
            and (GetInventoryItemLink("player",16) or GetInventoryItemLink("player",18)))
            or GetInventoryItemLink("player", slotID)
        if link then
            local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
            items[#items+1] = {
                link    = itemLink   or link,
                texture = iconPath   or "Interface\\Icons\\INV_Misc_QuestionMark",
                price   = tonumber(sellPrice) or 0,
            }
        end
    end
    -- Bags
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
                items[#items+1] = {
                    link    = itemLink   or link,
                    texture = iconPath   or "Interface\\Icons\\INV_Misc_QuestionMark",
                    price   = tonumber(sellPrice) or 0,
                }
            end
        end
    end
    return items
end

function WORS_U_EquipmentBook:UpdateValueFrame()
    local vf      = self.valueFrame
    local content = vf.content

    -- Hide existing buttons
    for _, btn in ipairs(vf.buttons) do btn:Hide() end

    -- Gather & sort
    local items = self:GatherAllItems()
    table.sort(items, function(a,b) return a.price > b.price end)

    -- Determine kept/grave based on prayer and skull toggles
    local kept, grave = {}, {}
    if self.pkSkullActive and not self.killedByPlayerActive then
        -- PK Skull only: everything to gravestone
        grave = items
    elseif not self.pkSkullActive then
        -- Normal prayer split
        local numKeep = self.prayerActive and 4 or 3
        for i, item in ipairs(items) do
            if i <= numKeep then kept[#kept+1] = item
            else              grave[#grave+1] = item end
        end
    end
    -- (if both toggles on, kept/grave stay empty for these two sections)

    -- Layout constants
    local ICON_SIZE, PADDING = 36, 6
    local scrollLeft, scrollRight = 10, 30
    local width  = vf:GetWidth() - scrollLeft - scrollRight
    local perRow = math.min(7, math.max(1, math.floor(width / (ICON_SIZE + PADDING))))
    local y      = -10

    -- Section 1: Kept
    local hdr1 = content.hdr1 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr1 = hdr1
    hdr1:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    hdr1:SetText("Items that are Kept on Death")
    y = y - hdr1:GetHeight() - PADDING

    for i, item in ipairs(kept) do
        local btn = vf.buttons[i] or CreateFrame("Button", nil, content)
        if not vf.buttons[i] then
            btn:SetSize(ICON_SIZE, ICON_SIZE)
            btn.tex   = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
            btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
            vf.buttons[i] = btn
        end
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", content, "TOPLEFT", (i-1)*(ICON_SIZE+PADDING), y)
        btn.tex:SetTexture(item.texture)
        btn.label:SetText(item.price)
        btn:Show()
    end
    y = y - ICON_SIZE - PADDING*2

    -- Section 2: Gravestone
    local hdr2 = content.hdr2 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr2 = hdr2
    hdr2:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    hdr2:SetText("Items that go to your Gravestone")
    y = y - hdr2:GetHeight() - PADDING

    for idx, item in ipairs(grave) do
        local row = math.floor((idx-1)/perRow)
        local col = (idx-1)%perRow
        local slotIndex = (#kept) + idx

        local btn = vf.buttons[slotIndex] or CreateFrame("Button", nil, content)
        if not vf.buttons[slotIndex] then
            btn:SetSize(ICON_SIZE, ICON_SIZE)
            btn.tex   = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
            btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
            vf.buttons[slotIndex] = btn
        end
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                     col*(ICON_SIZE+PADDING),
                     y - row*(ICON_SIZE+PADDING))
        btn.tex:SetTexture(item.texture)
        btn.label:SetText(item.price)
        btn:Show()
    end

    -- Move y down past the gravestone rows
    local graveRows = math.ceil(#grave / perRow)
    y = y - graveRows * (ICON_SIZE + PADDING) - PADDING

    -- Section 3: Lost (only if both toggles on)
    if self.pkSkullActive and self.killedByPlayerActive then
        local hdrLost = content.hdrLost or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
        content.hdrLost = hdrLost
        hdrLost:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdrLost:SetText("Items LOST to the player who kills you:")
        y = y - hdrLost:GetHeight() - PADDING

        for i, item in ipairs(items) do
            local row = math.floor((i-1)/perRow)
            local col = (i-1)%perRow

            local btn = vf.buttons["lost"..i] or CreateFrame("Button", nil, content)
            if not content["lost"..i] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex   = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                vf.buttons["lost"..i] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                         col*(ICON_SIZE+PADDING),
                         y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            btn.label:SetText(item.price)
            btn:Show()
        end
        -- adjust final y if needed
        local lostRows = math.ceil(#items / perRow)
        y = y - lostRows * (ICON_SIZE + PADDING)
    end

    -- Resize scroll-child to fit everything
    content:SetSize(width, -y + PADDING)
end





-- VALUE BUTTON (shows valueFrame)
local valueBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "OldSchoolButtonTemplate")
valueBtn:SetSize(80,20)
valueBtn:SetPoint("BOTTOMRIGHT", WORS_U_EquipmentBook.frame, "BOTTOMRIGHT", -5,5)
valueBtn:SetText("Kept on Death")
valueBtn:SetScript("OnClick", function()
    if vf:IsShown() then vf:Hide() else
        WORS_U_EquipmentBook:UpdateValueFrame()
        vf:Show()
    end
end)



-- Helper function to unequip an item
local function UnequipItem(slotID)
    if GetInventoryItemID("player", slotID) then
        PickupInventoryItem(slotID)
        PutItemInBackpack() -- Puts item into the first available backpack slot
    end
end

WORS_U_EquipmentBook.buttons = {}
local buttonsCreated = false -- Flag to track if buttons have been created

-- Function to create all equipment slot buttons
function WORS_U_EquipmentBook:CreateSlotButtons()
    -- Only create buttons once
    if buttonsCreated then return end
    buttonsCreated = true

    self.buttons = {}
    
    -- Calculate frame width inside this function to ensure it's up-to-date
    local frameW = WORS_U_EquipmentBook.frame:GetWidth() 
    if frameW == 0 then
        -- This warning helps if the frame somehow isn't laid out yet, though unlikely on PLAYER_ENTERING_WORLD
        print("WORS_U_EquipmentBook: WARNING: frameW is 0 during button creation. This might lead to incorrect positioning.")
    end

    for _, d in pairs(slotData) do
        local id, row, col, bg = d.id, d.row, d.col, d.bg
        local isDual = (id == 16) -- Special handling for MainHand (ID 16, also covers OffHand ID 18 for dual wield)
        local name = "WORS_U_EquipSlotBtn"..id

        -- Create ItemButtonTemplate button
        local btn = CreateFrame("Button", name, WORS_U_EquipmentBook.frame, "ItemButtonTemplate")

        btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
        btn:ClearAllPoints()

        -- Calculate horizontal padding based on row
        local padH = (row == 2) and H_PADDING_ROW2 or H_PADDING
        local count = 0
        for _, dd in pairs(slotData) do
            if dd.row == row then count = count + 1 end
        end
        local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
        local leftGapRow = (frameW - rowTotalW) / 2

        -- Calculate horizontal position within the row
        local idx = 0
        for _, dd in pairs(slotData) do
            if dd.row == row and dd.col < col then
                idx = idx + 1
            end
        end
        local x = leftGapRow + idx * (BUTTON_SIZE + padH)

        -- Calculate vertical position
        local y = TOP_OFFSET
        if row >= 2 then
            y = y + BUTTON_SIZE + V_PADDING_ROW2
            if row >= 3 then
                y = y + (row - 2) * (BUTTON_SIZE + V_PADDING)
            end
        end

        btn:SetPoint("TOPLEFT", WORS_U_EquipmentBook.frame, "TOPLEFT", x, -y)
        
        -- Create and set custom background texture
        -- Ensure texture object exists and is on the lowest possible layer
        btn.backgroundTexture = btn:CreateTexture(nil, "BACKGROUND") -- Always create, on BACKGROUND layer
        btn.backgroundTexture:SetAllPoints(btn) -- Make it fill the button
        btn.backgroundTexture:SetTexCoord(0,1,0,1) -- Ensure full texture is shown
        btn.backgroundTexture:SetTexture("Interface\\Icons\\"..bg..".blp")
        btn.backgroundTexture:Show() -- Ensure it's explicitly shown

        -- Get references to template's default sub-textures
        btn.icon    = _G[name.."IconTexture"]
        btn.count  = _G[name.."Count"]
        btn.border = _G[name.."Border"]
        if btn.border then btn.border:Hide() end -- Hide the default border

        -- Remove the default highlight texture from ItemButtonTemplate
        btn:SetHighlightTexture(nil)

        -- Register button interaction scripts
        btn:RegisterForClicks("LeftButtonUp")
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            if isDual then
                -- For MainHand/OffHand, check both slots for tooltip
                if GetInventoryItemTexture("player",16) then
                    GameTooltip:SetInventoryItem("player",16)
                elseif GetInventoryItemTexture("player",18) then
                    GameTooltip:SetInventoryItem("player",18)
                end
            else
                GameTooltip:SetInventoryItem("player",id)
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
        btn:SetScript("OnDragStart", function()
            if isDual then
                -- For MainHand/OffHand, pick up item from either slot if present
                if GetInventoryItemTexture("player",16) then PickupInventoryItem(16)
                elseif GetInventoryItemTexture("player",18) then PickupInventoryItem(18) end
            else
                PickupInventoryItem(id)
            end
        end)
        btn:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                local slotToUnequip = id
                if isDual then
                    if GetInventoryItemTexture("player",16) then
                        slotToUnequip = 16
                    elseif GetInventoryItemTexture("player",18) then
                        slotToUnequip = 18
                    else
                        return -- No item in either main or off-hand
                    end
                end
                UnequipItem(slotToUnequip)
            end
        end)

        self.buttons[id] = btn
    end
end

-- Function to update the icons on the equipment slots
function WORS_U_EquipmentBook:UpdateSlots()
    -- Ensure buttons are created before attempting to update their contents
    if not buttonsCreated then
        WORS_U_EquipmentBook:CreateSlotButtons()
    end

    for _, d in pairs(slotData) do
        local btn = self.buttons[d.id]
        -- Lua 5.1 compatible way to skip iteration instead of 'continue'
        if not btn then 
            print("WORS_U_EquipmentBook: Button for slot ID", d.id, "not found during UpdateSlots(). This should not happen.")
            -- We don't have 'continue', so wrap the rest of the loop in an 'if'
        else 
            local isDual = (d.id == 16)
            local tex = isDual
                and (GetInventoryItemTexture("player",16) or GetInventoryItemTexture("player",18))
                or GetInventoryItemTexture("player",d.id)
            
            if tex then
                btn.icon:SetTexture(tex); btn.icon:Show()
                btn:Enable(); btn:SetAlpha(1)
            else
                btn.icon:Hide()
                if isDual then btn:Disable(); btn:SetAlpha(1) -- Disable MainHand/OffHand if nothing is equipped there
                else btn:Enable(); btn:SetAlpha(1) end -- Keep other slots enabled even if empty
            end
            
            -- Explicitly ensure background texture is shown every update
            if btn.backgroundTexture then
                btn.backgroundTexture:Show()
            end
            btn:Show() -- Ensure the button itself is shown
        end -- Closes the 'if not btn then ... else' block
    end
end


-- Event frame for initial setup and equipment changes
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED") 
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD") 
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, slot,...)
    if event == "ADDON_LOADED" then
        -- Create and update buttons on initial world entry
        C_Timer.After(0.5, function() -- Delay by 0.1 seconds
            WORS_U_EquipmentBook:CreateSlotButtons()
            WORS_U_EquipmentBook:UpdateSlots()

        end)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Only update slots on equipment changes (buttons already exist)
		WORS_U_EquipmentBook:CreateSlotButtons()
        WORS_U_EquipmentBook:UpdateSlots()
    end
end)

-- Hook the default CharacterMicroButton to open our frame
CharacterMicroButton:SetScript("OnClick", function() 
    -- Assuming WORS_U_MicroMenuSettings.MicroMenuPOS is defined elsewhere for position saving
    -- Make sure WORS_U_MicroMenuSettings is loaded before this runs, or handle nil.
    -- The current setup with 'local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS' is safer.
    MicroMenu_ToggleFrame(WORS_U_EquipmentBook.frame) 
end)

-- Visual feedback on MicroButton when our frame is shown/hidden
WORS_U_EquipmentBook.frame:SetScript("OnShow", function(self) 
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,0,0) -- Make button red when frame is open
    WORS_U_EquipmentBook:UpdateSlots() -- Ensure slots are correctly updated/redrawn when shown
end)

WORS_U_EquipmentBook.frame:SetScript("OnHide", function() 
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,1,1) -- Reset button color when frame is closed
end)

-- Tooltip for the hooked CharacterMicroButton
CharacterMicroButton:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:SetText("Equipment",1,1,1)
    GameTooltip:AddLine("Open your equipped items overview.",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b)
    GameTooltip:Show()
end)
CharacterMicroButton:HookScript("OnLeave", GameTooltip_Hide)