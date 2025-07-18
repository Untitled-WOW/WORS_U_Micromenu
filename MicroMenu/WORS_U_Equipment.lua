-- WORS_U_EquipmentBook = {}

-- -- Function to unequip an item from a slot
-- local function UnequipItem(slotID)
    -- if GetInventoryItemID("player", slotID) then
        -- PickupInventoryItem(slotID)
        -- PutItemInBackpack()
    -- end
-- end

-- -- Create the main frame
-- WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent)
-- WORS_U_EquipmentBook.frame:SetSize(180, 330)
-- -- persisted positioning
-- local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
-- if pos then
    -- local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
    -- WORS_U_EquipmentBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
-- else
    -- WORS_U_EquipmentBook.frame:SetPoint("CENTER")
-- end


-- -- allow moving
-- WORS_U_EquipmentBook.frame:SetMovable(true)
-- WORS_U_EquipmentBook.frame:EnableMouse(true)
-- WORS_U_EquipmentBook.frame:RegisterForDrag("LeftButton")
-- WORS_U_EquipmentBook.frame:SetClampedToScreen(true)
-- WORS_U_EquipmentBook.frame:SetScript("OnDragStart", WORS_U_EquipmentBook.frame.StartMoving)
-- WORS_U_EquipmentBook.frame:SetScript("OnDragStop", function(self)
    -- self:StopMovingOrSizing()
    -- SaveFramePosition(self)
-- end)
-- WORS_U_EquipmentBook.frame:Hide()

-- -- backdrop styling
-- WORS_U_EquipmentBook.frame:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground1",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 32,
    -- insets = { left = 5, right = 5, top = 5, bottom = 5 },
-- })
-- WORS_U_EquipmentBook.frame:SetBackdropColor(1,1,1,1)

-- -- close button
-- local closeBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame)
-- closeBtn:SetSize(16,16)
-- closeBtn:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.frame, "TOPRIGHT", 4,4)
-- closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
-- closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
-- closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
-- closeBtn:SetScript("OnClick", function() WORS_U_EquipmentBook.frame:Hide() end)

-- -- Character‑frame toggle button
-- local charBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "UIPanelButtonTemplate")
-- charBtn:SetSize(80, 20)
-- charBtn:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.frame, "BOTTOMLEFT", 5, 5)
-- charBtn:SetText("Character")
-- charBtn:SetScript("OnClick", function()
    -- ToggleCharacter("PaperDollFrame")
-- end)



-- -- GRID CONFIGURATION
-- local BUTTON_SIZE  = 36
-- local PADDING      = 15
-- local TOP_OFFSET   = 10  -- pixels down from top of frame

-- -- slot definitions (no separate Ranged, handled by MainHand)
-- local slotData = {
    -- Head          = { id=1,  row=1, col=2, bg="Head_slot" },
    -- Neck          = { id=2,  row=2, col=2, bg="Neck_slot" },
    -- Shoulder      = { id=3,  row=2, col=3, bg="Ammo_slot" },
    -- Back          = { id=15, row=2, col=1, bg="Cape_slot" },
    -- Chest         = { id=5,  row=3, col=2, bg="Body_slot" },
    -- MainHand      = { id=16, row=3, col=1, bg="Weapon_slot" },
    -- SecondaryHand = { id=17, row=3, col=3, bg="Shield_slot" },
    -- Hands         = { id=10, row=4, col=1, bg="Hands_slot" },
    -- Legs          = { id=7,  row=4, col=2, bg="Legs_slot" },
    -- Finger0       = { id=11, row=4, col=3, bg="Ring_slot" },
    -- Wrist         = { id=9,  row=5, col=1, bg="2h_slot" },
    -- Feet          = { id=8,  row=5, col=2, bg="Feet_slot" },
    -- Finger1       = { id=12, row=5, col=3, bg="Ring_slot" },
-- }

-- -- calculate grid width for horizontal centering
-- local maxCol = 0
-- for _, d in pairs(slotData) do maxCol = math.max(maxCol, d.col) end
-- local totalW = maxCol * BUTTON_SIZE + (maxCol-1) * PADDING
-- local frameW = WORS_U_EquipmentBook.frame:GetWidth()
-- local leftGap = (frameW - totalW) / 2

-- WORS_U_EquipmentBook.buttons = {}

-- -- create and place buttons top-down, horizontally centered
-- for _, d in pairs(slotData) do
    -- local id,row,col,bg = d.id, d.row, d.col, d.bg
    -- local isDual = (id == 16)
    -- local name = "WORS_U_EquipSlotBtn"..id
    -- local btn = _G[name] or CreateFrame("Button", name, WORS_U_EquipmentBook.frame, "ItemButtonTemplate,BackdropTemplate")
    -- btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    -- btn:ClearAllPoints()
    -- -- position
    -- local x = leftGap + (col-1)*(BUTTON_SIZE + PADDING)
    -- local y = TOP_OFFSET + (row-1)*(BUTTON_SIZE + PADDING)
    -- btn:SetPoint("TOPLEFT", WORS_U_EquipmentBook.frame, "TOPLEFT", x, -y)

    -- -- set custom backdrop as background
    -- btn:SetBackdrop({
        -- bgFile   = "Interface\\Icons\\"..bg..".blp",
        -- edgeFile = nil,
        -- tile     = false,
        -- insets   = { left=0, right=0, top=0, bottom=0 },
    -- })
    -- btn:SetBackdropColor(1,1,1,1)

    -- -- grab icon, count, hide default border
    -- btn.icon   = _G[name.."IconTexture"]
    -- btn.count  = _G[name.."Count"]
    -- btn.border = _G[name.."Border"]
    -- if btn.border then btn.border:Hide() end

    -- -- clicks & drag (unequip on left click)
    -- btn:RegisterForClicks("LeftButtonUp")
    -- btn:RegisterForDrag("LeftButton")
    -- btn:SetScript("OnEnter", function(self)
        -- GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        -- if isDual then
            -- if GetInventoryItemTexture("player",16) then
                -- GameTooltip:SetInventoryItem("player",16)
            -- elseif GetInventoryItemTexture("player",18) then
                -- GameTooltip:SetInventoryItem("player",18)
            -- end
        -- else
            -- GameTooltip:SetInventoryItem("player",id)
        -- end
        -- GameTooltip:Show()
    -- end)
    -- btn:SetScript("OnLeave", GameTooltip_Hide)
    -- btn:SetScript("OnDragStart", function()
        -- if isDual then
            -- if GetInventoryItemTexture("player",16) then PickupInventoryItem(16)
            -- elseif GetInventoryItemTexture("player",18) then PickupInventoryItem(18) end
        -- else
            -- PickupInventoryItem(id)
        -- end
    -- end)
    -- btn:SetScript("OnClick", function(self, button)
        -- if button == "LeftButton" then
            -- local slotToUnequip = id
            -- if isDual then
                -- if GetInventoryItemTexture("player",16) then
                    -- slotToUnequip = 16
                -- elseif GetInventoryItemTexture("player",18) then
                    -- slotToUnequip = 18
                -- else
                    -- return
                -- end
            -- end
            -- UnequipItem(slotToUnequip)
        -- end
    -- end)

    -- WORS_U_EquipmentBook.buttons[id] = btn
-- end

-- -- update function: show icons, disable dual when empty
-- function WORS_U_EquipmentBook:UpdateSlots()
    -- for _, d in pairs(slotData) do
        -- local btn = self.buttons[d.id]
        -- if not btn then return end
        -- local isDual = (d.id == 16)
        -- local tex = isDual
            -- and (GetInventoryItemTexture("player",16) or GetInventoryItemTexture("player",18))
            -- or GetInventoryItemTexture("player",d.id)
        -- if tex then
            -- btn.icon:SetTexture(tex)
            -- btn.icon:Show()
            -- btn:Enable()
            -- btn:SetAlpha(1)
        -- else
            -- btn.icon:Hide()
            -- if isDual then
                -- btn:Disable()
                -- btn:SetAlpha(1)
            -- else
                -- btn:Enable()
                -- btn:SetAlpha(1)
            -- end
        -- end
        -- btn:Show()
    -- end
-- end

-- WORS_U_EquipmentBook.frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
-- WORS_U_EquipmentBook.frame:SetScript("OnEvent", function(_,_,slot) WORS_U_EquipmentBook:UpdateSlots() end)
-- WORS_U_EquipmentBook:UpdateSlots()

-- -- micro-menu hook
-- CharacterMicroButton:SetScript("OnClick", function() MicroMenu_ToggleFrame(WORS_U_EquipmentBook.frame) end)


-- WORS_U_EquipmentBook.frame:SetScript("OnShow", function() CharacterMicroButton:GetNormalTexture():SetVertexColor(1,0,0) end)
-- WORS_U_EquipmentBook.frame:SetScript("OnHide", function() CharacterMicroButton:GetNormalTexture():SetVertexColor(1,1,1) end)

-- CharacterMicroButton:HookScript("OnEnter", function(self)
    -- GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
    -- GameTooltip:SetText("Equipment",1,1,1)
    -- GameTooltip:AddLine("Open your equipped items overview.",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b)
    -- GameTooltip:Show()
-- end)
-- CharacterMicroButton:HookScript("OnLeave", GameTooltip_Hide)



WORS_U_EquipmentBook = {}

local function UnequipItem(slotID)
    if GetInventoryItemID("player", slotID) then
        PickupInventoryItem(slotID)
        PutItemInBackpack()
    end
end

WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "BackdropTemplate")
WORS_U_EquipmentBook.frame:SetSize(180, 330)
local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
if pos then
    local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
    WORS_U_EquipmentBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
else
    WORS_U_EquipmentBook.frame:SetPoint("CENTER")
end
WORS_U_EquipmentBook.frame:SetMovable(true)
WORS_U_EquipmentBook.frame:EnableMouse(true)
WORS_U_EquipmentBook.frame:RegisterForDrag("LeftButton")
WORS_U_EquipmentBook.frame:SetClampedToScreen(true)
WORS_U_EquipmentBook.frame:SetScript("OnDragStart", WORS_U_EquipmentBook.frame.StartMoving)
WORS_U_EquipmentBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    SaveFramePosition(self)
end)
WORS_U_EquipmentBook.frame:Hide()

WORS_U_EquipmentBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left=5, right=5, top=5, bottom=5 },
})
WORS_U_EquipmentBook.frame:SetBackdropColor(1,1,1,1)

local closeBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame)
closeBtn:SetSize(16,16)
closeBtn:SetPoint("TOPRIGHT", WORS_U_EquipmentBook.frame, "TOPRIGHT", 4,4)
closeBtn:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeBtn:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp","ADD")
closeBtn:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeBtn:SetScript("OnClick", function() WORS_U_EquipmentBook.frame:Hide() end)

local charBtn = CreateFrame("Button", nil, WORS_U_EquipmentBook.frame, "UIPanelButtonTemplate")
charBtn:SetSize(80,20)
charBtn:SetPoint("BOTTOMLEFT", WORS_U_EquipmentBook.frame, "BOTTOMLEFT", 5,5)
charBtn:SetText("Character")
charBtn:SetScript("OnClick", function()
    ToggleCharacter("PaperDollFrame")
end)

-- GRID CONFIGURATION
local BUTTON_SIZE    = 36
local H_PADDING      = 30
local H_PADDING_ROW2 = 10   -- custom horizontal gap for row 2
local V_PADDING      = 8
local V_PADDING_ROW2 = 8
local TOP_OFFSET     = 10

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

-- Precompute frame width
local frameW = WORS_U_EquipmentBook.frame:GetWidth()

WORS_U_EquipmentBook.buttons = {}

for _, d in pairs(slotData) do
    local id,row,col,bg = d.id, d.row, d.col, d.bg
    local isDual = (id == 16)
    local name = "WORS_U_EquipSlotBtn"..id
    local btn = _G[name] or CreateFrame("Button", name, WORS_U_EquipmentBook.frame, "ItemButtonTemplate,BackdropTemplate")
    btn:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    btn:ClearAllPoints()

    -- horizontal padding per row
    local padH = (row == 2) and H_PADDING_ROW2 or H_PADDING
    -- compute entries in this row (always 3 for rows 2–4, row 1 only 1, row 5 only 3)
    local count = 0
    for _, dd in pairs(slotData) do if dd.row == row then count = count + 1 end end
    -- center that row
    local rowTotalW = count * BUTTON_SIZE + (count - 1) * padH
    local leftGapRow = (frameW - rowTotalW) / 2

    local x = leftGapRow + ( -- find index among row
        (function()
            local idx = 0
            for _, dd in pairs(slotData) do
                if dd.row == row and dd.col < col then idx = idx + 1 end
            end
            return idx
        end)() * (BUTTON_SIZE + padH)
    )

    -- vertical positioning
    local y = TOP_OFFSET
    if row >= 2 then
        y = y + BUTTON_SIZE + V_PADDING_ROW2
        if row >= 3 then
            y = y + (row - 2) * (BUTTON_SIZE + V_PADDING)
        end
    end

    btn:SetPoint("TOPLEFT", WORS_U_EquipmentBook.frame, "TOPLEFT", x, -y)

    btn:SetBackdrop({
        bgFile   = "Interface\\Icons\\"..bg..".blp",
        edgeFile = nil,
        tile     = false,
        insets   = { left=0, right=0, top=0, bottom=0 },
    })
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
    btn:SetScript("OnClick", function(self,button)
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

    WORS_U_EquipmentBook.buttons[id] = btn
end

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

WORS_U_EquipmentBook.frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
WORS_U_EquipmentBook.frame:SetScript("OnEvent", function(_,_,slot) WORS_U_EquipmentBook:UpdateSlots() end)
WORS_U_EquipmentBook:UpdateSlots()

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
