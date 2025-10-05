local ADDON_NAME = ...

-- =========================
-- SavedVariables defaults
-- =========================
local DEFAULTS = {
    Backpack    = false,
    CombatStyle = false,
    Prayer      = false,
    Magic       = false,
    Equipment   = false,
    Skills      = false,
    Emotes      = false,
    Scale       = 1.0,
}

-- =========================
-- Normalize + apply defaults
-- =========================
local function tobool(v)
    return (v == true) or (v == 1) or (v == "1")
end

local function ApplyDefaultsAndNormalize(db, defaults)
    db = db or {}
    for k, v in pairs(defaults) do
        local cur = db[k]
        if cur == nil then
            db[k] = v
        else
            if type(v) == "boolean" then
                db[k] = tobool(cur)
            elseif type(v) == "number" then
                local n = tonumber(cur)
                db[k] = n or v
            else
                db[k] = cur
            end
        end
    end
    return db
end

-- Init SV
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
    if name ~= ADDON_NAME then return end
    WORS_U_MicroMenuAutoClose = ApplyDefaultsAndNormalize(WORS_U_MicroMenuAutoClose, DEFAULTS)
end)

-- =========================
-- Scale Application
-- =========================
local function ApplyMicroMenuScale()
    if not WORS_U_MicroMenuAutoClose then return end
    local scale = tonumber(WORS_U_MicroMenuAutoClose.Scale) or 1.0
    local frames = {
        Backpack, CombatStylePanel,
        WORS_U_PrayBookFrame, WORS_U_SpellBookFrame,
        WORS_U_EquipmentBookFrame, WORS_U_SkillsBookFrame,
        EmoteBookFrame,
    }
    for _, fref in ipairs(frames) do
        local frame = fref and (fref.frame or fref)
        if frame and frame.SetScale then
            frame:SetScale(scale)
        end
    end
end

-- =========================
-- Options Panel
-- =========================
local panel = CreateFrame("Frame", "WORS_U_MicroMenuOptions", UIParent)
panel.name = "MicroMenu"
InterfaceOptions_AddCategory(panel)

-- Title
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", panel, "TOP", 0, -16)
title:SetText("MicroMenu")

-- -------------------------
-- Auto Close Box (TOP-LEFT)
-- -------------------------
local autoBox = CreateFrame("Frame", nil, panel)
autoBox:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -52)
autoBox:SetSize(290, 340)
autoBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
autoBox:SetBackdropBorderColor(0.5, 0.5, 0.5)
autoBox:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

local sub = autoBox:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
sub:SetPoint("TOPLEFT", autoBox, "TOPLEFT", 10, -10)
sub:SetText("Auto Close")

local note = autoBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
note:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", 0, -6)
note:SetWidth(240)
note:SetJustifyH("LEFT")
note:SetText("Any Menus selected will auto close and open at the same location")

-- Checkbox factory
local function MakeCheckbox(parent, labelText, key, anchor)
    local cb = CreateFrame("CheckButton", "WORS_U_MM_CB_"..key, parent, "InterfaceOptionsCheckButtonTemplate")
    cb.key = key
    if anchor then
        cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)
    else
        cb:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -12)
    end
    _G[cb:GetName().."Text"]:SetText(labelText)

    cb:SetScript("OnClick", function(self)
        local checked = self:GetChecked() and true or false
        WORS_U_MicroMenuAutoClose[self.key] = checked
        PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
        ApplyMicroMenuScale()
    end)
    return cb
end

-- Checkboxes inside Auto Box
local cbBackpack    = MakeCheckbox(autoBox, "Backpack",     "Backpack",    note)
local cbCombatStyle = MakeCheckbox(autoBox, "Combat Style", "CombatStyle", cbBackpack)
local cbPrayer      = MakeCheckbox(autoBox, "Prayer",       "Prayer",      cbCombatStyle)
local cbMagic       = MakeCheckbox(autoBox, "Magic",        "Magic",       cbPrayer)
local cbEquip       = MakeCheckbox(autoBox, "Equipment",    "Equipment",   cbMagic)
local cbSkills      = MakeCheckbox(autoBox, "Skills",       "Skills",      cbEquip)
local cbEmote       = MakeCheckbox(autoBox, "Emotes",       "Emotes",      cbSkills)

-- ---------------------------------------------------------
-- Key Bindings Box (TOP-RIGHT — aligned)
-- ---------------------------------------------------------
local MM_BINDINGS = {
    { id = "TOGGLEBACKPACK",    label = "Backpack"     },
    { id = "TOGGLECOMBATSTYLE", label = "Combat Style" },
    { id = "TOGGLEPRAYER",      label = "Prayer"       },
    { id = "TOGGLEMAGIC",       label = "Magic"        },
    { id = "TOGGLEEQUIPMENT",   label = "Equipment"    },
    { id = "TOGGLESKILLS",      label = "Skills"       },
    { id = "TOGGLEEMOTE",       label = "Emotes"       },
}

local keyBox = CreateFrame("Frame", "WORS_U_MM_KeyBox", panel)
keyBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -52)
keyBox:SetSize(290, 340)
keyBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
keyBox:SetBackdropBorderColor(0.5, 0.5, 0.5)
keyBox:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

local kbHeader = keyBox:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
kbHeader:SetPoint("TOPLEFT", keyBox, "TOPLEFT", 10, -10)
kbHeader:SetText("Key Bindings")

local kbHint = keyBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
kbHint:SetPoint("TOPLEFT", kbHeader, "BOTTOMLEFT", 0, -6)
kbHint:SetWidth(240)  -- match Auto Close note width so both columns start at same Y
kbHint:SetJustifyH("LEFT")
kbHint:SetText("Click a slot, then press a key/mouse/wheel. Esc = clear. Right-click = cancel.")

-- --- helpers
local function PrettyKey(k)
    if not k or k == "" then return nil end
    return GetBindingText(k, "KEY_")
end

local function MakeKeyStringFromKeyboard(key)
    if not key then return nil end
    if key == "ESCAPE" then return "__CLEAR__" end
    if key == "LSHIFT" or key == "RSHIFT" or key == "SHIFT"
       or key == "LCTRL" or key == "RCTRL" or key == "CTRL"
       or key == "LALT" or key == "RALT" or key == "ALT" then
        return nil
    end
    local parts = {}
    if IsShiftKeyDown()   then table.insert(parts, "SHIFT") end
    if IsControlKeyDown() then table.insert(parts, "CTRL")  end
    if IsAltKeyDown()     then table.insert(parts, "ALT")   end
    table.insert(parts, key)
    return table.concat(parts, "-")
end

local function MakeKeyStringFromMouse(button)
    if button == "RightButton" then return "__CANCEL__" end -- reserve right click for cancel
    local b = GetBindingFromClick(button)
    if not b then return nil end
    local parts = {}
    if IsShiftKeyDown()   then table.insert(parts, "SHIFT") end
    if IsControlKeyDown() then table.insert(parts, "CTRL")  end
    if IsAltKeyDown()     then table.insert(parts, "ALT")   end
    table.insert(parts, b)
    return table.concat(parts, "-")
end

-- capture overlay + centered prompt
local kbCapture = CreateFrame("Frame", nil, UIParent)
kbCapture:Hide()
kbCapture:EnableKeyboard(true)
kbCapture:EnableMouse(true)
kbCapture:EnableMouseWheel(true)
kbCapture:SetFrameStrata("FULLSCREEN_DIALOG")
kbCapture:SetAllPoints(UIParent)

kbCapture.bg = kbCapture:CreateTexture(nil, "BACKGROUND")
kbCapture.bg:SetAllPoints()
kbCapture.bg:SetColorTexture(0,0,0,0.35)

local center = CreateFrame("Frame", nil, kbCapture)
center:SetSize(420, 120)
center:SetPoint("CENTER")
center:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
center:SetBackdropBorderColor(0.9, 0.9, 0.9)
center:SetBackdropColor(0.07, 0.07, 0.07, 0.95)

center.header = center:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
center.header:SetPoint("TOP", 0, -14)
center.header:SetText("Set Keybinding")

center.line1 = center:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
center.line1:SetPoint("TOP", center.header, "BOTTOM", 0, -10)
center.line1:SetText("")

center.line2 = center:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
center.line2:SetPoint("TOP", center.line1, "BOTTOM", 0, -8)
center.line2:SetText("Esc = clear this slot Right-click = cancel")

local captureState = { row = nil, which = 1, button = nil }

local KBRows = {}
_G.WORS_U_MM_KeyBoxRows = KBRows

local function SetSlotButtonText(btn, which, keyString)
    local label = (which == 1) and "Primary" or "Secondary"
    local pretty = PrettyKey(keyString)
    btn:SetText(pretty or label) -- only show "Primary/Secondary" if not set
end

local function RefreshRowFromGame(row)
    local k1, k2 = GetBindingKey(row.id)
    row.keys[1], row.keys[2] = k1, k2
    SetSlotButtonText(row.pbtn, 1, k1)
    SetSlotButtonText(row.sbtn, 2, k2)
end

local function RefreshAllRows()
    for _, r in ipairs(KBRows) do
        RefreshRowFromGame(r)
    end
end

local function EndCapture()
    kbCapture:Hide()
    kbCapture:SetScript("OnKeyDown", nil)
    kbCapture:SetScript("OnMouseDown", nil)
    kbCapture:SetScript("OnMouseWheel", nil)
    captureState.row, captureState.which, captureState.button = nil, 1, nil
end

local function ReapplyRowBindings(row)
    local i = 1
    while true do
        local k = select(i, GetBindingKey(row.id))
        if not k then break end
        SetBinding(k)
        i = i + 1
    end
    for idx = 1, 2 do
        local k = row.keys[idx]
        if k and k ~= "" then
            SetBinding(k, row.id)
        end
    end
    SaveBindings(GetCurrentBindingSet())
    RefreshAllRows()
end

local function StartCapture(row, which, btn)
    captureState.row, captureState.which, captureState.button = row, which, btn
    local whichLabel = (which == 1) and "Primary" or "Secondary"
    center.line1:SetText(string.format("%s", row.label:GetText()))
    kbCapture:Show()
    btn:SetText(whichLabel..": …")

    kbCapture:SetScript("OnKeyDown", function(_, key)
        local chord = MakeKeyStringFromKeyboard(key)
        if chord == "__CLEAR__" then
            row.keys[which] = nil
            ReapplyRowBindings(row); EndCapture(); return
        elseif chord then
            row.keys[which] = chord
            ReapplyRowBindings(row); EndCapture(); return
        end
    end)

    kbCapture:SetScript("OnMouseDown", function(_, mouseButton)
        local chord = MakeKeyStringFromMouse(mouseButton)
        if chord == "__CANCEL__" then
            RefreshAllRows(); EndCapture(); return
        end
        if chord then
            row.keys[which] = chord
            ReapplyRowBindings(row); EndCapture(); return
        end
    end)

    kbCapture:SetScript("OnMouseWheel", function(_, delta)
        local wheel = (delta > 0) and "MOUSEWHEELUP" or "MOUSEWHEELDOWN"
        local chord = MakeKeyStringFromKeyboard(wheel) or wheel
        row.keys[which] = chord
        ReapplyRowBindings(row); EndCapture()
    end)
end

-- Build rows
local function MakeBindingRow(parent, anchor, data)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(260, 24)
    if anchor then
        row:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)
    else
        row:SetPoint("TOPLEFT", kbHint, "BOTTOMLEFT", 0, -20) -- match checkbox spacing for perfect alignment
    end
    row.id = data.id
    row.keys = {}

    local label = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", row, "LEFT", 0, 0)
    label:SetWidth(90)
    label:SetJustifyH("LEFT")
    label:SetText(data.label or data.id)
    row.label = label

    local pbtn = CreateFrame("Button", nil, row, "OldSchoolButtonTemplate")
    pbtn:SetSize(80, 20)
    pbtn:SetPoint("LEFT", label, "RIGHT", 4, 0)
    pbtn:SetText("Primary")

    local sbtn = CreateFrame("Button", nil, row, "OldSchoolButtonTemplate")
    sbtn:SetSize(80, 20)
    sbtn:SetPoint("LEFT", pbtn, "RIGHT", 4, 0)
    sbtn:SetText("Secondary")

    pbtn:SetScript("OnClick", function(self) StartCapture(row, 1, self) end)
    sbtn:SetScript("OnClick", function(self) StartCapture(row, 2, self) end)

    row.pbtn = pbtn
    row.sbtn = sbtn

    RefreshRowFromGame(row)
    table.insert(KBRows, row)
    return row
end

local lastRow
for _, data in ipairs(MM_BINDINGS) do
    lastRow = MakeBindingRow(keyBox, lastRow, data)
end

-- -------------------------
-- Scale Box (UNDER Auto Close — moved down)
-- -------------------------
local scaleBox = CreateFrame("Frame", nil, panel)
scaleBox:SetPoint("TOPLEFT", autoBox, "BOTTOMLEFT", 0, -16)
scaleBox:SetSize(290, 100)
scaleBox:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
scaleBox:SetBackdropBorderColor(0.5, 0.5, 0.5)
scaleBox:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

local scaleHeader = scaleBox:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
scaleHeader:SetPoint("TOPLEFT", scaleBox, "TOPLEFT", 10, -10)
scaleHeader:SetText("Scale")

local scaleSlider = CreateFrame("Slider", "WORS_U_MM_ScaleSlider", scaleBox, "OptionsSliderTemplate")
scaleSlider:SetPoint("TOPLEFT", scaleHeader, "BOTTOMLEFT", 0, -20)
scaleSlider:SetMinMaxValues(0.5, 2.0)
scaleSlider:SetValueStep(0.05)
_G[scaleSlider:GetName().."Low"]:SetText("0.5")
_G[scaleSlider:GetName().."High"]:SetText("2.0")
_G[scaleSlider:GetName().."Text"]:SetText("Frame Scale")

scaleSlider:SetScript("OnValueChanged", function(self, value)
    if value < 0.5 then value = 0.5 elseif value > 2.0 then value = 2.0 end
    WORS_U_MicroMenuAutoClose.Scale = tonumber(string.format("%.2f", value)) or 1.0
    ApplyMicroMenuScale()
end)

local scaleReset = CreateFrame("Button", "WORS_U_MM_ScaleReset", scaleBox, "OldSchoolButtonTemplate")
scaleReset:SetSize(100, 22)
scaleReset:SetPoint("LEFT", scaleSlider, "RIGHT", 10, 0)
scaleReset:SetText("Reset Scale")
scaleReset:SetScript("OnClick", function()
    local val = DEFAULTS.Scale or 1.0
    WORS_U_MicroMenuAutoClose.Scale = val
    WORS_U_MM_ScaleSlider:SetValue(val)
    ApplyMicroMenuScale()
    PlaySound("igMainMenuOptionCheckBoxOn")
end)

-- =========================
-- Sync UI
-- =========================
local function Refresh()
    if not WORS_U_MicroMenuAutoClose then return end
    cbBackpack:SetChecked(    tobool(WORS_U_MicroMenuAutoClose.Backpack)    )
    cbCombatStyle:SetChecked( tobool(WORS_U_MicroMenuAutoClose.CombatStyle) )
    cbPrayer:SetChecked(      tobool(WORS_U_MicroMenuAutoClose.Prayer)      )
    cbMagic:SetChecked(       tobool(WORS_U_MicroMenuAutoClose.Magic)       )
    cbEquip:SetChecked(       tobool(WORS_U_MicroMenuAutoClose.Equipment)   )
    cbSkills:SetChecked(      tobool(WORS_U_MicroMenuAutoClose.Skills)      )
    cbEmote:SetChecked(       tobool(WORS_U_MicroMenuAutoClose.Emotes)      )
    scaleSlider:SetValue(     tonumber(WORS_U_MicroMenuAutoClose.Scale) or 1.0 )

    if _G.WORS_U_MM_KeyBoxRows then
        for _, r in ipairs(_G.WORS_U_MM_KeyBoxRows) do
            if r.id then
                local k1, k2 = GetBindingKey(r.id)
                r.keys[1], r.keys[2] = k1, k2
                SetSlotButtonText(r.pbtn, 1, k1)
                SetSlotButtonText(r.sbtn, 2, k2)
            end
        end
    end
end

panel.okay    = function() end
panel.cancel  = Refresh
panel.default = function()
    for k, v in pairs(DEFAULTS) do
        WORS_U_MicroMenuAutoClose[k] = v
    end
    Refresh()
    ApplyMicroMenuScale()
end
panel.refresh = Refresh
panel:HookScript("OnShow", Refresh)

-- Slash
SLASH_WORSUMM1 = "/micromenu"
SlashCmdList.WORSUMM = function()
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel)
end

-- =====================================
-- Position Save/Restore
-- =====================================
function ApplyMicroMenuSavedPosition()
    local pos = WORS_U_MicroMenuAutoClose and WORS_U_MicroMenuAutoClose.AutoClosePOS
    if not pos then return end
    for key, enabled in pairs(WORS_U_MicroMenuAutoClose) do
        if enabled == true then
            local frame = nil
            if key == "Backpack"    then frame = Backpack end
            if key == "CombatStyle" then frame = CombatStylePanel end
            if key == "Prayer"      then frame = WORS_U_PrayBookFrame end
            if key == "Magic"       then frame = WORS_U_SpellBookFrame end
            if key == "Equipment"   then frame = WORS_U_EquipmentBookFrame end
            if key == "Skills"      then frame = WORS_U_SkillsBookFrame end
            if key == "Emotes"      then frame = EmoteBookFrame end

            frame = frame and (frame.frame or frame)
            if frame then
                local reference = (_G[pos.relativeTo] or UIParent)
                frame:ClearAllPoints()
                frame:SetPoint(pos.point, reference, pos.relativePoint, pos.xOfs, pos.yOfs)
                frame:SetUserPlaced(false)
            end
        end
    end
end

function SaveMicroMenuFramePosition(self)
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    local relName = (relativeTo and relativeTo:GetName()) or "UIParent"
    WORS_U_MicroMenuAutoClose.AutoClosePOS = {
        point = point,
        relativeTo = relName,
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs
    }
    ApplyMicroMenuSavedPosition()
end

-- Apply on login
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function()
    ApplyMicroMenuSavedPosition()
    ApplyMicroMenuScale()
end)

-- ================
-- HOOK: Backpack
-- ================
if Backpack then
    Backpack:HookScript("OnDragStop", function(self)
        if WORS_U_MicroMenuAutoClose.Backpack then
            SaveMicroMenuFramePosition(self)
        else
            self:SetUserPlaced(true)
        end
    end)

    hooksecurefunc(Backpack, "Show", function()
        if WORS_U_MicroMenuAutoClose.Backpack then
            if WORS_U_MicroMenuAutoClose.CombatStyle and CombatStylePanel and CombatStylePanel:IsShown() then CombatStylePanel:Hide() end
            if WORS_U_MicroMenuAutoClose.Magic and WORS_U_SpellBookFrame and WORS_U_SpellBookFrame:IsShown() then WORS_U_SpellBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Equipment and WORS_U_EquipmentBookFrame and WORS_U_EquipmentBookFrame:IsShown() then WORS_U_EquipmentBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Prayer and WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown() then WORS_U_PrayBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Skills and WORS_U_SkillsBookFrame and WORS_U_SkillsBookFrame:IsShown() then WORS_U_SkillsBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Emotes and EmoteBookFrame and EmoteBookFrame:IsShown() then EmoteBookFrame:Hide() end
        end
    end)
end

-- ================
-- HOOK: CombatStylePanel
-- ================
if CombatStylePanel then
    CombatStylePanel:HookScript("OnDragStop", function(self)
        if WORS_U_MicroMenuAutoClose.CombatStyle then
            SaveMicroMenuFramePosition(self)
        else
            self:SetUserPlaced(true)
        end
    end)

    hooksecurefunc(CombatStylePanel, "Show", function()
        if WORS_U_MicroMenuAutoClose.CombatStyle then
            if WORS_U_MicroMenuAutoClose.Backpack and Backpack and Backpack:IsShown() then Backpack:Hide() end
            if WORS_U_MicroMenuAutoClose.Magic and WORS_U_SpellBookFrame and WORS_U_SpellBookFrame:IsShown() then WORS_U_SpellBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Equipment and WORS_U_EquipmentBookFrame and WORS_U_EquipmentBookFrame:IsShown() then WORS_U_EquipmentBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Prayer and WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown() then WORS_U_PrayBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Skills and WORS_U_SkillsBookFrame and WORS_U_SkillsBookFrame:IsShown() then WORS_U_SkillsBookFrame:Hide() end
            if WORS_U_MicroMenuAutoClose.Emotes and EmoteBookFrame and EmoteBookFrame:IsShown() then EmoteBookFrame:Hide() end
        end
    end)
end
