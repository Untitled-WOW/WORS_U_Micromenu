WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}
local EB = WORS_U_EquipmentBook

-- ---------------- Configuration ----------------
local BASE_TEX_PATH   = "Interface\\AddOns\\MicroMenu\\Textures\\EquipmentIcon\\"


local BUTTON_SIZE     = 36
local H_PAD           = 30          -- horizontal gap (rows except row 2)
local H_PAD_ROW2      = 10
local V_PAD           = 8
local V_PAD_ROW2      = 8
local TOP_OFFSET      = 0

-- Slot layout (add more if desired)
local slotData = {
	{ id=13, row=1, col=1, hover="Trinket", tex="Trinket_slot"},
	{ id=14, row=1, col=3, hover="Trinket", tex="Trinket_slot"},
    { id=1,  row=1, col=2, hover="Head", tex="Head_slot" },
    { id=2,  row=2, col=2, hover="Neck", tex="Neck_slot" },
    { id=3,  row=2, col=3, hover="Arrows", tex="Ammo_slot" },
    { id=15, row=2, col=1, hover="Cape", tex="Cape_slot" },
    { id=5,  row=3, col=2, hover="Chest", tex="Body_slot" },
    { id=16, row=3, col=1, hover="Main Hand", tex="Weapon_slot" },    -- MainHand (16/18 Main Hand / Ranged)
    { id=17, row=3, col=3, hover="Off Hand", tex="Shield_slot" },
	{ id=4,  row=4, col=1, hover="Shirt", tex="Shirt_slot" },
    { id=6,  row=4, col=2, hover="Waist", tex="Belt_slot" },
    { id=19, row=4, col=3, hover="Tabard", tex="Tabard_slot" },
	{ id=10, row=5, col=1, hover="Hands", tex="Hands_slot" },
    { id=7,  row=5, col=2, hover="Legs", tex="Legs_slot" },
    { id=11, row=5, col=3, hover="Ring", tex="Ring_slot" },
    { id=9,  row=6, col=1, hover="Wrist", tex="Bracer_slot" },
    { id=8,  row=6, col=2, hover="Feet", tex="Feet_slot" },
    { id=12, row=6, col=3, hover="Ring", tex="Ring_slot" },	
}

local function formatOSRSNumber(value)
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



local function UpdateButtonCounts()
	for id, btn in pairs(EB.buttons) do
		local itemLink = GetInventoryItemLink("player", id)
		if itemLink then
			local itemName = GetItemInfo(itemLink)
			local quantity = GetInventoryItemCount("player", id)

			local countStr = ""
			local chargeSuffix = itemName and itemName:match("%((%d+)%)")
			if chargeSuffix then
				countStr = formatOSRSNumber(tonumber(chargeSuffix))
			end
			if quantity and quantity > 1 then
				countStr = formatOSRSNumber(quantity)
			end
			btn.countText:SetText(countStr or "")
		else
			btn.countText:SetText("")
		end
	end
end



-- ---------------- Frame Creation ----------------
if not EB.frame then
    EB.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent)
    EB.frame:SetSize(180, 330)
    -- EB.frame:SetBackdrop({
        -- bgFile   = "Interface\\WORS\\OldSchoolBackground1",
        -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
        -- tile = false, tileSize = 32, edgeSize = 32,
        -- insets = { left=5, right=5, top=5, bottom=5 },
    -- })
    EB.frame:Hide()
    EB.frame:SetMovable(true)
    EB.frame:EnableMouse(true)
    EB.frame:RegisterForDrag("LeftButton")
    EB.frame:SetClampedToScreen(true)
    EB.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    EB.frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if SaveFramePosition then SaveFramePosition(self) end
    end)

    local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
    if pos then
        local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
        EB.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
    else
        EB.frame:SetPoint("CENTER")
    end
	-- Periodically update item quantity and charge counts
	local updateInterval = 2.0
	local timeSinceLast = 0

	EB.frame:SetScript("OnUpdate", function(self, elapsed)
		timeSinceLast = timeSinceLast + elapsed
		if timeSinceLast >= updateInterval then
			timeSinceLast = 0
			UpdateButtonCounts()
		end
	end)

end

-- ---------------- Close & Bottom Buttons ----------------
-- Close
local closeBtn = CreateFrame("Button", nil, EB.frame)
closeBtn:SetSize(16,16)
closeBtn:SetPoint("TOPRIGHT", 4,4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() EB.frame:Hide() end)

local buttonSize = 40
local buttonPadding = 4
local numButtons = 4
local totalWidth = (buttonSize * numButtons) + (buttonPadding * (numButtons - 1))

-- Create a container frame to center the button row
local buttonRow = CreateFrame("Frame", nil, EB.frame)
buttonRow:SetSize(totalWidth, buttonSize)
buttonRow:SetPoint("BOTTOM", EB.frame, "BOTTOM", 0, 5)

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

-- 1: Equipment Stats
local btn1 = CreateIconButton(buttonRow,
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Equipment_Stats.blp",
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Equipment_Stats_Down.blp",
	"View Equipment Stats",
	function() ToggleCharacter("PaperDollFrame") end)

-- 2: Guide Prices
local btn2 = CreateIconButton(buttonRow,
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Guide_prices.blp",
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Guide_prices_Down.blp",
	"View Guide Prices",
	function()
		if EB.guidePricesFrame then
			if EB.guidePricesFrame:IsShown() then
				EB.guidePricesFrame:Hide()
			else
				if EB.UpdateGuidePricesFrame then EB:UpdateGuidePricesFrame() end
				EB.guidePricesFrame:Show()
			end
		end
	end)

-- 3: Items Kept on Death
local btn3 = CreateIconButton(buttonRow,
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Items_kept_on_death.blp",
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Items_kept_on_death_Down.blp",
	"View Items Kept on Death",
	function()
		if EB.itemsKeptOnDeathFrame then
			if EB.itemsKeptOnDeathFrame:IsShown() then
				EB.itemsKeptOnDeathFrame:Hide()
			else
				if EB.UpdateitemsKeptOnDeathFrame then EB:UpdateitemsKeptOnDeathFrame() end
				EB.itemsKeptOnDeathFrame:Show()
			end
		end
	end)

-- 4: Call Follower
local btn4 = CreateIconButton(buttonRow,
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Call_follower.blp",
	"Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Call_follower_Down.blp",
	"Call Follower",
	function()
		print("|cffffcc00[MicroMenu]|r You do not have a follower. (This doesn't do anything)")
	end)


-- Layout the buttons horizontally inside the container
btn1:SetPoint("LEFT", buttonRow, "LEFT", 0, 0)
btn2:SetPoint("LEFT", btn1, "RIGHT", buttonPadding, 0)
btn3:SetPoint("LEFT", btn2, "RIGHT", buttonPadding, 0)
btn4:SetPoint("LEFT", btn3, "RIGHT", buttonPadding, 0)




-- ---------------- Utilities ----------------
EB.buttons = EB.buttons or {}

local function ClearOldButtons()
    for _, b in pairs(EB.buttons) do
        b:Hide()
        b:SetParent(nil)
    end
    EB.buttons = {}
end


local function CreateButtons()
    ClearOldButtons()
    local frameW = EB.frame:GetWidth()

    -- Count per row
    local rowCounts = {}
    for _, d in ipairs(slotData) do
        rowCounts[d.row] = (rowCounts[d.row] or 0) + 1
    end

    for _, d in ipairs(slotData) do
        local id, row, col, texKey, hover = d.id, d.row, d.col, d.tex, d.hover
        local btn = CreateFrame("Button", "WORS_U_EquipSlotBtn"..id, EB.frame, "OldSchoolButtonTemplate,WORSEqItemTemplate")
        btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)

        -- For Mainhand when Ranged (18) item is equipped, use 18 so WORSEqItemTemplate works 
        if id == 16 and not GetInventoryItemTexture("player", 16) and GetInventoryItemTexture("player", 18) then
            id = 18
        end		
        btn:SetID(id)

        -- Horizontal positioning
        local padH = (row == 2 or row == 1) and H_PAD_ROW2 or H_PAD
        local count = rowCounts[row]
        local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
        local leftGapRow = (frameW - rowTotalW) / 2

        local idx = 0
        for _, dd in ipairs(slotData) do
            if dd.row == row and dd.col < col then idx = idx + 1 end
        end
        local x = leftGapRow + idx * (BUTTON_SIZE + padH)

        -- Vertical positioning
        local y = TOP_OFFSET
        if row >= 2 then
            y = y + BUTTON_SIZE + V_PAD_ROW2
            if row >= 3 then
                y = y + (row - 2) * (BUTTON_SIZE + V_PAD)
            end
        end
        btn:SetPoint("TOPLEFT", EB.frame, "TOPLEFT", x, -y)

        -- Background texture (slot border / blank)
        local bg = btn:CreateTexture(nil, "ARTWORK", nil, 0)
        bg:SetTexture("Interface\\AddOns\\MicroMenu\\Textures\\EquipmentIcon\\Blank_slot.blp")
        bg:SetAllPoints()
        btn.slotBg = bg

        -- Icon texture (item or slot-graphic)
        local icon = btn:CreateTexture(nil, "OVERLAY", nil, 1)
        icon:SetPoint("TOPLEFT", 3, -3)
        icon:SetPoint("BOTTOMRIGHT", -3, 3)
        icon:Show()
        btn.icon = icon
        btn.icon.emptySlotTex = BASE_TEX_PATH .. texKey .. ".blp"

        -- Top-left count/charges text
        local countText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        countText:SetPoint("TOPLEFT", 2, -1)
        countText:SetText("")
        countText:SetJustifyH("LEFT")
        countText:SetJustifyV("TOP")
        countText:SetTextColor(1, 1, 1)
        btn.countText = countText

        -- Tooltip
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetInventoryItem("player", id)
            if GameTooltip:NumLines() == 0 then
                GameTooltip:SetText(hover or "")
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        -- Drag pickup
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function()
            PickupInventoryItem(id)
        end)

        EB.buttons[id] = btn
    end

    -- Initial update for count/charges
    UpdateButtonCounts()
end


local function UpdateButtons()
    for id, btn in pairs(EB.buttons) do
        local itemTex = nil -- This will store the equipped item's texture, if any.
		itemTex = GetInventoryItemTexture("player", id)
        if itemTex then
            -- An item IS equipped: Show its icon.
            btn.icon:SetTexture(itemTex)
            btn.icon:Show()
        else
            -- Nothing is equipped: Show the specific slot icon (e.g., Head_slot.blp)
            btn.icon:SetTexture(btn.icon.emptySlotTex) -- Use the stored empty slot texture
			btn.countText:SetText("")
            btn.icon:Show() -- Ensure it's visible
        end
    end
end


-- ---------------- Show / Hide ----------------
EB.frame:SetScript("OnShow", function()
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,0,0)
    CreateButtons()
    UpdateButtons()
end)

EB.frame:SetScript("OnHide", function()
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,1,1)
    ClearOldButtons()
end)

-- ---------------- Events (only update if visible) ----------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if not EB.frame:IsShown() then return end
    if event == "UNIT_INVENTORY_CHANGED" and arg1 ~= "player" then return end
    UpdateButtons()
end)

-- ---------------- Micro Button Toggle ----------------
CharacterMicroButton:SetScript("OnClick", function()
    MicroMenu_ToggleFrame(EB.frame)
end)

-- Tooltip for micro button
CharacterMicroButton:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:SetText("Equipment",1,1,1)
    GameTooltip:AddLine("Open your equipped items overview.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    GameTooltip:Show()
end)
CharacterMicroButton:HookScript("OnLeave", GameTooltip_Hide)

-- ====================================================================
-- End of File
-- ====================================================================