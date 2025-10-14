local WORS_U_EquipmentBook = WORS_U_EquipmentBook

-------------------------------------------------
-- === Item IDs to ignore (shared logic) ===
-------------------------------------------------
local IGNORED_ITEM_IDS = {
    201922, 201880, 1000, 202011, 202023, 202120, 202059, 202072, 202048, 202096, 202108, 202084, 202144, 202156, 202132, 202000, 202012, 202121, 202061, 202073, 202049, 202097, 202109, 202085, 202145, 202157, 202133, 202009, 202021, 202122, 202062, 202074, 202050, 202098, 202110, 202086, 202146, 202158, 202134, 202006, 202018, 202123, 202063, 202075, 202051, 202099, 202111, 202087, 202147, 202159, 202135, 202008, 202020, 202124, 202064, 202076, 202052, 202100, 202112, 202088, 202148, 202160, 202136, 202002, 202014, 202125, 202065, 202077, 202053, 202101, 202113, 202089, 202149, 202161, 202137, 202001, 202013, 202126, 202066, 202078, 202054, 202102, 202114, 202090, 202150, 202162, 202138, 202010, 202022, 202127, 202067, 202079, 202055, 202103, 202115, 202091, 202151, 202163, 202139, 202003, 202015, 202128, 202068, 202080, 202056, 202104, 202116, 202092, 202152, 202164, 202140, 202004, 202016, 202129, 202069, 202081, 202057, 202105, 202117, 202093, 202153, 202165, 202141, 202005, 202017, 202130, 202070, 202082, 202058, 202106, 202118, 202094, 202154, 202166, 202142, 202007, 202019, 202131, 202071, 202083, 201921, 202107, 202119, 202095, 202155, 202167, 202143, 202035, 202047, 202024, 202036, 202033, 202045, 202030, 202042, 202032, 202044, 202026, 202038, 202025, 202037, 202034, 202046, 202027, 202039, 202028, 202040, 202029, 202041, 202031, 202043, 59, 62, 60
}

local function IsIgnoredItem(itemID)
    if not itemID then return false end
    for _, id in ipairs(IGNORED_ITEM_IDS) do
        if id == itemID then
            return true
        end
    end
    return false
end

-------------------------------------------------
-- === Frame Setup ===
-------------------------------------------------
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
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
tinsert(UISpecialFrames, "WORS_U_EquipmentBookGuidePricesFrame")
frame:SetUserPlaced(false)
frame:Hide()

-- Title
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -5)
title:SetText("Guide Prices")

-- Close button
local closeBtn = CreateFrame("Button", nil, frame)
closeBtn:SetSize(16, 16)
closeBtn:SetPoint("TOPRIGHT", 4, 4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-------------------------------------------------
-- === Layout constants ===
-------------------------------------------------
local OUTER_PAD = 10
local TOP_PAD = 30
local SIDE_WIDTH = 150
local SIDE_GAP = 5
local CONTENT_INSET = 6

-------------------------------------------------
-- === Sidebar setup ===
-------------------------------------------------
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

-- Total Value label
side.totalLabel = side.totalLabel or side:CreateFontString(nil, "OVERLAY", "GameFontNormal")
side.totalLabel:SetPoint("TOP", side, "TOP", 0, -8)
side.totalLabel:SetJustifyH("CENTER")
side.totalLabel:SetWidth(SIDE_WIDTH - 10)
side.totalLabel:SetWordWrap(true)

-------------------------------------------------
-- === Button creation helper (SetSelected) ===
-------------------------------------------------
local function CreateSidebarToggleButton(parent, key, anchor, label, onClick)
    local btn = parent[key] or CreateFrame("Button", nil, parent, "OldSchoolButtonTemplate")
    parent[key] = btn
    btn:SetSize(120, 40)
    btn:SetPoint("TOP", anchor, "BOTTOM", 0, -8)
    btn:SetText(label)
    btn:SetScript("OnClick", function() onClick(btn) end)
    return btn
end

-------------------------------------------------
-- === Sidebar button logic ===
-------------------------------------------------
WORS_U_EquipmentBook.useVendorValue = true
WORS_U_EquipmentBook.useGEValue = false

local function RefreshValueButtons()
    side.vendorBtn:SetSelected(WORS_U_EquipmentBook.useVendorValue)
    side.geBtn:SetSelected(WORS_U_EquipmentBook.useGEValue)
end

-- Vendor value button
side.vendorBtn = CreateSidebarToggleButton(side, "vendorBtn", side.totalLabel, "Use Vendor Value", function()
    WORS_U_EquipmentBook.useVendorValue = true
    WORS_U_EquipmentBook.useGEValue = false
    RefreshValueButtons()
    WORS_U_EquipmentBook:UpdateGuidePricesFrame()
end)

-- GE value button (disabled for now)
side.geBtn = CreateSidebarToggleButton(side, "geBtn", side.vendorBtn, "Use GE Value", function()
    print("|cffff0000[GuidePrices]|r Grand Exchange values are not available yet.")
end)
side.geBtn:SetEnabled(false)
side.geBtn:SetNormalFontObject(GameFontDisable)

RefreshValueButtons()

-------------------------------------------------
-- === ScrollFrame setup ===
-------------------------------------------------
local scrollWidth = frame:GetWidth() - (OUTER_PAD * 2) - SIDE_WIDTH - SIDE_GAP
local scroll = frame.scroll or CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
frame.scroll = scroll
scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", OUTER_PAD, -TOP_PAD)
scroll:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", OUTER_PAD, OUTER_PAD)
scroll:SetWidth(scrollWidth)

-- Border
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

-- Hide scroll art
for _, r in ipairs({ scroll:GetRegions() }) do r:Hide() end
if scroll.ScrollBar then
    for _, r in ipairs({ scroll.ScrollBar:GetRegions() }) do r:Hide() end
    scroll.ScrollBar:Hide()
end

-- Scroll content
local content = frame.content or CreateFrame("Frame", nil, scroll)
frame.content = content
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", CONTENT_INSET, -CONTENT_INSET)
content:SetSize(1, 1)
scroll:SetScrollChild(content)

-------------------------------------------------
-- === Update Function ===
-------------------------------------------------
function WORS_U_EquipmentBook:UpdateGuidePricesFrame()
    local allItems = self:GatherAllItems()
    local items = {}

    -- Filter ignored item IDs
    for _, item in ipairs(allItems) do
        local itemID = tonumber(string.match(item.link or "", "item:(%d+)"))
        if not IsIgnoredItem(itemID) then
            table.insert(items, item)
        end
    end

    table.sort(items, function(a, b)
        return a.price * a.count > b.price * b.count
    end)

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
    if content.buttons then
        for _, b in ipairs(content.buttons) do b:Hide() end
    else
        content.buttons = {}
    end

    -- Sidebar value
    side.totalLabel:SetText("Total Guide Value:\n" ..
        formatOSRSNumber(totalValue) ..
        " |TInterface\\Icons\\CoinsMany.blp:18:18|t")

    -- Item grid
    for i, item in ipairs(items) do
        local row = math.floor((i - 1) / perRow)
        local col = (i - 1) % perRow
        local btn = content.buttons[i] or CreateFrame("Button", nil, content)
        content.buttons[i] = btn

        btn:SetSize(ICON_SIZE, ICON_SIZE)
        btn:SetPoint("TOPLEFT", content, "TOPLEFT",
            col * (ICON_SIZE + PADDING),
            y - row * (ICON_SIZE + PADDING))

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
