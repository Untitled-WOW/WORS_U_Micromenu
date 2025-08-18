-- WORS_U_Equipment_GuidePrices.lua

local WORS_U_EquipmentBook = WORS_U_EquipmentBook

-- ========== Guide Prices Frame ==========
WORS_U_EquipmentBook.guidePricesFrame = CreateFrame("Frame", "WORS_U_EquipmentBookGuidePricesFrame", UIParent, "BackdropTemplate")
local frame = WORS_U_EquipmentBook.guidePricesFrame
frame:SetSize(500, 400)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left=5, right=5, top=5, bottom=5 },
})
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
tinsert(UISpecialFrames, "WORS_U_EquipmentBookGuidePricesFrame")
frame:Hide()

-- Title
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -5)
title:SetText("*WIP* Guide Prices *WIP*")

-- closeBtn button
local closeBtn = CreateFrame("Button", nil, frame)
closeBtn:SetSize(16, 16)
closeBtn:SetPoint("TOPRIGHT", 4, 4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Layout constants
local OUTER_PAD = 10
local TOP_PAD = 30
local SIDE_WIDTH = 150
local SIDE_GAP = 5
local CONTENT_INSET = 6

-- Side panel
local side = frame.side or CreateFrame("Frame", nil, frame)
frame.side = side
side:SetWidth(SIDE_WIDTH)
side:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -OUTER_PAD, -TOP_PAD)
side:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -OUTER_PAD, OUTER_PAD)
side:SetBackdrop({
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, edgeSize = 10,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
})
side:SetBackdropBorderColor(0, 0, 0, 1)

-- Total Value label in sidebar
side.totalLabel = side.totalLabel or side:CreateFontString(nil, "OVERLAY", "GameFontNormal")
side.totalLabel:SetPoint("TOP", side, "TOP", 0, -8)
side.totalLabel:SetJustifyH("CENTER")
side.totalLabel:SetWidth(SIDE_WIDTH - 10)
side.totalLabel:SetWordWrap(true)


-- Toggle Buttons (styled like Items Kept frame)
local function CreateSidebarToggleButton(parent, key, anchor, label, onClick)
    local btn = parent[key] or CreateFrame("Button", nil, parent, "OldSchoolButtonTemplate")
    parent[key] = btn
    btn:SetSize(120, 40)
    btn:SetPoint("TOP", anchor, "BOTTOM", 0, -8)
    btn:SetText(label)

    btn.bg = btn.bg or btn:CreateTexture(nil, "ARTWORK")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(0, 1, 0, 0.3)
    btn.bg:Hide()

    btn:SetScript("OnClick", function() onClick(btn) end)

    return btn
end

WORS_U_EquipmentBook.useVendorValue = true
WORS_U_EquipmentBook.useGEValue = false

-- Create Vendor button
side.vendorBtn = CreateSidebarToggleButton(side, "vendorBtn", side.totalLabel, "Use Vendor Value", function(btn)
    WORS_U_EquipmentBook.useVendorValue = not WORS_U_EquipmentBook.useVendorValue
    btn.bg:SetShown(WORS_U_EquipmentBook.useVendorValue)
    WORS_U_EquipmentBook:UpdateGuidePricesFrame()
end)
if WORS_U_EquipmentBook.useVendorValue then side.vendorBtn.bg:Show() end

-- Create GE button (disabled logic)
side.geBtn = CreateSidebarToggleButton(side, "geBtn", side.vendorBtn, "Use GE Value", function(btn)
    -- Do NOT toggle highlight
    -- Do NOT change WORS_U_EquipmentBook.useGEValue
    print("|cffff0000[GuidePrices]|r Grand Exchange values are not available yet.")
end)

-- Ensure it doesn't get green background
side.geBtn.bg:Hide()

-- Optional: Grey out the button to indicate it's inactive
side.geBtn:SetNormalFontObject(GameFontDisable)




-- ScrollFrame
local scrollWidth = frame:GetWidth() - (OUTER_PAD * 2) - SIDE_WIDTH - SIDE_GAP
local scroll = frame.scroll or CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
frame.scroll = scroll
scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", OUTER_PAD, -TOP_PAD)
scroll:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", OUTER_PAD, OUTER_PAD)
scroll:SetWidth(scrollWidth)

-- Scroll border
local border = frame.scrollBorder or CreateFrame("Frame", nil, frame, "BackdropTemplate")
frame.scrollBorder = border
border:SetPoint("TOPLEFT", scroll, "TOPLEFT", -4, 0)
border:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 0, 0)
border:SetBackdrop({
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, edgeSize = 10,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
})
border:SetBackdropBorderColor(0, 0, 0, 1)
border:SetFrameLevel(scroll:GetFrameLevel() - 1)

-- Hide default scroll art
for _, r in ipairs({ scroll:GetRegions() }) do r:Hide() end
if scroll.ScrollBar then
    for _, r in ipairs({ scroll.ScrollBar:GetRegions() }) do r:Hide() end
    scroll.ScrollBar:Hide()
end

-- Content
local content = frame.content or CreateFrame("Frame", nil, scroll)
frame.content = content
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", CONTENT_INSET, -CONTENT_INSET)
content:SetSize(1, 1)
scroll:SetScrollChild(content)

-- ========== Update Function ==========
function WORS_U_EquipmentBook:UpdateGuidePricesFrame()
    local items = self:GatherAllItems()
    table.sort(items, function(a, b) return a.price * a.count > b.price * b.count end)

    local totalValue = 0
    for _, item in ipairs(items) do
        totalValue = totalValue + (item.price * item.count)
    end

    local formatOSRSNumber = formatOSRSNumber
    local ICON_SIZE, PADDING = 36, 6
    local width = scroll:GetWidth() - 20 - (CONTENT_INSET * 2)
    local perRow = math.min(7, math.floor(width / (ICON_SIZE + PADDING)))

    local y = -10
    if content.header then content.header:Hide() end
    if content.buttons then for _, b in ipairs(content.buttons) do b:Hide() end else content.buttons = {} end

    -- Update sidebar value
    side.totalLabel:SetText("Total Guide Value:\n" .. formatOSRSNumber(totalValue) .. " |TInterface\\Icons\\CoinsMany.blp:18:18|t")

    -- Display items
    for i, item in ipairs(items) do
        local row = math.floor((i-1)/perRow)
        local col = (i-1)%perRow

        local btn = content.buttons[i] or CreateFrame("Button", nil, content)
        content.buttons[i] = btn

        btn:SetSize(ICON_SIZE, ICON_SIZE)
        btn:SetPoint("TOPLEFT", content, "TOPLEFT", col*(ICON_SIZE + PADDING), y - row*(ICON_SIZE + PADDING))

        if not btn.tex then
            btn.tex = btn:CreateTexture(nil, "ARTWORK")
            btn.tex:SetAllPoints()
            btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            btn.label:SetPoint("BOTTOM", btn, "BOTTOM", 0, -2)
            btn.countLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btn.countLabel:SetPoint("TOPLEFT", btn, 2, -2)
            btn.countLabel:SetJustifyH("LEFT")
        end

        btn.tex:SetTexture(item.texture)
        btn.label:SetText(formatOSRSNumber(item.price * item.count))
        if item.count > 1 then
            btn.countLabel:SetText(formatOSRSNumber(item.count))
            btn.countLabel:Show()
        else
            btn.countLabel:Hide()
        end

        btn:SetScript("OnEnter", function(self)
            if item.link then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(item.link)
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

        btn:Show()
    end

    local rows = math.ceil(#items / perRow)
    content:SetSize(width, rows * (ICON_SIZE + PADDING) + 40)
end
