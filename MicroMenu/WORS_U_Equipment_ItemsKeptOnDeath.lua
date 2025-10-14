local slotData = {
    { id=13, row=1, col=1, hover="Trinket", tex="Trinket_slot"},
    { id=14, row=1, col=3, hover="Trinket", tex="Trinket_slot"},
    { id=1,  row=1, col=2, hover="Head",    tex="Head_slot" },

    { id=2,  row=2, col=2, hover="Neck",   tex="Neck_slot" },
    { id=3,  row=2, col=3, hover="Arrows", tex="Ammo_slot" },
    { id=15, row=2, col=1, hover="Back",   tex="Cape_slot" },

    -- Row 3 now has 4 buttons, but layout should center as if 3.
    { id=16, row=3, col=1, hover="Main Hand",  tex="Weapon_slot" },
    { id=5,  row=3, col=2, hover="Chest",      tex="Body_slot"   },
    { id=17, row=3, col=3, hover="Off Hand",   tex="Shield_slot" },
    { id=18, row=3, col=4, hover="Ranged", tex="Ranged_slot" }, -- placed to the right of id=16

    { id=4,  row=4, col=1, hover="Shirt",  tex="Shirt_slot"  },
    { id=6,  row=4, col=2, hover="Waist",  tex="Belt_slot"   },
    { id=19, row=4, col=3, hover="Tabard", tex="Tabard_slot" },

    { id=10, row=5, col=1, hover="Hands", tex="Hands_slot" },
    { id=7,  row=5, col=2, hover="Legs",  tex="Legs_slot"  },
    { id=11, row=5, col=3, hover="Ring",  tex="Ring_slot"  },

    { id=9,  row=6, col=1, hover="Wrist", tex="Bracer_slot" },
    { id=8,  row=6, col=2, hover="Feet",  tex="Feet_slot"   },
    { id=12, row=6, col=3, hover="Ring",  tex="Ring_slot2"  },
}


-- === Item IDs to ignore (simple numeric list) ===
local IGNORED_ITEM_IDS = {
    201922, 201880, 1000, 202011, 202023, 202120, 202059, 202072, 202048, 202096, 202108, 202084, 202144, 202156, 202132, 202000, 202012, 202121, 202061, 202073, 202049, 202097, 202109, 202085, 202145, 202157, 202133, 202009, 202021, 202122, 202062, 202074, 202050, 202098, 202110, 202086, 202146, 202158, 202134, 202006, 202018, 202123, 202063, 202075, 202051, 202099, 202111, 202087, 202147, 202159, 202135, 202008, 202020, 202124, 202064, 202076, 202052, 202100, 202112, 202088, 202148, 202160, 202136, 202002, 202014, 202125, 202065, 202077, 202053, 202101, 202113, 202089, 202149, 202161, 202137, 202001, 202013, 202126, 202066, 202078, 202054, 202102, 202114, 202090, 202150, 202162, 202138, 202010, 202022, 202127, 202067, 202079, 202055, 202103, 202115, 202091, 202151, 202163, 202139, 202003, 202015, 202128, 202068, 202080, 202056, 202104, 202116, 202092, 202152, 202164, 202140, 202004, 202016, 202129, 202069, 202081, 202057, 202105, 202117, 202093, 202153, 202165, 202141, 202005, 202017, 202130, 202070, 202082, 202058, 202106, 202118, 202094, 202154, 202166, 202142, 202007, 202019, 202131, 202071, 202083, 201921, 202107, 202119, 202095, 202155, 202167, 202143, 202035, 202047, 202024, 202036, 202033, 202045, 202030, 202042, 202032, 202044, 202026, 202038, 202025, 202037, 202034, 202046, 202027, 202039, 202028, 202040, 202029, 202041, 202031, 202043, 59, 62, 60
}

-- Simple membership check against the numeric list
local function IsIgnoredItem(itemID)
    if not itemID then return false end
    for _, id in ipairs(IGNORED_ITEM_IDS) do
        if id == itemID then
            return true
        end
    end
    return false
end

function formatOSRSNumber(value)
    local formattedValue
    local color
    -- Ensure the value is a number
    if type(value) ~= "number" then
        return "|cffff0000Invalid Value|r"  -- Return red error if not a number
    end
    -- Values below 100,000 (Yellow)
    if value < 100000 then
        formattedValue = tostring(value)  -- Just the number itself
        color = "|cffffff00"  -- Yellow
    -- Values between 100,000 and 9.99M (White)
    elseif value >= 100000 and value <= 9999999 then
        formattedValue = math.floor(value / 1000) .. "K"  -- Format in thousands
        color = "|cffffffff"  -- White
    -- Values 10M and above (Green)
    elseif value >= 10000000 then
        formattedValue = math.floor(value / 1000000) .. "M"  -- Format in millions
        color = "|cff00ff00"  -- Green
    end
    -- Return the formatted string with color and value, ensuring no extra characters or invalid tags
    return color .. formattedValue .. "|r"
end


WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}

WORS_U_EquipmentBook.itemsKeptOnDeathFrame = CreateFrame("Frame", "WORS_U_EquipmentBookitemsKeptOnDeathFrame", UIParent, "BackdropTemplate")
local FRAME_WIDTH  = 500
local FRAME_HEIGHT = 400
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetBackdrop({
    bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile     = true, tileSize = 32, edgeSize = 32,
    insets   = { left=5, right=5, top=5, bottom=5 },
})
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetPoint("CENTER")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:EnableMouse(true)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetMovable(true)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:RegisterForDrag("LeftButton")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetClampedToScreen(true)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:Hide()
tinsert(UISpecialFrames, "WORS_U_EquipmentBookitemsKeptOnDeathFrame")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetUserPlaced(false)

local closeButton = CreateFrame("Button", nil, WORS_U_EquipmentBook.itemsKeptOnDeathFrame)
closeButton:SetSize(16,16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "TOPRIGHT", 4,4)
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function() WORS_U_EquipmentBook.itemsKeptOnDeathFrame:Hide() end)

WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetScript("OnDragStart", WORS_U_EquipmentBook.itemsKeptOnDeathFrame.StartMoving)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame:SetScript("OnDragStop",  WORS_U_EquipmentBook.itemsKeptOnDeathFrame.StopMovingOrSizing)

WORS_U_EquipmentBook.itemsKeptOnDeathFrame.title = WORS_U_EquipmentBook.itemsKeptOnDeathFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.title:SetPoint("TOP", WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "TOP", 0, -5)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.title:SetText("Items kept on Death")

-- ===== Layout constants (fixed) =====
local OUTER_PAD     = 10   -- padding from parent edges
local TOP_PAD       = 30   -- space below title
local SIDE_WIDTH    = 150
local SIDE_GAP      = 5    -- gap between scroll area and side panel
local CONTENT_INSET = 6    -- inner padding inside scroll border

-- Side panel (fixed position/size)
local side = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.side or CreateFrame("Frame", nil, WORS_U_EquipmentBook.itemsKeptOnDeathFrame)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.side = side
side:ClearAllPoints()
side:SetWidth(SIDE_WIDTH)
side:SetPoint("TOPRIGHT",    WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "TOPRIGHT",    -OUTER_PAD, -TOP_PAD)
side:SetPoint("BOTTOMRIGHT", WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "BOTTOMRIGHT", -OUTER_PAD,  OUTER_PAD)
side:SetBackdrop({
    bgFile = nil,
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, edgeSize = 10,
    insets = { left=0,right=0,top=0,bottom=0 },
})
side:SetBackdropBorderColor(0,0,0,1)

-- ScrollFrame (FIXED WIDTH: no anchoring to side panel)
local scrollWidth = FRAME_WIDTH - (OUTER_PAD * 2) - SIDE_WIDTH - SIDE_GAP - 0                 
local scroll = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.scroll or CreateFrame("ScrollFrame", nil, WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "UIPanelScrollFrameTemplate")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.scroll = scroll
scroll:ClearAllPoints()
scroll:SetPoint("TOPLEFT",    WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "TOPLEFT",    OUTER_PAD, -TOP_PAD)
scroll:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "BOTTOMLEFT", OUTER_PAD, OUTER_PAD)
scroll:SetWidth(scrollWidth)

-- Border around scroll (flush with scroll edges)
local border = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.scrollBorder or CreateFrame("Frame", nil, WORS_U_EquipmentBook.itemsKeptOnDeathFrame, "BackdropTemplate")
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.scrollBorder = border
border:ClearAllPoints()
border:SetPoint("TOPLEFT", scroll, "TOPLEFT", -4, 0)
border:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 0, 0)
border:SetBackdrop({
    bgFile = nil,
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, edgeSize = 10,
    insets = { left=0,right=0,top=0,bottom=0 },
})
border:SetBackdropBorderColor(0,0,0,1)
border:SetFrameLevel(scroll:GetFrameLevel()-1)

-- Hide default scrollframe art
for _, r in ipairs({scroll:GetRegions()}) do r:Hide() end
local sb = scroll.ScrollBar
if sb then
    for _, r in ipairs({sb:GetRegions()}) do r:Hide() end
    sb:Hide()
end

-- Content frame (inset inside scroll viewport)
local content = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.content or CreateFrame("Frame", nil, scroll)
WORS_U_EquipmentBook.itemsKeptOnDeathFrame.content = content
content:ClearAllPoints()
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", CONTENT_INSET, -CONTENT_INSET)
content:SetSize(1,1)
scroll:SetScrollChild(content)

WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons = {}

-- Toggle states
WORS_U_EquipmentBook.prayerActive        = WORS_U_EquipmentBook.prayerActive or false
WORS_U_EquipmentBook.pkSkullActive       = WORS_U_EquipmentBook.pkSkullActive or false
WORS_U_EquipmentBook.killedByPlayerActive= WORS_U_EquipmentBook.killedByPlayerActive or false

-- ========== Sidebar UI ==========
side.label = side.label or side:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
local sideLabel = side.label
sideLabel:ClearAllPoints()
sideLabel:SetPoint("TOP", side, "TOP", 0, -8)
sideLabel:SetJustifyH("CENTER")
sideLabel:SetText("Showing info for:")

-- Helper to make/setup a centered button
local function EnsureButton(key, anchor, text)
    local btn = side[key]
    if not btn then
        btn = CreateFrame("Button", nil, side, "OldSchoolButtonTemplate")
        side[key] = btn
        btn:SetSize(120, 40)
    end
    btn:ClearAllPoints()
    btn:SetPoint("TOP", anchor, "BOTTOM", 0, -8)
    btn:SetText(text)
    return btn
end

local pb = EnsureButton("prayerBtn", sideLabel, "Protect item Prayer\nenabled")
local pkb = EnsureButton("pkSkullBtn", pb, "PK Skull active")
local kb = EnsureButton("killedBtn", pkb, "Killed by player")


local function RefreshPrayerBtn()
    pb:SetSelected(WORS_U_EquipmentBook.prayerActive)
end

local function RefreshPKBtn()
    pkb:SetSelected(WORS_U_EquipmentBook.pkSkullActive)
end

local function RefreshKilledBtn()
    kb:SetSelected(WORS_U_EquipmentBook.killedByPlayerActive)
end



pb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.prayerActive = not WORS_U_EquipmentBook.prayerActive
    RefreshPrayerBtn(); WORS_U_EquipmentBook:UpdateitemsKeptOnDeathFrame()
end)
pkb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.pkSkullActive = not WORS_U_EquipmentBook.pkSkullActive
    RefreshPKBtn(); WORS_U_EquipmentBook:UpdateitemsKeptOnDeathFrame()
end)
kb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.killedByPlayerActive = not WORS_U_EquipmentBook.killedByPlayerActive
    RefreshKilledBtn(); WORS_U_EquipmentBook:UpdateitemsKeptOnDeathFrame()
end)

RefreshPrayerBtn(); RefreshPKBtn(); RefreshKilledBtn()

-- Notes label (above risk label)
side.notesLabel = side.notesLabel or side:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local nL = side.notesLabel
nL:ClearAllPoints()
nL:SetPoint("BOTTOM", side, "BOTTOM", 0, 70) -- adjust height above the risk label
nL:SetJustifyH("CENTER")
nL:SetWidth(140) -- set to match your sidebar's width
nL:SetWordWrap(true)
nL:SetText("Assumes quest items will be lost if value is lower than other items equiped or in bags")

-- Risk label
side.riskLabel = side.riskLabel or side:CreateFontString(nil,"OVERLAY","GameFontNormal")
local rL = side.riskLabel
rL:ClearAllPoints()
rL:SetPoint("BOTTOM", side, "BOTTOM", 0, 8)
rL:SetJustifyH("CENTER")
rL:SetText("Guide Risk Value:\n0 |TInterface\\Icons\\CoinsMany.blp:18:18|t")


-- Gather items
function WORS_U_EquipmentBook:GatherAllItems()
    local items = {}
    for slotName, d in pairs(slotData) do
        local slotID = d.id
        local link = GetInventoryItemLink("player", slotID)
        if slotName == "MainHand" and not link then
            link = GetInventoryItemLink("player", 18)
        end
        if link then
            local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
            local itemCount = GetInventoryItemCount("player", slotID)
            if slotName == "MainHand" and not itemCount then
                itemCount = GetInventoryItemCount("player", 16) or GetInventoryItemCount("player", 18)
            end
            itemCount = itemCount or 1

            -- NEW: ignore list check for equipped item
            local itemID = tonumber(string.match(itemLink or link, "item:(%d+)"))
            if not IsIgnoredItem(itemID) then
                items[#items+1] = {
                    link    = itemLink or link,
                    texture = iconPath or "Interface\\Icons\\INV_Misc_QuestionMark",
                    price   = tonumber(sellPrice) or 0,
                    count   = itemCount,
                }
            end
        end
    end
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)

                -- NEW: ignore list check for bag item
                local itemID = tonumber(string.match(itemLink or link, "item:(%d+)"))
                if not IsIgnoredItem(itemID) then
                    items[#items+1] = {
                        link    = itemLink or link,
                        texture = iconPath or "Interface\\Icons\\INV_Misc_QuestionMark",
                        price   = tonumber(sellPrice) or 0,
                        count   = itemCount or 1,
                    }
                end
            end
        end
    end
    return items
end

-- Update display
function WORS_U_EquipmentBook:UpdateitemsKeptOnDeathFrame()
    local content = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.content
    for _, btn in pairs(WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons) do btn:Hide() end
    if content.hdr1 then content.hdr1:Hide() end
    if content.hdr2 then content.hdr2:Hide() end
    if content.hdrLost then content.hdrLost:Hide() end

    local items = self:GatherAllItems()
    table.sort(items, function(a,b) return a.price > b.price end)

    local kept, grave, lost = {}, {}, {}
    local numKeptBase = 0
    local remainingItemsDestination = ""

    if self.killedByPlayerActive then
        if self.pkSkullActive then
            numKeptBase = 0
            remainingItemsDestination = "lost"
        else
            numKeptBase = 3
            remainingItemsDestination = "lost"
        end
    elseif self.pkSkullActive then
        numKeptBase = 0
        remainingItemsDestination = "grave"
    else
        numKeptBase = 3
        remainingItemsDestination = "grave"
    end

    local numKeptActual = numKeptBase
    if self.prayerActive then numKeptActual = numKeptActual + 1 end

    for i, item in ipairs(items) do
        if i <= numKeptActual then
            kept[#kept+1] = item
        else
            if remainingItemsDestination == "grave" then grave[#grave+1] = item else lost[#lost+1] = item end
        end
    end

    local totalRiskValue = 0
    local playerGold = GetMoney()
    if self.killedByPlayerActive and playerGold > 0 then
        lost[#lost+1] = {
            texture = "Interface\\Icons\\CoinsMany.blp",
            price = playerGold,
            count = 1,
            isGold = true,
        }
    end

    for _, item in ipairs(grave) do totalRiskValue = totalRiskValue + (item.price * item.count) end
    for _, item in ipairs(lost)  do totalRiskValue = totalRiskValue + (item.price * item.count) end

    --WORS_U_EquipmentBook.itemsKeptOnDeathFrame.side.riskLabel:SetText("Guide Risk Value:\n" .. BreakUpLargeNumbers(totalRiskValue) .. " |TInterface\\Icons\\CoinsMany.blp:18:18|t")
    WORS_U_EquipmentBook.itemsKeptOnDeathFrame.side.riskLabel:SetText("Guide Risk Value:\n" .. formatOSRSNumber(totalRiskValue) .. " |TInterface\\Icons\\CoinsMany.blp:18:18|t")

	local ICON_SIZE, PADDING = 36, 6
	local CONTENT_INSET = 6          -- must match layout constant
	local width  = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.scroll:GetWidth() - 20 - (CONTENT_INSET * 2)
	local perRow = math.min(7, math.max(1, math.floor(width / (ICON_SIZE + PADDING))))
	local y = -10                     -- top inside the *inset* content frame


    -- Kept
    local hdr1 = content.hdr1 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr1 = hdr1
    if #kept > 0 then
        hdr1:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdr1:SetText("Items that are Kept on Death")
        hdr1:Show()
        y = y - hdr1:GetHeight() - PADDING
        for i, item in ipairs(kept) do
            local btn = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[i] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[i] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[i] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT", (i-1)*(ICON_SIZE+PADDING), y)
            btn.tex:SetTexture(item.texture)
            btn.label:SetText(formatOSRSNumber(item.price * (item.count or 1)))
            btn:Show()
            if item.count and item.count > 1 then
                btn.countLabel:SetText(formatOSRSNumber(item.count)); btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
			btn:SetScript("OnEnter", function(self)
				if item.link then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
					GameTooltip:SetHyperlink(item.link);
					GameTooltip:Show();
				end
			end)
			btn:SetScript("OnLeave", function() GameTooltip:Hide(); end)
			
			
			
        end
        y = y - ICON_SIZE - PADDING*2
    else
        hdr1:Hide()
    end

    -- Gravestone
    local hdr2 = content.hdr2 or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdr2 = hdr2
    if #grave > 0 then
        hdr2:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdr2:SetText("Items that go to your Gravestone")
        hdr2:Show()
        y = y - hdr2:GetHeight() - PADDING
        for idx, item in ipairs(grave) do
            local row = math.floor((idx-1)/perRow)
            local col = (idx-1)%perRow
            local slotIndex = (#kept) + idx
            local btn = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[slotIndex] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[slotIndex] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[slotIndex] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                col*(ICON_SIZE+PADDING),
                y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            btn.label:SetText(formatOSRSNumber(item.price * (item.count or 1)))
            btn:Show()
            if item.count and item.count > 1 then
                btn.countLabel:SetText(formatOSRSNumber(item.count)); btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
			
			btn:SetScript("OnEnter", function(self)
				if item.link then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
					GameTooltip:SetHyperlink(item.link);
					GameTooltip:Show();
				end
			end)
			btn:SetScript("OnLeave", function() GameTooltip:Hide(); end)
			
			
			
        end
        local graveRows = math.ceil(#grave / perRow)
        y = y - graveRows * (ICON_SIZE + PADDING) - PADDING
    else
        hdr2:Hide()
    end

    -- Lost
    local hdrLost = content.hdrLost or content:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    content.hdrLost = hdrLost
    if #lost > 0 then
        hdrLost:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        hdrLost:SetText("Items LOST to the player who kills you:")
        hdrLost:Show()
        y = y - hdrLost:GetHeight() - PADDING
        for i, item in ipairs(lost) do
            local row = math.floor((i-1)/perRow)
            local col = (i-1)%perRow
            local btnKey = "lost_"..i
            local btn = WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[btnKey] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[btnKey] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.itemsKeptOnDeathFrame.buttons[btnKey] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                col*(ICON_SIZE+PADDING),
                y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            if item.isGold then
                btn.label:SetText(formatOSRSNumber(item.price))
            else
                btn.label:SetText(formatOSRSNumber(item.price * (item.count or 1)))
            end
            btn:Show()
            if item.count and item.count > 1 and not item.isGold then
                btn.countLabel:SetText(formatOSRSNumber(item.count)); btn.countLabel:Show()
            else
                btn.countLabel:Hide()
            end
			btn:SetScript("OnEnter", function(self)
				if item.link then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
					GameTooltip:SetHyperlink(item.link);
					GameTooltip:Show();
				end
			end)
			btn:SetScript("OnLeave", function() GameTooltip:Hide(); end)
			
			
			
        end
        local lostRows = math.ceil(#lost / perRow)
        y = y - lostRows * (ICON_SIZE + PADDING)
    else
        hdrLost:Hide()
    end

	content:SetSize(width, -y + PADDING + CONTENT_INSET)
end
