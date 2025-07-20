WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}
local EB = WORS_U_EquipmentBook

-- ---------------- Configuration ----------------
local BASE_TEX_PATH   = "Interface\\AddOns\\MicroMenu\\Textures\\"
-- BLANK_TEX is definitely not needed now, as we're using the slot's default texture as the "blank"
-- local BLANK_TEX       = BASE_TEX_PATH .. "Blank_slot.blp"

local BUTTON_SIZE     = 36
local H_PAD           = 30          -- horizontal gap (rows except row 2)
local H_PAD_ROW2      = 10
local V_PAD           = 8
local V_PAD_ROW2      = 8
local TOP_OFFSET      = 10

-- Slot layout (add more if desired)
local slotData = {
    { id=1,  row=1, col=2, tex="Head_slot" },
    { id=2,  row=2, col=2, tex="Neck_slot" },
    { id=3,  row=2, col=3, tex="Ammo_slot" },
    { id=15, row=2, col=1, tex="Cape_slot" },
    { id=5,  row=3, col=2, tex="Body_slot" },
    { id=16, row=3, col=1, tex="Weapon_slot" },    -- MainHand (special dual logic 16/18)
    { id=17, row=3, col=3, tex="Shield_slot" },
    { id=10, row=4, col=1, tex="Hands_slot" },
    { id=7,  row=4, col=2, tex="Legs_slot" },
    { id=11, row=4, col=3, tex="Ring_slot" },
    { id=9,  row=5, col=1, tex="Bracer_slot" },
    { id=8,  row=5, col=2, tex="Feet_slot" },
    { id=12, row=5, col=3, tex="Ring_slot" },
}

-- ---------------- Frame Creation ----------------
if not EB.frame then
    EB.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent)
    EB.frame:SetSize(180, 330)
    EB.frame:SetBackdrop({
        bgFile   = "Interface\\WORS\\OldSchoolBackground1",
        edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
        tile = false, tileSize = 32, edgeSize = 32,
        insets = { left=5, right=5, top=5, bottom=5 },
    })
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

-- Character open
local charBtn = CreateFrame("Button", nil, EB.frame, "OldSchoolButtonTemplate")
charBtn:SetSize(80,20)
charBtn:SetPoint("BOTTOMLEFT", 5,5)
charBtn:SetText("Character")
charBtn:SetScript("OnClick", function() ToggleCharacter("PaperDollFrame") end)

-- Value button (kept on death)
local valueBtn = CreateFrame("Button", nil, EB.frame, "OldSchoolButtonTemplate")
valueBtn:SetSize(80,20)
valueBtn:SetPoint("BOTTOMRIGHT", -5,5)
valueBtn:SetText("Kept on Death")
valueBtn:SetScript("OnClick", function()
    if EB.valueFrame then
        if EB.valueFrame:IsShown() then
            EB.valueFrame:Hide()
        else
            if EB.UpdateValueFrame then EB:UpdateValueFrame() end
            EB.valueFrame:Show()
        end
    end
end)

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
        local id, row, col, texKey = d.id, d.row, d.col, d.tex
        --local isDual = (id == 16)

        local btn = CreateFrame("Button", "WORS_U_EquipSlotBtn"..id, EB.frame, "OldSchoolButtonTemplate,WORSEqItemTemplate")
        btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)

        -- Horizontal position
        local padH = (row == 2) and H_PAD_ROW2 or H_PAD
        local count = rowCounts[row]
        local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
        local leftGapRow = (frameW - rowTotalW) / 2

        local idx = 0
        for _, dd in ipairs(slotData) do
            if dd.row == row and dd.col < col then idx = idx + 1 end
        end
        local x = leftGapRow + idx * (BUTTON_SIZE + padH)

        -- Vertical
        local y = TOP_OFFSET
        if row >= 2 then
            y = y + BUTTON_SIZE + V_PAD_ROW2
            if row >= 3 then
                y = y + (row - 2) * (BUTTON_SIZE + V_PAD)
            end
        end
        btn:SetPoint("TOPLEFT", EB.frame, "TOPLEFT", x, -y)
		
		-- Background texture (slot border / “blank”)
		local bg = btn:CreateTexture(nil, "ARTWORK", nil, 0)
		bg:SetTexture("Interface\\AddOns\\MicroMenu\\Textures\\Blank_slot.blp")
		bg:SetAllPoints()
		btn.slotBg = bg

		-- Icon texture (item or slot‑graphic)
		local icon = btn:CreateTexture(nil, "OVERLAY", nil, 1)
		icon:SetPoint("TOPLEFT", 3, -3)
		icon:SetPoint("BOTTOMRIGHT", -3, 3)
		
		icon:Show()
		btn.icon = icon
		-- Store the path to the "empty slot" graphic directly on the icon object
		btn.icon.emptySlotTex = BASE_TEX_PATH .. texKey .. ".blp"

        -- Tooltip
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if isDual then
                if GetInventoryItemTexture("player",16) then
                    GameTooltip:SetInventoryItem("player",16)
                elseif GetInventoryItemTexture("player",18) then
                    GameTooltip:SetInventoryItem("player",18)
                end
            else
                GameTooltip:SetInventoryItem("player", id)
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
		
		if id == 16 and not GetInventoryItemTexture("player", 16) and GetInventoryItemTexture("player", 18) then
			id = 18
		end
		
		btn:SetID(id)	
		
        -- Drag pickup
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function()
            if isDual then
                if GetInventoryItemTexture("player",16) then
                    PickupInventoryItem(16)
                elseif GetInventoryItemTexture("player",18) then
                    PickupInventoryItem(18)
                end
            else
                PickupInventoryItem(id)
            end
        end)
        EB.buttons[id] = btn
    end
end

local function UpdateButtons()
    for id, btn in pairs(EB.buttons) do
        local isDual = (id == 16)
        local itemTex = nil -- This will store the equipped item's texture, if any.

        if isDual then
            itemTex = GetInventoryItemTexture("player", 16) or GetInventoryItemTexture("player", 18)
        else
            itemTex = GetInventoryItemTexture("player", id)
        end

        if itemTex then
            -- An item IS equipped: Show its icon.
            btn.icon:SetTexture(itemTex)
            btn.icon:Show()
            btn:Enable() -- Keep button enabled for interaction
        else
            -- Nothing is equipped: Show the specific slot icon (e.g., Head_slot.blp)
            btn.icon:SetTexture(btn.icon.emptySlotTex) -- Use the stored empty slot texture
            btn.icon:Show() -- Ensure it's visible

            if isDual then
                -- For dual slots, if empty, disable to prevent dragging "nothing"
                btn:Disable()
            else
                -- For other slots, enable to allow dropping items into them
                btn:Enable()
            end
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