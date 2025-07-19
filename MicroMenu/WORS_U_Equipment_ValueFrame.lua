local slotData = {
    Head          = { id=1,  row=1, col=2, bg="Head_slot" },
    Neck          = { id=2,  row=2, col=2, bg="Neck_slot" },
    Shoulder      = { id=3,  row=2, col=3, bg="Ammo_slot" },
    Back          = { id=15, row=2, col=1, bg="Cape_slot" },
    Chest         = { id=5,  row=3, col=2, bg="Body_slot" },
    MainHand      = { id=16, row=3, col=1, bg="Weapon_slot" },
    SecondaryHand = { id=17, row=3, col=3, bg="Shield_slot" },
    Hands         = { id=10, row=4, col=1, bg="Hands_slot" },
    Legs          = { id=7,  row=4, col=2, bg="Legs_slot" },
    Finger0       = { id=11, row=4, col=3, bg="Ring_slot" },
    Wrist         = { id=9,  row=5, col=1, bg="2h_slot" },
    Feet          = { id=8,  row=5, col=2, bg="Feet_slot" },
    Finger1       = { id=12, row=5, col=3, bg="Ring_slot" },
}

-- Ensure the global table exists or initialize it
WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}

WORS_U_EquipmentBook.valueFrame = CreateFrame("Frame", "WORS_U_EquipmentBookValueFrame", UIParent, "BackdropTemplate")

WORS_U_EquipmentBook.valueFrame:SetSize(500, 400)
WORS_U_EquipmentBook.valueFrame:SetBackdrop({
    bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile     = true, tileSize = 32, edgeSize = 32,
    insets   = { left=5, right=5, top=5, bottom=5 },
})
WORS_U_EquipmentBook.valueFrame:SetPoint("CENTER", UIParent, "CENTER", 4, 4)
WORS_U_EquipmentBook.valueFrame:EnableMouse(true)
WORS_U_EquipmentBook.valueFrame:SetMovable(true)
WORS_U_EquipmentBook.valueFrame:RegisterForDrag("LeftButton")
WORS_U_EquipmentBook.valueFrame:SetClampedToScreen(true)
WORS_U_EquipmentBook.valueFrame:Hide()

local closeButton = CreateFrame("Button", nil, WORS_U_EquipmentBook.valueFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.valueFrame, "TOPRIGHT", 4, 4)
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
    WORS_U_EquipmentBook.valueFrame:Hide()
end)

-- Drag handlers
WORS_U_EquipmentBook.valueFrame:SetScript("OnDragStart", WORS_U_EquipmentBook.valueFrame.StartMoving)
WORS_U_EquipmentBook.valueFrame:SetScript("OnDragStop", WORS_U_EquipmentBook.valueFrame.StopMovingOrSizing)

-- Title text (centered for whole frame)
WORS_U_EquipmentBook.valueFrame.title = WORS_U_EquipmentBook.valueFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_EquipmentBook.valueFrame.title:SetPoint("TOP", WORS_U_EquipmentBook.valueFrame, "TOP", 0, -10)
WORS_U_EquipmentBook.valueFrame.title:SetText("Items kept on Death")

-- ScrollFrame + content (leaving room on right for side panel)
WORS_U_EquipmentBook.valueFrame.scroll = CreateFrame("ScrollFrame", nil, WORS_U_EquipmentBook.valueFrame, "UIPanelScrollFrameTemplate")
WORS_U_EquipmentBook.valueFrame.scroll:SetPoint("TOPLEFT",      WORS_U_EquipmentBook.valueFrame, "TOPLEFT",      10,  -30)
WORS_U_EquipmentBook.valueFrame.scroll:SetPoint("BOTTOMRIGHT", WORS_U_EquipmentBook.valueFrame, "BOTTOMRIGHT", -160,  10)

-- hide the scrollframe borders/background
for _, region in ipairs({WORS_U_EquipmentBook.valueFrame.scroll:GetRegions()}) do
    region:Hide()
end
-- hide the scrollbar and all of its textures
local sb = WORS_U_EquipmentBook.valueFrame.scroll.ScrollBar
if sb then
    for _, region in ipairs({sb:GetRegions()}) do
        region:Hide()
    end
    sb:Hide()  -- hides the up/down buttons & thumb as well
end

WORS_U_EquipmentBook.valueFrame.content = CreateFrame("Frame", nil, WORS_U_EquipmentBook.valueFrame.scroll)
WORS_U_EquipmentBook.valueFrame.content:SetSize(1,1)  -- will be resized dynamically
WORS_U_EquipmentBook.valueFrame.scroll:SetScrollChild(WORS_U_EquipmentBook.valueFrame.content)

WORS_U_EquipmentBook.valueFrame.buttons = {}  -- pool of icon buttons

-- toggle state for prayer -- PK Skull and Killed-By-Player toggles
WORS_U_EquipmentBook.prayerActive = false
WORS_U_EquipmentBook.pkSkullActive        = false
WORS_U_EquipmentBook.killedByPlayerActive = false

-- side panel (inside the frame, to the right of scroll)
WORS_U_EquipmentBook.valueFrame.side = CreateFrame("Frame", nil, WORS_U_EquipmentBook.valueFrame)
WORS_U_EquipmentBook.valueFrame.side:SetSize(150, 60)
WORS_U_EquipmentBook.valueFrame.side:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.valueFrame, "TOPRIGHT", 20, -40)

WORS_U_EquipmentBook.valueFrame.side.label = WORS_U_EquipmentBook.valueFrame.side:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
WORS_U_EquipmentBook.valueFrame.side.label:SetPoint("TOPLEFT", WORS_U_EquipmentBook.valueFrame.side, "TOPLEFT", 0, 0)
WORS_U_EquipmentBook.valueFrame.side.label:SetText("Showing info for:")


-- Protect item Prayer toggle button with green color when active
WORS_U_EquipmentBook.valueFrame.side.prayerBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.valueFrame.side, "OldSchoolButtonTemplate")
local pb = WORS_U_EquipmentBook.valueFrame.side.prayerBtn
pb:SetSize(120, 40)
pb:SetPoint("TOP", WORS_U_EquipmentBook.valueFrame.side.label, "BOTTOM", 0, -5)
pb:SetText("Protect item Prayer\nenabled")

-- Create a fully opaque green background texture for the button's active state
pb.bg = pb:CreateTexture(nil, "ARTWORK") -- Changed layer to "ARTWORK"
pb.bg:SetAllPoints(pb)
pb.bg:SetColorTexture(0, 1, 0, 0.3) -- Green with FULL alpha (1.0)
pb.bg:Hide()

-- helper to show/hide the green background based on prayerActive
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
RefreshPrayerBtn() -- Initialize button state

-- PK Skull button
WORS_U_EquipmentBook.valueFrame.side.pkSkullBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.valueFrame.side, "OldSchoolButtonTemplate")
local pkb = WORS_U_EquipmentBook.valueFrame.side.pkSkullBtn
pkb:SetSize(120, 40)
pkb:SetPoint("TOP", WORS_U_EquipmentBook.valueFrame.side.prayerBtn, "BOTTOM", 0, -5)
pkb:SetText("PK Skull active")
-- green background
pkb.bg = pkb:CreateTexture(nil, "ARTWORK") -- Changed layer to "ARTWORK"
pkb.bg:SetAllPoints(pkb)
pkb.bg:SetColorTexture(0,1,0,0.3) -- Green with FULL alpha (1.0)
pkb.bg:Hide()
local function RefreshPKBtn() 
    if WORS_U_EquipmentBook.pkSkullActive then 
        pkb.bg:Show() 
    else 
        pkb.bg:Hide() 
    end 
end
pkb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.pkSkullActive = not WORS_U_EquipmentBook.pkSkullActive
    RefreshPKBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
RefreshPKBtn() -- Initialize button state

-- Killed-By-Player button
WORS_U_EquipmentBook.valueFrame.side.killedBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.valueFrame.side, "OldSchoolButtonTemplate")
local kb = WORS_U_EquipmentBook.valueFrame.side.killedBtn
kb:SetSize(120, 40)
kb:SetPoint("TOP", pkb, "BOTTOM", 0, -5)
kb:SetText("Killed by player")
-- green background
kb.bg = kb:CreateTexture(nil, "ARTWORK") -- Changed layer to "ARTWORK"
kb.bg:SetAllPoints(kb)
kb.bg:SetColorTexture(0,1,0,0.3) -- Green with FULL alpha (1.0)
kb.bg:Hide()
local function RefreshKilledBtn() 
    if WORS_U_EquipmentBook.killedByPlayerActive then 
        kb.bg:Show() 
    else 
        kb.bg:Hide() 
    end 
end
kb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.killedByPlayerActive = not WORS_U_EquipmentBook.killedByPlayerActive
    RefreshKilledBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
RefreshKilledBtn() -- Initialize button state


-- NEW: Guide Risk Value Label
WORS_U_EquipmentBook.valueFrame.side.riskLabel = WORS_U_EquipmentBook.valueFrame.side:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local rL = WORS_U_EquipmentBook.valueFrame.side.riskLabel
rL:SetPoint("TOPLEFT", kb, "BOTTOMLEFT", 0, -10)
rL:SetJustifyH("LEFT")
-- Initial placeholder text with embedded icon
rL:SetText("Guide Risk Value:\n0 |TInterface\\Icons\\CoinsMany.blp:18:18|t")


-- 1) GatherAllItems: Collects all equipped and bag items with their prices AND quantities
function WORS_U_EquipmentBook:GatherAllItems()
    local items = {}
    -- Equipped items
    for slotName, d in pairs(slotData) do 
        local slotID = d.id
        local link = GetInventoryItemLink("player", slotID)
        -- Special handling for MainHand to also check OffHand if MainHand is empty (e.g. 2H weapon)
        if slotName == "MainHand" and not link then
            link = GetInventoryItemLink("player", 18) -- Offhand slot for 2H weapons
        end
        
        if link then
            local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
            -- Get item count for equipped items
            local itemCount = GetInventoryItemCount("player", slotID)
            if slotName == "MainHand" and not itemCount then -- For 2H weapons, count might be on the mainhand slot 16 or offhand 18
                itemCount = GetInventoryItemCount("player", 16) or GetInventoryItemCount("player", 18)
            end
            itemCount = itemCount or 1 -- Default to 1 if no count found (e.g., non-stackable items)

            items[#items+1] = {
                link    = itemLink    or link,
                texture = iconPath    or "Interface\\Icons\\INV_Misc_QuestionMark",
                price   = tonumber(sellPrice) or 0,
                count   = itemCount, -- Store the count
            }
        end
    end
    -- Bag items
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                -- Get itemCount directly from GetContainerItemInfo
                local _, itemCount, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
                -- Get other info from GetItemInfo using the link
                local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
                
                items[#items+1] = {
                    link    = itemLink    or link,
                    texture = iconPath    or "Interface\\Icons\\INV_Misc_QuestionMark",
                    price   = tonumber(sellPrice) or 0,
                    count   = itemCount or 1, -- Store the count, default to 1
                }
            end
        end
    end
    return items
end

-- 2) UpdateValueFrame: Main function to calculate and display item states
function WORS_U_EquipmentBook:UpdateValueFrame()
    local content = WORS_U_EquipmentBook.valueFrame.content

    -- Hide ALL existing buttons in the pool, regardless of key type (numerical or string)
    for _, btn in pairs(WORS_U_EquipmentBook.valueFrame.buttons) do 
        btn:Hide() 
    end

    -- Hide all headers initially, they will be shown if needed
    if content.hdr1 then content.hdr1:Hide() end
    if content.hdr2 then content.hdr2:Hide() end
    if content.hdrLost then content.hdrLost:Hide() end

    -- Gather & sort all player's items by value (highest first)
    local items = self:GatherAllItems()
    -- ALTERATION 1: Sort by per-unit price, not total stack value, for determining which items are kept/lost.
    table.sort(items, function(a,b) return a.price > b.price end) 

    -- Initialize lists for kept, gravestone, and lost items
    local kept, grave, lost = {}, {}, {}

    local numKeptBase = 0 -- Base number of items kept before prayer bonus
    local remainingItemsDestination = "" -- "grave" or "lost" for items not kept

    -- Determine the base number of items kept and where the rest go
    if self.killedByPlayerActive then
        -- Scenario: Killed by a player (PvP death)
        if self.pkSkullActive then
            -- Rule: Killed by player AND PK Skull active
            numKeptBase = 0 
            remainingItemsDestination = "lost" -- All non-kept items lost to killer
        else
            -- Rule: Killed by player BUT PK Skull NOT active (UNSKULLED PvP death)
            numKeptBase = 3 -- You keep 3 items
            remainingItemsDestination = "lost" -- The rest are still lost, not gravestone, as it's a PvP death
        end
    elseif self.pkSkullActive then
        -- Scenario: Not killed by player, but PK Skull is active (e.g., mob kills skulled player)
        numKeptBase = 0 
        remainingItemsDestination = "grave" -- All non-kept items go to gravestone
    else
        -- Scenario: Default (Not killed by player, no PK Skull - e.g., mob kills unskulled player)
        numKeptBase = 3
        remainingItemsDestination = "grave" -- All non-kept items go to gravestone
    end

    -- Apply Prayer bonus: always keep one more item 
    local numKeptActual = numKeptBase
    if self.prayerActive then
        numKeptActual = numKeptActual + 1
    end

    -- Populate kept, grave, or lost lists based on the calculated numKeptActual
    for i, item in ipairs(items) do
        if i <= numKeptActual then 
            kept[#kept+1] = item
        else
            -- Assign remaining items to their determined destination
            if remainingItemsDestination == "grave" then
                grave[#grave+1] = item
            elseif remainingItemsDestination == "lost" then
                lost[#lost+1] = item
            end
        end
    end

    -- NEW: Add player gold to the 'lost' category if killed by a player
    local totalRiskValue = 0
    local playerGold = GetMoney() -- Returns total copper
    if self.killedByPlayerActive and playerGold > 0 then
        -- Create a special item entry for gold
        local goldItem = {
            texture = "Interface\\Icons\\CoinsMany.blp",
            price = playerGold, -- Already the total copper value
            count = 1, -- Represent as a single "stack" of all gold
            isGold = true, -- Flag to identify it as the gold entry
        }
        lost[#lost+1] = goldItem
    end

    -- Calculate total Risk Value (now includes potential gold AND item quantities)
    for _, item in ipairs(grave) do
        totalRiskValue = totalRiskValue + (item.price * item.count)
    end
    for _, item in ipairs(lost) do
        totalRiskValue = totalRiskValue + (item.price * item.count)
    end

    -- Format the total risk value with the gold icon
    local formattedRiskValue = tostring(totalRiskValue) .. " |TInterface\\Icons\\CoinsMany.blp:18:18|t" 

    -- Update the risk label text
    WORS_U_EquipmentBook.valueFrame.side.riskLabel:SetText("Guide Risk Value:\n" .. formattedRiskValue)

    -- Layout constants
    local ICON_SIZE, PADDING = 36, 6
    local scrollLeft = 0 -- Relative to content frame, which is already offset by scrollframe
    local scrollRight = 0 -- Relative to content frame
    local width  = WORS_U_EquipmentBook.valueFrame.scroll:GetWidth() - 20 -- Get width from scroll, account for scroll frame internal padding
    local perRow = math.min(7, math.max(1, math.floor(width / (ICON_SIZE + PADDING))))
    local y      = -10

    -- Section 1: Kept
    local hdr1 = content.hdr1 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr1 = hdr1
    if #kept > 0 then -- Only show header if there are items to display
        hdr1:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdr1:SetText("Items that are Kept on Death")
        hdr1:Show()
        y = y - hdr1:GetHeight() - PADDING

        for i, item in ipairs(kept) do
            local btn = WORS_U_EquipmentBook.valueFrame.buttons[i] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.valueFrame.buttons[i] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex    = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                
                -- NEW: Quantity label (Yellow)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall") -- Using GameFontHighlightSmall for yellow
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2) -- Offset slightly from corner
                btn.countLabel:SetJustifyH("LEFT")

                WORS_U_EquipmentBook.valueFrame.buttons[i] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT", (i-1)*(ICON_SIZE+PADDING), y)
            btn.tex:SetTexture(item.texture)
            -- ALTERATION 2: Always set the main label to the total stack value
            btn.label:SetText(item.price * (item.count or 1)) 
            btn:Show()

            -- Only show the separate quantity label if count > 1
            if item.count and item.count > 1 then
                btn.countLabel:SetText(item.count)
                btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
        end
        y = y - ICON_SIZE - PADDING*2
    else
        hdr1:Hide() -- Hide if no items
    end

    -- Section 2: Gravestone
    local hdr2 = content.hdr2 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr2 = hdr2
    if #grave > 0 then -- Only show header if there are items to display
        hdr2:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdr2:SetText("Items that go to your Gravestone")
        hdr2:Show()
        y = y - hdr2:GetHeight() - PADDING

        for idx, item in ipairs(grave) do
            local row = math.floor((idx-1)/perRow)
            local col = (idx-1)%perRow
            local slotIndex = (#kept) + idx -- Ensure unique index across kept and grave

            local btn = WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex    = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)

                -- NEW: Quantity label (Yellow)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall") -- Using GameFontHighlightSmall for yellow
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2) -- Adjusted position
                btn.countLabel:SetJustifyH("LEFT")

                WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                          col*(ICON_SIZE+PADDING),
                          y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            -- ALTERATION 3: Always set the main label to the total stack value (fixed syntax)
            btn.label:SetText(item.price * (item.count or 1))
            btn:Show()

            -- Only show the separate quantity label if count > 1
            if item.count and item.count > 1 then
                btn.countLabel:SetText(item.count)
                btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
        end
        -- Move y down past the gravestone rows
        local graveRows = math.ceil(#grave / perRow)
        y = y - graveRows * (ICON_SIZE + PADDING) - PADDING
    else
        hdr2:Hide() -- Hide if no items
    end


    -- Section 3: Lost (only if items are lost)
    local hdrLost = content.hdrLost or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdrLost = hdrLost
    if #lost > 0 then -- Only show header if there are items to display
        hdrLost:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdrLost:SetText("Items LOST to the player who kills you:")
        hdrLost:Show()
        y = y - hdrLost:GetHeight() - PADDING

        for i, item in ipairs(lost) do
            local row = math.floor((i-1)/perRow)
            local col = (i-1)%perRow

            -- Use a string key for lost items to prevent index collision with kept/grave
            local btnKey = "lost_"..i 
            local btn = WORS_U_EquipmentBook.valueFrame.buttons[btnKey] or CreateFrame("Button", nil, content)
            
            if not WORS_U_EquipmentBook.valueFrame.buttons[btnKey] then 
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex    = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)

                -- NEW: Quantity label (Yellow)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall") -- Using GameFontHighlightSmall for yellow
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2) -- Adjusted position
                btn.countLabel:SetJustifyH("LEFT")

                WORS_U_EquipmentBook.valueFrame.buttons[btnKey] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                          col*(ICON_SIZE+PADDING),
                          y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            -- ALTERATION 4: Always set the main label to the total stack value
            -- Special handling for gold item, as its 'price' is already the total amount
            if item.isGold then 
                btn.label:SetText(item.price) 
            else
                btn.label:SetText(item.price * (item.count or 1))
            end
            btn:Show()

            -- Show quantity label only if count > 1 AND it's not the 'gold' item
            if item.count and item.count > 1 and not item.isGold then 
                btn.countLabel:SetText(item.count)
                btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
        end
        -- adjust final y if needed
        local lostRows = math.ceil(#lost / perRow)
        y = y - lostRows * (ICON_SIZE + PADDING)
    else
        hdrLost:Hide() -- Hide if no items
    end

    -- Resize scroll-child to fit everything
    content:SetSize(width, -y + PADDING)
end