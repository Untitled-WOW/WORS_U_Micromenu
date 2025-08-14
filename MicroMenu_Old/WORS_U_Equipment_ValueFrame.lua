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



WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}

WORS_U_EquipmentBook.valueFrame = CreateFrame("Frame", "WORS_U_EquipmentBookValueFrame", UIParent, "BackdropTemplate")
local FRAME_WIDTH  = 500
local FRAME_HEIGHT = 400
WORS_U_EquipmentBook.valueFrame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
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
closeButton:SetSize(16,16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.valueFrame, "TOPRIGHT", 4,4)
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function() WORS_U_EquipmentBook.valueFrame:Hide() end)

WORS_U_EquipmentBook.valueFrame:SetScript("OnDragStart", WORS_U_EquipmentBook.valueFrame.StartMoving)
WORS_U_EquipmentBook.valueFrame:SetScript("OnDragStop",  WORS_U_EquipmentBook.valueFrame.StopMovingOrSizing)

WORS_U_EquipmentBook.valueFrame.title = WORS_U_EquipmentBook.valueFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
WORS_U_EquipmentBook.valueFrame.title:SetPoint("TOP", WORS_U_EquipmentBook.valueFrame, "TOP", 0, -5)
WORS_U_EquipmentBook.valueFrame.title:SetText("Items kept on Death")

-- ===== Layout constants (fixed) =====
local OUTER_PAD     = 10   -- padding from parent edges
local TOP_PAD       = 30   -- space below title
local SIDE_WIDTH    = 150
local SIDE_GAP      = 5    -- gap between scroll area and side panel
local CONTENT_INSET = 6    -- inner padding inside scroll border

-- Side panel (fixed position/size)
local side = WORS_U_EquipmentBook.valueFrame.side or CreateFrame("Frame", nil, WORS_U_EquipmentBook.valueFrame)
WORS_U_EquipmentBook.valueFrame.side = side
side:ClearAllPoints()
side:SetWidth(SIDE_WIDTH)
side:SetPoint("TOPRIGHT",    WORS_U_EquipmentBook.valueFrame, "TOPRIGHT",    -OUTER_PAD, -TOP_PAD)
side:SetPoint("BOTTOMRIGHT", WORS_U_EquipmentBook.valueFrame, "BOTTOMRIGHT", -OUTER_PAD,  OUTER_PAD)
side:SetBackdrop({
    bgFile = nil,
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, edgeSize = 10,
    insets = { left=0,right=0,top=0,bottom=0 },
})
side:SetBackdropBorderColor(0,0,0,1)

-- ScrollFrame (FIXED WIDTH: no anchoring to side panel)
local scrollWidth = FRAME_WIDTH - (OUTER_PAD * 2) - SIDE_WIDTH - SIDE_GAP - 0                 
local scroll = WORS_U_EquipmentBook.valueFrame.scroll or CreateFrame("ScrollFrame", nil, WORS_U_EquipmentBook.valueFrame, "UIPanelScrollFrameTemplate")
WORS_U_EquipmentBook.valueFrame.scroll = scroll
scroll:ClearAllPoints()
scroll:SetPoint("TOPLEFT",    WORS_U_EquipmentBook.valueFrame, "TOPLEFT",    OUTER_PAD, -TOP_PAD)
scroll:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.valueFrame, "BOTTOMLEFT", OUTER_PAD, OUTER_PAD)
scroll:SetWidth(scrollWidth)

-- Border around scroll (flush with scroll edges)
local border = WORS_U_EquipmentBook.valueFrame.scrollBorder or CreateFrame("Frame", nil, WORS_U_EquipmentBook.valueFrame, "BackdropTemplate")
WORS_U_EquipmentBook.valueFrame.scrollBorder = border
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
local content = WORS_U_EquipmentBook.valueFrame.content or CreateFrame("Frame", nil, scroll)
WORS_U_EquipmentBook.valueFrame.content = content
content:ClearAllPoints()
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", CONTENT_INSET, -CONTENT_INSET)
content:SetSize(1,1)
scroll:SetScrollChild(content)

WORS_U_EquipmentBook.valueFrame.buttons = {}

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
        btn.bg = btn:CreateTexture(nil, "ARTWORK")
        btn.bg:SetAllPoints(btn)
        btn.bg:SetColorTexture(0,1,0,0.3)
        btn.bg:Hide()
    end
    btn:ClearAllPoints()
    btn:SetPoint("TOP", anchor, "BOTTOM", 0, -8)
    btn:SetText(text)
    return btn
end

local pb = EnsureButton("prayerBtn", sideLabel, "Protect item Prayer\nenabled")
local pkb = EnsureButton("pkSkullBtn", pb, "PK Skull active")
local kb = EnsureButton("killedBtn", pkb, "Killed by player")

local function RefreshPrayerBtn() if WORS_U_EquipmentBook.prayerActive then pb.bg:Show() else pb.bg:Hide() end end
local function RefreshPKBtn()     if WORS_U_EquipmentBook.pkSkullActive then pkb.bg:Show() else pkb.bg:Hide() end end
local function RefreshKilledBtn() if WORS_U_EquipmentBook.killedByPlayerActive then kb.bg:Show() else kb.bg:Hide() end end

pb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.prayerActive = not WORS_U_EquipmentBook.prayerActive
    RefreshPrayerBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
pkb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.pkSkullActive = not WORS_U_EquipmentBook.pkSkullActive
    RefreshPKBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)
kb:SetScript("OnClick", function()
    WORS_U_EquipmentBook.killedByPlayerActive = not WORS_U_EquipmentBook.killedByPlayerActive
    RefreshKilledBtn(); WORS_U_EquipmentBook:UpdateValueFrame()
end)

RefreshPrayerBtn(); RefreshPKBtn(); RefreshKilledBtn()

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
            items[#items+1] = {
                link    = itemLink or link,
                texture = iconPath or "Interface\\Icons\\INV_Misc_QuestionMark",
                price   = tonumber(sellPrice) or 0,
                count   = itemCount,
            }
        end
    end
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                local _, itemLink, _, _, _, _, _, _, _, iconPath, sellPrice = GetItemInfo(link)
                items[#items+1] = {
                    link    = itemLink or link,
                    texture = iconPath or "Interface\\Icons\\INV_Misc_QuestionMark",
                    price   = tonumber(sellPrice) or 0,
                    count   = itemCount or 1,
                }
            end
        end
    end
    return items
end

-- Update display
function WORS_U_EquipmentBook:UpdateValueFrame()
    local content = WORS_U_EquipmentBook.valueFrame.content
    for _, btn in pairs(WORS_U_EquipmentBook.valueFrame.buttons) do btn:Hide() end
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

    WORS_U_EquipmentBook.valueFrame.side.riskLabel:SetText("Guide Risk Value:\n" .. totalRiskValue .. " |TInterface\\Icons\\CoinsMany.blp:18:18|t")

	local ICON_SIZE, PADDING = 36, 6
	local CONTENT_INSET = 6          -- must match layout constant
	local width  = WORS_U_EquipmentBook.valueFrame.scroll:GetWidth() - 20 - (CONTENT_INSET * 2)
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
            local btn = WORS_U_EquipmentBook.valueFrame.buttons[i] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.valueFrame.buttons[i] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.valueFrame.buttons[i] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT", (i-1)*(ICON_SIZE+PADDING), y)
            btn.tex:SetTexture(item.texture)
            btn.label:SetText(item.price * (item.count or 1))
            btn:Show()
            if item.count and item.count > 1 then
                btn.countLabel:SetText(item.count); btn.countLabel:Show()
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
            local btn = WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.valueFrame.buttons[slotIndex] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                col*(ICON_SIZE+PADDING),
                y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            btn.label:SetText(item.price * (item.count or 1))
            btn:Show()
            if item.count and item.count > 1 then
                btn.countLabel:SetText(item.count); btn.countLabel:Show()
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
            local btn = WORS_U_EquipmentBook.valueFrame.buttons[btnKey] or CreateFrame("Button", nil, content)
            if not WORS_U_EquipmentBook.valueFrame.buttons[btnKey] then
                btn:SetSize(ICON_SIZE, ICON_SIZE)
                btn.tex = btn:CreateTexture(nil,"ARTWORK"); btn.tex:SetAllPoints()
                btn.label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
                btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
                btn.countLabel:SetJustifyH("LEFT")
                WORS_U_EquipmentBook.valueFrame.buttons[btnKey] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content, "TOPLEFT",
                col*(ICON_SIZE+PADDING),
                y - row*(ICON_SIZE+PADDING))
            btn.tex:SetTexture(item.texture)
            if item.isGold then
                btn.label:SetText(item.price)
            else
                btn.label:SetText(item.price * (item.count or 1))
            end
            btn:Show()
            if item.count and item.count > 1 and not item.isGold then
                btn.countLabel:SetText(item.count); btn.countLabel:Show()
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
