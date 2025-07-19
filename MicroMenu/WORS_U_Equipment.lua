-- WORS_U_Equipment.lua
local ADDON_NAME = ...
WORS_U_EquipmentBook = WORS_U_EquipmentBook or {}

-- ===================== CONFIGURATION =====================
local BUTTON_SIZE       = 36
local H_PADDING         = 30
local H_PADDING_ROW2    = 10   -- custom horizontal gap for row 2
local V_PADDING         = 8
local V_PADDING_ROW2    = 8    -- gap between row1 and row2
local TOP_OFFSET        = 10   -- offset from top of frame to first row

-- Ordered slot keys to guarantee deterministic creation & positioning
local slotOrder = {
    "Head","Neck","Shoulder","Back",
    "Chest","MainHand","SecondaryHand",
    "Hands","Legs","Finger0",
    "Wrist","Feet","Finger1",
}

-- Slot meta data
local slotData = {
    Head          = { id=1,  row=1, col=2, bg="Head_slot" },
    Neck          = { id=2,  row=2, col=2, bg="Neck_slot" },
    Shoulder      = { id=3,  row=2, col=3, bg="Ammo_slot" },    -- Shoulder using Ammo_slot texture (as you had)
    Back          = { id=15, row=2, col=1, bg="Cape_slot" },
    Chest         = { id=5,  row=3, col=2, bg="Body_slot" },
    MainHand      = { id=16, row=3, col=1, bg="Weapon_slot", dual=true }, -- dual covers 16 or 18 (server: only one equipped)
    SecondaryHand = { id=17, row=3, col=3, bg="Shield_slot" },
    Hands         = { id=10, row=4, col=1, bg="Hands_slot" },
    Legs          = { id=7,  row=4, col=2, bg="Legs_slot" },
    Finger0       = { id=11, row=4, col=3, bg="Ring_slot" },
    Wrist         = { id=9,  row=5, col=1, bg="2h_slot" },      -- Using 2h_slot texture for Wrist (as you had)
    Feet          = { id=8,  row=5, col=2, bg="Feet_slot" },
    Finger1       = { id=12, row=5, col=3, bg="Ring_slot" },
}

-- Prebuild row structure for fast layout
local rows = {}
for _, key in ipairs(slotOrder) do
    local d = slotData[key]
    rows[d.row] = rows[d.row] or {}
    rows[d.row][d.col] = d
end

-- ===================== MAIN FRAME =====================
WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "BackdropTemplate")
local frame = WORS_U_EquipmentBook.frame
frame:SetSize(180, 330)
frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left=5, right=5, top=5, bottom=5 },
})
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)

-- Position restore
local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
    local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
    frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
else
    frame:SetPoint("CENTER")
end

frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    if SaveFramePosition then
        SaveFramePosition(self)
    end
end)

-- Close Button
local closeBtn = CreateFrame("Button", nil, frame)
closeBtn:SetSize(16,16)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 4,4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Stats button
local charBtn = CreateFrame("Button", nil, frame, "OldSchoolButtonTemplate")
charBtn:SetSize(80,20)
charBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5,5)
charBtn:SetText("Stats")
charBtn:SetScript("OnClick", function()
    ToggleCharacter("PaperDollFrame")
end)

-- Value button
local valueBtn = CreateFrame("Button", nil, frame, "OldSchoolButtonTemplate")
valueBtn:SetSize(80,20)
valueBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5,5)
valueBtn:SetText("Kept on Death")
valueBtn:SetScript("OnClick", function()
    if WORS_U_EquipmentBook.valueFrame then
        if WORS_U_EquipmentBook.valueFrame:IsShown() then
            WORS_U_EquipmentBook.valueFrame:Hide()
        else
            if WORS_U_EquipmentBook.UpdateValueFrame then
                WORS_U_EquipmentBook:UpdateValueFrame()
            end
            WORS_U_EquipmentBook.valueFrame:Show()
        end
    end
end)

-- ===================== HELPERS =====================
local function UnequipItem(slotID)
    if GetInventoryItemID("player", slotID) then
        PickupInventoryItem(slotID)
        PutItemInBackpack()
    end
end

WORS_U_EquipmentBook.buttons = {}
local buttonsCreated = false

-- ===================== BUTTON CREATION =====================
function WORS_U_EquipmentBook:CreateSlotButtons()
    --if buttonsCreated then return end
    buttonsCreated = true
    self.buttons = {}

    local frameW = frame:GetWidth()

    for rowIndex, rowSlots in pairs(rows) do
        -- Determine horizontal spacing for the row
        local padH = (rowIndex == 2) and H_PADDING_ROW2 or H_PADDING

        -- Determine how many columns actually exist in this row
        local orderedCols = {}
        for colIndex, d in pairs(rowSlots) do
            orderedCols[#orderedCols+1] = colIndex
        end
        table.sort(orderedCols)

        local count = #orderedCols
        local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
        local leftGapRow = (frameW - rowTotalW) / 2

        for posIndex, colIndex in ipairs(orderedCols) do
            local d = rowSlots[colIndex]
            local id = d.id
            local name = "WORS_U_EquipSlotBtn"..id
            local btn = CreateFrame("Button", name, frame, "ItemButtonTemplate")
            btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)

            -- Position
            local x = leftGapRow + (posIndex - 1) * (BUTTON_SIZE + padH)
            local y = TOP_OFFSET
            if rowIndex >= 2 then
                y = y + BUTTON_SIZE + V_PADDING_ROW2
                if rowIndex >= 3 then
                    y = y + (rowIndex - 2) * (BUTTON_SIZE + V_PADDING)
                end
            end
            btn:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -y)

            -- Background
            local texPath = "Interface\\AddOns\\MicroMenu\\Textures\\"..d.bg..".blp"
            btn.backgroundTexture = btn:CreateTexture(nil, "ARTWORK")
            btn.backgroundTexture:SetAllPoints()
            btn.backgroundTexture:SetTexture(texPath)

            -- Template internals
            btn.icon   = _G[name.."IconTexture"]
            btn.count  = _G[name.."Count"]
            btn.border = _G[name.."Border"]
            if btn.border then btn.border:Hide() end
            btn.icon:SetDrawLayer("ARTWORK", 1)
            btn:SetHighlightTexture(nil)

            -- Interaction
            btn:RegisterForClicks("LeftButtonUp")
            btn:RegisterForDrag("LeftButton")

            local isDual = (d.dual == true) -- covers id 16 representing 16 or 18
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
                if isDual then
                    -- show whichever is equipped (16 then 18)
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

            btn:SetScript("OnClick", function(self, button)
                if button == "LeftButton" then
                    local slotToUnequip = id
                    if isDual then
                        if GetInventoryItemTexture("player",16) then
                            slotToUnequip = 16
                        elseif GetInventoryItemTexture("player",18) then
                            slotToUnequip = 18
                        else
                            return
                        end
                    end
                    UnequipItem(slotToUnequip)
                end
            end)

            self.buttons[id] = btn
        end
    end
end

-- ===================== UPDATE =====================
function WORS_U_EquipmentBook:UpdateSlots()
    if not buttonsCreated then return end

    for _, key in ipairs(slotOrder) do
        local d = slotData[key]
        local btn = self.buttons[d.id]
        if btn then
            local tex
            if d.dual then
                tex = GetInventoryItemTexture("player",16) or GetInventoryItemTexture("player",18)
            else
                tex = GetInventoryItemTexture("player", d.id)
            end

            if tex then
                btn.icon:SetTexture(tex)
				btn.icon:SetDrawLayer("ARTWORK", 1)
                btn.icon:Show()
                btn:Enable()
                btn:SetAlpha(1)
            else
                btn.icon:Hide()
                -- Keep button enabled (you preferred same alpha), only icon disappears.
				btn.icon:SetDrawLayer("ARTWORK", 1)
                btn:Enable()
                btn:SetAlpha(1)
            end
            if btn.backgroundTexture then
                btn.backgroundTexture:Show()
            end
			btn.icon:SetDrawLayer("ARTWORK", 1)
            btn:Show()
        end
    end
end

-- ===================== EVENTS =====================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" then
        if arg1 ~= ADDON_NAME then return end -- only our addon
        WORS_U_EquipmentBook:CreateSlotButtons()
        WORS_U_EquipmentBook:UpdateSlots()

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Ensure everything is in sync when player fully loads
        WORS_U_EquipmentBook:CreateSlotButtons()
        WORS_U_EquipmentBook:UpdateSlots()

    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        WORS_U_EquipmentBook:UpdateSlots()
    end
end)

-- ===================== MICRO BUTTON HOOK =====================
CharacterMicroButton:SetScript("OnClick", function()
    MicroMenu_ToggleFrame(WORS_U_EquipmentBook.frame)
end)

frame:SetScript("OnShow", function()
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,0,0)
    WORS_U_EquipmentBook:UpdateSlots()
end)

frame:SetScript("OnHide", function()
    CharacterMicroButton:GetNormalTexture():SetVertexColor(1,1,1)
end)

CharacterMicroButton:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:SetText("Equipment",1,1,1)
    GameTooltip:AddLine("Open your equipped items overview.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    GameTooltip:Show()
end)
CharacterMicroButton:HookScript("OnLeave", GameTooltip_Hide)

-- ===================== OPTIONAL DEBUG (uncomment if needed) =====================

SLASH_WORSUEDBG1 = "/worsequip"
SlashCmdList.WORSUEDBG = function()
    print("---- Equipment Buttons ----")
    for id, btn in pairs(WORS_U_EquipmentBook.buttons) do
        local tex = btn.icon and (btn.icon:IsShown() and (btn.icon:GetTexture() or "nil") or "hidden_icon")
        local bg  = btn.backgroundTexture and (btn.backgroundTexture:GetTexture() or "nil") or "no_bg"
        local p1, rel, p2, x, y = btn:GetPoint(1)
        print(id, tex, bg, p1, rel and rel:GetName(), p2, x, y)
    end
end
