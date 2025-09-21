
-- ---------------- Configuration ----------------
local BASE_TEX_PATH   = "Interface\\AddOns\\MicroMenu\\Textures\\EquipmentIcon\\"
local BUTTON_SIZE     = 35
local GRID_OFFSET_X   = 0
local GRID_OFFSET_Y   = 10
-- change  H_PAD back to 30 and remove ranged button when Special Attack function works
local H_PAD           = 33
local H_PAD_ROW2      = 10
local V_PAD           = 5
local V_PAD_ROW2      = 5
local TOP_OFFSET      = 0

-- ---- Padding crop helpers ----
local SLOT_TEX_ZOOM = 0.2
local function CropSlotTex(tex) tex:SetTexCoord(SLOT_TEX_ZOOM, 1 - SLOT_TEX_ZOOM, SLOT_TEX_ZOOM, 1 - SLOT_TEX_ZOOM) end
local function ResetTex(tex)    tex:SetTexCoord(0, 1, 0, 1) end

-- Slot layout (add more if desired)
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

-- quick lookup for fallback tex by slot id
local texById = {}
for _, d in ipairs(slotData) do texById[d.id] = d.tex end

local function formatOSRSNumber(value)
    local formattedValue, color
    if type(value) ~= "number" then return "|cffff0000Invalid Value|r" end
    if value < 100000 then
        formattedValue, color = tostring(value), "|cffffff00"
    elseif value <= 9999999 then
        formattedValue, color = math.floor(value/1000).."K", "|cffffffff"
    else
        formattedValue, color = math.floor(value/1000000).."M", "|cff00ff00"
    end
    return color .. formattedValue .. "|r"
end

WORS_U_EquipmentBook.buttons = WORS_U_EquipmentBook.buttons or {}

local function UpdateButtonCounts()
    for id, btn in pairs(WORS_U_EquipmentBook.buttons) do
        local itemLink = GetInventoryItemLink("player", id)
        if itemLink then
            local itemName = GetItemInfo(itemLink)
            local quantity = GetInventoryItemCount("player", id)
            local countStr = ""
            local chargeSuffix = itemName and itemName:match("%((%d+)%)")
            if chargeSuffix then countStr = formatOSRSNumber(tonumber(chargeSuffix)) end
            if quantity and quantity > 1 then countStr = formatOSRSNumber(quantity) end
            btn.countText:SetText(countStr or "")
        else
            btn.countText:SetText("")
        end
    end
end


function SetupEquipmentButtons()
    if InCombatLockdown() then return end

    local frame  = WORS_U_EquipmentBook.frame
    local frameW = frame:GetWidth()

    -- counts per row (centering)
    local rowCounts = {}
    for _, d in ipairs(slotData) do
        rowCounts[d.row] = (rowCounts[d.row] or 0) + 1
    end

    -- ensure storage table exists
    if not WORS_U_EquipmentBook.buttons then
        WORS_U_EquipmentBook.buttons = {}
    end

    local btnRow3Col1, btnRanged

    for _, d in ipairs(slotData) do
        local id, row, col, texKey, hover = d.id, d.row, d.col, d.tex, d.hover
        local btn = WORS_U_EquipmentBook.buttons[id]

        -- ✅ create button only if it doesn't exist yet
        if not btn then
            btn = CreateFrame("Frame", "WORS_U_EquipSlotBtn"..id, frame, "OldSchoolButtonTemplate")
            btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
            btn:SetID(id)

            -- background icon (slot art)
            local bgIcon = btn:CreateTexture(nil, "ARTWORK")
            bgIcon:SetPoint("TOPLEFT", 3, -3)
            bgIcon:SetPoint("BOTTOMRIGHT", -3, 3)
            bgIcon:SetVertexColor(1,1,1,1)
            bgIcon:SetTexture(BASE_TEX_PATH .. (texById[id] or "Weapon_slot") .. ".blp")
            CropSlotTex(bgIcon)
            btn.bgIcon = bgIcon

            -- overlay for counts
            local overlay = CreateFrame("Frame", nil, btn)
            overlay:SetAllPoints()
            overlay:SetFrameLevel(btn:GetFrameLevel() + 5)
            local countText = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            countText:SetPoint("TOPLEFT", 2, -1)
            btn.countText = countText

            -- normal clickable slot
            local sbtn = CreateFrame("Button", nil, btn, "SecureActionButtonTemplate")
            sbtn:SetAllPoints(btn)
            sbtn:RegisterForClicks("AnyUp")
            sbtn:SetAttribute("type2", "item")
            sbtn:SetAttribute("item2", id)

            sbtn.icon = sbtn:CreateTexture(nil, "OVERLAY")
            sbtn.icon:SetAllPoints(btn.bgIcon)
            ResetTex(sbtn.icon)

            sbtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetInventoryItem("player", id)
                if GameTooltip:NumLines() == 0 then
                    GameTooltip:SetText(hover or "")
                end
                GameTooltip:Show()
            end)
            sbtn:SetScript("OnLeave", GameTooltip_Hide)

            sbtn:RegisterForDrag("LeftButton")
            sbtn:SetScript("OnDragStart", function()
                if not InCombatLockdown() then PickupInventoryItem(id) end
            end)
            sbtn:SetScript("PostClick", function(self, button)
                if button ~= "LeftButton" then return end
                PickupInventoryItem(id)
                if CursorHasItem() then PutItemInBackpack() ClearCursor() end
            end)

            btn._singleSlot = sbtn
            WORS_U_EquipmentBook.buttons[id] = btn
        end

        -- positioning (recalculate every time)
        local padH = (row == 1 or row == 2) and H_PAD_ROW2 or H_PAD
        local countUsed = rowCounts[row]
        if row == 3 then countUsed = 3 end
        local rowW = countUsed * BUTTON_SIZE + (countUsed - 1) * padH
        local leftGap = (frameW - rowW) / 2

        local idx = 0
        for _, dd in ipairs(slotData) do
            if dd.row == row and dd.col < col then
                if not (row == 3 and dd.col == 4) then
                    idx = idx + 1
                end
            end
        end

        local x = leftGap + idx * (BUTTON_SIZE + padH) + GRID_OFFSET_X
        local y = TOP_OFFSET
        if row >= 2 then
            y = y + BUTTON_SIZE + V_PAD_ROW2
            if row >= 3 then
                y = y + (row - 2) * (BUTTON_SIZE + V_PAD)
            end
        end
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -(y + GRID_OFFSET_Y))

        -- keep handles for row 3 special positioning
        if row == 3 and col == 1 then btnRow3Col1 = btn end
        if id == 18 then btnRanged = btn end

        btn:Show()
    end

    -- place ranged slot to the right of mainhand (row3 col1)
    if btnRow3Col1 and btnRanged then
        btnRanged:ClearAllPoints()
        btnRanged:SetPoint("TOPLEFT", btnRow3Col1, "TOPRIGHT", -1, 0)
    end

    UpdateButtonCounts()
end


function UpdateEquipmentButtons()
    if not WORS_U_EquipmentBook.buttons then return end

    for id, btn in pairs(WORS_U_EquipmentBook.buttons) do
        local tex = GetInventoryItemTexture("player", id)
        if tex then
            -- Show actual item icon
            btn._singleSlot.icon:SetTexture(tex)
            ResetTex(btn._singleSlot.icon)

            -- Hide the slot art background since item is equipped
            btn.bgIcon:Hide()
        else
            -- No item: show slot art
            local key = texById[id]
            if key then
                btn._singleSlot.icon:SetTexture(nil) -- clear item icon
                btn.bgIcon:SetTexture(BASE_TEX_PATH .. key .. ".blp")
                CropSlotTex(btn.bgIcon)
                btn.bgIcon:Show()
            end

            if btn.countText then btn.countText:SetText("") end
        end
    end

    UpdateButtonCounts()
end



-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================
-- (your frame already exists)
-- WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")

WORS_U_EquipmentBook.frame:SetSize(192, 304)
WORS_U_EquipmentBook.frame:SetFrameStrata("LOW")
WORS_U_EquipmentBook.frame:SetFrameLevel(10)
local bg = WORS_U_EquipmentBook.frame:CreateTexture(nil, "LOW")
WORS_U_EquipmentBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_EquipmentBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)

WORS_U_EquipmentBook.frame:Hide()
WORS_U_EquipmentBook.frame:SetMovable(true)
WORS_U_EquipmentBook.frame:EnableMouse(true)
WORS_U_EquipmentBook.frame:RegisterForDrag("LeftButton")
WORS_U_EquipmentBook.frame:SetClampedToScreen(true)

WORS_U_EquipmentBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_EquipmentBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    SaveFramePosition(self)
end)


if WORS_U_EquipmentBookFrame and WORS_U_EquipmentBookFrame.CloseButton then
    WORS_U_EquipmentBookFrame.CloseButton:ClearAllPoints()
end

-- micro button tint on show/hide
local function UpdateButtonBackground()
    if WORS_U_EquipmentBook.frame:IsShown() then
        U_EquipmentMicroMenuButton:SetButtonState("PUSHED", true)
    else
        U_EquipmentMicroMenuButton:SetButtonState("NORMAL", true)
    end
end
WORS_U_EquipmentBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_EquipmentBook.frame:SetScript("OnHide", UpdateButtonBackground)

local buttonSize = 40
local buttonPadding = 4
local numButtons = 4
local totalWidth = (buttonSize * numButtons) + (buttonPadding * (numButtons - 1))

-- Create a container frame to center the button row
local buttonRow = CreateFrame("Frame", nil, WORS_U_EquipmentBook.frame)
buttonRow:SetSize(totalWidth, buttonSize)
buttonRow:SetPoint("BOTTOM", WORS_U_EquipmentBook.frame, "BOTTOM", 0, 12)

-- Helper to create a standard button
local function CreateIconButton(parent, texture, textureDown, tooltipText, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(buttonSize, buttonSize)
    b:SetNormalTexture(texture)
    b:SetHighlightTexture(textureDown, "DISABLE")
    b:SetPushedTexture(textureDown)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", onClick or function() end)
    return b
end

-- 1: EquipmentStats
local btn1_EquipmentStats = CreateIconButton(buttonRow, "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Equipment_Stats.blp", "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Equipment_Stats_Down.blp", "View Equipment Stats",
    function()
        if AscensionCharacterFrame:IsShown() then
            AscensionCharacterFrame:Hide()
        else
            AscensionCharacterFrame:Show()
        end
    end)

-- 2: GuidePrices
local btn2_GuidePrices = CreateIconButton(buttonRow, "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Guide_prices.blp", "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Guide_prices_Down.blp", "View Guide Prices",
    function()
        if WORS_U_EquipmentBook.guidePricesFrame then
            if WORS_U_EquipmentBook.guidePricesFrame:IsShown() then
                WORS_U_EquipmentBook.guidePricesFrame:Hide()
            else
                if WORS_U_EquipmentBook.UpdateGuidePricesFrame then WORS_U_EquipmentBook:UpdateGuidePricesFrame() end
                WORS_U_EquipmentBook.guidePricesFrame:Show()
				WORS_U_EquipmentBook.itemsKeptOnDeathFrame:Hide()
            end
        end
    end)

-- 3: ItemsKeptOnDeath
local btn3_ItemsKeptOnDeath = CreateIconButton(buttonRow, "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Items_kept_on_death.blp", "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Items_kept_on_death_Down.blp", "View Items Kept on Death",
    function()
        if WORS_U_EquipmentBook.itemsKeptOnDeathFrame then
            if WORS_U_EquipmentBook.itemsKeptOnDeathFrame:IsShown() then
                WORS_U_EquipmentBook.itemsKeptOnDeathFrame:Hide()
            else
                if WORS_U_EquipmentBook.UpdateitemsKeptOnDeathFrame then WORS_U_EquipmentBook:UpdateitemsKeptOnDeathFrame() end
                WORS_U_EquipmentBook.itemsKeptOnDeathFrame:Show()
				WORS_U_EquipmentBook.guidePricesFrame:Hide()

            end
        end
    end)

-- 4: CallFollower
local btn4_CallFollower = CreateIconButton(buttonRow, "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Call_follower.blp", "Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Call_follower_Down.blp", "Call Follower",
    function()
        print("|cffffcc00[MicroMenu]|r You do not have a follower. (This doesn't do anything)")
    end)

-- Layout the buttons horizontally inside the container
btn1_EquipmentStats:SetPoint("LEFT", buttonRow, "LEFT", 0, 0)
btn2_GuidePrices:SetPoint("LEFT", btn1_EquipmentStats, "RIGHT", buttonPadding, 0)
btn3_ItemsKeptOnDeath:SetPoint("LEFT", btn2_GuidePrices, "RIGHT", buttonPadding, 0)
btn4_CallFollower:SetPoint("LEFT", btn3_ItemsKeptOnDeath, "RIGHT", buttonPadding, 0)

-- =========================================
-- EVENTS (defined after functions exist)
-- =========================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        if InCombatLockdown() then return end
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
            WORS_U_EquipmentBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
        else
            ResetMicroMenuPOSByAspect(WORS_U_EquipmentBook.frame)
        end
        SetupEquipmentButtons()
        UpdateEquipmentButtons()
        UpdateButtonCounts()

    elseif event == "PLAYER_EQUIPMENT_CHANGED"  then
        UpdateEquipmentButtons()
        UpdateButtonCounts()

    elseif event == "BAG_UPDATE" then
        UpdateEquipmentButtons()
        UpdateButtonCounts()

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- if creates were blocked during combat, rebuild now
        SetupEquipmentButtons()
        UpdateEquipmentButtons()
        UpdateButtonCounts()
    end
end)


local closeButton = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "SecureHandlerClickTemplate")
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.frame, "TOPRIGHT", 4, 4)
WORS_U_EquipmentBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
closeButton:SetAttribute("_onclick", [=[
    local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
    uEquipmentBook:SetAttribute("userToggle", nil)
    uEquipmentBook:Hide()
]=])
