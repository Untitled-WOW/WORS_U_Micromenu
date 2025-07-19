WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "BackdropTemplate")
WORS_U_EquipmentBook.frame:SetSize(180, 330)
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

local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
    local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
    WORS_U_EquipmentBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
else
    WORS_U_EquipmentBook.frame:SetPoint("CENTER")
end

WORS_U_EquipmentBook.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving() 
end)
WORS_U_EquipmentBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    SaveFramePosition(self)
end)

local closeBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame)
closeBtn:SetSize(16,16)
closeBtn:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.frame, "TOPRIGHT", 4,4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() 
	WORS_U_EquipmentBook.frame:Hide() 
end)

local charBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "OldSchoolButtonTemplate")
charBtn:SetSize(80,20)
charBtn:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.frame, "BOTTOMLEFT", 5,5)
charBtn:SetText("Character")
charBtn:SetScript("OnClick", function()
    ToggleCharacter("PaperDollFrame")
end)

-- Value button
local valueBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "OldSchoolButtonTemplate")
valueBtn:SetSize(80,20)
valueBtn:SetPoint("BOTTOMRIGHT", WORS_U_EquipmentBook.frame, "BOTTOMRIGHT", -5,5)
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


-- GRID CONFIGURATION
local BUTTON_SIZE    = 36
local H_PADDING      = 30
local H_PADDING_ROW2 = 10   -- custom horizontal gap for row 2
local V_PADDING      = 8
local V_PADDING_ROW2 = 8
local TOP_OFFSET     = 10
local frameW = WORS_U_EquipmentBook.frame:GetWidth() -- Precompute frame width
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

local function UnequipItem(slotID)
    if GetInventoryItemID("player", slotID) then
        PickupInventoryItem(slotID)
        PutItemInBackpack()
    end
end

WORS_U_EquipmentBook.buttons = {}

-- after your slotData and constants definitions, add:

function WORS_U_EquipmentBook:CreateSlotButtons()
    self.buttons = {}

    for _, d in pairs(slotData) do
        local id, row, col, bg = d.id, d.row, d.col, d.bg
        local isDual = (id == 16)
        local name = "WORS_U_EquipSlotBtn"..id

        local btn = _G[name]
            or CreateFrame("Button", name, WORS_U_EquipmentBook.frame, "ItemButtonTemplate,BackdropTemplate")
        btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
        btn:ClearAllPoints()

        -- horizontal padding per row
        local padH = (row == 2) and H_PADDING_ROW2 or H_PADDING
        local count = 0
        for _, dd in pairs(slotData) do
            if dd.row == row then count = count + 1 end
        end
        local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
        local leftGapRow = (frameW - rowTotalW) / 2

        -- index in row
        local idx = 0
        for _, dd in pairs(slotData) do
            if dd.row == row and dd.col < col then
                idx = idx + 1
            end
        end
        local x = leftGapRow + idx * (BUTTON_SIZE + padH)

        -- vertical positioning
        local y = TOP_OFFSET
        if row >= 2 then
            y = y + BUTTON_SIZE + V_PADDING_ROW2
            if row >= 3 then
                y = y + (row - 2) * (BUTTON_SIZE + V_PADDING)
            end
        end

        btn:SetPoint("TOPLEFT", WORS_U_EquipmentBook.frame, "TOPLEFT", x, -y)
        btn:SetBackdrop{
            bgFile   = "Interface\\Icons\\"..bg,
            edgeFile = nil, tile = false,
            insets   = {0,0,0,0},
        }
        btn:SetBackdropColor(1,1,1,1)

        btn.icon   = _G[name.."IconTexture"]
        btn.count  = _G[name.."Count"]
        btn.border = _G[name.."Border"]
        if btn.border then btn.border:Hide() end

        btn:RegisterForClicks("LeftButtonUp")
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            if isDual then
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
                        return
                    end
                end
                UnequipItem(slotToUnequip)
            end
        end)

        self.buttons[id] = btn
    end
end

-- then, where you had the inline loop, replace it with:
WORS_U_EquipmentBook:CreateSlotButtons()


function WORS_U_EquipmentBook:UpdateSlots()
    for _, d in pairs(slotData) do
        local btn = self.buttons[d.id]
        local isDual = (d.id == 16)
        local tex = isDual
            and (GetInventoryItemTexture("player",16) or GetInventoryItemTexture("player",18))
            or GetInventoryItemTexture("player",d.id)
        if tex then
            btn.icon:SetTexture(tex); btn.icon:Show()
            btn:Enable(); btn:SetAlpha(1)
        else
            btn.icon:Hide()
            if isDual then btn:Disable(); btn:SetAlpha(1)
            else btn:Enable(); btn:SetAlpha(1) end
        end
        btn:Show()
    end
end


local eventFrame = CreateFrame("Frame")
-- Register the events we'll use
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, slot,...)
	if event == "PLAYER_ENTERING_WORLD" then
		WORS_U_EquipmentBook:CreateSlotButtons()
		WORS_U_EquipmentBook:UpdateSlots()
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		WORS_U_EquipmentBook:UpdateSlots()
	end
end)

CharacterMicroButton:SetScript("OnClick", function() MicroMenu_ToggleFrame(WORS_U_EquipmentBook.frame) end)
WORS_U_EquipmentBook.frame:SetScript("OnShow", function() CharacterMicroButton:GetNormalTexture():SetVertexColor(1,0,0) end)
WORS_U_EquipmentBook.frame:SetScript("OnHide", function() CharacterMicroButton:GetNormalTexture():SetVertexColor(1,1,1) end)
CharacterMicroButton:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    GameTooltip:SetText("Equipment",1,1,1)
    GameTooltip:AddLine("Open your equipped items overview.",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b)
    GameTooltip:Show()
end)
CharacterMicroButton:HookScript("OnLeave", GameTooltip_Hide)
