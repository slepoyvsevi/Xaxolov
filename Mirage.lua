--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║              ECLIPSE — All-in-One v5                          ║
    ║   Оригинальный Ragebot • Улучшенные визуалы • Wallbang кнопка ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"
))()
local CheatName = "Eclipse"
Library.Folders = {
    Directory = CheatName,
    Configs   = CheatName .. "/Configs",
    Assets    = CheatName .. "/Assets",
}
local Accent   = Color3.fromRGB(240, 50, 50)
local Gradient = Color3.fromRGB(120, 10, 10)
Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent",         Accent)
Library:ChangeTheme("AccentGradient", Gradient)

local Services = {
    Players           = game:GetService("Players"),
    RunService        = game:GetService("RunService"),
    Workspace         = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    UserInputService  = game:GetService("UserInputService"),
    TweenService      = game:GetService("TweenService"),
    Lighting          = game:GetService("Lighting"),
    Debris            = game:GetService("Debris"),
    SoundService      = game:GetService("SoundService"),
    HttpService       = game:GetService("HttpService"),
}
local LocalPlayer = Services.Players.LocalPlayer

-- ══════════════════════════════════════════════════════════
--  [ ESP MODULE ]
-- ══════════════════════════════════════════════════════════
local ESPModule = {}
ESPModule.__index = ESPModule

local hasDrawing = Drawing and Drawing.new
local FONT = 2
pcall(function() FONT = Drawing.Fonts.Plex end)

local MAX_BT = 8
local BT_INTERVAL = 0.05

local BONES_R15 = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local BONES_R6 = {
    {"Head","Torso"},
    {"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}

local V2new = Vector2.new
local V3new = Vector3.new
local C3new = Color3.new
local C3rgb = Color3.fromRGB
local mathFloor = math.floor
local mathAbs = math.abs
local mathClamp = math.clamp
local mathMin = math.min
local mathMax = math.max
local tick = tick

-- ════════════════════════════════════════
--  Drawing Helpers
-- ════════════════════════════════════════
local function newLine()
    if not hasDrawing then return nil end
    local l = Drawing.new("Line")
    l.Visible = false; l.Thickness = 1; l.Color = C3new(1,1,1)
    return l
end

local function newSquare(filled)
    if not hasDrawing then return nil end
    local s = Drawing.new("Square")
    s.Visible = false; s.Thickness = 1; s.Filled = filled or false
    s.Color = C3new(1,1,1)
    return s
end

local function newText()
    if not hasDrawing then return nil end
    local t = Drawing.new("Text")
    t.Visible = false; t.Color = C3new(1,1,1); t.Size = 13
    t.Center = true; t.Outline = true; t.OutlineColor = C3new(0,0,0)
    t.Font = FONT
    return t
end

local function rem(obj)
    if obj then pcall(function() obj:Remove() end) end
end

-- ════════════════════════════════════════
--  Constructor
-- ════════════════════════════════════════
function ESPModule.new(config)
    local self = setmetatable({}, ESPModule)

    self.player = config.Player
    self.Players = config.Services.Players
    self.RunService = config.Services.RunService
    self.Workspace = config.Services.Workspace or game:GetService("Workspace")

    self.ESP_ENABLED = false
    self.SELF_ESP = false
    self.TEAM_CHECK = true
    self.TEAM_HIDE = false

    self.BOX_ENABLED = false
    self.BOX_TYPE = "Corner"
    self.BOX_COLOR = C3rgb(255, 60, 60)
    self.BOX_FILL_ENABLED = false
    self.BOX_FILL_COLOR = C3rgb(180, 20, 20)
    self.BOX_FILL_TRANSPARENCY = 0.82

    self.HEALTH_ENABLED = true
    self.HEALTH_GRADIENT = true
    self.HEALTH_LOW_COLOR = C3rgb(255, 40, 40)
    self.HEALTH_HIGH_COLOR = C3rgb(60, 255, 80)

    self.NAME_ENABLED = true
    self.NAME_COLOR = C3new(1,1,1)
    self.DISTANCE_ENABLED = true
    self.DISTANCE_COLOR = C3rgb(190, 190, 190)
    self.WEAPON_ENABLED = true
    self.WEAPON_COLOR = C3rgb(210, 210, 210)

    self.TRACERS_ENABLED = false
    self.TRACER_COLOR = C3rgb(255, 60, 60)
    self.TRACER_ORIGIN = "Bottom"
    self.TRACER_THICKNESS = 1

    self.SKELETON_ENABLED = false
    self.SKELETON_COLOR = C3rgb(255, 60, 60)
    self.SKELETON_THICKNESS = 1.5

    self.CHAMS_ENABLED = false
    self.CHAMS_TYPE = "Glow"
    self.CHAMS_OUTLINE_COLOR = C3rgb(255, 55, 55)
    self.CHAMS_FILL_COLOR = C3rgb(180, 20, 20)
    self.CHAMS_FILL_TRANSPARENCY = 0.45
    self.CHAMS_OUTLINE_TRANSPARENCY = 0
    self.CHAMS_DEPTH = "AlwaysOnTop"

    self.BACKTRACK_ENABLED = false
    self.BACKTRACK_COLOR = C3rgb(255, 55, 55)
    self.BACKTRACK_DURATION = 0.5
    self.BACKTRACK_TRANSPARENCY = 0.5

    self._data = {}
    self._connections = {}
    self._playerCache = {}
    self._playerCacheTick = 0
    self._PLAYER_CACHE_RATE = 0.3
    self._MAX_ESP_DIST = 2000
    self._frame = 0

    return self
end

-- ════════════════════════════════════════
--  Setters
-- ════════════════════════════════════════
function ESPModule:SetEnabled(v)            self.ESP_ENABLED = v end
function ESPModule:SetSelfESP(v)            self.SELF_ESP = v end
function ESPModule:SetTeamCheck(v)          self.TEAM_CHECK = v end
function ESPModule:SetTeamHide(v)           self.TEAM_HIDE = v end

function ESPModule:SetBoxEnabled(v)         self.BOX_ENABLED = v end
function ESPModule:SetBoxType(v)            self.BOX_TYPE = v end
function ESPModule:SetBoxColor(v)           self.BOX_COLOR = v end
function ESPModule:SetBoxFillEnabled(v)     self.BOX_FILL_ENABLED = v end
function ESPModule:SetBoxFillColor(v)       self.BOX_FILL_COLOR = v end
function ESPModule:SetBoxFillTransparency(v) self.BOX_FILL_TRANSPARENCY = v end

function ESPModule:SetHealthEnabled(v)      self.HEALTH_ENABLED = v end
function ESPModule:SetHealthGradient(v)     self.HEALTH_GRADIENT = v end
function ESPModule:SetHealthLowColor(v)     self.HEALTH_LOW_COLOR = v end
function ESPModule:SetHealthHighColor(v)    self.HEALTH_HIGH_COLOR = v end

function ESPModule:SetNameEnabled(v)        self.NAME_ENABLED = v end
function ESPModule:SetNameColor(v)          self.NAME_COLOR = v end
function ESPModule:SetDistanceEnabled(v)    self.DISTANCE_ENABLED = v end
function ESPModule:SetDistanceColor(v)      self.DISTANCE_COLOR = v end
function ESPModule:SetWeaponEnabled(v)      self.WEAPON_ENABLED = v end
function ESPModule:SetWeaponColor(v)        self.WEAPON_COLOR = v end

function ESPModule:SetTracersEnabled(v)     self.TRACERS_ENABLED = v end
function ESPModule:SetTracerColor(v)        self.TRACER_COLOR = v end
function ESPModule:SetTracerOrigin(v)       self.TRACER_ORIGIN = v end
function ESPModule:SetTracerThickness(v)    self.TRACER_THICKNESS = v end

function ESPModule:SetSkeletonEnabled(v)    self.SKELETON_ENABLED = v end
function ESPModule:SetSkeletonColor(v)      self.SKELETON_COLOR = v end
function ESPModule:SetSkeletonThickness(v)  self.SKELETON_THICKNESS = v end

function ESPModule:SetChamsEnabled(v)       self.CHAMS_ENABLED = v end
function ESPModule:SetChamsType(v)          self.CHAMS_TYPE = v end
function ESPModule:SetChamsOutlineColor(v)  self.CHAMS_OUTLINE_COLOR = v end
function ESPModule:SetChamsFillColor(v)     self.CHAMS_FILL_COLOR = v end
function ESPModule:SetChamsFillTransparency(v) self.CHAMS_FILL_TRANSPARENCY = v end
function ESPModule:SetChamsOutlineTransparency(v) self.CHAMS_OUTLINE_TRANSPARENCY = v end
function ESPModule:SetChamsDepth(v)         self.CHAMS_DEPTH = v end

function ESPModule:SetBacktrackEnabled(v)   self.BACKTRACK_ENABLED = v end
function ESPModule:SetBacktrackColor(v)     self.BACKTRACK_COLOR = v end
function ESPModule:SetBacktrackDuration(v)  self.BACKTRACK_DURATION = v end
function ESPModule:SetBacktrackTransparency(v) self.BACKTRACK_TRANSPARENCY = v end

-- ════════════════════════════════════════
--  Utilities
-- ════════════════════════════════════════
function ESPModule:IsTeammate(plr)
    if not self.player.Team or not plr.Team then return false end
    return self.player.Team == plr.Team
end

function ESPModule:GetHealthColor(ratio)
    -- Beautiful gradient: Red -> Orange -> Yellow -> Green
    if ratio > 0.75 then
        -- 75-100%: Green to Bright Green
        local t = (ratio - 0.75) / 0.25
        return C3new(
            0.2 + (0.3 - 0.2) * t,  -- R: 0.2 -> 0.3
            0.9 + (1.0 - 0.9) * t,  -- G: 0.9 -> 1.0
            0.2 + (0.3 - 0.2) * t   -- B: 0.2 -> 0.3
        )
    elseif ratio > 0.5 then
        -- 50-75%: Yellow to Green
        local t = (ratio - 0.5) / 0.25
        return C3new(
            0.9 + (0.2 - 0.9) * t,  -- R: 0.9 -> 0.2
            0.9 + (0.9 - 0.9) * t,  -- G: 0.9 -> 0.9
            0.0 + (0.2 - 0.0) * t   -- B: 0.0 -> 0.2
        )
    elseif ratio > 0.25 then
        -- 25-50%: Orange to Yellow
        local t = (ratio - 0.25) / 0.25
        return C3new(
            1.0 + (0.9 - 1.0) * t,  -- R: 1.0 -> 0.9
            0.5 + (0.9 - 0.5) * t,  -- G: 0.5 -> 0.9
            0.0 + (0.0 - 0.0) * t   -- B: 0.0 -> 0.0
        )
    else
        -- 0-25%: Dark Red to Orange
        local t = ratio / 0.25
        return C3new(
            0.8 + (1.0 - 0.8) * t,  -- R: 0.8 -> 1.0
            0.0 + (0.5 - 0.0) * t,  -- G: 0.0 -> 0.5
            0.0 + (0.0 - 0.0) * t   -- B: 0.0 -> 0.0
        )
    end
end

function ESPModule:GetBoundingBox(root, cam)
    local pos = root.Position
    local top = pos + V3new(0, 3, 0)
    local btm = pos + V3new(0, -3, 0)

    local ts, tv = cam:WorldToViewportPoint(top)
    local bs, bv = cam:WorldToViewportPoint(btm)
    if ts.Z < 0 and bs.Z < 0 then return nil end
    if not tv and not bv then return nil end

    local h = mathAbs(bs.Y - ts.Y)
    local w = h * 0.55
    local cx = (ts.X + bs.X) * 0.5

    return {
        x = cx - w * 0.5,
        y = mathMin(ts.Y, bs.Y),
        w = w,
        h = h,
        cx = cx,
        cy = (ts.Y + bs.Y) * 0.5,
    }
end

-- ════════════════════════════════════════
--  Per-Player Data
-- ════════════════════════════════════════
function ESPModule:CreateData()
    local d = {
        fullBox = newSquare(false),
        boxFill = newSquare(true),
        corners = {},
        healthBg = newSquare(true),
        healthFill = newSquare(true),
        nameText = newText(),
        distText = newText(),
        weaponText = newText(),
        tracer = newLine(),
        bones = {},
        highlight = nil,
        btGhost = nil,
        btHighlight = nil,
        btGhostTime = 0,
        btHistory = {},
        btHead = 1,
        btTail = 0,
        btLastRecord = 0,
        cachedWeapon = nil,
        cachedWeaponTick = 0,
        lastChamsType = nil,
        lastChamsDepth = nil,
        lastChamsOC = nil,
        lastChamsFC = nil,
        lastChamsFT = nil,
        lastChamsOT = nil,
    }

    for i = 1, 8 do d.corners[i] = newLine() end
    for i = 1, 14 do d.bones[i] = newLine() end

    return d
end

function ESPModule:DestroyData(plr)
    local d = self._data[plr]
    if not d then return end

    rem(d.fullBox); rem(d.boxFill)
    for _, l in ipairs(d.corners) do rem(l) end
    rem(d.healthBg); rem(d.healthFill)
    rem(d.nameText); rem(d.distText); rem(d.weaponText)
    rem(d.tracer)
    for _, l in ipairs(d.bones) do rem(l) end
    if d.btGhost then pcall(function() d.btGhost:Destroy() end) end
    if d.btHighlight then pcall(function() d.btHighlight:Destroy() end) end
    if d.highlight then pcall(function() d.highlight:Destroy() end) end

    self._data[plr] = nil
end

function ESPModule:HideAll(d)
    if not hasDrawing then return end
    if d.fullBox then d.fullBox.Visible = false end
    if d.boxFill then d.boxFill.Visible = false end
    for i = 1, 8 do local l = d.corners[i]; if l then l.Visible = false end end
    if d.healthBg then d.healthBg.Visible = false end
    if d.healthFill then d.healthFill.Visible = false end
    if d.nameText then d.nameText.Visible = false end
    if d.distText then d.distText.Visible = false end
    if d.weaponText then d.weaponText.Visible = false end
    if d.tracer then d.tracer.Visible = false end
    for i = 1, #d.bones do local l = d.bones[i]; if l then l.Visible = false end end
    if d.btGhost then d.btGhost.Parent = nil end
    if d.btHighlight then d.btHighlight.Enabled = false end
    if d.highlight then d.highlight.Enabled = false end
end

-- ════════════════════════════════════════
--  Component Updaters
-- ════════════════════════════════════════
function ESPModule:UpdateBox(d, bb)
    if not self.BOX_ENABLED then
        if d.fullBox then d.fullBox.Visible = false end
        if d.boxFill then d.boxFill.Visible = false end
        for i = 1, 8 do local l = d.corners[i]; if l then l.Visible = false end end
        return
    end

    local x, y, w, h = bb.x, bb.y, bb.w, bb.h
    local col = self.BOX_COLOR

    if self.BOX_TYPE == "Full" then
        for i = 1, 8 do local l = d.corners[i]; if l then l.Visible = false end end
        if d.fullBox then
            d.fullBox.Position = V2new(x, y)
            d.fullBox.Size = V2new(w, h)
            d.fullBox.Color = col
            d.fullBox.Thickness = 1
            d.fullBox.Visible = true
        end
    else
        if d.fullBox then d.fullBox.Visible = false end
        local cl = mathMax(w * 0.28, 7)
        local xw, yh = x + w, y + h
        local c = d.corners
        if c[1] then c[1].From = V2new(x, y);   c[1].To = V2new(x + cl, y);   c[1].Color = col; c[1].Thickness = 2; c[1].Visible = true end
        if c[2] then c[2].From = V2new(x, y);   c[2].To = V2new(x, y + cl);   c[2].Color = col; c[2].Thickness = 2; c[2].Visible = true end
        if c[3] then c[3].From = V2new(xw, y);  c[3].To = V2new(xw - cl, y);  c[3].Color = col; c[3].Thickness = 2; c[3].Visible = true end
        if c[4] then c[4].From = V2new(xw, y);  c[4].To = V2new(xw, y + cl);  c[4].Color = col; c[4].Thickness = 2; c[4].Visible = true end
        if c[5] then c[5].From = V2new(x, yh);  c[5].To = V2new(x + cl, yh);  c[5].Color = col; c[5].Thickness = 2; c[5].Visible = true end
        if c[6] then c[6].From = V2new(x, yh);  c[6].To = V2new(x, yh - cl);  c[6].Color = col; c[6].Thickness = 2; c[6].Visible = true end
        if c[7] then c[7].From = V2new(xw, yh); c[7].To = V2new(xw - cl, yh); c[7].Color = col; c[7].Thickness = 2; c[7].Visible = true end
        if c[8] then c[8].From = V2new(xw, yh); c[8].To = V2new(xw, yh - cl); c[8].Color = col; c[8].Thickness = 2; c[8].Visible = true end
    end

    if d.boxFill then
        if self.BOX_FILL_ENABLED then
            d.boxFill.Position = V2new(x, y)
            d.boxFill.Size = V2new(w, h)
            d.boxFill.Color = self.BOX_FILL_COLOR
            d.boxFill.Transparency = self.BOX_FILL_TRANSPARENCY
            d.boxFill.Visible = true
        else
            d.boxFill.Visible = false
        end
    end
end

function ESPModule:UpdateHealth(d, bb, hum)
    if not self.HEALTH_ENABLED or not hum then
        if d.healthBg then d.healthBg.Visible = false end
        if d.healthFill then d.healthFill.Visible = false end
        return
    end

    local hp = hum.Health
    local maxHp = hum.MaxHealth
    if maxHp <= 0 then maxHp = 100 end
    local ratio = mathClamp(hp / maxHp, 0, 1)
    local barW = 4
    local x = bb.x - barW - 4
    local y = bb.y
    local h = bb.h

    if d.healthBg then
        d.healthBg.Position = V2new(x - 1, y - 1)
        d.healthBg.Size = V2new(barW + 2, h + 2)
        d.healthBg.Color = C3rgb(0, 0, 0)
        d.healthBg.Filled = true
        d.healthBg.Visible = true
    end

    if d.healthFill then
        local fh = mathMax(h * ratio, 1)
        d.healthFill.Position = V2new(x, y + h - fh)
        d.healthFill.Size = V2new(barW, fh)
        d.healthFill.Filled = true
        if self.HEALTH_GRADIENT then
            d.healthFill.Color = self:GetHealthColor(ratio)
        else
            d.healthFill.Color = self.HEALTH_HIGH_COLOR
        end
        d.healthFill.Visible = true
    end
end

function ESPModule:UpdateInfo(d, bb, targetPlayer, distance, char)
    local yAbove = bb.y - 3
    local yBelow = bb.y + bb.h + 3

    if self.NAME_ENABLED and d.nameText then
        d.nameText.Text = targetPlayer.DisplayName
        d.nameText.Color = self.NAME_COLOR
        d.nameText.Size = 14
        d.nameText.Outline = true
        d.nameText.OutlineColor = C3new(0,0,0)
        yAbove = yAbove - 15
        d.nameText.Position = V2new(bb.cx, yAbove)
        d.nameText.Visible = true
    elseif d.nameText then
        d.nameText.Visible = false
    end

    if self.DISTANCE_ENABLED and d.distText then
        d.distText.Text = string.format("[%dm]", mathFloor(distance))
        d.distText.Color = self.DISTANCE_COLOR
        d.distText.Size = 12
        d.distText.Outline = true
        d.distText.OutlineColor = C3new(0,0,0)
        d.distText.Position = V2new(bb.cx, yBelow)
        d.distText.Visible = true
        yBelow = yBelow + 14
    elseif d.distText then
        d.distText.Visible = false
    end

    if self.WEAPON_ENABLED and d.weaponText then
        local now = tick()
        local wep = d.cachedWeapon
        if now - d.cachedWeaponTick > 0.5 then
            d.cachedWeaponTick = now
            wep = nil
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then wep = tool.Name end
            d.cachedWeapon = wep
        end
        if wep then
            d.weaponText.Text = "⚔ " .. wep
            d.weaponText.Color = self.WEAPON_COLOR
            d.weaponText.Size = 12
            d.weaponText.Outline = true
            d.weaponText.OutlineColor = C3new(0,0,0)
            d.weaponText.Position = V2new(bb.cx, yBelow)
            d.weaponText.Visible = true
        else
            d.weaponText.Visible = false
        end
    elseif d.weaponText then
        d.weaponText.Visible = false
    end
end

function ESPModule:UpdateTracer(d, bb, vpSize)
    if not d.tracer then return end
    if not self.TRACERS_ENABLED then d.tracer.Visible = false; return end

    local fromX, fromY
    if self.TRACER_ORIGIN == "Top" then
        fromX, fromY = vpSize.X * 0.5, 0
    elseif self.TRACER_ORIGIN == "Center" then
        fromX, fromY = vpSize.X * 0.5, vpSize.Y * 0.5
    else
        fromX, fromY = vpSize.X * 0.5, vpSize.Y
    end

    d.tracer.From = V2new(fromX, fromY)
    d.tracer.To = V2new(bb.cx, bb.y + bb.h)
    d.tracer.Color = self.TRACER_COLOR
    d.tracer.Thickness = self.TRACER_THICKNESS
    d.tracer.Visible = true
end

function ESPModule:UpdateSkeleton(d, char, cam)
    if not self.SKELETON_ENABLED then
        for i = 1, #d.bones do local l = d.bones[i]; if l then l.Visible = false end end
        return
    end

    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
    local boneList = isR15 and BONES_R15 or BONES_R6
    local idx = 0
    local skelColor = self.SKELETON_COLOR
    local skelThick = self.SKELETON_THICKNESS

    for bi = 1, #boneList do
        idx = idx + 1
        local l = d.bones[idx]
        if not l then break end

        local pair = boneList[bi]
        local p1 = char:FindFirstChild(pair[1])
        local p2 = char:FindFirstChild(pair[2])

        if p1 and p2 then
            local v1 = cam:WorldToViewportPoint(p1.Position)
            local v2 = cam:WorldToViewportPoint(p2.Position)
            if v1.Z > 0 or v2.Z > 0 then
                l.From = V2new(v1.X, v1.Y)
                l.To = V2new(v2.X, v2.Y)
                l.Color = skelColor
                l.Thickness = skelThick
                l.Visible = true
            else
                l.Visible = false
            end
        else
            l.Visible = false
        end
    end

    for i = idx + 1, #d.bones do
        if d.bones[i] then d.bones[i].Visible = false end
    end
end

function ESPModule:UpdateChams(d, char)
    if not self.CHAMS_ENABLED then
        if d.highlight then d.highlight.Enabled = false end
        d.lastChamsType = nil
        return
    end

    if not d.highlight then
        local ok, hl = pcall(function()
            local h = Instance.new("Highlight")
            h.Name = "ArcanumChams"
            return h
        end)
        if ok and hl then d.highlight = hl else return end
    end

    local hl = d.highlight
    if hl.Adornee ~= char then
        hl.Adornee = char
        hl.Parent  = char
    end

    local t     = self.CHAMS_TYPE
    local depth = self.CHAMS_DEPTH
    local oc    = self.CHAMS_OUTLINE_COLOR
    local fc    = self.CHAMS_FILL_COLOR
    local ft    = self.CHAMS_FILL_TRANSPARENCY
    local ot    = self.CHAMS_OUTLINE_TRANSPARENCY

    -- Pulse is animated every frame — always recompute
    if t == "Pulse" then
        local pulse = mathAbs(math.sin(tick() * 3))
        hl.FillTransparency    = mathClamp(ft + pulse * (1 - ft) * 0.8, 0, 1)
        hl.OutlineTransparency = mathClamp(ot + pulse * 0.5, 0, 1)
        hl.FillColor    = fc
        hl.OutlineColor = oc
        hl.DepthMode    = depth == "AlwaysOnTop"
            and Enum.HighlightDepthMode.AlwaysOnTop
            or  Enum.HighlightDepthMode.Occluded
        hl.Enabled = true
        return
    end

    -- For static modes only re-apply when something changed
    local needsApply = (t ~= d.lastChamsType)
        or (depth ~= d.lastChamsDepth)
        or (oc ~= d.lastChamsOC)
        or (fc ~= d.lastChamsFC)
        or (ft ~= d.lastChamsFT)
        or (ot ~= d.lastChamsOT)

    if needsApply then
        d.lastChamsType  = t
        d.lastChamsDepth = depth
        d.lastChamsOC    = oc
        d.lastChamsFC    = fc
        d.lastChamsFT    = ft
        d.lastChamsOT    = ot

        if t == "Outline" then
            hl.FillTransparency    = 1
            hl.OutlineTransparency = ot
            hl.OutlineColor        = oc
        elseif t == "Solid" then
            hl.FillTransparency    = ft
            hl.FillColor           = fc
            hl.OutlineTransparency = 1
        elseif t == "Outline+Solid" then
            hl.FillTransparency    = ft
            hl.FillColor           = fc
            hl.OutlineTransparency = ot
            hl.OutlineColor        = oc
        elseif t == "Glow" then
            hl.FillTransparency    = mathClamp(ft, 0.1, 0.5)
            hl.FillColor           = fc
            hl.OutlineTransparency = 0
            hl.OutlineColor        = oc
        elseif t == "Neon" then
            hl.FillTransparency    = 0.65
            hl.FillColor           = fc
            hl.OutlineTransparency = 0
            hl.OutlineColor        = oc
        elseif t == "Ghost" then
            hl.FillTransparency    = 0.82
            hl.FillColor           = fc
            hl.OutlineTransparency = 0.4
            hl.OutlineColor        = oc
        elseif t == "Wireframe" then
            hl.FillTransparency    = 1
            hl.OutlineTransparency = ot
            hl.OutlineColor        = oc
            hl.DepthMode           = Enum.HighlightDepthMode.Occluded
        end

        if t ~= "Wireframe" then
            hl.DepthMode = depth == "AlwaysOnTop"
                and Enum.HighlightDepthMode.AlwaysOnTop
                or  Enum.HighlightDepthMode.Occluded
        end
    end

    hl.Enabled = true
end

function ESPModule:CreateGhost(char)
    local ok, ghost = pcall(function()
        local g = char:Clone()
        for _, v in ipairs(g:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript")
                or v:IsA("Sound") or v:IsA("ParticleEmitter") or v:IsA("BillboardGui")
                or v:IsA("ProximityPrompt") or v:IsA("Decal") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                v.CanCollide = false
                v.Anchored = true
                v.Transparency = 1
            end
        end
        local hum = g:FindFirstChildOfClass("Humanoid")
        if hum then hum:Destroy() end
        local anim = g:FindFirstChildOfClass("Animator")
        if anim then anim:Destroy() end
        g.Name = "ArcanumBT"
        return g
    end)
    return ok and ghost or nil
end

function ESPModule:UpdateBacktrack(d, char, root, targetPlayer)
    if not root or not root.Parent then
        if d.btGhost then d.btGhost.Parent = nil end
        if d.btHighlight then d.btHighlight.Enabled = false end
        return
    end

    local shouldShow = self.BACKTRACK_ENABLED
    if shouldShow and self.TEAM_CHECK and self:IsTeammate(targetPlayer) then
        shouldShow = false
    end

    if not shouldShow then
        if d.btGhost then d.btGhost.Parent = nil end
        if d.btHighlight then d.btHighlight.Enabled = false end
        d.btHistory = {}; d.btHead = 1; d.btTail = 0
        return
    end

    local now = tick()
    if now - d.btLastRecord >= BT_INTERVAL then
        d.btLastRecord = now
        d.btTail = d.btTail + 1
        d.btHistory[d.btTail] = { t = now, cf = root.CFrame }
        while d.btHead <= d.btTail
            and (now - d.btHistory[d.btHead].t) > self.BACKTRACK_DURATION do
            d.btHistory[d.btHead] = nil
            d.btHead = d.btHead + 1
        end
    end

    local count = d.btTail - d.btHead + 1
    if count < 2 then
        if d.btGhost then d.btGhost.Parent = nil end
        if d.btHighlight then d.btHighlight.Enabled = false end
        return
    end

    -- Пересоздаём ghost при необходимости
    if not d.btGhost or not d.btGhost.Parent or (now - d.btGhostTime > 2.0) then
        if d.btGhost then pcall(function() d.btGhost:Destroy() end) end
        if d.btHighlight then pcall(function() d.btHighlight:Destroy() end); d.btHighlight = nil end
        d.btGhost = self:CreateGhost(char)
        d.btGhostTime = now
    end

    if not d.btGhost then return end

    -- Берём самую старую позицию
    local oldest = d.btHistory[d.btHead]
    if oldest and oldest.cf then
        d.btGhost.Parent = self.Workspace
        pcall(function() d.btGhost:PivotTo(oldest.cf) end)
    end

    -- Highlight с gradient: чем старее — тем прозрачнее
    if not d.btHighlight then
        local ok, hl = pcall(function()
            local h = Instance.new("Highlight")
            h.Name = "EclipseBTChams"
            return h
        end)
        if ok and hl then d.btHighlight = hl end
    end

    if d.btHighlight then
        -- Возраст самой старой точки → прозрачность
        local age      = oldest and (now - oldest.t) or 0
        local ageFrac  = mathClamp(age / mathMax(self.BACKTRACK_DURATION, 0.01), 0, 1)
        local fillT    = self.BACKTRACK_TRANSPARENCY + ageFrac * (1 - self.BACKTRACK_TRANSPARENCY) * 0.7
        local outlineT = mathClamp(fillT - 0.15, 0, 1)

        d.btHighlight.FillColor           = self.BACKTRACK_COLOR
        d.btHighlight.FillTransparency    = fillT
        d.btHighlight.OutlineColor        = self.BACKTRACK_COLOR
        d.btHighlight.OutlineTransparency = outlineT
        d.btHighlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
        d.btHighlight.Adornee             = d.btGhost
        d.btHighlight.Parent              = d.btGhost
        d.btHighlight.Enabled             = true
    end
end

-- ════════════════════════════════════════
--  Main Loop
-- ════════════════════════════════════════
function ESPModule:Update()
    local cam = self.Workspace.CurrentCamera
    if not cam then return end

    local myChar = self.player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos  = myRoot and myRoot.Position
    local vpSize = cam.ViewportSize

    self._frame = self._frame + 1
    local now = tick()

    if now - self._playerCacheTick >= self._PLAYER_CACHE_RATE then
        self._playerCacheTick = now
        self._playerCache = self.Players:GetPlayers()
    end

    -- Локальные ссылки — быстрее чем self.X каждый итер
    local wantBox    = self.BOX_ENABLED
    local wantHP     = self.HEALTH_ENABLED
    local wantName   = self.NAME_ENABLED
    local wantDist   = self.DISTANCE_ENABLED
    local wantWep    = self.WEAPON_ENABLED
    local wantTracer = self.TRACERS_ENABLED
    local wantSkel   = self.SKELETON_ENABLED
    local wantChams  = self.CHAMS_ENABLED
    local wantBT     = self.BACKTRACK_ENABLED
    local espOn      = self.ESP_ENABLED
    local selfESP    = self.SELF_ESP
    local teamCheck  = self.TEAM_CHECK
    local teamHide   = self.TEAM_HIDE
    local maxDist    = self._MAX_ESP_DIST

    local anyDrawing = wantBox or wantHP or wantName or wantDist or wantWep or wantTracer or wantSkel

    local players = self._playerCache
    for pi = 1, #players do
        local plr = players[pi]
        local d = self._data[plr]
        if not d then
            d = self:CreateData()
            self._data[plr] = d
        end

        local show = espOn
        if plr == self.player and not selfESP then show = false end
        if show and teamCheck and self:IsTeammate(plr) and teamHide then show = false end

        local char = plr.Character
        local root, hum
        if show and char then
            root = char:FindFirstChild("HumanoidRootPart")
            hum  = char:FindFirstChildOfClass("Humanoid")
        end

        if not show or not char or not root or not hum or hum.Health <= 0 then
            self:HideAll(d)
            if wantBT then self:UpdateBacktrack(d, char, root, plr) end
            continue
        end

        local dist = myPos and (root.Position - myPos).Magnitude or 0
        if dist > maxDist then
            self:HideAll(d)
            continue
        end

        if anyDrawing then
            local bb = self:GetBoundingBox(root, cam)
            if not bb then
                self:HideAll(d)
                if wantBT then self:UpdateBacktrack(d, char, root, plr) end
                continue
            end

            if wantBox  then self:UpdateBox(d, bb)
            else
                if d.fullBox then d.fullBox.Visible = false end
                if d.boxFill then d.boxFill.Visible = false end
                for i = 1, 8 do local l = d.corners[i]; if l then l.Visible = false end end
            end
            if wantHP   then self:UpdateHealth(d, bb, hum)
            else
                if d.healthBg   then d.healthBg.Visible   = false end
                if d.healthFill then d.healthFill.Visible = false end
            end
            if wantName or wantDist or wantWep then
                self:UpdateInfo(d, bb, plr, dist, char)
            else
                if d.nameText   then d.nameText.Visible   = false end
                if d.distText   then d.distText.Visible   = false end
                if d.weaponText then d.weaponText.Visible = false end
            end
            if wantTracer then self:UpdateTracer(d, bb, vpSize)
            elseif d.tracer then d.tracer.Visible = false end
            if wantSkel   then self:UpdateSkeleton(d, char, cam)
            else
                for i = 1, #d.bones do local l = d.bones[i]; if l then l.Visible = false end end
            end
        else
            -- Всё выключено — скрываем быстро
            if d.fullBox    then d.fullBox.Visible    = false end
            if d.boxFill    then d.boxFill.Visible    = false end
            for i = 1, 8 do local l = d.corners[i]; if l then l.Visible = false end end
            if d.healthBg   then d.healthBg.Visible   = false end
            if d.healthFill then d.healthFill.Visible = false end
            if d.nameText   then d.nameText.Visible   = false end
            if d.distText   then d.distText.Visible   = false end
            if d.weaponText then d.weaponText.Visible = false end
            if d.tracer     then d.tracer.Visible     = false end
            for i = 1, #d.bones do local l = d.bones[i]; if l then l.Visible = false end end
        end

        if wantChams then self:UpdateChams(d, char)
        else
            if d.highlight then d.highlight.Enabled = false; d.lastChamsType = nil end
        end
        if wantBT then self:UpdateBacktrack(d, char, root, plr)
        else
            if d.btGhost     then d.btGhost.Parent = nil end
            if d.btHighlight then d.btHighlight.Enabled = false end
        end
    end

    -- Чистим удалённых игроков
    for plr, _ in pairs(self._data) do
        if not plr.Parent then
            self:DestroyData(plr)
        end
    end
end

-- ════════════════════════════════════════
--  Start / Stop / Destroy
-- ════════════════════════════════════════
function ESPModule:Start()
    if self._renderConn then return end
    local _nextUpdate = 0
    local _INTERVAL   = 1 / 30  -- 30 обновлений/сек достаточно для ESP
    self._renderConn = self.RunService.Heartbeat:Connect(function()
        local now = tick()
        if now < _nextUpdate then return end
        _nextUpdate = now + _INTERVAL
        self:Update()
    end)
    self._playerLeftConn = self.Players.PlayerRemoving:Connect(function(plr)
        self:DestroyData(plr)
    end)
end

function ESPModule:Stop()
    if self._renderConn then self._renderConn:Disconnect(); self._renderConn = nil end
    if self._playerLeftConn then self._playerLeftConn:Disconnect(); self._playerLeftConn = nil end
end

function ESPModule:Destroy()
    self:Stop()
    for plr, _ in pairs(self._data) do
        self:DestroyData(plr)
    end
end

-- ════════════════════════════════════════
--  Config
-- ════════════════════════════════════════
local function c3str(c) return {R = c.R, G = c.G, B = c.B} end
local function strc3(t)
    if not t then return nil end
    return C3new(t.R or 1, t.G or 1, t.B or 1)
end

function ESPModule:GetSettings()
    return {
        ESP_ENABLED = self.ESP_ENABLED,
        SELF_ESP = self.SELF_ESP,
        TEAM_CHECK = self.TEAM_CHECK,
        TEAM_HIDE = self.TEAM_HIDE,
        BOX_ENABLED = self.BOX_ENABLED,
        BOX_TYPE = self.BOX_TYPE,
        BOX_COLOR = c3str(self.BOX_COLOR),
        BOX_FILL_ENABLED = self.BOX_FILL_ENABLED,
        BOX_FILL_COLOR = c3str(self.BOX_FILL_COLOR),
        BOX_FILL_TRANSPARENCY = self.BOX_FILL_TRANSPARENCY,
        HEALTH_ENABLED = self.HEALTH_ENABLED,
        HEALTH_GRADIENT = self.HEALTH_GRADIENT,
        HEALTH_LOW_COLOR = c3str(self.HEALTH_LOW_COLOR),
        HEALTH_HIGH_COLOR = c3str(self.HEALTH_HIGH_COLOR),
        NAME_ENABLED = self.NAME_ENABLED,
        NAME_COLOR = c3str(self.NAME_COLOR),
        DISTANCE_ENABLED = self.DISTANCE_ENABLED,
        DISTANCE_COLOR = c3str(self.DISTANCE_COLOR),
        WEAPON_ENABLED = self.WEAPON_ENABLED,
        WEAPON_COLOR = c3str(self.WEAPON_COLOR),
        TRACERS_ENABLED = self.TRACERS_ENABLED,
        TRACER_COLOR = c3str(self.TRACER_COLOR),
        TRACER_ORIGIN = self.TRACER_ORIGIN,
        TRACER_THICKNESS = self.TRACER_THICKNESS,
        SKELETON_ENABLED = self.SKELETON_ENABLED,
        SKELETON_COLOR = c3str(self.SKELETON_COLOR),
        SKELETON_THICKNESS = self.SKELETON_THICKNESS,
        CHAMS_ENABLED = self.CHAMS_ENABLED,
        CHAMS_TYPE = self.CHAMS_TYPE,
        CHAMS_OUTLINE_COLOR = c3str(self.CHAMS_OUTLINE_COLOR),
        CHAMS_FILL_COLOR = c3str(self.CHAMS_FILL_COLOR),
        CHAMS_FILL_TRANSPARENCY = self.CHAMS_FILL_TRANSPARENCY,
        CHAMS_OUTLINE_TRANSPARENCY = self.CHAMS_OUTLINE_TRANSPARENCY,
        CHAMS_DEPTH = self.CHAMS_DEPTH,
        BACKTRACK_ENABLED = self.BACKTRACK_ENABLED,
        BACKTRACK_COLOR = c3str(self.BACKTRACK_COLOR),
        BACKTRACK_DURATION = self.BACKTRACK_DURATION,
        BACKTRACK_TRANSPARENCY = self.BACKTRACK_TRANSPARENCY,
    }
end

function ESPModule:ApplySettings(s)
    if not s then return end
    local function apply(key, setter)
        if s[key] ~= nil then setter(s[key]) end
    end
    local function applyC3(key, setter)
        if s[key] then setter(strc3(s[key])) end
    end

    apply("ESP_ENABLED", function(v) self:SetEnabled(v) end)
    apply("SELF_ESP", function(v) self:SetSelfESP(v) end)
    apply("TEAM_CHECK", function(v) self:SetTeamCheck(v) end)
    apply("TEAM_HIDE", function(v) self:SetTeamHide(v) end)
    apply("BOX_ENABLED", function(v) self:SetBoxEnabled(v) end)
    apply("BOX_TYPE", function(v) self:SetBoxType(v) end)
    applyC3("BOX_COLOR", function(v) self:SetBoxColor(v) end)
    apply("BOX_FILL_ENABLED", function(v) self:SetBoxFillEnabled(v) end)
    applyC3("BOX_FILL_COLOR", function(v) self:SetBoxFillColor(v) end)
    apply("BOX_FILL_TRANSPARENCY", function(v) self:SetBoxFillTransparency(v) end)
    apply("HEALTH_ENABLED", function(v) self:SetHealthEnabled(v) end)
    apply("HEALTH_GRADIENT", function(v) self:SetHealthGradient(v) end)
    applyC3("HEALTH_LOW_COLOR", function(v) self:SetHealthLowColor(v) end)
    applyC3("HEALTH_HIGH_COLOR", function(v) self:SetHealthHighColor(v) end)
    apply("NAME_ENABLED", function(v) self:SetNameEnabled(v) end)
    applyC3("NAME_COLOR", function(v) self:SetNameColor(v) end)
    apply("DISTANCE_ENABLED", function(v) self:SetDistanceEnabled(v) end)
    applyC3("DISTANCE_COLOR", function(v) self:SetDistanceColor(v) end)
    apply("WEAPON_ENABLED", function(v) self:SetWeaponEnabled(v) end)
    applyC3("WEAPON_COLOR", function(v) self:SetWeaponColor(v) end)
    apply("TRACERS_ENABLED", function(v) self:SetTracersEnabled(v) end)
    applyC3("TRACER_COLOR", function(v) self:SetTracerColor(v) end)
    apply("TRACER_ORIGIN", function(v) self:SetTracerOrigin(v) end)
    apply("TRACER_THICKNESS", function(v) self:SetTracerThickness(v) end)
    apply("SKELETON_ENABLED", function(v) self:SetSkeletonEnabled(v) end)
    applyC3("SKELETON_COLOR", function(v) self:SetSkeletonColor(v) end)
    apply("SKELETON_THICKNESS", function(v) self:SetSkeletonThickness(v) end)
    apply("CHAMS_ENABLED", function(v) self:SetChamsEnabled(v) end)
    apply("CHAMS_TYPE", function(v) self:SetChamsType(v) end)
    applyC3("CHAMS_OUTLINE_COLOR", function(v) self:SetChamsOutlineColor(v) end)
    applyC3("CHAMS_FILL_COLOR", function(v) self:SetChamsFillColor(v) end)
    apply("CHAMS_FILL_TRANSPARENCY", function(v) self:SetChamsFillTransparency(v) end)
    apply("CHAMS_OUTLINE_TRANSPARENCY", function(v) self:SetChamsOutlineTransparency(v) end)
    apply("CHAMS_DEPTH", function(v) self:SetChamsDepth(v) end)
    apply("BACKTRACK_ENABLED", function(v) self:SetBacktrackEnabled(v) end)
    applyC3("BACKTRACK_COLOR", function(v) self:SetBacktrackColor(v) end)
    apply("BACKTRACK_DURATION", function(v) self:SetBacktrackDuration(v) end)
    apply("BACKTRACK_TRANSPARENCY", function(v) self:SetBacktrackTransparency(v) end)
end


-- ══════════════════════════════════════════════════════════
--  [ VISUALS MODULE ]
-- ══════════════════════════════════════════════════════════
local VisualsModule = {}
VisualsModule.__index = VisualsModule

function VisualsModule.new(config)
	local self = setmetatable({}, VisualsModule)

	self.player = config.Player
	self.guiParent = config.GuiParent
	self.Services = config.Services or {}

	self.Players = self.Services.Players
	self.TweenService = self.Services.TweenService
	self.RunService = self.Services.RunService
	self.UserInputService = self.Services.UserInputService
	self.ReplicatedStorage = self.Services.ReplicatedStorage
	self.Workspace = self.Services.Workspace
	self.Lighting = self.Services.Lighting
	self.Debris = self.Services.Debris
	self.SoundService = self.Services.SoundService
	self.HttpService = self.Services.HttpService

	self.Notification = config.Notification
	self.IsFakeLagEnabled = config.IsFakeLagEnabled

	self.HITLOG_ENABLED   = true
	self.HITSOUND_ENABLED = true
	self.HITSOUND_VOLUME  = 0.75
	self.HITSOUND_PRESET  = "bell"

self.GHOST_BASE_TRANSPARENCY = 0.7
self.GHOST_FADE_RADIUS = 1.6
self.GHOST_FADE_POWER = 1.2

	self.TRACER_ENABLED  = true
	self.TRACER_COLOR    = Color3.fromRGB(255, 65, 65)
	self.TRACER_LIFETIME = 0.45
	self.TRACER_WIDTH    = 0.12
	self.TRACER_NEON     = true
	self.TRACER_STYLE    = "Classic"

	self.TRACER_BRIGHTNESS = 20
	self.TRACER_LIGHTEMISSION = 1
	self.TRACER_LIGHTINFLUENCE = 0.95
	self.TRACER_TAIL = 2
	self.TRACER_TRANSPARENCY = NumberSequence.new({
		NumberSequenceKeypoint.new(0.00, 1.00),
		NumberSequenceKeypoint.new(0.125, 0.05),
		NumberSequenceKeypoint.new(0.89, 0.0562),
		NumberSequenceKeypoint.new(1.00, 1.00),
	})

	self.WALLBANG_ENABLED = false
	self.WALLBANG_ENTRY_COLOR = Color3.fromRGB(255, 50, 50)
	self.WALLBANG_EXIT_COLOR = Color3.fromRGB(50, 255, 50)
	self.WALLBANG_MARKER_SIZE = Vector3.new(0.5, 0.5, 0.5)
	self.WALLBANG_LIFETIME = 3

	self.KILLFX_ENABLED = true
	self.KILLFX_TYPE    = "Nova"
	self.KILLFX_COLOR   = Color3.fromRGB(255, 65, 65)
	self.KILLFX_LIGHT_COLOR  = Color3.fromRGB(255, 120, 120)
	self.KILLFX_CUSTOM_DURATION = 0.25
	self.KILLFX_LIGHT_RANGE     = 18
	self.KILLFX_LIGHT_BRIGHTNESS = 1

	-- ── Auto-Detect системa ──────────────────────────────────────
	-- Анализирует игру и автоматически подбирает
	-- трассеры, хит-саунды, хит-эффекты и килл-эффекты
	self.AUTO_DETECT_ENABLED   = true
	self.AUTO_DETECT_DONE      = false
	self._gameProfile          = nil  -- заполняется после анализа

	self.OFFSCREEN_ENABLED = true
	self.OFFSCREEN_COLOR = Color3.fromRGB(255, 65, 65)

	self.BACKTRACK_GHOST_ENABLED = false
	self.BACKTRACK_GHOST_COLOR = Color3.fromRGB(80, 160, 255)
	self.BACKTRACK_GHOST_DURATION = 0.3

	self.KILLIMAGE_ENABLED   = true
	self.KILLIMAGE_COLOR     = Color3.fromRGB(255, 65, 65)
	self.KILLIMAGE_FADE_IN   = 0.08
	self.KILLIMAGE_HOLD      = 0.1
	self.KILLIMAGE_FADE_OUT  = 0.6
	self.KILLIMAGE_MAX_ALPHA = 0.3

	self.KILLBANNER_ENABLED = true

	self.ATMOSPHERE_ENABLED = false
	self.ATMOSPHERE_DENSITY = 0.25
	self.ATMOSPHERE_OFFSET  = 0.25
	self.ATMOSPHERE_COLOR   = Color3.fromRGB(200, 200, 200)
	self.ATMOSPHERE_DECAY   = Color3.fromRGB(128, 128, 128)
	self.ATMOSPHERE_GLARE   = 0.5
	self.ATMOSPHERE_HAZE    = 0.4

	self.BLOOM_ENABLED    = true
	self.BLOOM_INTENSITY  = 1.2
	self.BLOOM_SIZE       = 20
	self.BLOOM_THRESHOLD  = 0.95

	self.COLOR_CORRECTION_ENABLED     = true
	self.COLOR_CORRECTION_BRIGHTNESS  = 0.03
	self.COLOR_CORRECTION_CONTRAST    = 0.08
	self.COLOR_CORRECTION_SATURATION  = 0.06
	self.COLOR_CORRECTION_TINT        = Color3.fromRGB(255, 255, 255)

	self.CHINA_HAT_ENABLED  = false
	self.CHINA_HAT_COLOR    = Color3.fromRGB(255, 65, 65)
	self.CHINA_HAT_MATERIAL = "Neon"
	self.CHINA_HAT_SIZE     = 2.8
	self.CHINA_HAT_SPEED    = 15
	self._chinaHatParts     = {}
	self._chinaHatConn      = nil

	self.WINGS_ENABLED   = false
	self.WINGS_COLOR     = Color3.fromRGB(255, 65, 65)
	self.WINGS_MATERIAL  = "Neon"
	self._wingData       = nil

	self.AURA_ENABLED  = false
	self.AURA_COLOR    = Color3.fromRGB(255, 65, 65)
	self.AURA_MATERIAL = "Neon"
	self._auraData     = nil

	self.JUMP_CIRCLES_ENABLED = false
	self.JUMP_CIRCLES_COLOR   = Color3.fromRGB(255, 65, 65)
	self._jumpConn            = nil

	self.HIT_MARKER_ENABLED = true
	self._hitMarkerGui      = nil
	self._hitMarkerLines    = {}

	self.NEON_PLAYER_ENABLED = false
	self.NEON_PLAYER_COLOR = Color3.fromRGB(255, 255, 255)
	self._neonConn = nil
	self._neonGlow = nil
	self._origMaterials = {}

	self.tracerPool = {}
	self.MAX_TRACER_POOL = 12

	self.arrows = {}
	self.hitlogContainer = nil
	self.hitlogOrder = 0

	self._bindInputBegan = nil
	self._bindInputEnded = nil

	self.ghostModel = nil
	self.ghostExpireAt = 0
	self.sourceCharacter = nil
	self.lastFakeLagState = nil
	self.ghostParts = {}
	self.ghostLastCFrames = {}
	self.GHOST_SMOOTH_SPEED = 45
	self._hbLast = tick()
	self._ghostDt = 1 / 60

	self.killImage = nil

	self:Initialize()

	return self
end

function VisualsModule:Initialize()
	pcall(function()
		self.Camera  = self.Workspace.CurrentCamera
		self.FX_ROOT = self.ReplicatedStorage:WaitForChild("FXTemplates", 5)
	end)

	pcall(function()
		local playerGui = self.player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local sg = playerGui:FindFirstChild("ScreenGui")
			if sg then
				self.HITSOUND_STORAGE = sg:FindFirstChild("storage")
			end
		end
	end)

	pcall(function()
		self.ORIGINAL_EFFECTS = {
			Atmosphere            = self:SnapshotFirstEffect("Atmosphere"),
			BloomEffect           = self:SnapshotFirstEffect("BloomEffect"),
			ColorCorrectionEffect = self:SnapshotFirstEffect("ColorCorrectionEffect"),
		}
	end)

	pcall(function() self:CreateHitlogUI()       end)
	pcall(function() self:CreateOffscreenArrows() end)
	pcall(function() self:CreateKillImageGUI()   end)
	pcall(function() self:CreateKillBannerUI()   end)
	pcall(function() self:CreateHitMarkerUI()    end)

	task.spawn(function()
		pcall(function() self:SetupBacktrackGhost()  end)
		pcall(function() self:SetupKillFXListener()  end)
	end)

	pcall(function() self:SetupPlayerEffects() end)
	pcall(function() self:UpdateBloom()            end)
	pcall(function() self:UpdateColorCorrection()  end)
	pcall(function() self:ApplyAutoDetect()        end)  -- AUTO-DETECT
end

function VisualsModule:CreateHitlogUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Hitlogs"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 50
	screenGui.Parent = self.guiParent

	-- Right side, vertically centered-ish
	local container = Instance.new("Frame")
	container.Name = "HitlogList"
	container.Active = false
	container.Selectable = false
	container.Size = UDim2.new(0, 230, 1, -120)
	container.Position = UDim2.new(1, -240, 0.5, -60)
	container.AnchorPoint = Vector2.new(0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = screenGui

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 3)
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	listLayout.Parent = container

	self.hitlogContainer = container
	self.hitlogOrder = 0
end

function VisualsModule:ShowHitlog(hitType, info)
	if not self.HITLOG_ENABLED then return end
	if not self.hitlogContainer then return end

	self.hitlogOrder += 1

	local isHit = (hitType == "Hit")
	local dmg = math.floor(tonumber(info and info.damage) or 0)
	local dist = math.floor(tonumber(info and info.distance) or 0)
	local part = tostring(info and info.bodyPart or "")
	local reason = info and info.reason or ""

	-- Icon + label
	local icon, mainText, subText
	if isHit then
		-- Choose icon by hitpart
		if part:find("Head") then
			icon = "☠"
		elseif part:find("Arm") or part:find("Hand") then
			icon = "✦"
		elseif part:find("Leg") or part:find("Foot") then
			icon = "✦"
		else
			icon = "✦"
		end
		mainText = string.format("%s  %d DMG", icon, dmg)
		subText = string.format("%s  •  %dm", part ~= "" and part or "Body", dist)
	else
		icon = "✕"
		if reason == "hitchance_failed" then
			mainText = string.format("%s  MISS  %d%%", icon, tonumber(info and info.hitchance) or 0)
			subText = string.format("Roll %d  •  %dm", tonumber(info and info.roll) or 0, dist)
		elseif reason == "min_damage" then
			mainText = string.format("%s  MISS  LOW DMG", icon)
			subText = string.format("< %d req  •  %dm", tonumber(info and info.minDamage) or 0, dist)
		elseif reason == "wall_blocking_target" then
			mainText = string.format("%s  MISS  WALL", icon)
			subText = string.format("%dm", dist)
		elseif reason == "too_far" then
			mainText = string.format("%s  MISS  TOO FAR", icon)
			subText = string.format("%dm", dist)
		elseif reason == "no_target" then
			mainText = string.format("%s  NO TARGET", icon); subText = ""
		elseif reason == "target_dead" then
			mainText = string.format("%s  ALREADY DEAD", icon); subText = ""
		else
			mainText = string.format("%s  MISS", icon); subText = ""
		end
	end

	-- Colors
	local accentCol  = isHit and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(130, 130, 140)
	local textCol    = isHit and Color3.fromRGB(255, 220, 220) or Color3.fromRGB(180, 180, 190)
	local subCol     = isHit and Color3.fromRGB(200, 130, 130) or Color3.fromRGB(120, 120, 130)
	local bgCol      = isHit and Color3.fromRGB(30, 10, 10)   or Color3.fromRGB(14, 14, 18)

	local row = Instance.new("Frame")
	row.Name = "Hitlog_" .. self.hitlogOrder
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = bgCol
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.LayoutOrder = self.hitlogOrder
	row.Parent = self.hitlogContainer

	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

	local stroke = Instance.new("UIStroke")
	stroke.Color = accentCol
	stroke.Thickness = 1
	stroke.Transparency = 1
	stroke.Parent = row

	-- Left accent bar
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 2, 1, -8)
	bar.Position = UDim2.new(0, 4, 0, 4)
	bar.BackgroundColor3 = accentCol
	bar.BackgroundTransparency = 1
	bar.BorderSizePixel = 0
	bar.Parent = row
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	-- Main text
	local mainLabel = Instance.new("TextLabel")
	mainLabel.Size = UDim2.new(1, -18, 0, 18)
	mainLabel.Position = UDim2.new(0, 12, 0, 3)
	mainLabel.BackgroundTransparency = 1
	mainLabel.Text = mainText
	mainLabel.TextColor3 = textCol
	mainLabel.TextTransparency = 1
	mainLabel.TextSize = 13
	mainLabel.Font = Enum.Font.GothamBold
	mainLabel.TextXAlignment = Enum.TextXAlignment.Left
	mainLabel.TextTruncate = Enum.TextTruncate.AtEnd
	mainLabel.Parent = row

	-- Sub text
	if subText ~= "" then
		local subLabel = Instance.new("TextLabel")
		subLabel.Size = UDim2.new(1, -18, 0, 13)
		subLabel.Position = UDim2.new(0, 12, 0, 18)
		subLabel.BackgroundTransparency = 1
		subLabel.Text = subText
		subLabel.TextColor3 = subCol
		subLabel.TextTransparency = 1
		subLabel.TextSize = 11
		subLabel.Font = Enum.Font.Gotham
		subLabel.TextXAlignment = Enum.TextXAlignment.Left
		subLabel.TextTruncate = Enum.TextTruncate.AtEnd
		subLabel.Parent = row

		local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		self.TweenService:Create(subLabel, fadeIn, {TextTransparency = 0}):Play()
	end

	-- Animate in
	local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	self.TweenService:Create(row,     fadeIn, {BackgroundTransparency = isHit and 0.25 or 0.4}):Play()
	self.TweenService:Create(stroke,  fadeIn, {Transparency = isHit and 0.35 or 0.65}):Play()
	self.TweenService:Create(bar,     fadeIn, {BackgroundTransparency = 0}):Play()
	self.TweenService:Create(mainLabel, fadeIn, {TextTransparency = 0}):Play()

	-- Auto-remove
	task.spawn(function()
		task.wait(3.5)
		if not row or not row.Parent then return end
		local fadeOut = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		self.TweenService:Create(row,     fadeOut, {BackgroundTransparency = 1}):Play()
		self.TweenService:Create(stroke,  fadeOut, {Transparency = 1}):Play()
		self.TweenService:Create(bar,     fadeOut, {BackgroundTransparency = 1}):Play()
		self.TweenService:Create(mainLabel, fadeOut, {TextTransparency = 1}):Play()
		local t = self.TweenService:Create(row, TweenInfo.new(0.45), {Size = UDim2.new(1, 0, 0, 0)})
		t:Play()
		t.Completed:Connect(function() if row and row.Parent then row:Destroy() end end)
	end)
end

function VisualsModule:PlayHitSound()
	if not self.HITSOUND_ENABLED then return end

	local HITSOUND_MAP = {
		correct = "HitSfx13",
		skeet = "HitSfx",
		orchestra = "HitSfx2",
		bow = "HitSfx3",
		uwu = "HitSfx4",
		tf2 = "HitSfx5",
		b8 = "HitSfx6",
		basketball = "HitSfx7",
		idk = "HitSfx8",
		orb = "HitSfx9",
		balltap = "HitSfx10",
		softbell = "HitSfx11",
		softhit = "HitSfx12",
		soft = "HitSfx14",
		bell2 = "HitSfx15",
		tank1 = "HitSfx16",
		rampage = "HitSfx18",
		headshot = "HitSfx19",
		tank2 = "HitSfx20",
		rust = "HitSfx22",
	}

	local CUSTOM_SOUNDS = {
		bell = "rbxassetid://7112391013",
		["apple pay"] = "rbxassetid://82415663525492",
		["low honour"] = "rbxassetid://116963486461562",
		["error"] = "rbxassetid://95509039020568",
		["fatality"] = "rbxassetid://138378419413244",
	}

	if CUSTOM_SOUNDS[self.HITSOUND_PRESET] then
		local s = Instance.new("Sound")
		s.SoundId = CUSTOM_SOUNDS[self.HITSOUND_PRESET]
		s.Volume = self.HITSOUND_VOLUME
		s.Parent = self.SoundService
		s:Play()
		self.Debris:AddItem(s, 3)
		return
	end

	if not self.HITSOUND_STORAGE then return end

	local assetName = HITSOUND_MAP[self.HITSOUND_PRESET]
	if not assetName then return end

	local src = self.HITSOUND_STORAGE:FindFirstChild(assetName)
	if not src then return end

	local sound
	if src:IsA("Sound") then
		sound = src:Clone()
	else
		sound = src:FindFirstChildWhichIsA("Sound", true)
		if sound then sound = sound:Clone() end
	end
	if not sound then return end

	sound.Volume = self.HITSOUND_VOLUME
	sound.Parent = self.SoundService
	sound:Play()
	self.Debris:AddItem(sound, math.max(sound.TimeLength + 0.3, 2))
end

function VisualsModule:CreateOffscreenArrows()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ArcPointers"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = self.guiParent
	self.OffscreenGui = gui

	local function isEnemy(plr)
		if self.player.Team and plr.Team then return self.player.Team ~= plr.Team end
		return true
	end

	local function createPointer(plr)
		local c = Instance.new("Frame")
		c.Name = plr.Name .. "_Ptr"
		c.Size = UDim2.fromOffset(44, 52)
		c.AnchorPoint = Vector2.new(0.5, 0.5)
		c.BackgroundTransparency = 1
		c.Visible = false
		c.Parent = gui

		local chevL = Instance.new("Frame")
		chevL.Size = UDim2.fromOffset(4, 18)
		chevL.AnchorPoint = Vector2.new(0.5, 1)
		chevL.Position = UDim2.new(0.5, -4, 0, 22)
		chevL.BackgroundColor3 = self.OFFSCREEN_COLOR
		chevL.Rotation = -30
		chevL.Parent = c
		Instance.new("UICorner", chevL).CornerRadius = UDim.new(0, 2)

		local chevR = Instance.new("Frame")
		chevR.Size = UDim2.fromOffset(4, 18)
		chevR.AnchorPoint = Vector2.new(0.5, 1)
		chevR.Position = UDim2.new(0.5, 4, 0, 22)
		chevR.BackgroundColor3 = self.OFFSCREEN_COLOR
		chevR.Rotation = 30
		chevR.Parent = c
		Instance.new("UICorner", chevR).CornerRadius = UDim.new(0, 2)

		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(5, 5)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.new(0.5, 0, 0, 4)
		dot.BackgroundColor3 = self.OFFSCREEN_COLOR
		dot.Parent = c
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local hpBg = Instance.new("Frame")
		hpBg.Size = UDim2.fromOffset(26, 3)
		hpBg.AnchorPoint = Vector2.new(0.5, 0)
		hpBg.Position = UDim2.new(0.5, 0, 0, 26)
		hpBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		hpBg.BackgroundTransparency = 0.4
		hpBg.BorderSizePixel = 0
		hpBg.Parent = c
		Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

		local hpFill = Instance.new("Frame")
		hpFill.Size = UDim2.new(1, 0, 1, 0)
		hpFill.BackgroundColor3 = self.OFFSCREEN_COLOR
		hpFill.BorderSizePixel = 0
		hpFill.Parent = hpBg
		Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

		local dist = Instance.new("TextLabel")
		dist.Size = UDim2.fromOffset(44, 11)
		dist.AnchorPoint = Vector2.new(0.5, 0)
		dist.Position = UDim2.new(0.5, 0, 0, 31)
		dist.BackgroundTransparency = 1
		dist.TextColor3 = Color3.fromRGB(200, 200, 200)
		dist.Font = Enum.Font.GothamBold
		dist.TextSize = 8
		dist.Text = ""
		dist.TextStrokeTransparency = 0.3
		dist.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		dist.Parent = c

		self.arrows[plr] = {
			container = c,
			chevL = chevL, chevR = chevR, dot = dot,
			hpBg = hpBg, hpFill = hpFill, distLabel = dist,
		}
	end

	local function removePointer(plr)
		if self.arrows[plr] then
			self.arrows[plr].container:Destroy()
			self.arrows[plr] = nil
		end
	end

	self.Players.PlayerAdded:Connect(function(plr)
		if plr ~= self.player and isEnemy(plr) then createPointer(plr) end
	end)
	self.Players.PlayerRemoving:Connect(removePointer)

	for _, p in ipairs(self.Players:GetPlayers()) do
		if p ~= self.player and isEnemy(p) then createPointer(p) end
	end

	local function refresh()
		for plr, d in pairs(self.arrows) do
			if not isEnemy(plr) then d.container:Destroy(); self.arrows[plr] = nil end
		end
		for _, plr in ipairs(self.Players:GetPlayers()) do
			if plr ~= self.player and isEnemy(plr) and not self.arrows[plr] then createPointer(plr) end
		end
	end
	self.player:GetPropertyChangedSignal("Team"):Connect(refresh)

	local _nextOff = 0
	local _OFF_DT  = 1 / 30

	self.RunService.Heartbeat:Connect(function()
		local now = tick()
		if now < _nextOff then return end
		_nextOff = now + _OFF_DT

		self.Camera = self.Workspace.CurrentCamera or self.Camera
		local cam = self.Camera
		if not cam then return end

		if not self.OFFSCREEN_ENABLED then
			for _, d in pairs(self.arrows) do d.container.Visible = false end
			return
		end

		local t      = now
		local camCF  = cam.CFrame
		local camPos = camCF.Position
		local vp     = cam.ViewportSize
		local cx, cy = vp.X * 0.5, vp.Y * 0.5
		local color  = self.OFFSCREEN_COLOR
		local pulse  = 0.9 + math.sin(t * 4) * 0.1
		local maxR   = math.min(vp.X, vp.Y) * 0.4

		for plr, d in pairs(self.arrows) do
			if not isEnemy(plr) then d.container.Visible = false; continue end

			local char = plr.Character
			local hrp  = char and char:FindFirstChild("HumanoidRootPart")
			local hum  = char and char:FindFirstChildOfClass("Humanoid")

			if not hrp or not hum or hum.Health <= 0 then
				d.container.Visible = false; continue
			end

			local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
			if onScreen and sp.Z > 0 and sp.X > 0 and sp.X < vp.X and sp.Y > 0 and sp.Y < vp.Y then
				d.container.Visible = false; continue
			end

			local toP   = (hrp.Position - camPos).Unit
			local angle = math.atan2(toP:Dot(camCF.RightVector), toP:Dot(camCF.LookVector))
			local rot   = math.deg(angle)
			local dist  = (hrp.Position - camPos).Magnitude

			d.container.Position = UDim2.fromOffset(
				cx + math.sin(angle) * maxR,
				cy - math.cos(angle) * maxR)
			d.container.Rotation       = rot + 180
			d.chevL.BackgroundColor3   = color
			d.chevL.BackgroundTransparency = 1 - pulse
			d.chevR.BackgroundColor3   = color
			d.chevR.BackgroundTransparency = 1 - pulse
			d.dot.BackgroundColor3     = color
			d.dot.BackgroundTransparency = 1 - pulse

			local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
			d.hpFill.Size = UDim2.new(hpPct, 0, 1, 0)
			d.hpFill.BackgroundColor3 = Color3.fromRGB(255*(1-hpPct), 255*hpPct, 40)
			d.hpBg.Rotation      = -(rot + 180)
			d.distLabel.Rotation = -(rot + 180)
			d.distLabel.Text     = math.floor(dist) .. "m"
			d.container.Visible  = true
		end
	end)
end

function VisualsModule:CreateHelixTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	local folder = Instance.new("Folder")
	folder.Name = "helix_tracer"
	folder.Parent = self.Workspace

	local color = self.TRACER_COLOR
	local dir = (endPos - startPos).Unit
	local right = dir:Cross(Vector3.new(0, 1, 0))
	if right.Magnitude < 0.01 then right = dir:Cross(Vector3.new(1, 0, 0)) end
	right = right.Unit
	local up = dir:Cross(right).Unit

	local segments = math.clamp(math.floor(distance / 2), 6, 30)
	local radius = 0.8
	local twists = distance / 5

	local strandColors = {
		color,
		Color3.new(
			math.min(color.R * 0.6 + 0.4, 1),
			math.min(color.G * 0.6 + 0.4, 1),
			math.min(color.B * 0.6 + 0.4, 1)
		),
	}

	for strand = 0, 1 do
		local phase = strand * math.pi
		local sc = strandColors[strand + 1]

		local mover = Instance.new("Part")
		mover.Name = "HelixMover_" .. strand
		mover.Anchored = true; mover.CanCollide = false
		mover.CanQuery = false; mover.CanTouch = false; mover.CastShadow = false
		mover.Transparency = 1
		mover.Size = Vector3.new(0.1, 0.1, 0.1)
		mover.Parent = folder

		local a0 = Instance.new("Attachment"); a0.Name = "A0"; a0.Parent = mover
		local a1 = Instance.new("Attachment"); a1.Name = "A1"
		a1.Position = Vector3.new(0.15, 0, 0); a1.Parent = mover

		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(sc)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.1),
			NumberSequenceKeypoint.new(1, 1),
		})
		trail.Lifetime    = 0.5
		trail.FaceCamera  = true
		trail.LightEmission = 0.9
		trail.Width       = self.TRACER_WIDTH
		trail.WidthScale  = NumberSequence.new(1)
		trail.Enabled     = true
		trail.Parent      = mover

		local pts = {}
		for i = 0, segments do
			local t = i / segments
			local basePos = startPos + dir * (distance * t)
			local angle = t * twists * math.pi * 2 + phase
			local offset = right * math.cos(angle) * radius + up * math.sin(angle) * radius
			table.insert(pts, basePos + offset)
		end

		task.spawn(function()
			local flyTime = math.clamp(distance / 1800, 0.05, 0.25)
			local stepTime = flyTime / #pts
			for _, p in ipairs(pts) do
				if not mover or not mover.Parent then break end
				mover.CFrame = CFrame.new(p)
				task.wait(stepTime)
			end
		end)
	end

	local corePart = Instance.new("Part")
	corePart.Anchored = true; corePart.CanCollide = false
	corePart.CanQuery = false; corePart.CanTouch = false; corePart.CastShadow = false
	corePart.Material = Enum.Material.Neon
	corePart.Color = color
	corePart.Size = Vector3.new(0.04, 0.04, distance)
	corePart.CFrame = CFrame.lookAt((startPos + endPos) / 2, endPos)
	corePart.Transparency = 0.5
	corePart.Parent = folder

	local lifetime = self.TRACER_LIFETIME
	task.delay(lifetime * 0.4, function()
		if corePart and corePart.Parent then
			self.TweenService:Create(corePart,
				TweenInfo.new(lifetime * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1}
			):Play()
			end
		end)
	self.Debris:AddItem(folder, lifetime + 0.8)
end

function VisualsModule:CreatePulseTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	local folder = Instance.new("Folder")
	folder.Name = "pulse_tracer"
	folder.Parent = self.Workspace

	local color = self.TRACER_COLOR
	local dir = (endPos - startPos).Unit

	local core = Instance.new("Part")
	core.Name = "PulseCore"
	core.Anchored = true; core.CanCollide = false
	core.CanQuery = false; core.CanTouch = false; core.CastShadow = false
	core.Material = Enum.Material.Neon
	core.Color = color
	core.Size = Vector3.new(0.08, 0.08, distance)
	core.CFrame = CFrame.lookAt((startPos + endPos) / 2, endPos)
	core.Transparency = 0.3
	core.Parent = folder

	local NUM_PULSES = math.clamp(math.floor(distance / 5), 3, 12)
	local pulses = {}
	for i = 1, NUM_PULSES do
		local t = i / (NUM_PULSES + 1)
		local pos = startPos + dir * (distance * t)

		local ring = Instance.new("Part")
		ring.Shape = Enum.PartType.Cylinder
		ring.Anchored = true; ring.CanCollide = false
		ring.CanQuery = false; ring.CanTouch = false; ring.CastShadow = false
		ring.Material = Enum.Material.Neon
		ring.Color = color
		ring.Size = Vector3.new(0.04, 0.3, 0.3)
		ring.Transparency = 0.2
		ring.Parent = folder

		local lookCF = CFrame.lookAt(pos, pos + dir)
		ring.CFrame = lookCF * CFrame.Angles(0, 0, math.rad(90))

		table.insert(pulses, {ring = ring, basePos = pos, delay = (1 - t) * 0.3})
	end

	for _, p in ipairs(pulses) do
		task.delay(p.delay, function()
			if p.ring and p.ring.Parent then
				self.TweenService:Create(p.ring,
					TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Size = Vector3.new(0.04, 1.8, 1.8), Transparency = 1}
				):Play()
			end
		end)
	end

	local lifetime = self.TRACER_LIFETIME
	task.delay(lifetime * 0.4, function()
		if core and core.Parent then
			self.TweenService:Create(core,
				TweenInfo.new(lifetime * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1}
			):Play()
		end
	end)
	self.Debris:AddItem(folder, lifetime + 0.5)
end

function VisualsModule:CreateLightningTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	local folder = Instance.new("Folder")
	folder.Name = "lightning_tracer"
	folder.Parent = self.Workspace

	local color = self.TRACER_COLOR
	local dir = (endPos - startPos).Unit
	local segments = math.clamp(math.floor(distance / 3), 4, 16)
	local segLen = distance / segments
	local jitter = 1.2

	local points = {startPos}
	for i = 1, segments - 1 do
		local basePoint = startPos + dir * (segLen * i)
		local right = dir:Cross(Vector3.new(0, 1, 0))
		if right.Magnitude < 0.01 then right = dir:Cross(Vector3.new(1, 0, 0)) end
		right = right.Unit
		local up = dir:Cross(right).Unit
		local offsetR = (math.random() - 0.5) * 2 * jitter
		local offsetU = (math.random() - 0.5) * 2 * jitter
		table.insert(points, basePoint + right * offsetR + up * offsetU)
	end
	table.insert(points, endPos)

	for i = 1, #points - 1 do
		local p1 = points[i]
		local p2 = points[i + 1]
		local mid = (p1 + p2) / 2
		local len = (p2 - p1).Magnitude

		local seg = Instance.new("Part")
		seg.Name = "BoltSeg"
		seg.Anchored = true
		seg.CanCollide = false
		seg.CanQuery = false
		seg.CanTouch = false
		seg.CastShadow = false
		seg.Material = Enum.Material.Neon
		seg.Color = color
		seg.Size = Vector3.new(0.08, 0.08, len)
		seg.CFrame = CFrame.lookAt(mid, p2)
		seg.Transparency = 0.1
		seg.Parent = folder

		if i == 1 or i == #points - 1 then
			local glow = Instance.new("PointLight")
			glow.Color = color
			glow.Range = 6
			glow.Brightness = 1
			glow.Parent = seg
			end
		end

	local lifetime = self.TRACER_LIFETIME * 0.7
	task.delay(lifetime * 0.3, function()
		for _, child in pairs(folder:GetChildren()) do
			if child:IsA("BasePart") then
				self.TweenService:Create(child,
					TweenInfo.new(lifetime * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1}
				):Play()
			end
		end
	end)

	self.Debris:AddItem(folder, lifetime + 0.2)
end

function VisualsModule:CreateCometTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	local folder = Instance.new("Folder")
	folder.Name = "comet_tracer"
	folder.Parent = self.Workspace

	local color = self.TRACER_COLOR
	local dir = (endPos - startPos).Unit

	local head = Instance.new("Part")
	head.Shape = Enum.PartType.Ball
	head.Anchored = true; head.CanCollide = false
	head.CanQuery = false; head.CanTouch = false; head.CastShadow = false
	head.Material = Enum.Material.Neon
	head.Color = color
	head.Size = Vector3.new(0.5, 0.5, 0.5)
	head.CFrame = CFrame.new(startPos)
	head.Transparency = 0
	head.Parent = folder

	local headLight = Instance.new("PointLight")
	headLight.Color = color; headLight.Range = 12; headLight.Brightness = 3
	headLight.Parent = head

	local a0 = Instance.new("Attachment"); a0.Name = "A0"; a0.Parent = head
	local a1 = Instance.new("Attachment"); a1.Name = "A1"
	a1.Position = Vector3.new(0, 0, 0.4); a1.Parent = head

	local trail = Instance.new("Trail")
	trail.Attachment0 = a0; trail.Attachment1 = a1
	trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color),
		ColorSequenceKeypoint.new(1, Color3.new(
			math.min(color.R * 0.3 + 0.7, 1),
			math.min(color.G * 0.3 + 0.7, 1),
			math.min(color.B * 0.3 + 0.7, 1)
		)),
	})
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.Lifetime = 0.6
	trail.FaceCamera = true
	trail.LightEmission = 1
	trail.Width = self.TRACER_WIDTH
	trail.WidthScale = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.3, 0.6),
		NumberSequenceKeypoint.new(1, 0),
	})
	trail.Enabled = true
	trail.Parent = head

	local pe = Instance.new("ParticleEmitter")
	pe.Color = ColorSequence.new(color)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25),
		NumberSequenceKeypoint.new(1, 0),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Lifetime = NumberRange.new(0.2, 0.5)
	pe.Speed = NumberRange.new(1, 4)
	pe.SpreadAngle = Vector2.new(120, 120)
	pe.Rate = 60
	pe.LightEmission = 1; pe.LightInfluence = 0
	pe.Drag = 5
	pe.Texture = "rbxassetid://6490035152"
	pe.Parent = head

	local flyTime = math.clamp(distance / 1800, 0.06, 0.3)
	local tween = self.TweenService:Create(head,
		TweenInfo.new(flyTime, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(endPos)}
	)
	tween:Play()

	tween.Completed:Once(function()
		pe.Rate = 0
		pe:Emit(15)
		self.TweenService:Create(head,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{Transparency = 1, Size = Vector3.new(0.05, 0.05, 0.05)}
		):Play()
	end)

	self.Debris:AddItem(folder, self.TRACER_LIFETIME + 1)
end

function VisualsModule:CreateRazorTracer(startPos, endPos)
	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	local folder = Instance.new("Folder")
	folder.Name = "razor_tracer"
	folder.Parent = self.Workspace

	local color = self.TRACER_COLOR
	local dir = (endPos - startPos).Unit

	local core = Instance.new("Part")
	core.Anchored = true; core.CanCollide = false
	core.CanQuery = false; core.CanTouch = false; core.CastShadow = false
	core.Material = Enum.Material.Neon
	core.Color = color
	core.Size = Vector3.new(0.06, 0.06, distance)
	core.CFrame = CFrame.lookAt((startPos + endPos) / 2, endPos)
	core.Transparency = 0
	core.Parent = folder

	local right = dir:Cross(Vector3.new(0, 1, 0))
	if right.Magnitude < 0.01 then right = dir:Cross(Vector3.new(1, 0, 0)) end
	right = right.Unit
	local up = dir:Cross(right).Unit

	local echoCount = 4
	for i = 1, echoCount do
		local offset = right * (math.random() - 0.5) * 0.6 + up * (math.random() - 0.5) * 0.6
		local echoStart = startPos + offset
		local echoEnd = endPos + offset

		local echo = Instance.new("Part")
		echo.Anchored = true; echo.CanCollide = false
		echo.CanQuery = false; echo.CanTouch = false; echo.CastShadow = false
		echo.Material = Enum.Material.Neon
		echo.Color = color
		echo.Size = Vector3.new(0.03, 0.03, distance)
		echo.CFrame = CFrame.lookAt((echoStart + echoEnd) / 2, echoEnd)
		echo.Transparency = 0.4 + i * 0.1
		echo.Parent = folder

		task.delay(i * 0.03, function()
			if echo and echo.Parent then
				self.TweenService:Create(echo,
					TweenInfo.new(0.3 + i * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1, Size = Vector3.new(0.01, 0.01, distance * 0.5)}
				):Play()
			end
		end)
	end

	local bladeCount = math.clamp(math.floor(distance / 6), 2, 8)
	for i = 1, bladeCount do
		local t = i / (bladeCount + 1)
		local pos = startPos + dir * distance * t

		local blade = Instance.new("Part")
		blade.Anchored = true; blade.CanCollide = false
		blade.CanQuery = false; blade.CanTouch = false; blade.CastShadow = false
		blade.Material = Enum.Material.Neon
		blade.Color = color
		blade.Size = Vector3.new(1.2, 0.04, 0.04)
		blade.CFrame = CFrame.lookAt(pos, pos + dir) * CFrame.Angles(0, 0, math.rad(45 * i))
		blade.Transparency = 0.2
		blade.Parent = folder

		task.delay(0.15, function()
			if blade and blade.Parent then
				self.TweenService:Create(blade,
					TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1, Size = Vector3.new(2, 0.02, 0.02)}
				):Play()
			end
		end)
	end

	local lifetime = self.TRACER_LIFETIME
	task.delay(lifetime * 0.3, function()
		if core and core.Parent then
			self.TweenService:Create(core,
				TweenInfo.new(lifetime * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1}
			):Play()
		end
	end)

	self.Debris:AddItem(folder, lifetime + 0.3)
end

function VisualsModule:CreateTracer(startPos, endPos)
	if not self.TRACER_ENABLED then return end

	if self.TRACER_STYLE == "Lightning" then
		self:CreateLightningTracer(startPos, endPos)
		return
	elseif self.TRACER_STYLE == "Helix" then
		self:CreateHelixTracer(startPos, endPos)
		return
	elseif self.TRACER_STYLE == "Pulse" then
		self:CreatePulseTracer(startPos, endPos)
		return
	elseif self.TRACER_STYLE == "Comet" then
		self:CreateCometTracer(startPos, endPos)
		return
	elseif self.TRACER_STYLE == "Razor" then
		self:CreateRazorTracer(startPos, endPos)
		return
	end

	local distance = (endPos - startPos).Magnitude
	if distance < 0.5 then return end

	if self.WALLBANG_ENABLED then
		local direction = (endPos - startPos)
		local dirUnit = direction.Unit

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		local char = self.player.Character
		if char then
			params.FilterDescendantsInstances = { char }
		end

		local rayForward = self.Workspace:Raycast(startPos, dirUnit * distance, params)
		if rayForward then
			local rayBackward = self.Workspace:Raycast(endPos, -dirUnit * distance, params)
			if rayBackward then
				local penetrationDepth = (rayForward.Position - rayBackward.Position).Magnitude
				if penetrationDepth > 0.5 and penetrationDepth < (distance * 0.95) then
					task.spawn(function()
						self:CreateWallbangMarker(rayForward.Position, self.WALLBANG_ENTRY_COLOR)
						self:CreateWallbangMarker(rayBackward.Position, self.WALLBANG_EXIT_COLOR)
					end)
				end
			end
		end
	end

	local tracerObj = table.remove(self.tracerPool)
	if not tracerObj then
		local folder = Instance.new("Folder")
		folder.Name = "tracer_fx"

		local mover = Instance.new("Part")
		mover.Name = "Mover"
		mover.Anchored = true
		mover.Transparency = 1
		mover.CanCollide = false
		mover.CanQuery = false
		mover.CanTouch = false
		mover.Size = Vector3.new(0.05, 0.05, 0.05)
		mover.Parent = folder

		local a0 = Instance.new("Attachment")
		a0.Name = "A0"
		a0.Parent = mover

		local a1 = Instance.new("Attachment")
		a1.Name = "A1"
		a1.Parent = mover

		local trail = Instance.new("Trail")
		trail.Name = "Trace"
		trail.Attachment0 = a0
		trail.Attachment1 = a1
		trail.Enabled = false
		trail.FaceCamera = true
		trail.Brightness = self.TRACER_BRIGHTNESS
		trail.LightEmission = self.TRACER_LIGHTEMISSION
		trail.LightInfluence = self.TRACER_LIGHTINFLUENCE
		trail.TextureMode = Enum.TextureMode.Stretch
		trail.Texture = "rbxassetid://93746968407218"
		trail.TextureLength = 3
		trail.Transparency = self.TRACER_TRANSPARENCY
		trail.Parent = mover

		tracerObj = { folder = folder, mover = mover, a0 = a0, a1 = a1, trail = trail }
	end

	local w = math.max(self.TRACER_WIDTH, 0.02)  -- no upper clamp

	tracerObj.trail.Color          = ColorSequence.new(self.TRACER_COLOR)
	tracerObj.trail.Lifetime       = self.TRACER_LIFETIME
	-- Width sets actual stud-width; WidthScale is a 0-1 multiplier on top
	tracerObj.trail.Width          = w
	tracerObj.trail.WidthScale     = NumberSequence.new(1)  -- full width, tapered by Transparency
	tracerObj.trail.Transparency   = self.TRACER_TRANSPARENCY
	tracerObj.trail.Brightness     = self.TRACER_BRIGHTNESS
	tracerObj.trail.LightEmission  = self.TRACER_LIGHTEMISSION
	tracerObj.trail.LightInfluence = self.TRACER_LIGHTINFLUENCE

	local dir = (endPos - startPos)
	local unit = dir.Unit

	tracerObj.folder.Parent = self.Workspace
	tracerObj.mover.CFrame = CFrame.lookAt(startPos, startPos + unit)
	tracerObj.a0.Position = Vector3.new(0, 0, 0)
	tracerObj.a1.Position = Vector3.new(0, 0, -self.TRACER_TAIL)
	tracerObj.trail.Enabled = true

	local flyTime = math.clamp(distance / 2200, 0.06, 0.22)
	local tween = self.TweenService:Create(tracerObj.mover, TweenInfo.new(flyTime, Enum.EasingStyle.Linear), {
		CFrame = CFrame.lookAt(endPos, endPos + unit),
	})
	tween:Play()

	tween.Completed:Once(function()
		task.delay(tracerObj.trail.Lifetime + 0.05, function()
			if not tracerObj or not tracerObj.folder then return end
			tracerObj.trail.Enabled = false
			tracerObj.folder.Parent = nil
			if #self.tracerPool < self.MAX_TRACER_POOL then
				table.insert(self.tracerPool, tracerObj)
			else
				tracerObj.folder:Destroy()
			end
		end)
	end)
end

function VisualsModule:CreateWallbangMarker(pos, color)
	local part = Instance.new("Part")
	part.Name = "WallbangMarker"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.ForceField
	part.Color = color
	part.Size = self.WALLBANG_MARKER_SIZE
	part.CFrame = CFrame.new(pos)
	part.Parent = self.Workspace

	part.Transparency = 0
	local tIn = self.TweenService:Create(part, TweenInfo.new(0.3), { Transparency = 0 })
	tIn:Play()

	self.Debris:AddItem(part, self.WALLBANG_LIFETIME)

	task.delay(self.WALLBANG_LIFETIME - 0.5, function()
		if part.Parent then
			self.TweenService:Create(part, TweenInfo.new(0.5), { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
		end
	end)
end

function VisualsModule:CreateKillImageGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "KillImage"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 9999
	gui.Parent = self.guiParent

	local img = Instance.new("ImageLabel")
	img.Name = "Effect"
	img.Size = UDim2.fromScale(1, 1)
	img.Position = UDim2.fromScale(0.5, 0.5)
	img.AnchorPoint = Vector2.new(0.5, 0.5)
	img.BackgroundTransparency = 1
	img.Image = "http://www.roblox.com/asset/?id=3124804643"
	img.ImageTransparency = 1
	img.ScaleType = Enum.ScaleType.Stretch
	img.ZIndex = 999
	img.Parent = gui

	self.killImage = img
end

function VisualsModule:PlayKillImage()
	if not self.KILLIMAGE_ENABLED then return end
	if not self.killImage then return end

	self.killImage.ImageColor3 = self.KILLIMAGE_COLOR
	self.killImage.ImageTransparency = 1

	local tIn = self.TweenService:Create(
		self.killImage,
		TweenInfo.new(self.KILLIMAGE_FADE_IN, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ImageTransparency = 1 - self.KILLIMAGE_MAX_ALPHA }
	)

	local tOut = self.TweenService:Create(
		self.killImage,
		TweenInfo.new(self.KILLIMAGE_FADE_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ ImageTransparency = 1 }
	)

	tIn:Play()
	tIn.Completed:Wait()
	task.wait(self.KILLIMAGE_HOLD)
	tOut:Play()
end

function VisualsModule:CreateKillBannerUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "KillBanner"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 9998
	gui.Parent = self.guiParent

	-- Outer container - top-center
	local frame = Instance.new("Frame")
	frame.Name = "BannerFrame"
	frame.Size = UDim2.new(0, 280, 0, 44)
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0, -60) -- starts off-screen top
	frame.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 60, 60)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.3
	stroke.Parent = frame

	-- Left red accent bar
	local leftBar = Instance.new("Frame")
	leftBar.Size = UDim2.new(0, 3, 1, -10)
	leftBar.Position = UDim2.new(0, 5, 0, 5)
	leftBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	leftBar.BorderSizePixel = 0
	leftBar.Parent = frame
	Instance.new("UICorner", leftBar).CornerRadius = UDim.new(1, 0)

	-- Kill icon label
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Name = "Icon"
	iconLabel.Size = UDim2.new(0, 28, 1, 0)
	iconLabel.Position = UDim2.new(0, 13, 0, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = "☠"
	iconLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
	iconLabel.TextSize = 20
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextXAlignment = Enum.TextXAlignment.Center
	iconLabel.Parent = frame

	-- Main kill text
	local killLabel = Instance.new("TextLabel")
	killLabel.Name = "KillText"
	killLabel.Size = UDim2.new(1, -52, 0, 22)
	killLabel.Position = UDim2.new(0, 44, 0, 4)
	killLabel.BackgroundTransparency = 1
	killLabel.Text = "KILL"
	killLabel.TextColor3 = Color3.fromRGB(255, 210, 210)
	killLabel.TextSize = 14
	killLabel.Font = Enum.Font.GothamBold
	killLabel.TextXAlignment = Enum.TextXAlignment.Left
	killLabel.TextTruncate = Enum.TextTruncate.AtEnd
	killLabel.Parent = frame

	-- Sub info (damage / distance)
	local subLabel = Instance.new("TextLabel")
	subLabel.Name = "SubText"
	subLabel.Size = UDim2.new(1, -52, 0, 14)
	subLabel.Position = UDim2.new(0, 44, 0, 24)
	subLabel.BackgroundTransparency = 1
	subLabel.Text = ""
	subLabel.TextColor3 = Color3.fromRGB(180, 120, 120)
	subLabel.TextSize = 11
	subLabel.Font = Enum.Font.Gotham
	subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.TextTruncate = Enum.TextTruncate.AtEnd
	subLabel.Parent = frame

	self._killBannerFrame  = frame
	self._killBannerKill   = killLabel
	self._killBannerSub    = subLabel
	self._killBannerActive = false
end

function VisualsModule:ShowKillBanner(victimName, dmg, dist)
	if not self.KILLBANNER_ENABLED then return end
	if not self._killBannerFrame then return end
	if self._killBannerActive then return end

	self._killBannerActive = true

	local name = tostring(victimName or "Enemy")
	self._killBannerKill.Text = "ELIMINATED  " .. name
	self._killBannerSub.Text  = string.format("%d DMG  •  %dm", math.floor(tonumber(dmg) or 0), math.floor(tonumber(dist) or 0))

	-- Slide down from top
	self._killBannerFrame.Position = UDim2.new(0.5, 0, 0, -60)
	self._killBannerFrame.BackgroundTransparency = 0.15

	self.TweenService:Create(self._killBannerFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Position = UDim2.new(0.5, 0, 0, 14)}
	):Play()

	task.spawn(function()
		task.wait(2.2)
		if not self._killBannerFrame then return end
		local fadeOut = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		self.TweenService:Create(self._killBannerFrame, fadeOut,
			{Position = UDim2.new(0.5, 0, 0, -60), BackgroundTransparency = 1}
		):Play()
		task.wait(0.35)
		self._killBannerActive = false
	end)
end

function VisualsModule:CreateHitMarkerUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "HitMarker"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 100
	gui.Parent = self.guiParent

	local holder = Instance.new("Frame")
	holder.Name = "HitMarker"
	holder.Size = UDim2.new(0, 44, 0, 44)
	holder.AnchorPoint = Vector2.new(0.5, 0.5)
	holder.Position = UDim2.new(0.5, 0, 0.5, 0)
	holder.BackgroundTransparency = 1
	holder.Visible = false
	holder.Parent = gui

	self._hitMarkerLines = {}

	local HM_COLOR = Color3.fromRGB(255, 65, 65)

	local function makeLine(rot)
		local line = Instance.new("Frame")
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.Position = UDim2.new(0.5, 0, 0.5, 0)
		line.Size = UDim2.new(0, 2, 0, 20)
		line.BackgroundColor3 = HM_COLOR
		line.BorderSizePixel = 0
		line.Rotation = rot
		line.BackgroundTransparency = 1
		line.Parent = holder
		Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

		-- black gap in center
		local gap = Instance.new("Frame")
		gap.AnchorPoint = Vector2.new(0.5, 0.5)
		gap.Position = UDim2.new(0.5, 0, 0.5, 0)
		gap.Size = UDim2.new(0, 4, 0, 7)
		gap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		gap.BackgroundTransparency = 0
		gap.BorderSizePixel = 0
		gap.Parent = line

		return line
	end

	table.insert(self._hitMarkerLines, makeLine(45))
	table.insert(self._hitMarkerLines, makeLine(-45))

	-- Center dot
	local dot = Instance.new("Frame")
	dot.Name = "Dot"
	dot.Size = UDim2.new(0, 4, 0, 4)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.Position = UDim2.new(0.5, 0, 0.5, 0)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.BackgroundTransparency = 1
	dot.BorderSizePixel = 0
	dot.Parent = holder
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	self._hitMarkerDot = dot

	self._hitMarkerGui = holder
	self._hitMarkerColor = HM_COLOR
end

function VisualsModule:FlashHitMarker()
	if not self.HIT_MARKER_ENABLED then return end
	if not self._hitMarkerGui then return end

	self._hitMarkerGui.Visible = true

	-- Burst open big → shrink to normal
	self._hitMarkerGui.Size = UDim2.new(0, 58, 0, 58)
	for _, l in ipairs(self._hitMarkerLines) do
		l.BackgroundTransparency = 0
		l.BackgroundColor3 = self._hitMarkerColor
	end
	if self._hitMarkerDot then
		self._hitMarkerDot.BackgroundTransparency = 0
	end

	-- Shrink snap
	self.TweenService:Create(self._hitMarkerGui,
		TweenInfo.new(0.07, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 40, 0, 40)}
	):Play()

	task.spawn(function()
		task.wait(0.12)
		if not self._hitMarkerGui then return end
		local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		for _, l in ipairs(self._hitMarkerLines) do
			self.TweenService:Create(l, fadeInfo, {BackgroundTransparency = 1}):Play()
		end
		if self._hitMarkerDot then
			self.TweenService:Create(self._hitMarkerDot, fadeInfo, {BackgroundTransparency = 1}):Play()
		end
		task.wait(0.18)
		if self._hitMarkerGui then self._hitMarkerGui.Visible = false end
	end)
end

function VisualsModule:SetupPlayerEffects()
	self.player.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if self.CHINA_HAT_ENABLED then self:SpawnChinaHat() end
		if self.WINGS_ENABLED then self:SpawnWings() end
		if self.AURA_ENABLED then self:SpawnAura() end
		if self.JUMP_CIRCLES_ENABLED then self:ConnectJumpCircles() end
	end)

	if self.player.Character then
		task.defer(function()
			if self.CHINA_HAT_ENABLED then self:SpawnChinaHat() end
			if self.WINGS_ENABLED then self:SpawnWings() end
			if self.AURA_ENABLED then self:SpawnAura() end
			if self.JUMP_CIRCLES_ENABLED then self:ConnectJumpCircles() end
		end)
	end
end

function VisualsModule:SpawnChinaHat()
	self:DestroyChinaHat()
	local char = self.player.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	local SIZE   = self.CHINA_HAT_SIZE or 2.8
	local radius = SIZE / 2
	local height = SIZE * 0.42
	local bOff   = head.Size.Y / 2 + 0.05
	local col    = self.CHINA_HAT_COLOR

	local function adorn(class, name, r, h, trans, zi)
		local a = Instance.new(class)
		a.Name = name; a.Adornee = head
		if r then a.Radius = r end
		if h then a.Height = h end
		a.Color3 = col; a.Transparency = trans
		a.AlwaysOnTop = true; a.ZIndex = zi
		a.Parent = head
		table.insert(self._chinaHatParts, a)
		return a
	end

	-- Конус (основной)
	local main    = adorn("ConeHandleAdornment",     "Hat_Main",   radius,        height,      0.08, 5)
	local outline = adorn("ConeHandleAdornment",     "Hat_Outline",radius + 0.22, height + 0.07, 0.5, 4)
	local inner   = adorn("ConeHandleAdornment",     "Hat_Inner",  radius * 0.45, height * 0.55, 0.25, 6)
	-- Поля (цилиндр)
	local brim      = adorn("CylinderHandleAdornment","Hat_Brim",  radius + 0.38, 0.09, 0.18, 5)
	local brimOuter = adorn("CylinderHandleAdornment","Hat_BrimOut",radius + 0.6,  0.04, 0.5,  4)
	-- Верхний шарик-кончик
	local tip = adorn("SphereHandleAdornment", "Hat_Tip", radius * 0.12, nil, 0.1, 7)

	-- Обновляем цвет outline чуть темнее
	outline.Color3 = Color3.new(
		math.max(col.R * 0.55, 0),
		math.max(col.G * 0.55, 0),
		math.max(col.B * 0.55, 0))

	if self._chinaHatConn then self._chinaHatConn:Disconnect() end
	local rot    = 0
	local prevT  = tick()
	local _pulse = 0

	self._chinaHatConn = self.RunService.Heartbeat:Connect(function(dt)
		if not head or not head.Parent or not main.Parent then
			if self._chinaHatConn then self._chinaHatConn:Disconnect(); self._chinaHatConn = nil end
			return
		end
		local now   = tick()
		rot         = rot + dt * (self.CHINA_HAT_SPEED or 15)
		_pulse      = _pulse + dt * 2.2
		local spin  = math.rad(rot)
		local p     = 0.06 + math.abs(math.sin(_pulse)) * 0.08

		local rotCF  = CFrame.Angles(0, spin, 0) * CFrame.Angles(math.rad(90), 0, 0)
		local baseCF = CFrame.new(0, bOff, 0)
		local flatCF = CFrame.new(0, bOff - height * 0.06, 0) * CFrame.Angles(0, spin, 0)

		main.CFrame      = baseCF * rotCF
		outline.CFrame   = baseCF * rotCF
		inner.CFrame     = baseCF * rotCF
		brim.CFrame      = flatCF
		brimOuter.CFrame = flatCF
		tip.CFrame       = CFrame.new(0, bOff + height * 0.9, 0)

		main.Transparency  = p
		inner.Transparency = p + 0.18
		tip.Transparency   = p * 0.5
	end)
end

function VisualsModule:DestroyChinaHat()
	if self._chinaHatConn then
		self._chinaHatConn:Disconnect()
		self._chinaHatConn = nil
	end
	for _, p in ipairs(self._chinaHatParts) do
		if p and p.Parent then p:Destroy() end
	end
	self._chinaHatParts = {}
end

function VisualsModule:SpawnWings()
	self:DestroyWings()
	local char = self.player.Character
	if not char then return end
	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not torso then return end

	local folder = Instance.new("Folder")
	folder.Name = "ArcWings"
	folder.Parent = char

	local allParts = {}
	local allTrails = {}

	local mainFeathers = {
		{side = -1, x = 0.4, y = 1.0, z = 0.45, ry = 6,  flapMult = 0.6, w = 0.9, h = 1.5, d = 0.14},
		{side = -1, x = 0.9, y = 0.85, z = 0.5, ry = 10, flapMult = 0.75, w = 1.1, h = 2.1, d = 0.12},
		{side = -1, x = 1.5, y = 0.6, z = 0.55, ry = 16, flapMult = 0.9, w = 1.2, h = 2.7, d = 0.10},
		{side = -1, x = 2.1, y = 0.3, z = 0.6, ry = 22, flapMult = 1.05, w = 1.15, h = 3.1, d = 0.09},
		{side = -1, x = 2.7, y = -0.1, z = 0.65, ry = 28, flapMult = 1.2, w = 1.0, h = 3.0, d = 0.08},
		{side = -1, x = 3.2, y = -0.5, z = 0.7, ry = 33, flapMult = 1.35, w = 0.85, h = 2.5, d = 0.07},
		{side = -1, x = 3.6, y = -0.9, z = 0.75, ry = 37, flapMult = 1.5, w = 0.6, h = 1.8, d = 0.06},
	}

	local secondaryFeathers = {
		{side = -1, x = 0.6, y = 0.4, z = 0.55, ry = 12, flapMult = 0.8, w = 0.5, h = 1.2, d = 0.08},
		{side = -1, x = 1.2, y = 0.15, z = 0.6, ry = 18, flapMult = 0.95, w = 0.6, h = 1.6, d = 0.07},
		{side = -1, x = 1.8, y = -0.1, z = 0.65, ry = 24, flapMult = 1.1, w = 0.55, h = 1.8, d = 0.06},
		{side = -1, x = 2.3, y = -0.35, z = 0.7, ry = 29, flapMult = 1.25, w = 0.45, h = 1.5, d = 0.06},
	}

	local featherDefs = {}
	for _, def in ipairs(mainFeathers) do
		table.insert(featherDefs, def)
		local mirror = {}; for k, v in pairs(def) do mirror[k] = v end
		mirror.side = 1
		table.insert(featherDefs, mirror)
	end
	for _, def in ipairs(secondaryFeathers) do
		table.insert(featherDefs, def)
		local mirror = {}; for k, v in pairs(def) do mirror[k] = v end
		mirror.side = 1
		table.insert(featherDefs, mirror)
	end

	local feathers = {}
	for _, def in ipairs(featherDefs) do
		local feather = Instance.new("Part")
		feather.Name = "ArcFeather"
		feather.Size = Vector3.new(def.d, def.h, def.w)
		feather.Material = Enum.Material.Neon
		feather.Color = self.WINGS_COLOR
		feather.Anchored = true; feather.CanCollide = false
		feather.CanTouch = false; feather.CanQuery = false
		feather.CastShadow = false
		feather.Transparency = 0.12
		feather.Parent = folder
		table.insert(allParts, feather)

		local a0 = Instance.new("Attachment")
		a0.Position = Vector3.new(0, def.h * 0.4, 0)
		a0.Parent = feather
		local a1 = Instance.new("Attachment")
		a1.Position = Vector3.new(0, -def.h * 0.4, 0)
		a1.Parent = feather
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(self.WINGS_COLOR)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 1),
		})
		trail.Lifetime = 0.4
		trail.FaceCamera = true
		trail.LightEmission = 0.8
		trail.Parent = feather
		table.insert(allTrails, trail)

		table.insert(feathers, {part = feather, def = def})
	end

	local tipL = Instance.new("Part")
	tipL.Name = "ArcWingTipL"
	tipL.Shape = Enum.PartType.Ball
	tipL.Size = Vector3.new(0.3, 0.3, 0.3)
	tipL.Material = Enum.Material.Neon; tipL.Color = self.WINGS_COLOR
	tipL.Anchored = true; tipL.CanCollide = false; tipL.CanQuery = false
	tipL.CastShadow = false; tipL.Transparency = 0.3
	tipL.Parent = folder
	table.insert(allParts, tipL)

	local tipR = tipL:Clone()
	tipR.Name = "ArcWingTipR"
	tipR.Parent = folder
	table.insert(allParts, tipR)

	local glowPart = Instance.new("Part")
	glowPart.Name = "ArcWingGlow"
	glowPart.Size = Vector3.new(0.5, 0.5, 0.5)
	glowPart.Transparency = 1; glowPart.Anchored = true
	glowPart.CanCollide = false; glowPart.CanQuery = false
	glowPart.Parent = folder

	local glow = Instance.new("PointLight")
	glow.Color = self.WINGS_COLOR
	glow.Range = 10; glow.Brightness = 0.8
	glow.Parent = glowPart

	local particles = Instance.new("ParticleEmitter")
	particles.Color = ColorSequence.new(self.WINGS_COLOR)
	particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.1),
		NumberSequenceKeypoint.new(1, 0),
	})
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25),
		NumberSequenceKeypoint.new(1, 1),
	})
	particles.Lifetime = NumberRange.new(0.4, 1.0)
	particles.Rate = 20
	particles.Speed = NumberRange.new(0.5, 2.5)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.LightEmission = 0.9; particles.LightInfluence = 0
	particles.Texture = "rbxassetid://6490035152"
	particles.Parent = glowPart

	table.insert(allParts, glowPart)

	-- Применяем материал
	local matEnum = Enum.Material[self.WINGS_MATERIAL or "Neon"] or Enum.Material.Neon
	for _, p in ipairs(allParts) do
		if p:IsA("BasePart") then p.Material = matEnum end
	end

	local _nextWing = 0
	local _WING_DT  = 1 / 40  -- 40fps достаточно для плавных крыльев

	local conn = self.RunService.Heartbeat:Connect(function(dt)
		if not torso or not torso.Parent then self:DestroyWings(); return end
		local now = tick()
		if now < _nextWing then return end
		_nextWing = now + _WING_DT

		local t        = now
		local torsoCF  = torso.CFrame
		local sin28    = math.sin(t * 2.8)
		local flapBase = sin28 * 14
		local flapSec  = math.sin(t * 2.8 + 0.4) * 10
		local t18 = t * 1.8; local t6 = t * 6; local t32 = t * 3.2

		for _, f in ipairs(feathers) do
			local d    = f.def
			local side = d.side
			local dx   = d.x
			local flap = ((d.h < 2) and flapSec or flapBase) * d.flapMult
			f.part.CFrame = torsoCF
				* CFrame.new(side * dx, d.y, d.z)
				* CFrame.Angles(
					math.rad(math.sin(t18 + dx*.7)*2.5 + math.sin(t6+dx*3.5)*d.flapMult + math.sin(t32+dx*2)*1.2),
					math.rad(side * d.ry),
					math.rad(side * (flap - 12))
				)
		end

		local tipFlap = flapBase * 1.5 - 12
		tipL.CFrame   = torsoCF * CFrame.new(-3.7,-1.0,0.75) * CFrame.Angles(0,0,math.rad(-tipFlap))
		tipR.CFrame   = torsoCF * CFrame.new( 3.7,-1.0,0.75) * CFrame.Angles(0,0,math.rad( tipFlap))
		glowPart.CFrame = torsoCF * CFrame.new(0, 0.3, 0.5)
		glow.Brightness = 0.6 + sin28 * 0.3
	end)

	self._wingData = {
		folder = folder,
		allParts = allParts,
		allTrails = allTrails,
		glow = glow,
		particles = particles,
		conn = conn,
	}
end

function VisualsModule:DestroyWings()
	if self._wingData then
		if self._wingData.conn then
			self._wingData.conn:Disconnect()
		end
		if self._wingData.folder and self._wingData.folder.Parent then
			self._wingData.folder:Destroy()
		end
		self._wingData = nil
	end
end

function VisualsModule:SpawnAura()
	self:DestroyAura()
	local char = self.player.Character
	if not char then return end
	local hrp  = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local col     = self.AURA_COLOR
	local matName = self.AURA_MATERIAL or "Neon"
	local mat     = Enum.Material[matName] or Enum.Material.Neon

	local folder = Instance.new("Folder")
	folder.Name  = "EclipseAura"
	folder.Parent = char

	-- ── Хелпер: создать орб ──────────────────────────────────────
	local function makeOrb(sz, transp, lightRange, trailLife)
		local orb = Instance.new("Part")
		orb.Shape        = Enum.PartType.Ball
		orb.Size         = Vector3.new(sz, sz, sz)
		orb.Material     = mat
		orb.Color        = col
		orb.Anchored     = true
		orb.CanCollide   = false
		orb.CanTouch     = false
		orb.CanQuery     = false
		orb.CastShadow   = false
		orb.Transparency = transp
		orb.Parent       = folder

		if lightRange > 0 then
			local lt = Instance.new("PointLight")
			lt.Color      = col
			lt.Range      = lightRange
			lt.Brightness = 0.5
			lt.Parent     = orb
		end

		if trailLife > 0 then
			local a0 = Instance.new("Attachment")
			a0.Position = Vector3.new(0, sz * 0.4, 0)
			a0.Parent = orb
			local a1 = Instance.new("Attachment")
			a1.Position = Vector3.new(0, -sz * 0.4, 0)
			a1.Parent = orb
			local tr = Instance.new("Trail")
			tr.Attachment0   = a0
			tr.Attachment1   = a1
			tr.Color         = ColorSequence.new(col)
			tr.Transparency  = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(1, 1),
			})
			tr.Lifetime      = trailLife
			tr.FaceCamera    = true
			tr.LightEmission = 0.9
			tr.WidthScale    = NumberSequence.new(0.8)
			tr.Parent        = orb
		end

		return orb
	end

	-- ── Кольцо из орбов (внешнее) ─────────────────────────────
	local NUM_RING    = 8
	local RING_R      = 3.5
	local ringOrbs = {}
	for i = 1, NUM_RING do
		table.insert(ringOrbs, makeOrb(0.32, 0.15, 5, 0.55))
	end

	-- ── Спираль (средний ярус) ─────────────────────────────────
	local NUM_SPIRAL  = 6
	local SPIRAL_R    = 2.2
	local spiralOrbs = {}
	for i = 1, NUM_SPIRAL do
		table.insert(spiralOrbs, makeOrb(0.22, 0.2, 3, 0.35))
	end

	-- ── Внутреннее ядро (орбы у тела) ─────────────────────────
	local NUM_CORE    = 4
	local CORE_R      = 1.1
	local coreOrbs = {}
	for i = 1, NUM_CORE do
		table.insert(coreOrbs, makeOrb(0.16, 0.3, 2, 0.2))
	end

	-- ── Приземлённое кольцо (плоский тор) ─────────────────────
	local NUM_GROUND  = 12
	local GROUND_R    = 3.8
	local groundOrbs = {}
	for i = 1, NUM_GROUND do
		table.insert(groundOrbs, makeOrb(0.14, 0.35, 0, 0))
	end

	-- ── Частицы подъёма ───────────────────────────────────────
	local function makeParticles(parent, rate, speed, size0, size1)
		local pe = Instance.new("ParticleEmitter")
		pe.Color           = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   col),
			ColorSequenceKeypoint.new(0.5, Color3.new(
				math.min(col.R + 0.3, 1),
				math.min(col.G + 0.3, 1),
				math.min(col.B + 0.3, 1))),
			ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
		})
		pe.Size            = NumberSequence.new({
			NumberSequenceKeypoint.new(0,   size0),
			NumberSequenceKeypoint.new(0.4, size1),
			NumberSequenceKeypoint.new(1,   0),
		})
		pe.Transparency    = NumberSequence.new({
			NumberSequenceKeypoint.new(0,   0.2),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1,   1),
		})
		pe.Lifetime        = NumberRange.new(0.8, 1.8)
		pe.Rate            = rate
		pe.Speed           = NumberRange.new(speed * 0.6, speed)
		pe.SpreadAngle     = Vector2.new(25, 25)
		pe.RotSpeed        = NumberRange.new(-90, 90)
		pe.LightEmission   = 1
		pe.LightInfluence  = 0
		pe.Texture         = "rbxassetid://6490035152"
		pe.EmissionDirection = Enum.NormalId.Top
		pe.Parent          = parent
		return pe
	end

	local riseEmitter  = makeParticles(hrp, 22, 3.5, 0.12, 0.22)
	local glowEmitter  = makeParticles(hrp, 8,  1.0, 0.2,  0.35)
	glowEmitter.EmissionDirection = Enum.NormalId.Front
	glowEmitter.SpreadAngle = Vector2.new(360, 360)

	-- ── Анимационный луп (60fps cap, не каждый Heartbeat) ────────
	local conn
	local _nextAura  = 0
	local _AURA_DT   = 1 / 60
	local PI2        = math.pi * 2
	local _ringStep  = PI2 / NUM_RING
	local _spirStep  = PI2 / NUM_SPIRAL
	local _coreStep  = PI2 / NUM_CORE
	local _gndStep   = PI2 / NUM_GROUND

	conn = self.RunService.Heartbeat:Connect(function()
		if not hrp or not hrp.Parent then self:DestroyAura(); return end

		local now = tick()
		if now < _nextAura then return end
		_nextAura = now + _AURA_DT

		local t   = now
		local bp  = hrp.Position
		local col2 = self.AURA_COLOR

		-- Кэшируем общие углы
		local t14  = t * 1.4
		local t25  = t * 2.5
		local t38  = t * 3.8
		local t06  = t * 0.6

		for i, orb in ipairs(ringOrbs) do
			local ang  = t14 + (i - 1) * _ringStep
			local ca, sa = math.cos(ang), math.sin(ang)
			local yOff = math.sin(t * 1.8 + i) * 0.9
			orb.Color  = col2
			orb.CFrame = CFrame.new(bp.X + ca * RING_R, bp.Y + yOff, bp.Z + sa * RING_R)
		end

		for i, orb in ipairs(spiralOrbs) do
			local ang  = -t25 + (i - 1) * _spirStep
			local ca, sa = math.cos(ang), math.sin(ang)
			local yOff = math.sin(t * 2.2 + i * 1.4) * 1.1 + 0.8
			orb.Color  = col2
			orb.CFrame = CFrame.new(bp.X + ca * SPIRAL_R, bp.Y + yOff, bp.Z + sa * SPIRAL_R)
		end

		for i, orb in ipairs(coreOrbs) do
			local ang  = t38 + (i - 1) * _coreStep
			local ca   = math.cos(ang)
			local yOff = math.sin(ang) * 0.6 + 1.2
			local zOff = math.cos(t * 2.5 + i) * CORE_R
			orb.Color  = col2
			orb.CFrame = CFrame.new(bp.X + ca * CORE_R, bp.Y + yOff, bp.Z + zOff)
		end

		for i, orb in ipairs(groundOrbs) do
			local ang  = t06 + (i - 1) * _gndStep
			local ca, sa = math.cos(ang), math.sin(ang)
			orb.Color  = col2
			orb.CFrame = CFrame.new(bp.X + ca * GROUND_R, bp.Y - 2.8, bp.Z + sa * GROUND_R)
		end
	end)

	self._auraData = {
		folder    = folder,
		mainOrbs  = ringOrbs,
		innerOrbs = spiralOrbs,
		coreOrbs  = coreOrbs,
		groundOrbs = groundOrbs,
		emitter   = riseEmitter,
		glowEmitter = glowEmitter,
		conn      = conn,
	}
end

function VisualsModule:DestroyAura()
	if self._auraData then
		if self._auraData.conn then
			self._auraData.conn:Disconnect()
		end
		if self._auraData.folder and self._auraData.folder.Parent then
			self._auraData.folder:Destroy()
		end
		if self._auraData.emitter and self._auraData.emitter.Parent then
			self._auraData.emitter:Destroy()
		end
		if self._auraData.glowEmitter and self._auraData.glowEmitter.Parent then
			self._auraData.glowEmitter:Destroy()
		end
		self._auraData = nil
	end
end

function VisualsModule:ConnectJumpCircles()
	self:DisconnectJumpCircles()

	local wasGrounded = true
	local cooldown = 0

	local function hookChar(char)
		if self._jumpHumConn then
			pcall(function() self._jumpHumConn:Disconnect() end)
		end
		local hum = char:WaitForChild("Humanoid", 10)
		if not hum then return end
		wasGrounded = true; cooldown = 0

		self._jumpHumConn = hum.StateChanged:Connect(function(_, newState)
			if not self.JUMP_CIRCLES_ENABLED then return end
			if newState == Enum.HumanoidStateType.Jumping then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hrp and tick() > cooldown then
					cooldown = tick() + 0.3
					self:SpawnJumpCircle(hrp.Position - Vector3.new(0, 3, 0))
				end
			end
		end)

		if self._jumpPollConn then pcall(function() self._jumpPollConn:Disconnect() end) end
		self._jumpPollConn = self.RunService.Heartbeat:Connect(function()
			if not self.JUMP_CIRCLES_ENABLED then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local vel = hrp.AssemblyLinearVelocity
			local grounded = math.abs(vel.Y) < 1
			if wasGrounded and not grounded and vel.Y > 3 then
				if tick() > cooldown then
					cooldown = tick() + 0.3
					self:SpawnJumpCircle(hrp.Position - Vector3.new(0, 3, 0))
				end
			end
			wasGrounded = grounded
		end)
	end

	if self.player.Character then
		task.spawn(function() hookChar(self.player.Character) end)
	end
	self._jumpCharConn = self.player.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		hookChar(c)
	end)
end

function VisualsModule:DisconnectJumpCircles()
	if self._jumpHumConn then
		pcall(function() self._jumpHumConn:Disconnect() end)
		self._jumpHumConn = nil
	end
	if self._jumpPollConn then
		pcall(function() self._jumpPollConn:Disconnect() end)
		self._jumpPollConn = nil
	end
	if self._jumpCharConn then
		pcall(function() self._jumpCharConn:Disconnect() end)
		self._jumpCharConn = nil
	end
end

function VisualsModule:SpawnJumpCircle(position)
	local color = self.JUMP_CIRCLES_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcJumpCircle"
	folder.Parent = self.Workspace

	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Anchored = true
	ring.CanCollide = false
	ring.CanTouch = false
	ring.CanQuery = false
	ring.CastShadow = false
	ring.Material = Enum.Material.Neon
	ring.Color = color
	ring.Size = Vector3.new(0.06, 0.8, 0.8)
	ring.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	ring.Transparency = 0.2
	ring.Parent = folder

	local inner = Instance.new("Part")
	inner.Shape = Enum.PartType.Cylinder
	inner.Anchored = true
	inner.CanCollide = false
	inner.CanTouch = false
	inner.CanQuery = false
	inner.CastShadow = false
	inner.Material = Enum.Material.Neon
	inner.Color = color
	inner.Size = Vector3.new(0.04, 0.4, 0.4)
	inner.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	inner.Transparency = 0
	inner.Parent = folder

	local spark = Instance.new("Part")
	spark.Anchored = true
	spark.CanCollide = false
	spark.CanQuery = false
	spark.Transparency = 1
	spark.Size = Vector3.new(1, 1, 1)
	spark.CFrame = CFrame.new(position)
	spark.Parent = folder

	local emitter = Instance.new("ParticleEmitter")
	emitter.Color = ColorSequence.new(color)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	emitter.Lifetime = NumberRange.new(0.3, 0.6)
	emitter.Rate = 0
	emitter.Speed = NumberRange.new(3, 8)
	emitter.SpreadAngle = Vector2.new(360, 30)
	emitter.LightEmission = 1
	emitter.LightInfluence = 0
	emitter.Texture = "rbxassetid://6490035152"
	emitter.Parent = spark
	emitter:Emit(20)

	self.TweenService:Create(ring,
		TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.06, 7, 7), Transparency = 1}
	):Play()
	self.TweenService:Create(inner,
		TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.04, 4, 4), Transparency = 1}
	):Play()

	self.Debris:AddItem(folder, 1)
end

function VisualsModule:PlaySparkleFX(position)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcSparkleFX"
	folder.Parent = self.Workspace

	local base = Instance.new("Part")
	base.Anchored = true; base.CanCollide = false; base.CanQuery = false
	base.CanTouch = false; base.Transparency = 1
	base.Size = Vector3.new(1, 1, 1)
	base.CFrame = CFrame.new(position)
	base.Parent = folder

	local burst = Instance.new("ParticleEmitter")
	burst.Color = ColorSequence.new(col)
	burst.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.6),
		NumberSequenceKeypoint.new(0.4, 0.35),
		NumberSequenceKeypoint.new(1, 0),
	})
	burst.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.15),
		NumberSequenceKeypoint.new(1, 1),
	})
	burst.Lifetime = NumberRange.new(0.4, 1.0)
	burst.Speed = NumberRange.new(12, 28)
	burst.SpreadAngle = Vector2.new(360, 360)
	burst.Rate = 0
	burst.RotSpeed = NumberRange.new(-250, 250)
	burst.Rotation = NumberRange.new(-180, 180)
	burst.LightEmission = 1; burst.LightInfluence = 0
	burst.Texture = "rbxassetid://6490035152"
	burst.Parent = base
	burst:Emit(55)

	local shimmer = Instance.new("ParticleEmitter")
	shimmer.Color = ColorSequence.new(col)
	shimmer.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.18),
		NumberSequenceKeypoint.new(1, 0),
	})
	shimmer.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	shimmer.Lifetime = NumberRange.new(0.7, 1.4)
	shimmer.Speed = NumberRange.new(2, 7)
	shimmer.SpreadAngle = Vector2.new(360, 360)
	shimmer.Rate = 0
	shimmer.LightEmission = 1; shimmer.LightInfluence = 0
	shimmer.Texture = "rbxassetid://6490035152"
	shimmer.EmissionDirection = Enum.NormalId.Top
	shimmer.Parent = base
	shimmer:Emit(25)

	local flash = Instance.new("Part")
	flash.Shape = Enum.PartType.Ball
	flash.Anchored = true; flash.CanCollide = false
	flash.CanQuery = false; flash.CastShadow = false
	flash.Material = Enum.Material.Neon
	flash.Color = col
	flash.Size = Vector3.new(1.2, 1.2, 1.2)
	flash.CFrame = CFrame.new(position)
	flash.Transparency = 0.2
	flash.Parent = folder

	self.TweenService:Create(flash,
		TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(6, 6, 6), Transparency = 1}
	):Play()

	local light = Instance.new("PointLight")
	light.Color = col
	light.Range = 22
	light.Brightness = 3
	light.Parent = base
	self.TweenService:Create(light, TweenInfo.new(0.7), {Range = 0, Brightness = 0}):Play()

	self.Debris:AddItem(folder, 2)
end

function VisualsModule:PlayRingFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcRingFX"
	folder.Parent = self.Workspace

	local rings = {}
	local ringConfigs = {
		{tiltX = 0,  tiltZ = 0,  speed = 4.5, startSize = 2.5},
		{tiltX = 65, tiltZ = 25, speed = 3.5, startSize = 3.0},
		{tiltX = 25, tiltZ = 75, speed = 5.5, startSize = 2.0},
		{tiltX = 45, tiltZ = 45, speed = 2.8, startSize = 3.5},
	}

	for i, cfg in ipairs(ringConfigs) do
		local ring = Instance.new("Part")
		ring.Name = "Ring_" .. i
		ring.Shape = Enum.PartType.Cylinder
		ring.Anchored = true; ring.CanCollide = false
		ring.CanQuery = false; ring.CanTouch = false; ring.CastShadow = false
		ring.Material = Enum.Material.Neon
		ring.Color = col
		ring.Size = Vector3.new(0.05, cfg.startSize, cfg.startSize)
		ring.Transparency = 0.1
		ring.Parent = folder
		table.insert(rings, {part = ring, cfg = cfg})
	end

	local light = Instance.new("PointLight")
	light.Color = col
	light.Range = 26
	light.Brightness = 3
	light.Parent = rings[1].part

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon
					part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	local startT = tick()
	local conn
	conn = self.RunService.Heartbeat:Connect(function()
		local elapsed = tick() - startT
		if elapsed > 2.5 then conn:Disconnect(); return end

		for _, r in ipairs(rings) do
			local ring = r.part
			local cfg = r.cfg
			if ring and ring.Parent then
				local rot = elapsed * cfg.speed
				local sz = cfg.startSize + elapsed * 2
				ring.Size = Vector3.new(0.05, sz, sz)
				ring.CFrame = CFrame.new(position)
					* CFrame.Angles(math.rad(cfg.tiltX), rot, math.rad(cfg.tiltZ))
					* CFrame.Angles(0, 0, math.rad(90))
				ring.Transparency = 0.1 + math.clamp((elapsed - 1.2) / 1.3, 0, 0.9)
			end
		end
	end)

	self.TweenService:Create(light, TweenInfo.new(2.2), {Range = 0, Brightness = 0}):Play()
	self.Debris:AddItem(folder, 3.5)
end

function VisualsModule:PlayBeamFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcBeamFX"
	folder.Parent = self.Workspace

	local H = 65
	local midPos = position + Vector3.new(0, H / 2, 0)

	local beam = Instance.new("Part")
	beam.Name = "BeamOuter"
	beam.Anchored = true; beam.CanCollide = false
	beam.CanQuery = false; beam.CanTouch = false; beam.CastShadow = false
	beam.Material = Enum.Material.Neon
	beam.Color = col
	beam.Size = Vector3.new(3, H, 3)
	beam.CFrame = CFrame.new(midPos)
	beam.Transparency = 0.25
	beam.Parent = folder

	local inner = Instance.new("Part")
	inner.Name = "BeamInner"
	inner.Anchored = true; inner.CanCollide = false
	inner.CanQuery = false; inner.CanTouch = false; inner.CastShadow = false
	inner.Material = Enum.Material.Neon
	inner.Color = Color3.new(
		math.min(col.R * 1.3, 1),
		math.min(col.G * 1.3, 1),
		math.min(col.B * 1.3, 1)
	)
	inner.Size = Vector3.new(1, H, 1)
	inner.CFrame = CFrame.new(midPos)
	inner.Transparency = 0
	inner.Parent = folder

	local light = Instance.new("PointLight")
	light.Color = col
	light.Range = 40
	light.Brightness = 4.5
	light.Parent = inner

	local impactRing = Instance.new("Part")
	impactRing.Shape = Enum.PartType.Cylinder
	impactRing.Anchored = true; impactRing.CanCollide = false
	impactRing.CanQuery = false; impactRing.CanTouch = false; impactRing.CastShadow = false
	impactRing.Material = Enum.Material.Neon
	impactRing.Color = col
	impactRing.Size = Vector3.new(0.06, 2, 2)
	impactRing.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	impactRing.Transparency = 0.15
	impactRing.Parent = folder

	self.TweenService:Create(impactRing,
		TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.06, 16, 16), Transparency = 1}
	):Play()

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon
					part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	task.delay(0.4, function()
		if beam and beam.Parent then
			self.TweenService:Create(beam,
				TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Size = Vector3.new(0.15, H, 0.15), Transparency = 1}
			):Play()
		end
		if inner and inner.Parent then
			self.TweenService:Create(inner,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1}
			):Play()
		end
		if light then
			self.TweenService:Create(light, TweenInfo.new(0.7), {Range = 0, Brightness = 0}):Play()
		end
	end)

	self.Debris:AddItem(folder, 2)
end

function VisualsModule:PlayInfernoFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcInfernoFX"
	folder.Parent = self.Workspace

	local baseP = Instance.new("Part")
	baseP.Anchored = true; baseP.CanCollide = false
	baseP.CanQuery = false; baseP.CanTouch = false
	baseP.Transparency = 1
	baseP.Size = Vector3.new(1, 1, 1)
	baseP.CFrame = CFrame.new(position)
	baseP.Parent = folder

	local darkCol = Color3.new(col.R * 0.6, col.G * 0.6, col.B * 0.6)

	local fire = Instance.new("ParticleEmitter")
	fire.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, col),
		ColorSequenceKeypoint.new(0.5, Color3.new(
			math.min(col.R * 1.2, 1), math.min(col.G * 1.2, 1), math.min(col.B * 1.2, 1)
		)),
		ColorSequenceKeypoint.new(1, darkCol),
	})
	fire.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(0.3, 2.5),
		NumberSequenceKeypoint.new(0.7, 1.8),
		NumberSequenceKeypoint.new(1, 0),
	})
	fire.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.1),
		NumberSequenceKeypoint.new(0.4, 0.25),
		NumberSequenceKeypoint.new(1, 1),
	})
	fire.Lifetime = NumberRange.new(0.3, 0.8)
	fire.Rate = 70
	fire.Speed = NumberRange.new(6, 14)
	fire.SpreadAngle = Vector2.new(25, 25)
	fire.RotSpeed = NumberRange.new(-120, 120)
	fire.Rotation = NumberRange.new(-180, 180)
	fire.LightEmission = 1; fire.LightInfluence = 0
	fire.Texture = "rbxassetid://6490035152"
	fire.EmissionDirection = Enum.NormalId.Top
	fire.Parent = baseP

	local embers = Instance.new("ParticleEmitter")
	embers.Color = ColorSequence.new(col)
	embers.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(1, 0),
	})
	embers.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	embers.Lifetime = NumberRange.new(0.5, 1.4)
	embers.Rate = 30
	embers.Speed = NumberRange.new(6, 14)
	embers.SpreadAngle = Vector2.new(50, 50)
	embers.LightEmission = 1; embers.LightInfluence = 0
	embers.Texture = "rbxassetid://6490035152"
	embers.EmissionDirection = Enum.NormalId.Top
	embers.Parent = baseP

	local light = Instance.new("PointLight")
	light.Color = col
	light.Range = 28
	light.Brightness = 3.5
	light.Parent = baseP

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon
					part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	task.delay(0.8, function()
		if fire then fire.Rate = 0 end
		if embers then embers.Rate = 0 end
		if light and light.Parent then
			self.TweenService:Create(light, TweenInfo.new(0.8), {Range = 0, Brightness = 0}):Play()
		end
	end)

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:PlayVortexFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcVortexFX"
	folder.Parent = self.Workspace

	local base = Instance.new("Part")
	base.Anchored = true; base.CanCollide = false; base.CanQuery = false
	base.CanTouch = false; base.Transparency = 1
	base.Size = Vector3.new(1, 1, 1)
	base.CFrame = CFrame.new(position)
	base.Parent = folder

	local NUM_SPIRAL = 12
	local spiralParts = {}
	for i = 1, NUM_SPIRAL do
		local p = Instance.new("Part")
		p.Shape = Enum.PartType.Ball
		p.Anchored = true; p.CanCollide = false
		p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
		p.Material = Enum.Material.Neon
		p.Color = col
		p.Size = Vector3.new(0.5, 0.5, 0.5)
		p.Transparency = 0.2
		p.CFrame = CFrame.new(position)
		p.Parent = folder

		local a0 = Instance.new("Attachment"); a0.Parent = p
		local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, 0, 0.3); a1.Parent = p
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(col)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(1, 1),
		})
		trail.Lifetime = 0.4
		trail.FaceCamera = true
		trail.LightEmission = 0.8
		trail.Parent = p

		table.insert(spiralParts, p)
	end

	local light = Instance.new("PointLight")
	light.Color = col; light.Range = 24; light.Brightness = 3
	light.Parent = base

	local startT = tick()
	local conn
	conn = self.RunService.Heartbeat:Connect(function()
		local elapsed = tick() - startT
		if elapsed > 2.2 then conn:Disconnect(); return end

		local progress = math.clamp(elapsed / 2.2, 0, 1)
		local radius = 3 + elapsed * 1.5

		for i, p in ipairs(spiralParts) do
			if p and p.Parent then
				local baseAngle = (i / NUM_SPIRAL) * math.pi * 2
				local spin = elapsed * 6
				local angle = baseAngle + spin
				local h = (i / NUM_SPIRAL) * 6 * (1 - progress * 0.5)
				local r = radius * (1 - progress * 0.6)

				p.CFrame = CFrame.new(
					position.X + math.cos(angle) * r,
					position.Y + h - 1,
					position.Z + math.sin(angle) * r
				)
				p.Size = Vector3.new(0.5 - progress * 0.3, 0.5 - progress * 0.3, 0.5 - progress * 0.3)
				p.Transparency = 0.2 + progress * 0.8
			end
		end
	end)

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon
					part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	self.TweenService:Create(light, TweenInfo.new(2.0), {Range = 0, Brightness = 0}):Play()
	self.Debris:AddItem(folder, 3)
end

function VisualsModule:PlayShatterFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcShatterFX"
	folder.Parent = self.Workspace

	local NUM_SHARDS = 18
	for i = 1, NUM_SHARDS do
		local shard = Instance.new("Part")
		shard.Anchored = true; shard.CanCollide = false
		shard.CanQuery = false; shard.CanTouch = false; shard.CastShadow = false
		shard.Material = Enum.Material.Neon
		shard.Color = col
		local sx = math.random(3, 8) * 0.1
		local sy = math.random(5, 14) * 0.1
		local sz = math.random(1, 4) * 0.1
		shard.Size = Vector3.new(sx, sy, sz)
		shard.Transparency = 0.1
		shard.CFrame = CFrame.new(position)
			* CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
		shard.Parent = folder

		local dir = (CFrame.Angles(
			math.random() * math.pi * 2,
			math.random() * math.pi * 2, 0
		).LookVector) * (8 + math.random() * 10)

		local targetCF = CFrame.new(position + dir)
			* CFrame.Angles(math.random() * math.pi, math.random() * math.pi, 0)

		self.TweenService:Create(shard,
			TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{CFrame = targetCF}
		):Play()

		task.delay(0.5, function()
			if shard and shard.Parent then
				self.TweenService:Create(shard,
					TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1, Size = Vector3.new(0.05, 0.05, 0.05)}
				):Play()
			end
		end)
	end

	local flash = Instance.new("Part")
	flash.Shape = Enum.PartType.Ball
	flash.Anchored = true; flash.CanCollide = false
	flash.CanQuery = false; flash.CastShadow = false
	flash.Material = Enum.Material.Neon
	flash.Color = col
	flash.Size = Vector3.new(2, 2, 2)
	flash.CFrame = CFrame.new(position)
	flash.Transparency = 0
	flash.Parent = folder

	self.TweenService:Create(flash,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(5, 5, 5), Transparency = 1}
	):Play()

	local light = Instance.new("PointLight")
	light.Color = col; light.Range = 30; light.Brightness = 4
	light.Parent = flash
	self.TweenService:Create(light, TweenInfo.new(0.8), {Range = 0, Brightness = 0}):Play()

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon; part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:PlayNovaFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcNovaFX"
	folder.Parent = self.Workspace

	local shell = Instance.new("Part")
	shell.Shape = Enum.PartType.Ball
	shell.Anchored = true; shell.CanCollide = false
	shell.CanQuery = false; shell.CanTouch = false; shell.CastShadow = false
	shell.Material = Enum.Material.Neon
	shell.Color = col
	shell.Size = Vector3.new(0.5, 0.5, 0.5)
	shell.CFrame = CFrame.new(position)
	shell.Transparency = 0
	shell.Parent = folder

	self.TweenService:Create(shell,
		TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(18, 18, 18), Transparency = 0.95}
	):Play()

	local hRing = Instance.new("Part")
	hRing.Shape = Enum.PartType.Cylinder
	hRing.Anchored = true; hRing.CanCollide = false
	hRing.CanQuery = false; hRing.CastShadow = false
	hRing.Material = Enum.Material.Neon
	hRing.Color = col
	hRing.Size = Vector3.new(0.08, 1, 1)
	hRing.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	hRing.Transparency = 0.1
	hRing.Parent = folder

	self.TweenService:Create(hRing,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.08, 22, 22), Transparency = 1}
	):Play()

	local base = Instance.new("Part")
	base.Anchored = true; base.CanCollide = false; base.CanQuery = false
	base.CanTouch = false; base.Transparency = 1
	base.Size = Vector3.new(1, 1, 1)
	base.CFrame = CFrame.new(position)
	base.Parent = folder

	local pe = Instance.new("ParticleEmitter")
	pe.Color = ColorSequence.new(col)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 0),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Lifetime = NumberRange.new(0.5, 1.0)
	pe.Speed = NumberRange.new(15, 30)
	pe.SpreadAngle = Vector2.new(360, 360)
	pe.Rate = 0
	pe.LightEmission = 1; pe.LightInfluence = 0
	pe.Texture = "rbxassetid://6490035152"
	pe.Parent = base
	pe:Emit(40)

	local light = Instance.new("PointLight")
	light.Color = col; light.Range = 45; light.Brightness = 5
	light.Parent = base
	self.TweenService:Create(light, TweenInfo.new(1.0), {Range = 0, Brightness = 0}):Play()

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					part.Material = Enum.Material.Neon; part.Color = col
					self.TweenService:Create(part,
						TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{Transparency = 1}
					):Play()
				end)
			end
		end
	end

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:PlayCascadeFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcCascadeFX"
	folder.Parent = self.Workspace

	local pillarCount = 8
	local baseRadius = 4

	for i = 1, pillarCount do
		local angle = (i / pillarCount) * math.pi * 2
		local offset = Vector3.new(math.cos(angle) * baseRadius, 0, math.sin(angle) * baseRadius)
		local pillarPos = position + offset

		local pillar = Instance.new("Part")
		pillar.Anchored = true; pillar.CanCollide = false
		pillar.CanQuery = false; pillar.CanTouch = false; pillar.CastShadow = false
		pillar.Material = Enum.Material.Neon
		pillar.Color = col
		pillar.Size = Vector3.new(0.3, 0.1, 0.3)
		pillar.CFrame = CFrame.new(pillarPos.X, pillarPos.Y - 2, pillarPos.Z)
		pillar.Transparency = 0.2
		pillar.Shape = Enum.PartType.Block
		pillar.Parent = folder

		local delayTime = i * 0.06
		task.delay(delayTime, function()
			if not pillar or not pillar.Parent then return end
			self.TweenService:Create(pillar,
				TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{Size = Vector3.new(0.3, 14 + math.random() * 6, 0.3), CFrame = CFrame.new(pillarPos.X, pillarPos.Y + 5, pillarPos.Z)}
			):Play()

			task.delay(0.6, function()
				if not pillar or not pillar.Parent then return end
				self.TweenService:Create(pillar,
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1, Size = Vector3.new(0.05, 20, 0.05)}
				):Play()
			end)
		end)

		local glow = Instance.new("PointLight")
		glow.Color = col; glow.Range = 8; glow.Brightness = 3
		glow.Parent = pillar
	end

	local flash = Instance.new("Part")
	flash.Shape = Enum.PartType.Cylinder
	flash.Anchored = true; flash.CanCollide = false
	flash.CanQuery = false; flash.CastShadow = false
	flash.Material = Enum.Material.Neon
	flash.Color = col
	flash.Size = Vector3.new(0.08, 0.5, 0.5)
	flash.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	flash.Transparency = 0
	flash.Parent = folder

	self.TweenService:Create(flash,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.08, 20, 20), Transparency = 1}
	):Play()

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:PlayPlasmaFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcPlasmaFX"
	folder.Parent = self.Workspace

	local core = Instance.new("Part")
	core.Shape = Enum.PartType.Ball
	core.Anchored = true; core.CanCollide = false
	core.CanQuery = false; core.CanTouch = false; core.CastShadow = false
	core.Material = Enum.Material.Neon
	core.Color = col
	core.Size = Vector3.new(1, 1, 1)
	core.CFrame = CFrame.new(position)
	core.Transparency = 0
	core.Parent = folder

	local coreLight = Instance.new("PointLight")
	coreLight.Color = col; coreLight.Range = 35; coreLight.Brightness = 6
	coreLight.Parent = core

	self.TweenService:Create(core,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = Vector3.new(5, 5, 5)}
	):Play()

	task.delay(0.3, function()
		if not core or not core.Parent then return end
		self.TweenService:Create(core,
			TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{Size = Vector3.new(0.5, 0.5, 0.5), Transparency = 1}
		):Play()
	end)

	local boltCount = 6
	for i = 1, boltCount do
		task.delay(0.05 * i, function()
			local angle1 = math.random() * math.pi * 2
			local angle2 = math.random() * math.pi - math.pi / 2
			local endDir = Vector3.new(
				math.cos(angle1) * math.cos(angle2),
				math.sin(angle2),
				math.sin(angle1) * math.cos(angle2)
			)
			local boltLen = 8 + math.random() * 6

			local segs = 5
			local prevPt = position
			for s = 1, segs do
				local t = s / segs
				local idealPt = position + endDir * boltLen * t
				local jitter = Vector3.new(
					(math.random() - 0.5) * 2,
					(math.random() - 0.5) * 2,
					(math.random() - 0.5) * 2
				)
				local pt = (s == segs) and (position + endDir * boltLen) or (idealPt + jitter)

				local seg = Instance.new("Part")
				seg.Anchored = true; seg.CanCollide = false
				seg.CanQuery = false; seg.CanTouch = false; seg.CastShadow = false
				seg.Material = Enum.Material.Neon
				seg.Color = col
				local segLen = (pt - prevPt).Magnitude
				seg.Size = Vector3.new(0.12, 0.12, segLen)
				seg.CFrame = CFrame.lookAt((prevPt + pt) / 2, pt)
				seg.Transparency = 0.1
				seg.Parent = folder

				self.TweenService:Create(seg,
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{Transparency = 1, Size = Vector3.new(0.02, 0.02, segLen)}
				):Play()

				prevPt = pt
			end

			local tip = Instance.new("Part")
			tip.Shape = Enum.PartType.Ball
			tip.Anchored = true; tip.CanCollide = false
			tip.CanQuery = false; tip.CanTouch = false; tip.CastShadow = false
			tip.Material = Enum.Material.Neon
			tip.Color = col
			tip.Size = Vector3.new(0.8, 0.8, 0.8)
			tip.CFrame = CFrame.new(position + endDir * boltLen)
			tip.Transparency = 0
			tip.Parent = folder

			self.TweenService:Create(tip,
				TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}
			):Play()
		end)
	end

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:PlayReaperFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcReaperFX"
	folder.Parent = self.Workspace

	local slashCount = 3
	for i = 1, slashCount do
		local slash = Instance.new("Part")
		slash.Anchored = true; slash.CanCollide = false
		slash.CanQuery = false; slash.CanTouch = false; slash.CastShadow = false
		slash.Material = Enum.Material.Neon
		slash.Color = col
		slash.Size = Vector3.new(8, 0.08, 0.5)
		local rotAngle = (i - 1) * 60
		slash.CFrame = CFrame.new(position) * CFrame.Angles(
			math.rad(rotAngle + math.random(-15, 15)),
			math.rad(math.random(-30, 30)),
			math.rad(math.random(-20, 20))
		)
		slash.Transparency = 0.8
		slash.Parent = folder

		local targetSize = Vector3.new(12, 0.06, 0.15)
		self.TweenService:Create(slash,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Transparency = 0, Size = targetSize}
		):Play()

		task.delay(0.15, function()
			if not slash or not slash.Parent then return end
			self.TweenService:Create(slash,
				TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1, Size = Vector3.new(14, 0.02, 0.02)}
			):Play()
		end)
	end

	local base = Instance.new("Part")
	base.Anchored = true; base.CanCollide = false; base.CanQuery = false
	base.CanTouch = false; base.Transparency = 1
	base.Size = Vector3.new(1, 1, 1)
	base.CFrame = CFrame.new(position)
	base.Parent = folder

	local pe = Instance.new("ParticleEmitter")
	pe.Color = ColorSequence.new(col)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.4, 0.15),
		NumberSequenceKeypoint.new(1, 0),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Lifetime = NumberRange.new(0.4, 0.8)
	pe.Speed = NumberRange.new(4, 12)
	pe.SpreadAngle = Vector2.new(360, 360)
	pe.Rate = 0
	pe.LightEmission = 1; pe.LightInfluence = 0
	pe.Texture = "rbxassetid://6490035152"
	pe.Drag = 3
	pe.Parent = base
	pe:Emit(25)

	local darkCore = Instance.new("Part")
	darkCore.Shape = Enum.PartType.Ball
	darkCore.Anchored = true; darkCore.CanCollide = false
	darkCore.CanQuery = false; darkCore.CanTouch = false; darkCore.CastShadow = false
	darkCore.Material = Enum.Material.Neon
	darkCore.Color = Color3.new(0, 0, 0)
	darkCore.Size = Vector3.new(2, 2, 2)
	darkCore.CFrame = CFrame.new(position)
	darkCore.Transparency = 0.5
	darkCore.Parent = folder

	self.TweenService:Create(darkCore,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1}
	):Play()

	if victimChar then
		for _, part in pairs(victimChar:GetDescendants()) do
			if part:IsA("BasePart") then
				pcall(function()
					local stroke = Instance.new("SelectionBox")
					stroke.Adornee = part; stroke.Color3 = col
					stroke.LineThickness = 0.03; stroke.SurfaceTransparency = 0.9
					stroke.Parent = part
					self.TweenService:Create(stroke,
						TweenInfo.new(0.8), {SurfaceTransparency = 1}
					):Play()
					self.Debris:AddItem(stroke, 1)
				end)
			end
		end
	end

	self.Debris:AddItem(folder, 2.0)
end

function VisualsModule:PlayPixelFX(position, victimChar)
	local col = self.KILLFX_COLOR
	local folder = Instance.new("Folder")
	folder.Name = "ArcPixelFX"
	folder.Parent = self.Workspace

	local cubeCount = 24
	for i = 1, cubeCount do
		local cube = Instance.new("Part")
		cube.Shape = Enum.PartType.Block
		cube.Anchored = true; cube.CanCollide = false
		cube.CanQuery = false; cube.CanTouch = false; cube.CastShadow = false
		cube.Material = Enum.Material.Neon

		local shade = 0.6 + math.random() * 0.4
		cube.Color = Color3.new(col.R * shade, col.G * shade, col.B * shade)

		local s = 0.25 + math.random() * 0.5
		cube.Size = Vector3.new(s, s, s)

		local spread = 1.5
		cube.CFrame = CFrame.new(
			position.X + (math.random() - 0.5) * spread,
			position.Y + (math.random() - 0.5) * spread,
			position.Z + (math.random() - 0.5) * spread
		) * CFrame.Angles(math.random() * math.pi, math.random() * math.pi, math.random() * math.pi)
		cube.Transparency = 0
		cube.Parent = folder

		local targetDir = Vector3.new(
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2
		).Unit

		local dist = 4 + math.random() * 8
		local targetPos = position + targetDir * dist

		task.delay(math.random() * 0.15, function()
			if not cube or not cube.Parent then return end
			self.TweenService:Create(cube,
				TweenInfo.new(0.5 + math.random() * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					CFrame = CFrame.new(targetPos) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, 0),
					Transparency = 1,
					Size = Vector3.new(0.05, 0.05, 0.05),
				}
			):Play()
		end)
	end

	local flash = Instance.new("Part")
	flash.Shape = Enum.PartType.Ball
	flash.Anchored = true; flash.CanCollide = false
	flash.CanQuery = false; flash.CanTouch = false; flash.CastShadow = false
	flash.Material = Enum.Material.Neon
	flash.Color = col
	flash.Size = Vector3.new(2, 2, 2)
	flash.CFrame = CFrame.new(position)
	flash.Transparency = 0.3
	flash.Parent = folder

	self.TweenService:Create(flash,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(5, 5, 5), Transparency = 1}
	):Play()

	self.Debris:AddItem(folder, 2.5)
end

function VisualsModule:FixFxInstance(fx, cf)
	if fx:IsA("Model") then
		for _, d in ipairs(fx:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanQuery = false
				d.CanTouch = false
			end
		end
		fx:PivotTo(cf)
	elseif fx:IsA("BasePart") then
		fx.Anchored = true
		fx.CanCollide = false
		fx.CanQuery = false
		fx.CanTouch = false
		fx.CFrame = cf
	end
end

function VisualsModule:RecolorParticles(root, color)
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("ParticleEmitter") then
			d.Color = ColorSequence.new(color)
		end
	end
end

function VisualsModule:PlayImpactFX(position)
	local template = self.FX_ROOT:FindFirstChild("ImpactFX")
	if not template then return end

	local fx = template:Clone()
	self:FixFxInstance(fx, CFrame.new(position))
	fx.Parent = self.Workspace

	self:RecolorParticles(fx, self.KILLFX_COLOR)

	for _, d in ipairs(fx:GetDescendants()) do
		if d:IsA("ParticleEmitter") then
			d.Enabled = true
		end
	end

	task.delay(0.15, function()
		if fx and fx.Parent then
			for _, d in ipairs(fx:GetDescendants()) do
				if d:IsA("ParticleEmitter") then
					d.Enabled = false
				end
			end
		end
	end)

	self.Debris:AddItem(fx, 2)
end

function VisualsModule:PlayCustomFX(position)
	local template = self.FX_ROOT:FindFirstChild("CustomFX")
	if not template then return end

	local fx = template:Clone()
	self:FixFxInstance(fx, CFrame.new(position))
	fx.Parent = self.Workspace

	self:RecolorParticles(fx, self.KILLFX_COLOR)

	local light = fx:FindFirstChild("PointLight") or fx:FindFirstChildWhichIsA("PointLight", true)
	if light then
		light.Color = self.KILLFX_LIGHT_COLOR
		light.Range = 0
		light.Brightness = self.KILLFX_LIGHT_BRIGHTNESS
		light.Enabled = true

		local tIn = self.TweenService:Create(light, TweenInfo.new(self.KILLFX_CUSTOM_DURATION * 0.5, Enum.EasingStyle.Quad), { Range = self.KILLFX_LIGHT_RANGE })
		local tOut = self.TweenService:Create(light, TweenInfo.new(self.KILLFX_CUSTOM_DURATION * 0.5, Enum.EasingStyle.Quad), { Range = 0 })

		tIn:Play()
		tIn.Completed:Once(function()
			tOut:Play()
		end)
	end

	for _, d in ipairs(fx:GetDescendants()) do
		if d:IsA("ParticleEmitter") then
			d.Enabled = true
		end
	end

	task.delay(self.KILLFX_CUSTOM_DURATION, function()
		if fx and fx.Parent then
			for _, d in ipairs(fx:GetDescendants()) do
				if d:IsA("ParticleEmitter") then
					d.Enabled = false
				end
			end
		end
	end)

	self.Debris:AddItem(fx, 2)
end

-- ══════════════════════════════════════════════════════════════════
--  AUTO-DETECT ENGINE
--  Анализирует игру и автоматически подбирает:
--  • стиль трассеров (по скорости пуль, дистанции, FPS игры)
--  • хит-саунды (по атмосфере карты и типу оружий)
--  • хит-эффекты (по материалам карты и освещению)
--  • килл-эффекты (по общей атмосфере)
-- ══════════════════════════════════════════════════════════════════
function VisualsModule:AnalyzeGame()
	if self.AUTO_DETECT_DONE then return self._gameProfile end

	local ws      = self.Workspace
	local lighting = self.Lighting
	local rep     = self.ReplicatedStorage
	local profile = {
		-- Метрики карты
		mapBrightness  = 0,
		mapDarkness    = false,
		hasWater       = false,
		avgPartCount   = 0,
		dominantColor  = Color3.fromRGB(255, 65, 65),
		hasNeon        = false,
		-- Метрики игры
		gameStyle      = "default",   -- "sniper", "assault", "pistol", "hvh"
		mapMood        = "neutral",   -- "dark", "bright", "neon", "outdoor"
		-- Выбранные настройки
		tracerStyle    = "Classic",
		tracerColor    = Color3.fromRGB(255, 65, 65),
		tracerLifetime = 0.45,
		tracerWidth    = 0.12,
		hitSoundPreset = "bell",
		hitFXType      = "Sparkle",
		killFXType     = "Nova",
		killFXColor    = Color3.fromRGB(255, 65, 65),
	}

	pcall(function()
		-- Анализ освещения
		local amb   = lighting.Ambient
		local briB  = lighting.Brightness
		profile.mapBrightness = (amb.R + amb.G + amb.B) / 3 + briB
		profile.mapDarkness   = profile.mapBrightness < 0.4

		-- Поиск Neon-частей на карте
		local neonCount = 0
		local totalParts = 0
		local rCount, gCount, bCount = 0, 0, 0

		for _, obj in ipairs(ws:GetDescendants()) do
			if totalParts > 800 then break end
			if obj:IsA("BasePart") then
				totalParts = totalParts + 1
				if obj.Material == Enum.Material.Neon then
					neonCount = neonCount + 1
					rCount = rCount + obj.Color.R
					gCount = gCount + obj.Color.G
					bCount = bCount + obj.Color.B
				end
				if obj:IsA("Part") and obj.Shape == Enum.PartType.Ball then
					profile.hasWater = profile.hasWater
						or obj.Material == Enum.Material.Water
				end
			end
		end

		profile.avgPartCount = totalParts
		profile.hasNeon      = neonCount > 5

		if neonCount > 0 then
			profile.dominantColor = Color3.new(
				rCount / neonCount,
				gCount / neonCount,
				bCount / neonCount)
		end

		-- Анализ ReplicatedStorage: ищем конфигурации оружий
		local hasSSG, hasAWP, hasPistol = false, false, false
		for _, obj in ipairs(rep:GetDescendants()) do
			local n = obj.Name:lower()
			if n:find("ssg") or n:find("sniper") then hasSSG = true end
			if n:find("awp")  then hasAWP = true end
			if n:find("pistol") or n:find("glock") or n:find("deagle") then hasPistol = true end
		end

		if hasSSG or hasAWP then
			profile.gameStyle = "sniper"
		elseif hasPistol then
			profile.gameStyle = "pistol"
		else
			profile.gameStyle = "assault"
		end

		-- Определяем атмосферу карты
		if profile.hasNeon and profile.mapDarkness then
			profile.mapMood = "neon"
		elseif profile.mapDarkness then
			profile.mapMood = "dark"
		elseif profile.mapBrightness > 1.5 then
			profile.mapMood = "outdoor"
		else
			profile.mapMood = "neutral"
		end
	end)

	-- ── Подбор трассеров ────────────────────────────────────────
	if profile.mapMood == "neon" then
		profile.tracerStyle    = "Lightning"
		profile.tracerColor    = profile.dominantColor
		profile.tracerLifetime = 0.35
		profile.tracerWidth    = 0.10
	elseif profile.mapMood == "dark" then
		profile.tracerStyle    = "Helix"
		profile.tracerColor    = Color3.fromRGB(255, 50, 50)
		profile.tracerLifetime = 0.55
		profile.tracerWidth    = 0.14
	elseif profile.gameStyle == "sniper" then
		profile.tracerStyle    = "Razor"
		profile.tracerColor    = Color3.fromRGB(255, 200, 80)
		profile.tracerLifetime = 0.5
		profile.tracerWidth    = 0.08
	elseif profile.mapMood == "outdoor" then
		profile.tracerStyle    = "Comet"
		profile.tracerColor    = Color3.fromRGB(100, 200, 255)
		profile.tracerLifetime = 0.4
		profile.tracerWidth    = 0.11
	else
		profile.tracerStyle    = "Pulse"
		profile.tracerColor    = Color3.fromRGB(255, 65, 65)
		profile.tracerLifetime = 0.45
		profile.tracerWidth    = 0.12
	end

	-- ── Подбор хит-саунда ───────────────────────────────────────
	if profile.gameStyle == "sniper" then
		profile.hitSoundPreset = "headshot"
	elseif profile.mapMood == "neon" then
		profile.hitSoundPreset = "orb"
	elseif profile.mapMood == "dark" then
		profile.hitSoundPreset = "tank1"
	elseif profile.mapMood == "outdoor" then
		profile.hitSoundPreset = "bell"
	else
		profile.hitSoundPreset = "bell"
	end

	-- ── Подбор хит-эффекта ──────────────────────────────────────
	-- (HitMarker color + hitlog accent)
	if profile.mapMood == "neon" then
		profile.hitFXType = "Plasma"
	elseif profile.mapMood == "dark" then
		profile.hitFXType = "Reaper"
	elseif profile.gameStyle == "sniper" then
		profile.hitFXType = "Shatter"
	else
		profile.hitFXType = "Nova"
	end

	-- ── Подбор килл-эффекта ─────────────────────────────────────
	if profile.mapMood == "neon" then
		profile.killFXType  = "Plasma"
		profile.killFXColor = profile.dominantColor
	elseif profile.mapMood == "dark" then
		profile.killFXType  = "Vortex"
		profile.killFXColor = Color3.fromRGB(120, 0, 180)
	elseif profile.gameStyle == "sniper" then
		profile.killFXType  = "Shatter"
		profile.killFXColor = Color3.fromRGB(255, 200, 80)
	elseif profile.mapMood == "outdoor" then
		profile.killFXType  = "Cascade"
		profile.killFXColor = Color3.fromRGB(80, 200, 255)
	else
		profile.killFXType  = "Nova"
		profile.killFXColor = Color3.fromRGB(255, 65, 65)
	end

	self._gameProfile     = profile
	self.AUTO_DETECT_DONE = true
	return profile
end

function VisualsModule:ApplyAutoDetect()
	if not self.AUTO_DETECT_ENABLED then return end

	task.spawn(function()
		task.wait(3) -- Ждём загрузки карты
		local p = self:AnalyzeGame()
		if not p then return end

		-- Применяем трассеры
		self.TRACER_STYLE    = p.tracerStyle
		self.TRACER_COLOR    = p.tracerColor
		self.TRACER_LIFETIME = p.tracerLifetime
		self.TRACER_WIDTH    = p.tracerWidth

		-- Применяем хит-саунд
		self.HITSOUND_PRESET = p.hitSoundPreset

		-- Применяем килл-эффект
		self.KILLFX_TYPE  = p.killFXType
		self.KILLFX_COLOR = p.killFXColor

		-- Обновляем цвет маркеров
		if self._hitMarkerColor then
			self._hitMarkerColor = p.tracerColor
		end

		pcall(function()
			local mood = p.mapMood
			local style = p.gameStyle
			local moodStr = mood == "neon" and "неон" or
				mood == "dark" and "темная" or
				mood == "outdoor" and "открытая" or "нейтральная"
			local styleStr = style == "sniper" and "снайпер" or
				style == "pistol" and "пистолет" or "автомат"

			if self.Notification then
				self.Notification(
					"Eclipse Auto-Detect",
					"Карта: " .. moodStr .. " • Стиль: " .. styleStr ..
					"\nТрассер: " .. p.tracerStyle ..
					" • Эффект: " .. p.killFXType
				)
			end
		end)
	end)
end

function VisualsModule:SetupKillFXListener()
	local InfEvent = self.ReplicatedStorage:WaitForChild("inf", 10)
	if InfEvent then
		InfEvent.OnClientEvent:Connect(function(killedPlayerName)
			-- Kill banner (always, independent of FX toggle)
			self:ShowKillBanner(killedPlayerName, 0, 0)

			if not self.KILLFX_ENABLED then return end

			local killedPlayer = self.Players:FindFirstChild(killedPlayerName)
			if not killedPlayer then return end

			local char = killedPlayer.Character
			if not char then return end

			local head = char:FindFirstChild("Head")
			if not head then return end

			local pos = head.Position
			if self.KILLFX_TYPE == "Sparkle" then
				self:PlaySparkleFX(pos)
			elseif self.KILLFX_TYPE == "Ring" then
				self:PlayRingFX(pos, char)
			elseif self.KILLFX_TYPE == "Beam" then
				self:PlayBeamFX(pos, char)
			elseif self.KILLFX_TYPE == "Inferno" then
				self:PlayInfernoFX(pos, char)
			elseif self.KILLFX_TYPE == "Vortex" then
				self:PlayVortexFX(pos, char)
			elseif self.KILLFX_TYPE == "Shatter" then
				self:PlayShatterFX(pos, char)
			elseif self.KILLFX_TYPE == "Nova" then
				self:PlayNovaFX(pos, char)
			elseif self.KILLFX_TYPE == "Cascade" then
				self:PlayCascadeFX(pos, char)
			elseif self.KILLFX_TYPE == "Plasma" then
				self:PlayPlasmaFX(pos, char)
			elseif self.KILLFX_TYPE == "Reaper" then
				self:PlayReaperFX(pos, char)
			elseif self.KILLFX_TYPE == "Pixel" then
				self:PlayPixelFX(pos, char)
			end
		end)
	end

	task.spawn(function()
		local htl = self.ReplicatedStorage:WaitForChild("htl", 10)
		if not htl then return end

		htl.OnClientEvent:Connect(function(hitType, info)
			if hitType == "Hit" then
				self:PlayHitSound()
				self:FlashHitMarker()
			end

			if info and info.player then
				local targetPlr = Services and Services.Players:FindFirstChild(tostring(info.player))
				if targetPlr then
					if hitType == "Hit" and self._resolverOnHit then
						pcall(self._resolverOnHit, targetPlr)
					elseif hitType == "Miss" and self._resolverOnMiss then
						pcall(self._resolverOnMiss, targetPlr)
					end
				end
			end

			if hitType == "Hit" and info then
				local dmg = info.damage or 0
				if dmg > 99 then
					local victimName = tostring(info.playerName or info.player or "")
					local dist = info.distance or 0
					self:ShowKillBanner(victimName, dmg, dist)
					if self.KILLIMAGE_ENABLED then
						self:PlayKillImage()
					end
				end
			end

			if self.HITLOG_ENABLED then
				self:ShowHitlog(hitType, info)
			end
		end)
	end)
end

function VisualsModule:IsFakeLagEnabledFallback()
	if typeof(self.IsFakeLagEnabled) == "function" then
		local ok, v = pcall(self.IsFakeLagEnabled)
		if ok then return v == true end
	end
	if _G.ConfigSystem and _G.ConfigSystem.settings then
		return _G.ConfigSystem.settings["FakeLag"] == true
	end
	return false
end

function VisualsModule:SetupBacktrackGhost()
	local backtrackRemote = self.ReplicatedStorage:WaitForChild("btl", 10)
	if not backtrackRemote then return end
	local lastSend = 0

	local ghostsFolder = self.Workspace:FindFirstChild("BacktrackGhosts") or Instance.new("Folder", self.Workspace)
	ghostsFolder.Name = "BacktrackGhosts"
	self._ghostsFolder = ghostsFolder

	self.RunService.Heartbeat:Connect(function()
		local now = tick()
		local dt = now - self._hbLast
		self._hbLast = now
		self._ghostDt = dt

		if self.ghostModel and now > self.ghostExpireAt then
			self:ClearBacktrackGhost()
		end

		if self.BACKTRACK_GHOST_ENABLED and self.player.Character then
			local hrp = self.player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				if now - lastSend > 0.05 then
					lastSend = now
					backtrackRemote:FireServer(self:IsFakeLagEnabledFallback())
				end
			end
		end
	end)

	backtrackRemote.OnClientEvent:Connect(function(cframe, isFakelag, ping)
		if not self.BACKTRACK_GHOST_ENABLED then return end

		if not isFakelag and ping then
			local char = self.player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local velocity = hrp.AssemblyLinearVelocity
					local pingOffset = velocity * (ping * 0.5)
					cframe = hrp.CFrame - pingOffset
				end
			end
		end

		self:UpdateBacktrackGhostPose(cframe, isFakelag)
	end)

	self.player.CharacterAdded:Connect(function()
		self:ClearBacktrackGhost()
	end)

	self.player.CharacterRemoving:Connect(function()
		self:ClearBacktrackGhost()
	end)
end

function VisualsModule:ClearBacktrackGhost()
	if self.ghostModel then
		self.ghostModel:Destroy()
		self.ghostModel = nil
		table.clear(self.ghostParts)
		table.clear(self.ghostLastCFrames)
	end
	self.sourceCharacter = nil
	self.lastFakeLagState = nil
end

function VisualsModule:CreateBacktrackGhost()
	local srcChar = self.player.Character
	if not srcChar then return nil end

	local root = srcChar:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	srcChar.Archivable = true
	local ghost = srcChar:Clone()
	srcChar.Archivable = false
	if not ghost then return nil end

	ghost.Name = self.player.Name .. "_BacktrackGhost"

	for _, v in pairs(ghost:GetDescendants()) do
		if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("Sound")
			or v:IsA("BillboardGui") or v:IsA("Humanoid")
			or v:IsA("AlignPosition") or v:IsA("AlignOrientation")
			or v:IsA("BodyMover") or v:IsA("BodyGyro") or v:IsA("BodyVelocity")
			or v:IsA("BodyPosition") or v:IsA("BodyForce") or v:IsA("VectorForce")
			or v:IsA("LineForce") or v:IsA("Animator") then
			v:Destroy()
		end
	end

	for _, v in pairs(ghost:GetDescendants()) do
		if v:IsA("Motor6D") or v:IsA("Weld") or v:IsA("WeldConstraint")
			or v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint")
			or v:IsA("Constraint") or v:IsA("JointInstance") then
			v:Destroy()
		end
	end

	local hasParts = false
	local col = self.BACKTRACK_GHOST_COLOR
	for _, v in pairs(ghost:GetDescendants()) do
		if v:IsA("BasePart") then
			hasParts = true
			v.Anchored = true
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true
			v.Material = Enum.Material.Neon
			v.Transparency = self.GHOST_BASE_TRANSPARENCY
			v.Color = col
			v.CastShadow = false

			if v.Name == "Head" then
				local face = v:FindFirstChild("face")
				if face then face:Destroy() end
			end

			local selBox = Instance.new("SelectionBox")
			selBox.Adornee = v
			selBox.Color3 = col
			selBox.LineThickness = 0.02
			selBox.Transparency = 0.5
			selBox.SurfaceTransparency = 0.85
			selBox.SurfaceColor3 = col
			selBox.Parent = v
		end
	end

	if not hasParts then
		ghost:Destroy()
		return nil
	end

	table.clear(self.ghostParts)
	for _, v in ipairs(ghost:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(self.ghostParts, v)
		end
	end

	local rootP = ghost:FindFirstChild("HumanoidRootPart")
	if rootP then
		local glow = Instance.new("PointLight")
		glow.Color = col
		glow.Range = 6
		glow.Brightness = 0.4
		glow.Parent = rootP
	end

	ghost.Parent = self._ghostsFolder
	return ghost
end

function VisualsModule:UpdateBacktrackGhostPose(targetCFrame, isFakelag)
	if not self.BACKTRACK_GHOST_ENABLED then return end

	local srcChar = self.player.Character
	if not srcChar then return end

	local humanoid = srcChar:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		self:ClearBacktrackGhost()
		return
	end

	if (not self.ghostModel) or (self.sourceCharacter ~= srcChar) or (self.lastFakeLagState ~= isFakelag) or (not self.ghostModel.Parent) then
		self:ClearBacktrackGhost()
		self.ghostModel = self:CreateBacktrackGhost()
		if self.ghostModel then
			self.sourceCharacter = srcChar
			self.lastFakeLagState = isFakelag
		else
			return
		end
	end

	local srcRoot = srcChar:FindFirstChild("HumanoidRootPart")
	if not srcRoot then return end

	local currentRootCFrame = srcRoot.CFrame
	local offset = targetCFrame * currentRootCFrame:Inverse()

	local dt = tonumber(self._ghostDt) or (1 / 60)
	local alpha = math.clamp(self.GHOST_SMOOTH_SPEED * dt, 0, 1)

for _, ghostPart in ipairs(self.ghostParts) do
	local srcPart = srcChar:FindFirstChild(ghostPart.Name, true)
	if srcPart then
		local targetCF = offset * srcPart.CFrame
		local lastCF = self.ghostLastCFrames[ghostPart] or ghostPart.CFrame
		local newCF = lastCF:Lerp(targetCF, alpha)
		ghostPart.CFrame = newCF
		self.ghostLastCFrames[ghostPart] = newCF

		local dist = (newCF.Position - srcPart.Position).Magnitude

		if dist < self.GHOST_FADE_RADIUS then
			local k = math.clamp(1 - (dist / self.GHOST_FADE_RADIUS), 0, 1)
			k = k ^ self.GHOST_FADE_POWER
			ghostPart.Transparency = math.clamp(
				self.GHOST_BASE_TRANSPARENCY + k * (1 - self.GHOST_BASE_TRANSPARENCY),
				0,
				1
			)
		else
			ghostPart.Transparency = self.GHOST_BASE_TRANSPARENCY
		end
	end
end

	self.ghostExpireAt = tick() + self.BACKTRACK_GHOST_DURATION
end

function VisualsModule:SnapshotFirstEffect(className)
	local inst = self.Lighting:FindFirstChildOfClass(className)
	if not inst then return nil end
	local c = inst:Clone()
	c.Name = "NemesisOriginal_" .. className
	return c
end

function VisualsModule:WipeClass(className)
	for _, inst in ipairs(self.Lighting:GetDescendants()) do
		if inst.ClassName == className then
			inst:Destroy()
		end
	end
	for _, inst in ipairs(self.Lighting:GetChildren()) do
		if inst.ClassName == className then
			inst:Destroy()
		end
	end
end

function VisualsModule:ApplySingleEffect(className, enabled, applyFn)
	if enabled then
		self:WipeClass(className)
		local fx = Instance.new(className)
		fx.Name = "Nemesis_" .. className
		fx.Parent = self.Lighting
		applyFn(fx)
	else
		self:WipeClass(className)
		local original = self.ORIGINAL_EFFECTS[className]
		if original then
			original:Clone().Parent = self.Lighting
		end
	end
end

function VisualsModule:UpdateAtmosphere()
	self:ApplySingleEffect("Atmosphere", self.ATMOSPHERE_ENABLED, function(atmosphere)
		atmosphere.Density = self.ATMOSPHERE_DENSITY
		atmosphere.Offset = self.ATMOSPHERE_OFFSET
		atmosphere.Color = self.ATMOSPHERE_COLOR
		atmosphere.Decay = self.ATMOSPHERE_DECAY
		atmosphere.Glare = self.ATMOSPHERE_GLARE
		atmosphere.Haze = self.ATMOSPHERE_HAZE
	end)
end

function VisualsModule:SetAtmosphereEnabled(value)
	self.ATMOSPHERE_ENABLED = value
	self:UpdateAtmosphere()
end

function VisualsModule:SetAtmosphereDensity(value)
	self.ATMOSPHERE_DENSITY = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:SetAtmosphereOffset(value)
	self.ATMOSPHERE_OFFSET = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:SetAtmosphereColor(value)
	self.ATMOSPHERE_COLOR = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:SetAtmosphereDecay(value)
	self.ATMOSPHERE_DECAY = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:SetAtmosphereGlare(value)
	self.ATMOSPHERE_GLARE = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:SetAtmosphereHaze(value)
	self.ATMOSPHERE_HAZE = value
	if self.ATMOSPHERE_ENABLED then self:UpdateAtmosphere() end
end

function VisualsModule:UpdateBloom()
	self:ApplySingleEffect("BloomEffect", self.BLOOM_ENABLED, function(bloom)
		bloom.Enabled = true
		bloom.Intensity = self.BLOOM_INTENSITY
		bloom.Size = self.BLOOM_SIZE
		bloom.Threshold = self.BLOOM_THRESHOLD
	end)
end

function VisualsModule:SetBloomEnabled(value)
	self.BLOOM_ENABLED = value
	self:UpdateBloom()
end

function VisualsModule:SetBloomIntensity(value)
	self.BLOOM_INTENSITY = value
	if self.BLOOM_ENABLED then self:UpdateBloom() end
end

function VisualsModule:SetBloomSize(value)
	self.BLOOM_SIZE = value
	if self.BLOOM_ENABLED then self:UpdateBloom() end
end

function VisualsModule:SetBloomThreshold(value)
	self.BLOOM_THRESHOLD = value
	if self.BLOOM_ENABLED then self:UpdateBloom() end
end

function VisualsModule:UpdateColorCorrection()
	self:ApplySingleEffect("ColorCorrectionEffect", self.COLOR_CORRECTION_ENABLED, function(cc)
		cc.Brightness = self.COLOR_CORRECTION_BRIGHTNESS
		cc.Contrast = self.COLOR_CORRECTION_CONTRAST
		cc.Saturation = self.COLOR_CORRECTION_SATURATION
		cc.TintColor = self.COLOR_CORRECTION_TINT
	end)
end

function VisualsModule:SetColorCorrectionEnabled(value)
	self.COLOR_CORRECTION_ENABLED = value
	self:UpdateColorCorrection()
end

function VisualsModule:SetColorCorrectionBrightness(value)
	self.COLOR_CORRECTION_BRIGHTNESS = value
	if self.COLOR_CORRECTION_ENABLED then self:UpdateColorCorrection() end
end

function VisualsModule:SetColorCorrectionContrast(value)
	self.COLOR_CORRECTION_CONTRAST = value
	if self.COLOR_CORRECTION_ENABLED then self:UpdateColorCorrection() end
end

function VisualsModule:SetColorCorrectionSaturation(value)
	self.COLOR_CORRECTION_SATURATION = value
	if self.COLOR_CORRECTION_ENABLED then self:UpdateColorCorrection() end
end

function VisualsModule:SetColorCorrectionTint(value)
	self.COLOR_CORRECTION_TINT = value
	if self.COLOR_CORRECTION_ENABLED then self:UpdateColorCorrection() end
end

function VisualsModule:SetHitlogEnabled(value)
	self.HITLOG_ENABLED = value
	if self.hitlogContainer then
		self.hitlogContainer.Visible = value
	end
end

function VisualsModule:SetHitSoundEnabled(value)
	self.HITSOUND_ENABLED = value
end

function VisualsModule:SetHitSoundPreset(value)
	self.HITSOUND_PRESET = value
end

function VisualsModule:SetHitSoundVolume(value)
	self.HITSOUND_VOLUME = value
end

function VisualsModule:SetTracerEnabled(value)
	self.TRACER_ENABLED = value
end

function VisualsModule:SetTracerColor(value)
	self.TRACER_COLOR = value
end

function VisualsModule:SetTracerLifetime(value)
	self.TRACER_LIFETIME = value
end

function VisualsModule:SetTracerWidth(value)
	self.TRACER_WIDTH = value
end

function VisualsModule:SetTracerStyle(value)
	self.TRACER_STYLE = value
end

function VisualsModule:SetTracerNeon(value)
	self.TRACER_NEON = value
	if value then
		self.TRACER_BRIGHTNESS = 40
		self.TRACER_LIGHTEMISSION = 1
		self.TRACER_LIGHTINFLUENCE = 0
	else
		self.TRACER_BRIGHTNESS = 20
		self.TRACER_LIGHTEMISSION = 1
		self.TRACER_LIGHTINFLUENCE = 0.95
	end
end

function VisualsModule:SetChinaHatMaterial(value)
	self.CHINA_HAT_MATERIAL = value
	local mat = Enum.Material[value] or Enum.Material.Neon
	for _, p in ipairs(self._chinaHatParts) do
		pcall(function()
			if p:IsA("SpecialMesh") then return end
			-- ConeHandleAdornment нет Material, применяем к частям если используем Parts
		end)
	end
	-- Пересоздаём с новым материалом
	if self.CHINA_HAT_ENABLED then self:SpawnChinaHat() end
end

function VisualsModule:SetChinaHatSize(value)
	self.CHINA_HAT_SIZE = value
	if self.CHINA_HAT_ENABLED then self:SpawnChinaHat() end
end

function VisualsModule:SetChinaHatSpeed(value)
	self.CHINA_HAT_SPEED = value
end

function VisualsModule:SetWingsMaterial(value)
	self.WINGS_MATERIAL = value
	if self.WINGS_ENABLED then self:SpawnWings() end
end

function VisualsModule:SetChinaHatEnabled(value)
	self.CHINA_HAT_ENABLED = value
	if value then
		self:SpawnChinaHat()
	else
		self:DestroyChinaHat()
	end
end

function VisualsModule:SetChinaHatColor(value)
	self.CHINA_HAT_COLOR = value
	for _, p in ipairs(self._chinaHatParts) do
		if p and p.Parent then
			if p:IsA("ConeHandleAdornment") then
				p.Color3 = value
				-- Update outline to be darker version
				if p.Name == "ChinaHat_Outline" then
					p.Color3 = Color3.new(
						math.max(value.R * 0.6, 0),
						math.max(value.G * 0.6, 0),
						math.max(value.B * 0.6, 0)
					)
				end
			end
		end
	end
end

function VisualsModule:SetWingsEnabled(value)
	self.WINGS_ENABLED = value
	if value then
		self:SpawnWings()
	else
		self:DestroyWings()
	end
end

function VisualsModule:SetWingsColor(value)
	self.WINGS_COLOR = value
	if self._wingData then
		for _, p in ipairs(self._wingData.allParts) do
			if p and p.Parent then
				if not p:IsA("Part") or p.Transparency < 1 then
					pcall(function() p.Color = value end)
				end
			end
		end
		for _, trail in ipairs(self._wingData.allTrails) do
			trail.Color = ColorSequence.new(value)
		end
		if self._wingData.glow then self._wingData.glow.Color = value end
		if self._wingData.particles then
			self._wingData.particles.Color = ColorSequence.new(value)
		end
	end
end

function VisualsModule:SetAuraEnabled(value)
	self.AURA_ENABLED = value
	if value then self:SpawnAura() else self:DestroyAura() end
end

function VisualsModule:SetAuraColor(value)
	self.AURA_COLOR = value
	-- Цвет обновляется живьём в Heartbeat через self.AURA_COLOR
	-- Обновляем частицы сразу
	if self._auraData then
		local cs = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   value),
			ColorSequenceKeypoint.new(0.5, Color3.new(
				math.min(value.R + 0.3, 1),
				math.min(value.G + 0.3, 1),
				math.min(value.B + 0.3, 1))),
			ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),
		})
		if self._auraData.emitter and self._auraData.emitter.Parent then
			self._auraData.emitter.Color = cs
		end
		if self._auraData.glowEmitter and self._auraData.glowEmitter.Parent then
			self._auraData.glowEmitter.Color = cs
		end
	end
end

function VisualsModule:SetAuraMaterial(value)
	self.AURA_MATERIAL = value
	if self.AURA_ENABLED then self:SpawnAura() end
end

function VisualsModule:SetJumpCirclesEnabled(value)
	self.JUMP_CIRCLES_ENABLED = value
	if value then
		self:ConnectJumpCircles()
	else
		self:DisconnectJumpCircles()
	end
end

function VisualsModule:SetJumpCirclesColor(value)
	self.JUMP_CIRCLES_COLOR = value
end

function VisualsModule:SetHitMarkerEnabled(value)
	self.HIT_MARKER_ENABLED = value
end

function VisualsModule:SetNeonPlayerEnabled(value)
	self.NEON_PLAYER_ENABLED = value
	if value then
		self:ApplyNeonPlayer()
	else
		self:RemoveNeonPlayer()
	end
end

function VisualsModule:SetNeonPlayerColor(value)
	self.NEON_PLAYER_COLOR = value
	if self.NEON_PLAYER_ENABLED then
		self:ApplyNeonPlayer()
	end
end

function VisualsModule:ApplyNeonPlayer()
	self:RemoveNeonPlayer()
	local char = self.player.Character
	if not char then return end
	local col = self.NEON_PLAYER_COLOR

	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			self._origMaterials[v] = v.Material
			v.Material = Enum.Material.Neon
			v.Color = col
		end
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local glow = Instance.new("PointLight")
		glow.Name = "ArcNeonGlow"
		glow.Color = col
		glow.Range = 14
		glow.Brightness = 1.2
		glow.Parent = hrp
		self._neonGlow = glow
	end

	-- Применяем один раз, не каждый кадр
	for v, _ in pairs(self._origMaterials) do
		if v and v.Parent then
			v.Material = Enum.Material.Neon
			v.Color    = col
		end
	end

	-- Следим за удалением персонажа
	if self._neonConn then
		pcall(function() self._neonConn:Disconnect() end)
	end
	self._neonConn = char.AncestryChanged:Connect(function()
		if not char.Parent then self:RemoveNeonPlayer() end
	end)

	if not self._neonCharConn then
		self._neonCharConn = self.player.CharacterAdded:Connect(function()
			task.wait(0.5)
			if self.NEON_PLAYER_ENABLED then self:ApplyNeonPlayer() end
		end)
	end
end

function VisualsModule:RemoveNeonPlayer()
	if self._neonConn then
		pcall(function() self._neonConn:Disconnect() end)
		self._neonConn = nil
	end
	if self._neonGlow and self._neonGlow.Parent then
		self._neonGlow:Destroy()
		self._neonGlow = nil
	end
	for v, origMat in pairs(self._origMaterials) do
		pcall(function()
			if v and v.Parent then v.Material = origMat end
		end)
	end
	self._origMaterials = {}
end

function VisualsModule:SetWallbangEnabled(value)
	self.WALLBANG_ENABLED = value
end

function VisualsModule:SetWallbangEntryColor(value)
	self.WALLBANG_ENTRY_COLOR = value
end

function VisualsModule:SetWallbangExitColor(value)
	self.WALLBANG_EXIT_COLOR = value
end

function VisualsModule:SetWallbangMarkerSize(value)
	if typeof(value) == "number" then
		self.WALLBANG_MARKER_SIZE = Vector3.new(value, value, value)
	elseif typeof(value) == "Vector3" then
		self.WALLBANG_MARKER_SIZE = value
	end
end

function VisualsModule:SetWallbangLifetime(value)
	self.WALLBANG_LIFETIME = value
end

function VisualsModule:SetKillFXEnabled(value)
	self.KILLFX_ENABLED = value
end

function VisualsModule:SetKillFXType(value)
	self.KILLFX_TYPE = value
end

function VisualsModule:SetKillFXColor(value)
	self.KILLFX_COLOR = value
end

function VisualsModule:SetAutoDetectEnabled(value)
	self.AUTO_DETECT_ENABLED = value
	if value then
		self.AUTO_DETECT_DONE = false  -- сброс чтобы переанализировать
		self:ApplyAutoDetect()
	end
end

function VisualsModule:RerunAutoDetect()
	self.AUTO_DETECT_DONE = false
	self:ApplyAutoDetect()
end

function VisualsModule:SetKillFXLightColor(value)
	self.KILLFX_LIGHT_COLOR = value
end

function VisualsModule:SetKillFXDuration(value)
	self.KILLFX_CUSTOM_DURATION = value
end

function VisualsModule:SetKillFXLightRange(value)
	self.KILLFX_LIGHT_RANGE = value
end

function VisualsModule:SetKillFXLightBrightness(value)
	self.KILLFX_LIGHT_BRIGHTNESS = value
end

function VisualsModule:SetOffscreenEnabled(value)
	self.OFFSCREEN_ENABLED = value
end

function VisualsModule:SetOffscreenColor(value)
	self.OFFSCREEN_COLOR = value
	-- обновляем цвет стрелок живьём
	if self.arrows then
		for _, d in pairs(self.arrows) do
			pcall(function()
				d.chevL.BackgroundColor3 = value
				d.chevR.BackgroundColor3 = value
				d.dot.BackgroundColor3   = value
				d.hpFill.BackgroundColor3 = value
			end)
		end
	end
end

function VisualsModule:SetBacktrackGhostEnabled(value)
	self.BACKTRACK_GHOST_ENABLED = value
	if not value then
		self:ClearBacktrackGhost()
	end
end

function VisualsModule:SetBacktrackGhostColor(value)
	self.BACKTRACK_GHOST_COLOR = value
	if self.ghostModel then
		for _, p in ipairs(self.ghostModel:GetDescendants()) do
			if p:IsA("BasePart") then
				pcall(function()
					p.Color       = value
					p.Transparency = self.GHOST_BASE_TRANSPARENCY
				end)
			end
		end
	end
end

function VisualsModule:SetBacktrackGhostDuration(value)
	self.BACKTRACK_GHOST_DURATION = value
end

function VisualsModule:SetKillImageEnabled(value)
	self.KILLIMAGE_ENABLED = value
end

function VisualsModule:SetKillImageColor(value)
	self.KILLIMAGE_COLOR = value
end

function VisualsModule:SetKillImageMaxAlpha(value)
	self.KILLIMAGE_MAX_ALPHA = value
end

function VisualsModule:GetSettings()
	local function colorToTable(c)
		return { math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255) }
	end

	return {
		HITLOG_ENABLED = self.HITLOG_ENABLED,
		HITSOUND_ENABLED = self.HITSOUND_ENABLED,
		HITSOUND_PRESET = self.HITSOUND_PRESET,
		HITSOUND_VOLUME = self.HITSOUND_VOLUME,

		OFFSCREEN_ENABLED = self.OFFSCREEN_ENABLED,
		OFFSCREEN_COLOR = colorToTable(self.OFFSCREEN_COLOR),

		WALLBANG_ENABLED = self.WALLBANG_ENABLED,
		WALLBANG_ENTRY_COLOR = colorToTable(self.WALLBANG_ENTRY_COLOR),
		WALLBANG_EXIT_COLOR = colorToTable(self.WALLBANG_EXIT_COLOR),
		WALLBANG_MARKER_SIZE = self.WALLBANG_MARKER_SIZE.X,
		WALLBANG_LIFETIME = self.WALLBANG_LIFETIME,

		KILLFX_ENABLED = self.KILLFX_ENABLED,
		KILLFX_TYPE = self.KILLFX_TYPE,
		KILLFX_COLOR = colorToTable(self.KILLFX_COLOR),
		KILLFX_LIGHT_COLOR = colorToTable(self.KILLFX_LIGHT_COLOR),
		KILLFX_CUSTOM_DURATION = self.KILLFX_CUSTOM_DURATION,
		KILLFX_LIGHT_RANGE = self.KILLFX_LIGHT_RANGE,
		KILLFX_LIGHT_BRIGHTNESS = self.KILLFX_LIGHT_BRIGHTNESS,

		KILLIMAGE_ENABLED = self.KILLIMAGE_ENABLED,
		KILLIMAGE_COLOR = colorToTable(self.KILLIMAGE_COLOR),
		KILLIMAGE_MAX_ALPHA = self.KILLIMAGE_MAX_ALPHA,

		BACKTRACK_GHOST_ENABLED = self.BACKTRACK_GHOST_ENABLED,
		BACKTRACK_GHOST_COLOR = colorToTable(self.BACKTRACK_GHOST_COLOR),
		BACKTRACK_GHOST_DURATION = self.BACKTRACK_GHOST_DURATION,

		TRACER_ENABLED = self.TRACER_ENABLED,
		TRACER_COLOR = colorToTable(self.TRACER_COLOR),
		TRACER_LIFETIME = self.TRACER_LIFETIME,
		TRACER_WIDTH = self.TRACER_WIDTH,
		TRACER_NEON = self.TRACER_NEON,
		TRACER_STYLE = self.TRACER_STYLE,

		CHINA_HAT_ENABLED = self.CHINA_HAT_ENABLED,
		CHINA_HAT_COLOR = colorToTable(self.CHINA_HAT_COLOR),
		WINGS_ENABLED = self.WINGS_ENABLED,
		WINGS_COLOR = colorToTable(self.WINGS_COLOR),
		AURA_ENABLED = self.AURA_ENABLED,
		AURA_COLOR = colorToTable(self.AURA_COLOR),
		JUMP_CIRCLES_ENABLED = self.JUMP_CIRCLES_ENABLED,
		JUMP_CIRCLES_COLOR = colorToTable(self.JUMP_CIRCLES_COLOR),

		HIT_MARKER_ENABLED = self.HIT_MARKER_ENABLED,

		NEON_PLAYER_ENABLED = self.NEON_PLAYER_ENABLED,
		NEON_PLAYER_COLOR = colorToTable(self.NEON_PLAYER_COLOR),

		ATMOSPHERE_ENABLED = self.ATMOSPHERE_ENABLED,
		ATMOSPHERE_DENSITY = self.ATMOSPHERE_DENSITY,
		ATMOSPHERE_OFFSET = self.ATMOSPHERE_OFFSET,
		ATMOSPHERE_COLOR = colorToTable(self.ATMOSPHERE_COLOR),
		ATMOSPHERE_DECAY = colorToTable(self.ATMOSPHERE_DECAY),
		ATMOSPHERE_GLARE = self.ATMOSPHERE_GLARE,
		ATMOSPHERE_HAZE = self.ATMOSPHERE_HAZE,

		BLOOM_ENABLED = self.BLOOM_ENABLED,
		BLOOM_INTENSITY = self.BLOOM_INTENSITY,
		BLOOM_SIZE = self.BLOOM_SIZE,
		BLOOM_THRESHOLD = self.BLOOM_THRESHOLD,

		COLOR_CORRECTION_ENABLED = self.COLOR_CORRECTION_ENABLED,
		COLOR_CORRECTION_BRIGHTNESS = self.COLOR_CORRECTION_BRIGHTNESS,
		COLOR_CORRECTION_CONTRAST = self.COLOR_CORRECTION_CONTRAST,
		COLOR_CORRECTION_SATURATION = self.COLOR_CORRECTION_SATURATION,
		COLOR_CORRECTION_TINT = colorToTable(self.COLOR_CORRECTION_TINT),
	}
end

function VisualsModule:ApplySettings(settings)
	if not settings then return end

	local function toColor3(arr)
		if type(arr) == "table" and #arr >= 3 then
			return Color3.fromRGB(arr[1], arr[2], arr[3])
		end
		return nil
	end

	if settings.HITLOG_ENABLED ~= nil then self:SetHitlogEnabled(settings.HITLOG_ENABLED) end
	if settings.HITSOUND_ENABLED ~= nil then self:SetHitSoundEnabled(settings.HITSOUND_ENABLED) end
	if settings.HITSOUND_PRESET ~= nil then self:SetHitSoundPreset(settings.HITSOUND_PRESET) end
	if settings.HITSOUND_VOLUME ~= nil then self:SetHitSoundVolume(settings.HITSOUND_VOLUME) end

	if settings.OFFSCREEN_ENABLED ~= nil then self:SetOffscreenEnabled(settings.OFFSCREEN_ENABLED) end
	if settings.OFFSCREEN_COLOR then self:SetOffscreenColor(toColor3(settings.OFFSCREEN_COLOR) or self.OFFSCREEN_COLOR) end

	if settings.WALLBANG_ENABLED ~= nil then self:SetWallbangEnabled(settings.WALLBANG_ENABLED) end
	if settings.WALLBANG_ENTRY_COLOR then self:SetWallbangEntryColor(toColor3(settings.WALLBANG_ENTRY_COLOR) or self.WALLBANG_ENTRY_COLOR) end
	if settings.WALLBANG_EXIT_COLOR then self:SetWallbangExitColor(toColor3(settings.WALLBANG_EXIT_COLOR) or self.WALLBANG_EXIT_COLOR) end
	if settings.WALLBANG_MARKER_SIZE ~= nil then self:SetWallbangMarkerSize(settings.WALLBANG_MARKER_SIZE) end
	if settings.WALLBANG_LIFETIME ~= nil then self:SetWallbangLifetime(settings.WALLBANG_LIFETIME) end

	if settings.KILLFX_ENABLED ~= nil then self:SetKillFXEnabled(settings.KILLFX_ENABLED) end
	if settings.KILLFX_TYPE ~= nil then self:SetKillFXType(settings.KILLFX_TYPE) end
	if settings.KILLFX_COLOR then self:SetKillFXColor(toColor3(settings.KILLFX_COLOR) or self.KILLFX_COLOR) end
	if settings.KILLFX_LIGHT_COLOR then self:SetKillFXLightColor(toColor3(settings.KILLFX_LIGHT_COLOR) or self.KILLFX_LIGHT_COLOR) end
	if settings.KILLFX_CUSTOM_DURATION ~= nil then self:SetKillFXDuration(settings.KILLFX_CUSTOM_DURATION) end
	if settings.KILLFX_LIGHT_RANGE ~= nil then self:SetKillFXLightRange(settings.KILLFX_LIGHT_RANGE) end
	if settings.KILLFX_LIGHT_BRIGHTNESS ~= nil then self:SetKillFXLightBrightness(settings.KILLFX_LIGHT_BRIGHTNESS) end

	if settings.KILLIMAGE_ENABLED ~= nil then self:SetKillImageEnabled(settings.KILLIMAGE_ENABLED) end
	if settings.KILLIMAGE_COLOR then self:SetKillImageColor(toColor3(settings.KILLIMAGE_COLOR) or self.KILLIMAGE_COLOR) end
	if settings.KILLIMAGE_MAX_ALPHA ~= nil then self:SetKillImageMaxAlpha(settings.KILLIMAGE_MAX_ALPHA) end

	if settings.BACKTRACK_GHOST_ENABLED ~= nil then self:SetBacktrackGhostEnabled(settings.BACKTRACK_GHOST_ENABLED) end
	if settings.BACKTRACK_GHOST_COLOR then self:SetBacktrackGhostColor(toColor3(settings.BACKTRACK_GHOST_COLOR) or self.BACKTRACK_GHOST_COLOR) end
	if settings.BACKTRACK_GHOST_DURATION ~= nil then self:SetBacktrackGhostDuration(settings.BACKTRACK_GHOST_DURATION) end

	if settings.TRACER_ENABLED ~= nil then self:SetTracerEnabled(settings.TRACER_ENABLED) end
	if settings.TRACER_COLOR then self:SetTracerColor(toColor3(settings.TRACER_COLOR) or self.TRACER_COLOR) end
	if settings.TRACER_LIFETIME ~= nil then self:SetTracerLifetime(settings.TRACER_LIFETIME) end
	if settings.TRACER_WIDTH ~= nil then self:SetTracerWidth(settings.TRACER_WIDTH) end
	if settings.TRACER_NEON ~= nil then self:SetTracerNeon(settings.TRACER_NEON) end
	if settings.TRACER_STYLE then self:SetTracerStyle(settings.TRACER_STYLE) end

	if settings.CHINA_HAT_ENABLED ~= nil then self:SetChinaHatEnabled(settings.CHINA_HAT_ENABLED) end
	if settings.CHINA_HAT_COLOR then self:SetChinaHatColor(toColor3(settings.CHINA_HAT_COLOR) or self.CHINA_HAT_COLOR) end
	if settings.WINGS_ENABLED ~= nil then self:SetWingsEnabled(settings.WINGS_ENABLED) end
	if settings.WINGS_COLOR then self:SetWingsColor(toColor3(settings.WINGS_COLOR) or self.WINGS_COLOR) end
	if settings.AURA_ENABLED ~= nil then self:SetAuraEnabled(settings.AURA_ENABLED) end
	if settings.AURA_COLOR then self:SetAuraColor(toColor3(settings.AURA_COLOR) or self.AURA_COLOR) end
	if settings.JUMP_CIRCLES_ENABLED ~= nil then self:SetJumpCirclesEnabled(settings.JUMP_CIRCLES_ENABLED) end
	if settings.JUMP_CIRCLES_COLOR then self:SetJumpCirclesColor(toColor3(settings.JUMP_CIRCLES_COLOR) or self.JUMP_CIRCLES_COLOR) end

	if settings.HIT_MARKER_ENABLED ~= nil then self:SetHitMarkerEnabled(settings.HIT_MARKER_ENABLED) end

	if settings.NEON_PLAYER_ENABLED ~= nil then self:SetNeonPlayerEnabled(settings.NEON_PLAYER_ENABLED) end
	if settings.NEON_PLAYER_COLOR then self:SetNeonPlayerColor(toColor3(settings.NEON_PLAYER_COLOR) or self.NEON_PLAYER_COLOR) end

	if settings.ATMOSPHERE_ENABLED ~= nil then self:SetAtmosphereEnabled(settings.ATMOSPHERE_ENABLED) end
	if settings.ATMOSPHERE_DENSITY ~= nil then self:SetAtmosphereDensity(settings.ATMOSPHERE_DENSITY) end
	if settings.ATMOSPHERE_OFFSET ~= nil then self:SetAtmosphereOffset(settings.ATMOSPHERE_OFFSET) end
	if settings.ATMOSPHERE_COLOR then self:SetAtmosphereColor(toColor3(settings.ATMOSPHERE_COLOR) or self.ATMOSPHERE_COLOR) end
	if settings.ATMOSPHERE_DECAY then self:SetAtmosphereDecay(toColor3(settings.ATMOSPHERE_DECAY) or self.ATMOSPHERE_DECAY) end
	if settings.ATMOSPHERE_GLARE ~= nil then self:SetAtmosphereGlare(settings.ATMOSPHERE_GLARE) end
	if settings.ATMOSPHERE_HAZE ~= nil then self:SetAtmosphereHaze(settings.ATMOSPHERE_HAZE) end

	if settings.BLOOM_ENABLED ~= nil then self:SetBloomEnabled(settings.BLOOM_ENABLED) end
	if settings.BLOOM_INTENSITY ~= nil then self:SetBloomIntensity(settings.BLOOM_INTENSITY) end
	if settings.BLOOM_SIZE ~= nil then self:SetBloomSize(settings.BLOOM_SIZE) end
	if settings.BLOOM_THRESHOLD ~= nil then self:SetBloomThreshold(settings.BLOOM_THRESHOLD) end

	if settings.COLOR_CORRECTION_ENABLED ~= nil then self:SetColorCorrectionEnabled(settings.COLOR_CORRECTION_ENABLED) end
	if settings.COLOR_CORRECTION_BRIGHTNESS ~= nil then self:SetColorCorrectionBrightness(settings.COLOR_CORRECTION_BRIGHTNESS) end
	if settings.COLOR_CORRECTION_CONTRAST ~= nil then self:SetColorCorrectionContrast(settings.COLOR_CORRECTION_CONTRAST) end
	if settings.COLOR_CORRECTION_SATURATION ~= nil then self:SetColorCorrectionSaturation(settings.COLOR_CORRECTION_SATURATION) end
	if settings.COLOR_CORRECTION_TINT then self:SetColorCorrectionTint(toColor3(settings.COLOR_CORRECTION_TINT) or self.COLOR_CORRECTION_TINT) end
end

function VisualsModule:Start()
end


-- ══════════════════════════════════════════════════════════
--  [ RAGEBOT MODULE — Original ]
-- ══════════════════════════════════════════════════════════
-- RAGE MODULE (Optimized)
local RageModule = {}
RageModule.__index = RageModule

function RageModule.new(config)
	local self = setmetatable({}, RageModule)

	self.player              = config.Player
	self.Players             = config.Services.Players
	self.RunService          = config.Services.RunService
	self.Workspace           = config.Services.Workspace
	self.ReplicatedStorage   = config.Services.ReplicatedStorage
	self.Notification        = config.Notification
	self.Visuals             = config.Visuals

	self.RAGE_ENABLED        = false
	self.RAGE_HITPART        = "Head"
	self.RAGE_HITCHANCE      = 100
	self.RAGE_HITCHANCE_ENABLED = false
	self.RAGE_AUTOSHOOT      = false
	self.RAGE_NOSPREAD       = false
	self.AIRSHOT_ACTIVE      = false
	self.AUTO_EQUIP_SSG      = false
	self.MAX_DISTANCE        = 2000

	-- Предикт
	self.PREDICTION_ENABLED  = true
	self.PREDICTION_STRENGTH = 1.0  -- Множитель поверх физики (1.0 = чистая физика)
	self.BULLET_SPEED        = 2048 -- studs/s — скорость луча в игре (Ray * 2048)

	-- Per-player tracking
	self._velocityTracking   = {}
	self._targetHistory      = {}
	self._lastTargetSwitch   = 0
	self.TARGET_SWITCH_DELAY = 0.35

	-- Min damage
	self.MIN_DAMAGE_ENABLED  = false
	self.MIN_DAMAGE_VALUE    = 0
	self.BASE_DAMAGE         = 54

	-- Double Tap
	self.DOUBLETAP_ENABLED      = false
	self.DOUBLETAP_MODE         = "Aggressive"
	self.DOUBLETAP_TELEPORT     = true
	self.DOUBLETAP_MAX_TP_DIST  = 15
	self.dtLastUse              = 0
	self.DT_COOLDOWN            = 1.5
	self.DT_MAXDIST_OVERRIDE    = false

	-- Override Target
	self.OVERRIDE_TARGET_ENABLED = false
	self.OVERRIDE_TARGET_LIST    = {}

	-- Anti-Aims
	self.REMOVE_HEAD_ENABLED     = false
	self._removeHeadTrack        = nil
	self._removeHeadAnimObj      = nil
	self._removeHeadCharConn     = nil
	self._removeHeadNoclipConn   = nil
	self._cachedBypassAnimId     = nil
	self.FREESTAND_ENABLED       = false
	self._freestandConn          = nil
	self._freestandLastUpdate    = 0

	-- Rapidfire
	self.RAPIDFIRE_ENABLED     = false
	self.RAPIDFIRE_SHOTS       = 10
	self.RAPIDFIRE_MODE        = "Automatic"
	self.RAPIDFIRE_REEQUIP     = true
	self.RAPIDFIRE_CYCLE_DELAY = 0.03
	self._rfLoopActive         = false
	self._rfSteppedConn        = nil
	self._rfRenderConn         = nil

	-- AutoStop — тормозим перед выстрелом для точности
	self.AUTOSTOP_ENABLED    = false
	self.AUTOSTOP_THRESHOLD  = 8    -- studs/s — если быстрее, тормозим
	self._autostopActive     = false
	self._autostopConn       = nil

	-- Multi-Point — несколько точек прицеливания по хитбоксу
	self.MULTIPOINT_ENABLED  = false
	self.MULTIPOINT_SCALE    = 0.8  -- 0..1, доля hitbox для семплинга

	-- Baim-on-miss — переходим на торс при N мисах
	self.BAIM_ON_MISS        = false
	self.BAIM_MISS_THRESHOLD = 2
	self._baimMissCount      = 0
	self._baimFallback       = false

	-- Safe Point — стреляем только если точка видна без пенетрации
	self.SAFEPOINT_ENABLED   = false
	self.FIRE_RATE             = 0.05
	self.ping                  = 0
	self.lastPingUpdate        = 0
	self.PING_UPDATE_RATE      = 0.5  -- обновлять каждые 0.5с точнее
	self.activePlayers         = {}
	self.lastPlayerListUpdate  = 0
	self.PLAYER_LIST_UPDATE_RATE = 0.15  -- чаще для точного таргета
	self.autoEquippedOnce      = false

	-- Cached raycast params (reused every call)
	self._rayParams = RaycastParams.new()
	self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
	self._rayParams.IgnoreWater = true

	-- ── Resolver ────────────────────────────────────────────────
	-- Per-player resolver state (reads game AA attributes)
	self._resolverData = {}
	-- {[player] = {
	--   jitterEnabled = bool,
	--   jitterSpeed   = number,
	--   jitterAngle   = number,
	--   rotate        = number,   -- leaderstats.rotate
	--   lastYaw       = number,
	--   lastYawTime   = number,
	--   resolvedAngle = number,   -- final resolved yaw offset (degrees)
	--   flipCount     = 0,
	--   confidence    = 0,        -- 0..1
	-- }}
	self.RESOLVER_ENABLED = true

	-- Gun cache
	self._cachedGun = nil
	self._cachedGunTick = 0
	self._GUN_CACHE_RATE = 0.15

	-- Heartbeat throttle (increased for better performance)
	self._lastHeartbeat = 0
	self._HEARTBEAT_INTERVAL = 1 / 128 -- ~128 апд/сек

	self.BODY_PART_MULTIPLIERS = {
		["Head"] = 4.0,
		["UpperTorso"] = 1.0,
		["LowerTorso"] = 1.0,
		["Torso"] = 1.0,
		["HumanoidRootPart"] = 1.0,
		["LeftUpperArm"] = 0.75,
		["LeftLowerArm"] = 0.75,
		["LeftHand"] = 0.75,
		["RightUpperArm"] = 0.75,
		["RightLowerArm"] = 0.75,
		["RightHand"] = 0.75,
		["LeftUpperLeg"] = 0.6,
		["LeftLowerLeg"] = 0.6,
		["LeftFoot"] = 0.6,
		["RightUpperLeg"] = 0.6,
		["RightLowerLeg"] = 0.6,
		["RightFoot"] = 0.6,
		["Left Leg"] = 0.6,
		["Right Leg"] = 0.6,
	}

	self.MIN_DAMAGE_PRIORITY = {
		{name = "Legs", parts = {"LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "Left Leg", "Right Leg"}, multiplier = 0.6},
		{name = "Arms", parts = {"LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "Left Arm", "Right Arm"}, multiplier = 0.75},
		{name = "Body", parts = {"UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart"}, multiplier = 1.0},
		{name = "Head", parts = {"Head"}, multiplier = 4.0},
	}

	-- Reduced fallback part lists for visibility checks (fewer raycasts)
	self._VISIBILITY_FAST = {"Head", "UpperTorso", "HumanoidRootPart"}

	-- Wallbang: пробивание жёстких стен (Metal, Concrete и т.д.)
	self.WALLBANG_ENABLED = false

	return self
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
function RageModule:GetEffectiveMaxDist()
	if self.DT_MAXDIST_OVERRIDE and self.DOUBLETAP_ENABLED then
		return 99999
	end
	return self.MAX_DISTANCE
end

function RageModule:IsAlive()
	local char = self.player.Character
	if not char then return false end
	local hum = char:FindFirstChild("Humanoid")
	return hum and hum.Health > 0
end

function RageModule:IsEnemy(target)
	if self.player.Team and target.Team then
		return self.player.Team ~= target.Team
	end
	return true
end

function RageModule:IsInAir()
	local char = self.player.Character
	if not char then return true end
	local hum = char:FindFirstChild("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return true end
	if hum.FloorMaterial == Enum.Material.Air then return true end
	if math.abs(hrp.AssemblyLinearVelocity.Y) > 2 then return true end
	return false
end

-- Проверяем что ЦЕЛЬ в воздухе (для аирщота)
function RageModule:IsTargetInAir(rootPart)
	if not rootPart or not rootPart.Parent then return false end
	local char = rootPart.Parent
	local hum  = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	-- Цель в воздухе если FloorMaterial = Air или есть вертикальная скорость
	if hum.FloorMaterial == Enum.Material.Air then return true end
	local vel = rootPart.AssemblyLinearVelocity
	if vel and math.abs(vel.Y) > 3 then return true end
	return false
end

function RageModule:GetGun()
	local now = tick()
	if self._cachedGun and (now - self._cachedGunTick) < self._GUN_CACHE_RATE then
		local g = self._cachedGun
		if g.fireShot and g.fireShot.Parent then
			return g
		end
		self._cachedGun = nil
	end

	local char = self.player.Character
	if not char then self._cachedGun = nil; return nil end

	for _, item in pairs(char:GetChildren()) do
		if not item:IsA("Tool") then continue end

		-- Читаем реальный firerate из Configuration тула
		local cfg          = item:FindFirstChild("Configuration")
		local realFireRate = cfg and cfg:FindFirstChild("Firerate")
			and tonumber(cfg.Firerate.Value) or self.FIRE_RATE

		local remotes  = item:FindFirstChild("Remotes")
		if not remotes then continue end

		-- Новая версия игры: только FireShot (v_u_11)
		-- Сигнатура: FireServer(Ray, hitPos, player, hitPart)
		local fireShot = remotes:FindFirstChild("FireShot")
		if not fireShot then continue end

		-- Handle = источник ray origin (как в оригинале: v_u_7.Handle.Position)
		local handle = item:FindFirstChild("Handle")

		self._cachedGun = {
			type     = "FireShot",
			fireShot = fireShot,
			handle   = handle,
			tool     = item,
			fireRate = math.max(realFireRate or self.FIRE_RATE, 0.01),
		}
		self._cachedGunTick = now
		return self._cachedGun
	end

	self._cachedGun = nil
	return nil
end

function RageModule:CalculatePotentialDamage(partName, distance)
	local multiplier = self.BODY_PART_MULTIPLIERS[partName] or 0.5
	local damage = self.BASE_DAMAGE * multiplier
	if distance > 300 then
		damage = damage * 0.3
	elseif distance > 200 then
		damage = damage * 0.5
	elseif distance > 100 then
		damage = damage * 0.8
	end
	return math.floor(damage)
end

function RageModule:GetBestVisiblePart(char, distance)
	local priorities

	if self.RAGE_HITPART == "Head" then
		priorities = {"Head", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart"}
	elseif self.RAGE_HITPART == "Body" then
		priorities = {"UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart", "Head"}
	elseif self.RAGE_HITPART == "Arms" then
		priorities = {"RightUpperArm", "LeftUpperArm", "Right Arm", "Left Arm", "UpperTorso", "Torso"}
	elseif self.RAGE_HITPART == "Legs" then
		priorities = {"RightUpperLeg", "LeftUpperLeg", "Right Leg", "Left Leg", "LowerTorso", "Torso"}
	else
		priorities = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
	end

	for _, partName in ipairs(priorities) do
		local part = char:FindFirstChild(partName)
		if part and self:IsPartVisible(part, char) then
			return part
		end
	end

	return nil
end

function RageModule:GetTargetPart(char, distance)
	if self.AIRSHOT_ACTIVE then
		local head = char:FindFirstChild("Head")
		-- Verify head is valid and loaded
		if head and head.Size.Magnitude > 0.5 and head.Transparency < 1 then
			return head
		end
		return nil
	end

	if self.MIN_DAMAGE_ENABLED then
		for _, priorityGroup in ipairs(self.MIN_DAMAGE_PRIORITY) do
			for _, partName in ipairs(priorityGroup.parts) do
				local part = char:FindFirstChild(partName)
				if part and part.Size.Magnitude > 0.1 and part.Transparency < 1 then
					local damage = self:CalculatePotentialDamage(partName, distance)
					if damage >= self.MIN_DAMAGE_VALUE then
						return part
					end
				end
			end
		end
		return nil
	end

	if self.RAGE_HITPART == "Head" then
		local head = char:FindFirstChild("Head")
		if head and head.Size.Magnitude > 0.5 and head.Transparency < 1 then
			return head
		end
		return nil
	end
	if self.RAGE_HITPART == "Body" then
		return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
	end
	if self.RAGE_HITPART == "Arms" then
		return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("Left Arm")
	end
	if self.RAGE_HITPART == "Legs" then
		return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("Left Leg")
	end
	
	local head = char:FindFirstChild("Head")
	if head and head.Size.Magnitude > 0.5 and head.Transparency < 1 then
		return head
	end
	return char:FindFirstChild("HumanoidRootPart")
end

function RageModule:IsPartVisible(targetPart, targetChar)
	if not targetPart or not targetPart.Parent then return false end
	if targetPart.Transparency >= 1 then return false end

	local myChar = self.player.Character
	if not myChar then return false end
	local myHead = myChar:FindFirstChild("Head")
	if not myHead then return false end

	local origin    = myHead.Position
	local targetPos = targetPart.Position
	local dir       = targetPos - origin
	local dist      = dir.Magnitude

	if dist < 0.1 then return true end
	if dist > self:GetEffectiveMaxDist() then return false end

	-- Быстрый raycast: исключаем свой чар и чар цели
	local params = self._rayParams
	params.FilterDescendantsInstances = {myChar, targetChar}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local res = self.Workspace:Raycast(origin, dir, params)

	-- Если луч ничего не задел — цель видна
	if not res then return true end

	-- Если задели часть цели — тоже видна
	if res.Instance and res.Instance:IsDescendantOf(targetChar) then
		return true
	end

	-- Wallbang: пробиваем если включён
	if self.WALLBANG_ENABLED then
		-- Проверяем следующий слой
		local hit = res.Instance
		if hit then
			local mat = hit.Material
			-- Металл/гранит не пробиваем даже с wallbang
			if mat == Enum.Material.Metal or mat == Enum.Material.DiamondPlate
				or mat == Enum.Material.Granite or mat == Enum.Material.Marble then
				return false
			end
		end
		-- Всё остальное считаем пробиваемым при wallbang
		local secondOrigin = res.Position + dir.Unit * 0.3
		local res2 = self.Workspace:Raycast(secondOrigin, targetPos - secondOrigin, params)
		if not res2 then return true end
		if res2.Instance and res2.Instance:IsDescendantOf(targetChar) then return true end
		return false
	end

	-- Без wallbang: пробиваем только совсем прозрачные/некол объекты
	local hit = res.Instance
	if hit then
		local isSoft = hit.Transparency > 0.3 or hit.CanCollide == false or hit.CanQuery == false
		local name   = hit.Name:lower()
		local isGame = name:find("hamik") or name:find("paletka")
		if isSoft or isGame then
			local secondOrigin = res.Position + dir.Unit * 0.25
			local res2 = self.Workspace:Raycast(secondOrigin, targetPos - secondOrigin, params)
			if not res2 then return true end
			if res2.Instance and res2.Instance:IsDescendantOf(targetChar) then return true end
		end
	end

	return false
end

-- ── AutoStop ─────────────────────────────────────────────────────────
-- Тормозит LocalPlayer перед выстрелом через обнуление скорости
function RageModule:AutoStop()
	if not self.AUTOSTOP_ENABLED then return end
	local char = self.player.Character
	if not char then return end
	local hrp  = char:FindFirstChild("HumanoidRootPart")
	local hum  = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	local hVel = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
	if hVel.Magnitude < self.AUTOSTOP_THRESHOLD then return end

	-- Убираем горизонтальную скорость одним кадром
	hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
	self._autostopActive = true

	-- Восстанавливаем через один тик чтобы не залипать
	task.defer(function()
		self._autostopActive = false
	end)
end

-- Проверяем что мы сами достаточно медленные для точного выстрела
function RageModule:IsAccurate()
	if not self.AUTOSTOP_ENABLED then return true end
	local char = self.player.Character
	if not char then return true end
	local hrp  = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return true end
	local hVel = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
	return hVel.Magnitude <= self.AUTOSTOP_THRESHOLD
end

-- ── Multi-Point ───────────────────────────────────────────────────────
-- Возвращает таблицу точек на хитбоксе: центр + края
-- Сначала пробуем точку которая видна — её и используем
function RageModule:GetMultiPoints(part, char)
	local sz   = part.Size * self.MULTIPOINT_SCALE * 0.5
	local cf   = part.CFrame

	-- Генерируем точки: центр + 6 граней + 8 углов (упрощённо)
	local offsets = {
		Vector3.new(0,    0,    0),    -- центр (приоритет)
		Vector3.new(0,    sz.Y, 0),    -- верх
		Vector3.new(0,   -sz.Y, 0),    -- низ
		Vector3.new( sz.X, 0,  0),    -- право
		Vector3.new(-sz.X, 0,  0),    -- лево
		Vector3.new(0,    0,    sz.Z), -- перед
		Vector3.new(0,    0,   -sz.Z), -- зад
		-- диагонали (более скрытые точки)
		Vector3.new( sz.X * 0.7,  sz.Y * 0.7, 0),
		Vector3.new(-sz.X * 0.7,  sz.Y * 0.7, 0),
		Vector3.new( sz.X * 0.7, -sz.Y * 0.7, 0),
		Vector3.new(-sz.X * 0.7, -sz.Y * 0.7, 0),
	}

	local points = {}
	for _, off in ipairs(offsets) do
		table.insert(points, cf:PointToWorldSpace(off))
	end
	return points
end

-- Возвращает лучшую видимую точку из мультиточек
-- Если SafePoint включён — только полностью видимые
-- Если нет — берём центр или первую видимую
function RageModule:GetBestPoint(part, char, targetChar)
	if not self.MULTIPOINT_ENABLED then
		return part.Position
	end

	local points = self:GetMultiPoints(part, char)
	local myChar = self.player.Character
	if not myChar then return part.Position end
	local myHead = myChar:FindFirstChild("Head")
	if not myHead then return part.Position end

	-- Быстрый raycast-фильтр
	local params = self._rayParams
	params.FilterDescendantsInstances = {myChar, targetChar}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local bestPoint  = nil
	local bestScore  = -math.huge
	local origin     = myHead.Position

	for i, pt in ipairs(points) do
		local dir  = pt - origin
		local dist = dir.Magnitude
		if dist < 0.1 then
			return pt  -- вплотную — стреляем сразу
		end

		local res  = self.Workspace:Raycast(origin, dir, params)
		local visible = not res
			or (res.Instance and res.Instance:IsDescendantOf(targetChar))

		if visible then
			-- Центральные точки получают бонус (индекс 1 = центр)
			local centrality = 1 - (i - 1) / #points
			-- Ближе к центру модели = меньше шанс промазать при движении
			local score = centrality * 10 - dist * 0.01
			if score > bestScore then
				bestScore = score
				bestPoint = pt
			end
		end
	end

	-- SafePoint: только если есть видимая точка
	if self.SAFEPOINT_ENABLED and not bestPoint then
		return nil  -- нет безопасной точки — не стреляем
	end

	return bestPoint or part.Position
end

-- ── Baim (body aim) on miss ────────────────────────────────────────────
function RageModule:GetEffectivePart(char, dist, targetPlayer)
	-- Если включён Baim и накопились миссы — переключаемся на торс
	if self.BAIM_ON_MISS and self._baimFallback then
		local torso = char:FindFirstChild("UpperTorso")
			or char:FindFirstChild("Torso")
			or char:FindFirstChild("HumanoidRootPart")
		if torso then return torso end
	end
	return self:GetTargetPart(char, dist)
end

function RageModule:RegisterMiss(targetPlayer)
	self._baimMissCount = (self._baimMissCount or 0) + 1
	if self.BAIM_ON_MISS and self._baimMissCount >= self.BAIM_MISS_THRESHOLD then
		self._baimFallback = true
	end
	self:OnMiss(targetPlayer)
end

function RageModule:RegisterHit(targetPlayer)
	self._baimMissCount = 0
	self._baimFallback  = false
	self:OnHit(targetPlayer)
end
function RageModule:ReadAAAttributes(targetPlayer)
	-- Читаем атрибуты прямо с объекта Player, которые выставляет
	-- антиаим-система Mirage HVH
	local jitterEnabled = false
	local jitterSpeed   = 0
	local jitterAngle   = 0
	local rotate        = 0

	pcall(function()
		-- Jitter включён ли
		local je = targetPlayer:FindFirstChild("Jitter")
		if je then jitterEnabled = je.Value end

		-- Скорость джиттера
		local js = targetPlayer:FindFirstChild("JittersSpeed")
		if js then jitterSpeed = tonumber(js.Value) or 0 end

		-- Угол джиттера
		local ja = targetPlayer:FindFirstChild("JitteraAngle")
		if ja then jitterAngle = tonumber(ja.Value) or 0 end

		-- leaderstats.rotate
		local ls = targetPlayer:FindFirstChild("leaderstats")
		if ls then
			local r = ls:FindFirstChild("rotate")
			if r then rotate = tonumber(r.Value) or 0 end
		end
	end)

	return {
		jitterEnabled = jitterEnabled,
		jitterSpeed   = jitterSpeed,
		jitterAngle   = jitterAngle,
		rotate        = rotate,
	}
end

function RageModule:UpdateResolver(targetPlayer, rootPart)
	if not self.RESOLVER_ENABLED then return end
	if not rootPart or not rootPart.Parent then return end

	local now  = tick()
	local plr  = targetPlayer

	if not self._resolverData[plr] then
		self._resolverData[plr] = {
			jitterEnabled = false,
			jitterSpeed   = 0,
			jitterAngle   = 0,
			rotate        = 0,
			lastYaw       = 0,
			lastYawTime   = now,
			resolvedAngle = 0,
			flipCount     = 0,
			confidence    = 0,
			missStreak    = 0,
			flipSign      = 1,
		}
	end

	local d   = self._resolverData[plr]
	local raw = self:ReadAAAttributes(plr)

	d.jitterEnabled = raw.jitterEnabled
	d.jitterSpeed   = raw.jitterSpeed
	d.jitterAngle   = raw.jitterAngle
	d.rotate        = raw.rotate

	-- Текущий «видимый» яв корня (в градусах)
	local cf        = rootPart.CFrame
	local curYaw    = math.deg(math.atan2(-cf.LookVector.X, -cf.LookVector.Z))
	local dt        = math.max(now - d.lastYawTime, 0.001)
	local yawDelta  = math.abs(curYaw - d.lastYaw)

	-- Нормализуем дельту в [-180, 180]
	if yawDelta > 180 then yawDelta = 360 - yawDelta end

	-- Детект джиттера: быстрое туда-обратно
	local isJittering = d.jitterEnabled
		or (yawDelta > 15 and dt < 0.12)

	if isJittering then
		-- Джиттер: реальный угол примерно в центре размаха
		-- Используем jitterAngle из атрибута напрямую
		local halfAngle = d.jitterAngle * 0.5
		if halfAngle < 1 then halfAngle = yawDelta * 0.5 end

		-- Резольвим: противоположная сторона от текущего смещения
		local sign = (curYaw - d.lastYaw) > 0 and -1 or 1
		d.resolvedAngle = sign * halfAngle
		d.confidence    = math.clamp(0.5 + (d.jitterAngle / 180) * 0.5, 0.3, 0.9)
	else
		-- Спин / статичный АА: используем rotate из leaderstats
		local spinRate = d.rotate  -- угол/сек от сервера

		if math.abs(spinRate) > 3 then
			-- Спин: предсказываем угол через пинг (ping уже в секундах)
			local pingLead  = self.ping * spinRate  -- градусов смещения за пинг
			d.resolvedAngle = -curYaw - pingLead
			d.confidence    = 0.78
		else
			-- Статичный АА (180, sideways и т.д.)
			-- Чередуем ±180 при мисс-стриках
			if d.missStreak >= 2 then
				d.flipSign      = -d.flipSign
				d.missStreak    = 0
				d.flipCount     = d.flipCount + 1
			end
			d.resolvedAngle = 180 * d.flipSign
			d.confidence    = 0.6
		end
	end

	d.lastYaw     = curYaw
	d.lastYawTime = now
end

function RageModule:ResolveTargetPosition(target, rawPos)
	if not self.RESOLVER_ENABLED then return rawPos end

	local d = self._resolverData[target.player]
	if not d or d.confidence < 0.15 then return rawPos end

	local rootPart = target.rootPart
	if not rootPart then return rawPos end

	-- Вращаем offset головы на resolvedAngle вокруг Y
	local angle  = math.rad(d.resolvedAngle)
	local rel    = rawPos - rootPart.Position
	local cos_a  = math.cos(angle)
	local sin_a  = math.sin(angle)
	local rotated = Vector3.new(
		rel.X * cos_a - rel.Z * sin_a,
		rel.Y,
		rel.X * sin_a + rel.Z * cos_a
	)

	local corrected = rootPart.Position + rotated
	-- Lerp на confidence: 0.15→нет коррекции, 1.0→полная
	return rawPos:Lerp(corrected, math.clamp(d.confidence * 0.7, 0, 1))
end

function RageModule:OnMiss(targetPlayer)
	-- Вызывается при мисс — увеличиваем счётчик для флипа
	local d = self._resolverData[targetPlayer]
	if d then
		d.missStreak = (d.missStreak or 0) + 1
	end
end

function RageModule:OnHit(targetPlayer)
	-- Вызывается при хите — сбрасываем стрик
	local d = self._resolverData[targetPlayer]
	if d then
		d.missStreak = 0
		d.confidence = math.min(d.confidence + 0.1, 1.0)
	end
end

function RageModule:PredictPosition(part, rootPart, targetPlayer)
	if not self.PREDICTION_ENABLED or not rootPart then return part.Position end

	local vel = rootPart.AssemblyLinearVelocity
	if not vel then return part.Position end

	-- Обновляем резольвер
	if targetPlayer then
		self:UpdateResolver(targetPlayer, rootPart)
	end

	local hVel = Vector3.new(vel.X, 0, vel.Z)  -- только горизонталь
	local speed = hVel.Magnitude

	-- Стоит — резольв без предикта
	if speed < 1.5 then
		return self:ResolveTargetPosition(
			{player = targetPlayer, rootPart = rootPart}, part.Position)
	end

	-- Время полёта пули + пинг (оба в секундах)
	local cam      = self.Workspace.CurrentCamera
	local dist     = cam and (part.Position - cam.CFrame.Position).Magnitude or 100
	local tFlight  = dist / self.BULLET_SPEED  -- время полёта
	local tPing    = self.ping * 0.5           -- половина RTT

	-- dt = (время_полёта + пинг) * сила_предикта
	-- Нет верхнего ограничения — пользователь сам выставляет через слайдер
	local dtBase = math.max(tFlight + tPing, 0.02)
	local dt     = dtBase * self.PREDICTION_STRENGTH

	-- Акселерация per-player (сглаженная)
	local accel = Vector3.new()
	if targetPlayer then
		local tr = self._velocityTracking[targetPlayer]
		if tr and tr.t then
			local dT = tick() - tr.t
			if dT > 0 and dT < 0.3 then
				local raw = (vel - tr.vel) / dT
				accel = tr.accel and tr.accel:Lerp(raw, 0.4) or raw
			end
		end
		self._velocityTracking[targetPlayer] = {
			vel   = vel,
			t     = tick(),
			accel = accel,
		}
	end

	-- Формула: p' = p + v*dt + 0.5*a*dt²
	local predicted = part.Position
		+ hVel   * dt
		+ accel  * (dt * dt * 0.5)

	-- Вертикальная компенсация для аирщота (цель летит вверх/вниз)
	if self.AIRSHOT_ACTIVE then
		predicted = predicted + Vector3.new(0, vel.Y * dt, 0)
	end

	-- Поправка резольвера (АА)
	if targetPlayer then
		local d = self._resolverData[targetPlayer]
		if d then
			-- Джиттер: смещаем к центру размаха
			if d.jitterEnabled and d.jitterAngle > 0 and d.jitterSpeed > 0 then
				local phase  = math.fmod(tick() * d.jitterSpeed, math.pi * 2)
				local offset = math.sin(phase) * math.rad(d.jitterAngle) * 0.5
				local right  = rootPart.CFrame.RightVector
				predicted    = predicted + right * (offset * dist * 0.01)
			end
			-- Спин: поворачиваем предсказанную позицию на угол вращения * dt
			if math.abs(d.rotate) > 3 then
				local angle = math.rad(d.rotate) * dt
				local rel   = predicted - rootPart.Position
				local cos_a = math.cos(angle)
				local sin_a = math.sin(angle)
				predicted   = rootPart.Position + Vector3.new(
					rel.X * cos_a - rel.Z * sin_a,
					rel.Y,
					rel.X * sin_a + rel.Z * cos_a
				)
			end
		end
	end

	return self:ResolveTargetPosition(
		{player = targetPlayer, rootPart = rootPart}, predicted)
end

function RageModule:UpdateActivePlayersList()
	table.clear(self.activePlayers)
	local myPos
	local myChar = self.player.Character
	if myChar then
		local hrp = myChar:FindFirstChild("HumanoidRootPart")
		if hrp then myPos = hrp.Position end
	end

	for _, plr in ipairs(self.Players:GetPlayers()) do
		if plr == self.player then continue end
		if not self:IsEnemy(plr) then continue end

		local char = plr.Character
		if not char then continue end

		-- НЕ кешируем rootPart — берём живую ссылку при каждом обновлении
		local rootPart = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChildOfClass("Humanoid")

		if not rootPart or not humanoid or humanoid.Health <= 0 then continue end

		local dist = myPos and (rootPart.Position - myPos).Magnitude or 0
		if dist > self:GetEffectiveMaxDist() then continue end

		table.insert(self.activePlayers, {
			player   = plr,
			character = char,
			rootPart = rootPart,
			humanoid = humanoid,
			dist     = dist,
		})
	end

	-- Сортируем по дистанции — ближние первые (быстрее FindTarget)
	table.sort(self.activePlayers, function(a, b)
		return a.dist < b.dist
	end)
end

function RageModule:FindTarget()
	if not self:IsAlive() then return nil end

	local char = self.player.Character
	local myHead = char and char:FindFirstChild("Head")
	if not myHead then return nil end

	local now = tick()
	if now - self.lastPlayerListUpdate >= self.PLAYER_LIST_UPDATE_RATE then
		self.lastPlayerListUpdate = now
		self:UpdateActivePlayersList()
	end

	local bestTarget
	local bestScore = -math.huge
	local myPos = myHead.Position

	local filterByOverride = self.DT_MAXDIST_OVERRIDE and self.OVERRIDE_TARGET_ENABLED and #self.OVERRIDE_TARGET_LIST > 0

	local previousTarget = self._targetHistory[1]
	local shouldStickToTarget = previousTarget and (now - self._lastTargetSwitch < self.TARGET_SWITCH_DELAY)

	for _, data in ipairs(self.activePlayers) do
		if not data.humanoid or data.humanoid.Health <= 0 then continue end
		if not data.rootPart or not data.rootPart.Parent then continue end

		if filterByOverride then
			local found = false
			for _, tName in ipairs(self.OVERRIDE_TARGET_LIST) do
				if data.player.Name == tName or data.player.DisplayName == tName then
					found = true
					break
				end
			end
			if not found then continue end
		end

		local dist = (data.rootPart.Position - myPos).Magnitude
		if dist > self:GetEffectiveMaxDist() then continue end

		local part

		if self.AIRSHOT_ACTIVE then
			part = data.character:FindFirstChild("Head")
			if not part or not self:IsPartVisible(part, data.character) then
				continue
			end

		elseif self.MIN_DAMAGE_ENABLED then
			part = nil
			for _, group in ipairs(self.MIN_DAMAGE_PRIORITY) do
				for _, partName in ipairs(group.parts) do
					local p = data.character:FindFirstChild(partName)
					if p then
						local dmg = self:CalculatePotentialDamage(partName, dist)
						if dmg >= self.MIN_DAMAGE_VALUE and self:IsPartVisible(p, data.character) then
							part = p
							break
						end
					end
				end
				if part then break end
			end
			if not part then
				continue
			end

		else
			local visible = false
			for _, partName in ipairs(self._VISIBILITY_FAST) do
				local p = data.character:FindFirstChild(partName)
				if p and self:IsPartVisible(p, data.character) then
					visible = true
					break
				end
			end

			if not visible then
				continue
			end

			part = self:GetTargetPart(data.character, dist) or data.character:FindFirstChild("Head")
			if not part then
				continue
			end
		end

		-- Скоринг цели
		local score = 0

		-- Удержание цели (не переключаемся без причины)
		if shouldStickToTarget and previousTarget == data.player then
			score = score + 120
		end

		-- Дистанция: ближе = лучше, нелинейно
		score = score + math.max(0, 500 - dist * 2) * 0.25

		-- Здоровье: чем меньше HP — тем выше приоритет добить
		local hp = data.humanoid.Health / math.max(data.humanoid.MaxHealth, 1)
		score = score + (1 - hp) * 70

		-- Скорость: медленнее = проще попасть
		local vel = data.rootPart.AssemblyLinearVelocity or Vector3.new()
		local spd = Vector3.new(vel.X, 0, vel.Z).Magnitude
		score = score + math.max(0, 30 - spd) * 2

		-- Угол к цели: прямо перед нами — легче целиться
		local cam     = self.Workspace.CurrentCamera
		local lookDir = cam and cam.CFrame.LookVector or Vector3.new(0,0,-1)
		local toTgt   = (data.rootPart.Position - myPos).Unit
		local dot     = math.clamp(toTgt:Dot(lookDir), -1, 1)
		score = score + (dot + 1) * 15  -- 0..30

		-- Предсказуемость движения (низкое ускорение = стабильный путь)
		local tr = self._velocityTracking[data.player]
		if tr and tr.accel and tr.accel.Magnitude < 4 then
			score = score + 25
		end

		-- Аирщот: бонус если цель в воздухе и NoSpread включён
		if self.RAGE_NOSPREAD and self:IsTargetInAir(data.rootPart) then
			score = score + 60
		end

		if score > bestScore then
			bestScore = score
			bestTarget = {
				player = data.player,
				character = data.character,
				targetPart = part,
				rootPart = data.rootPart,
				distance = dist
			}
		end
	end

	-- Update target history
	if bestTarget and bestTarget.player ~= previousTarget then
		self._lastTargetSwitch = now
		table.insert(self._targetHistory, 1, bestTarget.player)
		if #self._targetHistory > 3 then
			table.remove(self._targetHistory, 4)
		end
	end

	return bestTarget
end

function RageModule:EquipSSGOnce()
	if not self.AUTO_EQUIP_SSG then return end
	if self.autoEquippedOnce then return end
	-- Не прерываем стрельбу: если уже стреляли недавно — пропускаем
	if tick() - self.lastShot < 2 then return end

	local char = self.player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	local currentTool = char:FindFirstChildOfClass("Tool")
	if currentTool and currentTool.Name == "SSG-08" then
		self.autoEquippedOnce = true
		return
	end

	-- Проверяем что сейчас нет активной стрельбы
	if self.RAGE_AUTOSHOOT and self.RAGE_ENABLED then return end

	local backpack = self.player:FindFirstChildOfClass("Backpack")
	if not backpack then return end

	local tool = backpack:FindFirstChild("SSG-08")
	if tool and tool:IsA("Tool") then
		-- Очищаем кеш пушки до и после equip
		self._cachedGun = nil
		hum:EquipTool(tool)
		self._cachedGun = nil
		self.autoEquippedOnce = true
	end
end

function RageModule:FireWeapon(gun, targetPos, target)
	if not gun or not gun.fireShot or not gun.fireShot.Parent then return false end

	local char = self.player.Character
	if not char then return false end

	-- Silent Aim override от AimbotModule
	if self._silentAimOverride and self._silentAimTarget then
		targetPos = self._silentAimOverride
		if self._silentAimTarget ~= target.player then
			-- цель аимбота отличается — используем его targetPart
			local sChar = self._silentAimTarget.Character
			if sChar then
				local sp = sChar:FindFirstChild("Head")
					or sChar:FindFirstChild("HumanoidRootPart")
				if sp then
					target = {
						player     = self._silentAimTarget,
						character  = sChar,
						targetPart = sp,
						rootPart   = sChar:FindFirstChild("HumanoidRootPart") or sp,
						distance   = target.distance,
					}
				end
			end
		end
	end

	-- Origin = Handle.Position (точно как в оригинале игры: v_u_7.Handle.Position)
	local handle = gun.handle
	local origin
	if handle and handle.Parent then
		origin = handle.Position
	else
		local head = char:FindFirstChild("Head")
		if not head then return false end
		origin = head.Position
	end

	-- Пинг-компенсация поверх предикта
	local vel       = target.rootPart.AssemblyLinearVelocity or Vector3.new()
	local pingShift = Vector3.new(vel.X, 0, vel.Z) * self.ping * 0.5
	local finalPos  = targetPos + pingShift

	local dir = finalPos - origin
	if dir.Magnitude < 0.01 then return false end

	-- Ray точно как в оригинале: Ray.new(Handle.Position, direction * 2048)
	local ray = Ray.new(origin, dir.Unit * 2048)

	-- Сигнатура оригинала: FireServer(ray, hitPos, player, hitPart)
	local ok = pcall(function()
		gun.fireShot:FireServer(ray, finalPos, target.player, target.targetPart)
	end)

	if ok then
		self.lastShot = tick()
		task.defer(function()
			pcall(function() self.Visuals:CreateTracer(origin, finalPos) end)
		end)
		return true
	end

	return false
end

-- ============================================
-- DOUBLE TAP
-- ============================================
function RageModule:FindNearestEnemy()
	if not self:IsAlive() then return nil end
	local char = self.player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local now = tick()
	if now - self.lastPlayerListUpdate >= self.PLAYER_LIST_UPDATE_RATE then
		self.lastPlayerListUpdate = now
		self:UpdateActivePlayersList()
	end

	local bestTarget
	local bestDist = self.DT_MAXDIST_OVERRIDE and 99999 or (self.DOUBLETAP_MAX_TP_DIST + 80)

	local filterByOverride = self.DT_MAXDIST_OVERRIDE and self.OVERRIDE_TARGET_ENABLED and #self.OVERRIDE_TARGET_LIST > 0

	for _, data in ipairs(self.activePlayers) do
		if not data.humanoid or data.humanoid.Health <= 0 then continue end
		if not data.rootPart or not data.rootPart.Parent then continue end

		if filterByOverride then
			local found = false
			for _, tName in ipairs(self.OVERRIDE_TARGET_LIST) do
				if data.player.Name == tName or data.player.DisplayName == tName then
					found = true
					break
				end
			end
			if not found then continue end
		end

		local dist = (data.rootPart.Position - hrp.Position).Magnitude
		if dist > bestDist then continue end

		local part = self:GetTargetPart(data.character, dist)
			or data.character:FindFirstChild("Head")
			or data.rootPart
		if not part then continue end

		bestDist = dist
		bestTarget = {
			player = data.player,
			character = data.character,
			targetPart = part,
			rootPart = data.rootPart,
			distance = dist
		}
	end

	return bestTarget
end

function RageModule:DoubleTapFire(gun, target)
	local char = self.player.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local originalCF = hrp.CFrame
	local didTP      = false

	if self.DOUBLETAP_TELEPORT then
		local dir  = target.rootPart.Position - hrp.Position
		local dist = dir.Magnitude
		local tpDist = math.clamp(dist * 0.3, 0, self.DOUBLETAP_MAX_TP_DIST)
		if tpDist > 2 then
			-- Проверяем стену перед TP
			self._rayParams.FilterDescendantsInstances = {char}
			local wallCheck = self.Workspace:Raycast(hrp.Position, dir.Unit * tpDist, self._rayParams)
			if not wallCheck or wallCheck.Instance:IsDescendantOf(target.character) then
				hrp.CFrame = originalCF + dir.Unit * tpDist
				didTP = true
				task.wait()
			end
		end
	end

	-- Всегда восстанавливаем позицию через defer, даже если упали
	if didTP then
		task.defer(function()
			pcall(function()
				if hrp and hrp.Parent then
					hrp.CFrame = originalCF
				end
			end)
		end)
	end

	if not self:IsAlive() then return end
	if not target.targetPart or not target.targetPart.Parent then return end

	local targetPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position

	self:FireWeapon(gun, targetPos, target)

	task.wait(0.05)

	if not self:IsAlive() then return end
	if not target.targetPart or not target.targetPart.Parent then return end

	local tPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position
	self:FireWeapon(gun, tPos, target)
end

-- ============================================
-- LEGIT DOUBLE TAP (no wall teleport, no return)
-- ============================================
function RageModule:DoubleTapFireLegit(gun, target)
	local char = self.player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local originalCF = hrp.CFrame

	local dir = target.rootPart.Position - hrp.Position
	local dist = dir.Magnitude
	local tpDist = math.clamp(6.5, 0, dist * 0.5) -- 6-7 studs
	
	if tpDist > 2 then
		local targetPos = originalCF.Position + dir.Unit * tpDist
		
		self._rayParams.FilterDescendantsInstances = {char}
		local result = self.Workspace:Raycast(originalCF.Position, dir.Unit * tpDist, self._rayParams)
		
		if not result or result.Instance:IsDescendantOf(target.character) then
			hrp.CFrame = originalCF + dir.Unit * tpDist
			task.wait()
		end
	end

	local targetPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position

	self:FireWeapon(gun, targetPos, target)

	task.wait(0.06)

	if not self:IsAlive() then
		return
	end

	local tPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position
	self:FireWeapon(gun, tPos, target)
	
end

-- ============================================
-- A-WALL (Auto-Wall: shoot through walls, no teleport)
-- ============================================
function RageModule:DoubleTapFireAWall(gun, target)
	local char = self.player.Character
	if not char then return end

	local targetPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position

	self:FireWeapon(gun, targetPos, target)

	task.wait(0.06)

	if not self:IsAlive() then
		return
	end

	local tPos = self.PREDICTION_ENABLED
		and self:PredictPosition(target.targetPart, target.rootPart, target.player)
		or target.targetPart.Position
	self:FireWeapon(gun, tPos, target)
end

function RageModule:RapidFireBurst(gun, target)
	if not gun or not gun.fireShot or not gun.fireShot.Parent then return 0 end

	local char = self.player.Character
	if not char then return 0 end

	-- Origin = Handle как в оригинале
	local handle = gun.handle
	local getOrigin = function()
		if handle and handle.Parent then return handle.Position end
		local head = char:FindFirstChild("Head")
		return head and head.Position
	end

	local shots  = math.floor(self.RAPIDFIRE_SHOTS)
	local fired  = 0
	local predPos

	for i = 1, shots do
		if not char.Parent then break end
		if not target.targetPart or not target.targetPart.Parent then break end

		-- Обновляем предикт каждые 4 выстрела
		if i == 1 or i % 4 == 0 then
			predPos = self.PREDICTION_ENABLED
				and self:PredictPosition(target.targetPart, target.rootPart, target.player)
				or target.targetPart.Position
		end
		if not predPos then break end

		local origin = getOrigin()
		if not origin then break end

		-- Микро-джиттер чтобы сервер не отклонял дубли
		local jitter = Vector3.new(
			(math.random() - 0.5) * 0.006,
			(math.random() - 0.5) * 0.006,
			(math.random() - 0.5) * 0.006
		)
		local finalOrigin = origin + jitter
		local dir = predPos - finalOrigin
		if dir.Magnitude < 0.01 then continue end

		-- Ray.new точно как оригинал + FireServer(ray, hitPos, player, hitPart)
		local ray = Ray.new(finalOrigin, dir.Unit * 2048)
		pcall(function()
			gun.fireShot:FireServer(ray, predPos, target.player, target.targetPart)
		end)
		fired = fired + 1
	end

	if fired > 0 and predPos then
		task.defer(function()
			local org = getOrigin()
			if org then
				pcall(function() self.Visuals:CreateTracer(org, predPos) end)
			end
		end)
	end

	return fired
end

-- ============================================
-- RE-EQUIP WEAPON (reset server-side cooldown)
-- ============================================
function RageModule:ReequipWeapon()
	local char = self.player.Character
	if not char then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local tool = char:FindFirstChildOfClass("Tool")
	if not hum or not tool then return false end

	local ref = tool
	hum:UnequipTools()
	task.wait()
	if ref and ref.Parent and hum and hum.Parent then
		hum:EquipTool(ref)
		self._cachedGun = nil
		return true
	end
	return false
end

-- ============================================
-- RAPIDFIRE PUMP (shoots at all visible enemies)
-- ============================================
function RageModule:RapidFirePump()
	if not self.RAPIDFIRE_ENABLED then return end
	if not self.RAGE_ENABLED or not self:IsAlive() or not self.RAGE_AUTOSHOOT then return end

	local gun = self:GetGun()
	if not gun then return end

	-- Shoot at ALL visible enemies rapidly
	local now = tick()
	if now - self.lastPlayerListUpdate >= self.PLAYER_LIST_UPDATE_RATE then
		self.lastPlayerListUpdate = now
		self:UpdateActivePlayersList()
	end

	local myChar = self.player.Character
	local myHead = myChar and myChar:FindFirstChild("Head")
	if not myHead then return end

	local enemiesShot = 0
	local maxEnemies = 10 -- Shoot at up to 10 enemies per cycle

	-- Find and shoot all visible enemies
	for _, data in ipairs(self.activePlayers) do
		if enemiesShot >= maxEnemies then break end
		
		if not data.humanoid or data.humanoid.Health <= 0 then continue end
		if not data.rootPart or not data.rootPart.Parent then continue end

		local dist = (data.rootPart.Position - myHead.Position).Magnitude
		if dist > self:GetEffectiveMaxDist() then continue end

		-- Check if enemy is visible
		local visible = false
		for _, partName in ipairs(self._VISIBILITY_FAST) do
			local p = data.character:FindFirstChild(partName)
			if p and self:IsPartVisible(p, data.character) then
				visible = true
				break
			end
		end

		if not visible then continue end

		local part = self:GetTargetPart(data.character, dist) or data.character:FindFirstChild("Head")
		if not part then continue end

		local target = {
			player = data.player,
			character = data.character,
			targetPart = part,
			rootPart = data.rootPart,
			distance = dist
		}

		-- Shoot burst at this enemy (no delays, just spam RemoteEvent)
		self:RapidFireBurst(gun, target)
		enemiesShot = enemiesShot + 1
	end
end

-- ============================================
-- MAIN LOOP
-- ============================================
function RageModule:Start()
	self.player.CharacterAdded:Connect(function()
		self.autoEquippedOnce  = false
		self._cachedGun        = nil
		self._resolverData     = {}
		self._velocityTracking = {}
		self._targetHistory    = {}
		self.lastShot          = 0
	end)

	self.RunService.Heartbeat:Connect(function()
		self:EquipSSGOnce()

		if not self.RAGE_ENABLED then return end
		if not self:IsAlive() then return end

		local now = tick()
		if now - self._lastHeartbeat < self._HEARTBEAT_INTERVAL then return end
		self._lastHeartbeat = now

		-- Пинг обновляем раз в секунду
		if now - self.lastPingUpdate >= self.PING_UPDATE_RATE then
			self.lastPingUpdate = now
			self.ping = self.player:GetNetworkPing()
		end

		local inAir = self:IsInAir()

		-- AutoStop: тормозим перед выстрелом
		if not inAir then self:AutoStop() end

		-- Без NoSpread не стреляем пока МЫ в воздухе
		if inAir and not self.RAGE_NOSPREAD then return end

		local gun = self:GetGun()
		if not gun then return end

		if not self.RAGE_AUTOSHOOT then return end
		if now - self.lastShot < gun.fireRate then return end

		-- AutoStop: ждём пока не замедлимся
		if not self:IsAccurate() then return end

		-- Патроны
		if gun.tool then
			local ammo = gun.tool:FindFirstChild("Ammo_" .. self.player.UserId)
			if ammo and ammo.Value <= 0 then return end
		end

		local target = self:FindTarget()

		-- DT fallback
		if not target and self.DOUBLETAP_ENABLED
			and self.DOUBLETAP_MODE ~= "Legit"
			and (now - self.dtLastUse) >= self.DT_COOLDOWN then
			target = self:FindNearestEnemy()
		end

		if not target then return end
		if not target.targetPart or not target.targetPart.Parent then return end

		-- Аирщот: цель в воздухе
		self.AIRSHOT_ACTIVE = self.RAGE_NOSPREAD
			and self:IsTargetInAir(target.rootPart)

		-- Hitchance
		if self.RAGE_HITCHANCE_ENABLED and not self.AIRSHOT_ACTIVE then
			if math.random(1, 100) > self.RAGE_HITCHANCE then return end
		end

		-- Baim-on-miss: переключаем на торс при накопленных мисах
		local effectivePart = self:GetEffectivePart(
			target.character, target.distance, target.player)
		if effectivePart then
			target.targetPart = effectivePart
		end

		-- Multi-Point: находим лучшую видимую точку на хитбоксе
		local shootOffset = Vector3.new()
		if self.MULTIPOINT_ENABLED then
			local bestPt = self:GetBestPoint(
				target.targetPart, target.character, target.character)
			if self.SAFEPOINT_ENABLED and not bestPt then return end
			if bestPt then
				shootOffset = bestPt - target.targetPart.Position
			end
		end

		-- Double Tap
		if self.DOUBLETAP_ENABLED and (now - self.dtLastUse) >= self.DT_COOLDOWN then
			local skipDT = self.DOUBLETAP_MODE == "Legit"
				and not self:IsPartVisible(target.targetPart, target.character)
			if not skipDT then
				self.dtLastUse = now
				self.lastShot  = now
				task.spawn(function()
					if self.DOUBLETAP_MODE == "Legit" then
						self:DoubleTapFireLegit(gun, target)
					elseif self.DOUBLETAP_MODE == "A-Wall" then
						self:DoubleTapFireAWall(gun, target)
					else
						self:DoubleTapFire(gun, target)
					end
				end)
				return
			end
		end

		-- Финальная позиция: предикт + мультиточка-смещение
		local aimPos = (self.PREDICTION_ENABLED
			and self:PredictPosition(target.targetPart, target.rootPart, target.player)
			or  target.targetPart.Position) + shootOffset

		self.lastShot = now
		self:FireWeapon(gun, aimPos, target)

		if self.RAPIDFIRE_ENABLED then
			self:RapidFireBurst(gun, target)
		end
	end)
end

function RageModule:SetRapidfireEnabled(value)
	self.RAPIDFIRE_ENABLED = value

	if self._rfSteppedConn then
		self._rfSteppedConn:Disconnect()
		self._rfSteppedConn = nil
	end
	if self._rfRenderConn then
		self._rfRenderConn:Disconnect()
		self._rfRenderConn = nil
	end

	if value then
		-- Only use the task loop for Automatic mode
		if not self._rfLoopActive and self.RAPIDFIRE_MODE == "Automatic" then
			self._rfLoopActive = true
			task.spawn(function()
				while self.RAPIDFIRE_ENABLED and self.RAPIDFIRE_MODE == "Automatic" do
					if self.RAGE_ENABLED and self:IsAlive() and self.RAGE_AUTOSHOOT then
						local gun = self:GetGun()
						local target = gun and self:FindTarget()
						if gun and target then
							self:RapidFireBurst(gun, target)
							if self.RAPIDFIRE_REEQUIP then
								self:ReequipWeapon()
							end
						end
					end
					
					local delay = self.RAPIDFIRE_CYCLE_DELAY
					if delay > 0 then
						task.wait(delay)
					else
						task.wait(0.03)
					end
				end
				self._rfLoopActive = false
			end)
		end
	end
end

-- ============================================
-- SETTERS
-- ============================================
function RageModule:SetEnabled(value)
	self.RAGE_ENABLED = value
end

function RageModule:SetHitpart(value)
	self.RAGE_HITPART = value
end

function RageModule:SetHitchance(value)
	self.RAGE_HITCHANCE = value
end

function RageModule:SetHitchanceEnabled(value)
	self.RAGE_HITCHANCE_ENABLED = value
end

function RageModule:SetAutoShoot(value)
	self.RAGE_AUTOSHOOT = value
end

function RageModule:SetNoSpread(value)
	self.RAGE_NOSPREAD = value
end

function RageModule:SetAutoEquipSSG(value)
	self.AUTO_EQUIP_SSG = value
end

function RageModule:SetMaxDistance(value)
	self.MAX_DISTANCE = value
end

function RageModule:SetPredictionEnabled(value)
	self.PREDICTION_ENABLED = value
end

function RageModule:SetPredictionStrength(value)
	-- value приходит как 0-200 из UI → конвертируем в 0.0-2.0
	self.PREDICTION_STRENGTH = value / 100
end

function RageModule:SetMinDamageEnabled(value)
	self.MIN_DAMAGE_ENABLED = value
end

function RageModule:SetMinDamageValue(value)
	self.MIN_DAMAGE_VALUE = value
end

function RageModule:SetDoubleTapEnabled(value)
	self.DOUBLETAP_ENABLED = value
end

function RageModule:SetDoubleTapMode(value)
	self.DOUBLETAP_MODE = value
	-- Set default cooldown based on mode
	if value == "Legit" then
		self.DT_COOLDOWN = 2.0
	else
		self.DT_COOLDOWN = 1.5
	end
end

function RageModule:SetDoubleTapTeleport(value)
	self.DOUBLETAP_TELEPORT = value
end

function RageModule:SetDoubleTapMaxDist(value)
	self.DOUBLETAP_MAX_TP_DIST = value
end

function RageModule:SetDoubleTapCooldown(value)
	self.DT_COOLDOWN = value
end

function RageModule:SetMaxDistOverride(value)
	self.DT_MAXDIST_OVERRIDE = value
end

function RageModule:SetWallbangEnabled(value)
	self.WALLBANG_ENABLED = value
end

function RageModule:SetAutoStopEnabled(value)
	self.AUTOSTOP_ENABLED = value
end

function RageModule:SetAutoStopThreshold(value)
	self.AUTOSTOP_THRESHOLD = value
end

function RageModule:SetMultiPointEnabled(value)
	self.MULTIPOINT_ENABLED = value
end

function RageModule:SetMultiPointScale(value)
	self.MULTIPOINT_SCALE = value
end

function RageModule:SetSafePointEnabled(value)
	self.SAFEPOINT_ENABLED = value
end

function RageModule:SetBaimOnMiss(value)
	self.BAIM_ON_MISS = value
	if not value then
		self._baimMissCount = 0
		self._baimFallback  = false
	end
end

function RageModule:SetBaimMissThreshold(value)
	self.BAIM_MISS_THRESHOLD = value
end

function RageModule:SetOverrideTargetEnabled(value)
	self.OVERRIDE_TARGET_ENABLED = value
end

function RageModule:SetOverrideTargetList(list)
	self.OVERRIDE_TARGET_LIST = list or {}
end

function RageModule:GetEnemyPlayers()
	local enemies = {}
	for _, p in ipairs(self.Players:GetPlayers()) do
		if p ~= self.player and self:IsEnemy(p) then
			table.insert(enemies, p.DisplayName)
		end
	end
	return enemies
end

-- ============================================
-- ANTI-AIMS
-- ============================================
function RageModule:_resolveAnimationId(assetId)
	if self._cachedBypassAnimId then
		return self._cachedBypassAnimId
	end

	local rawId = "rbxassetid://" .. tostring(assetId)

	-- Method 1: AnimationClipProvider (modern, no deprecation warnings)
	pcall(function()
		local ACP = game:GetService("AnimationClipProvider")
		local clip = ACP:GetAnimationClipAsync(rawId)
		if clip then
			self._cachedBypassAnimId = ACP:RegisterAnimationClip(clip)
		end
	end)
	if self._cachedBypassAnimId then return self._cachedBypassAnimId end

	-- Method 2: game:GetObjects extraction
	pcall(function()
		local objects = game:GetObjects(rawId)
		if not objects then return end
		for _, obj in ipairs(objects) do
			if obj:IsA("KeyframeSequence") or obj:IsA("CurveAnimation") then
				pcall(function()
					local ACP = game:GetService("AnimationClipProvider")
					self._cachedBypassAnimId = ACP:RegisterAnimationClip(obj)
				end)
				if self._cachedBypassAnimId then return end
			end
			if obj:IsA("Animation") then
				local innerRaw = obj.AnimationId
				pcall(function()
					local ACP = game:GetService("AnimationClipProvider")
					local clip2 = ACP:GetAnimationClipAsync(innerRaw)
					if clip2 then
						self._cachedBypassAnimId = ACP:RegisterAnimationClip(clip2)
					end
				end)
				if self._cachedBypassAnimId then return end
				self._cachedBypassAnimId = innerRaw
				return
			end
			for _, desc in ipairs(obj:GetDescendants()) do
				if desc:IsA("KeyframeSequence") or desc:IsA("CurveAnimation") then
					pcall(function()
						local ACP = game:GetService("AnimationClipProvider")
						self._cachedBypassAnimId = ACP:RegisterAnimationClip(desc)
					end)
					if self._cachedBypassAnimId then return end
				end
				if desc:IsA("Animation") then
					local innerRaw2 = desc.AnimationId
					pcall(function()
						local ACP = game:GetService("AnimationClipProvider")
						local clip3 = ACP:GetAnimationClipAsync(innerRaw2)
						if clip3 then
							self._cachedBypassAnimId = ACP:RegisterAnimationClip(clip3)
						end
					end)
					if self._cachedBypassAnimId then return end
					self._cachedBypassAnimId = innerRaw2
					return
				end
			end
		end
	end)
	if self._cachedBypassAnimId then return self._cachedBypassAnimId end

	-- Method 3: Direct ID as last resort
	self._cachedBypassAnimId = rawId
	return rawId
end

function RageModule:_startRemoveHead()
	self:_stopRemoveHead()

	local char = self.player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local animId = self:_resolveAnimationId(98193399505416)

	local anim = Instance.new("Animation")
	anim.AnimationId = animId
	self._removeHeadAnimObj = anim

	local track
	local animator = hum:FindFirstChildOfClass("Animator")
	if animator then
		local ok, t = pcall(function() return animator:LoadAnimation(anim) end)
		if ok then track = t end
	end
	if not track then
		local ok2, t2 = pcall(function() return hum:LoadAnimation(anim) end)
		if ok2 then track = t2 end
	end

	if not track then
		warn("[Arcanum] Remove Head: all animation methods failed")
		return
	end

	self._removeHeadTrack = track
	track.Looped = true
	track.Priority = Enum.AnimationPriority.Action4
	track:Play()

	self._removeHeadNoclipConn = self.RunService.Stepped:Connect(function()
		local c = self.player.Character
		if not c then return end
		for _, part in ipairs(c:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

function RageModule:_stopRemoveHead()
	if self._removeHeadNoclipConn then
		self._removeHeadNoclipConn:Disconnect()
		self._removeHeadNoclipConn = nil
	end
	if self._removeHeadTrack then
		pcall(function() self._removeHeadTrack:Stop() end)
		pcall(function() self._removeHeadTrack:Destroy() end)
		self._removeHeadTrack = nil
	end
	if self._removeHeadAnimObj then
		pcall(function() self._removeHeadAnimObj:Destroy() end)
		self._removeHeadAnimObj = nil
	end
end

function RageModule:SetRemoveHeadEnabled(value)
	self.REMOVE_HEAD_ENABLED = value

	if self._removeHeadCharConn then
		self._removeHeadCharConn:Disconnect()
		self._removeHeadCharConn = nil
	end

	if value then
		self:_startRemoveHead()
		self._removeHeadCharConn = self.player.CharacterAdded:Connect(function()
			task.wait(0.5)
			if self.REMOVE_HEAD_ENABLED then
				self:_startRemoveHead()
			end
		end)
	else
		self:_stopRemoveHead()
	end
end

-- ============================================
-- FREESTANDING
-- ============================================
function RageModule:_findClosestEnemy()
	local char = self.player.Character
	if not char then return nil end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	
	local myPos = hrp.Position
	local closestEnemy = nil
	local closestDist = math.huge
	
	-- Find closest enemy within 200 studs (increased range)
	for _, p in ipairs(game.Players:GetPlayers()) do
		if p ~= self.player and p.Team ~= self.player.Team and p.Character then
			local enemyHrp = p.Character:FindFirstChild("HumanoidRootPart")
			if enemyHrp then
				local dist = (myPos - enemyHrp.Position).Magnitude
				if dist < closestDist and dist <= 200 then
					closestDist = dist
					closestEnemy = p
				end
			end
		end
	end
	
	return closestEnemy, closestDist
end

function RageModule:_applyBodyTilt(tiltAngle1, tiltAngle2)
	-- Use aahelp1 RemoteEvent to apply body tilt (server-side, visible to all)
	local RS = game:GetService("ReplicatedStorage")
	local aahelp1 = RS:FindFirstChild("aahelp1")
	
	if aahelp1 and aahelp1:IsA("RemoteEvent") then
		pcall(function()
			aahelp1:FireServer("apply", tiltAngle1, tiltAngle2)
		end)
	end
end

function RageModule:_resetBodyTilt()
	-- Reset body tilt using aahelp1
	local RS = game:GetService("ReplicatedStorage")
	local aahelp1 = RS:FindFirstChild("aahelp1")
	
	if aahelp1 and aahelp1:IsA("RemoteEvent") then
		pcall(function()
			aahelp1:FireServer("reset")
		end)
	end
end

function RageModule:_enableAntiAim()
	-- Enable anti-aim system
	local RS = game:GetService("ReplicatedStorage")
	local aahelp1 = RS:FindFirstChild("aahelp1")
	
	if aahelp1 and aahelp1:IsA("RemoteEvent") then
		pcall(function()
			aahelp1:FireServer("enable")
		end)
	end
end

function RageModule:_disableAntiAim()
	-- Disable anti-aim system
	local RS = game:GetService("ReplicatedStorage")
	local aahelp1 = RS:FindFirstChild("aahelp1")
	
	if aahelp1 and aahelp1:IsA("RemoteEvent") then
		pcall(function()
			aahelp1:FireServer("disable")
		end)
	end
end

function RageModule:_findBestFreestandAngle()
	local char = self.player.Character
	if not char then return nil, 0, 0 end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if not hrp or not head then return nil, 0, 0 end
	
	local myPos = hrp.Position
	local headPos = head.Position
	
	-- Find closest enemy
	local closestEnemy, enemyDist = self:_findClosestEnemy()
	
	if not closestEnemy or not closestEnemy.Character then
		return nil, 0, 0 -- No enemy nearby
	end
	
	local enemyHrp = closestEnemy.Character:FindFirstChild("HumanoidRootPart")
	if not enemyHrp then return nil, 0, 0 end
	
	local enemyPos = enemyHrp.Position
	
	-- Calculate direction to enemy (horizontal only)
	local dirToEnemy = (enemyPos - myPos)
	dirToEnemy = Vector3.new(dirToEnemy.X, 0, dirToEnemy.Z).Unit
	
	-- Scan multiple angles around player to find best cover
	local bestAngle = nil
	local bestScore = -math.huge
	local bestTilt1 = 0
	local bestTilt2 = 0
	
	-- Check 8 directions around player
	local checkAngles = {-90, -67.5, -45, -22.5, 0, 22.5, 45, 67.5, 90}
	
	for _, angleOffset in ipairs(checkAngles) do
		local checkAngle = math.rad(angleOffset)
		
		-- Calculate direction to check (relative to enemy direction)
		local checkDir = Vector3.new(
			dirToEnemy.X * math.cos(checkAngle) - dirToEnemy.Z * math.sin(checkAngle),
			0,
			dirToEnemy.X * math.sin(checkAngle) + dirToEnemy.Z * math.cos(checkAngle)
		)
		
		-- Raycast from head position in this direction to find wall
		local rayOrigin = headPos
		local rayDistance = 20 -- Check 20 studs
		
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {char}
		raycastParams.IgnoreWater = true
		
		local wallResult = self.Workspace:Raycast(rayOrigin, checkDir * rayDistance, raycastParams)
		local wallDist = wallResult and wallResult.Distance or rayDistance
		
		-- Calculate if this position would hide head from enemy
		-- The closer the wall and the more perpendicular to enemy, the better
		local score = 0
		
		-- Prefer closer walls (up to 15 studs)
		if wallDist < 15 then
			score = score + (15 - wallDist) * 10 -- Closer wall = higher score
		end
		
		-- Prefer angles that put wall between us and enemy
		-- Best angle is 90 degrees (perpendicular to enemy)
		local angleToEnemy = math.abs(angleOffset)
		if angleToEnemy > 45 and angleToEnemy < 135 then
			score = score + 50 -- Bonus for perpendicular angles
		end
		
		-- Check if wall actually blocks line of sight to enemy
		if wallResult then
			-- Raycast from enemy to our head position
			local enemyToHeadDir = (headPos - enemyPos).Unit
			local losRaycast = self.Workspace:Raycast(enemyPos, enemyToHeadDir * enemyDist, raycastParams)
			
			if losRaycast and losRaycast.Instance then
				-- Wall blocks line of sight!
				score = score + 100
			end
		end
		
		if score > bestScore then
			bestScore = score
			bestAngle = checkAngle
			
			-- Determine tilt based on angle
			if angleOffset < -45 then
				-- Lean left
				bestTilt1 = -70
				bestTilt2 = 70
			elseif angleOffset > 45 then
				-- Lean right
				bestTilt1 = 70
				bestTilt2 = -70
			else
				-- Slight lean
				bestTilt1 = -30
				bestTilt2 = 30
			end
		end
	end
	
	-- If no good cover found, just face away from enemy
	if bestAngle == nil then
		bestAngle = 0 -- Face away from enemy (0 degrees = opposite direction)
		bestTilt1 = -30
		bestTilt2 = 30
	end
	
	-- Calculate final direction (OPPOSITE to the found angle to hide head behind wall)
	-- If wall is on left (-90°), we turn right to hide head behind it
	local finalAngle = bestAngle + math.pi -- Add 180 degrees to face opposite direction
	
	local finalDir = Vector3.new(
		dirToEnemy.X * math.cos(finalAngle) - dirToEnemy.Z * math.sin(finalAngle),
		0,
		dirToEnemy.X * math.sin(finalAngle) + dirToEnemy.Z * math.cos(finalAngle)
	)
	
	local targetCFrame = CFrame.lookAt(myPos, myPos + finalDir)
	
	return targetCFrame, bestTilt1, bestTilt2
end

function RageModule:_startFreestand()
	if self._freestandConn then return end
	
	-- Enable anti-aim system
	self:_enableAntiAim()
	
	self._freestandConn = self.RunService.Heartbeat:Connect(function()
		local now = tick()
		
		-- Update every 0.1 seconds (10 times per second)
		if now - self._freestandLastUpdate < 0.1 then return end
		self._freestandLastUpdate = now
		
		local char = self.player.Character
		if not char then return end
		
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		-- Get best angle and tilt
		local targetCFrame, tiltAngle1, tiltAngle2 = self:_findBestFreestandAngle()
		
		if not targetCFrame then 
			-- No enemy, reset tilt
			self:_resetBodyTilt()
			return 
		end
		
		-- Apply rotation to HumanoidRootPart (only Y-axis rotation to avoid breaking hitboxes)
		local currentCFrame = hrp.CFrame
		local currentPos = currentCFrame.Position
		
		-- Extract only the Y rotation from target CFrame
		local _, targetY, _ = targetCFrame:ToEulerAnglesYXZ()
		
		-- Create new CFrame with only Y rotation, keeping position and upright orientation
		local newCFrame = CFrame.new(currentPos) * CFrame.Angles(0, targetY, 0)
		
		-- Smooth rotation (20% interpolation for stability)
		hrp.CFrame = currentCFrame:Lerp(newCFrame, 0.2)
		
		-- Apply body tilt using aahelp1 (server-side, visible to all players)
		self:_applyBodyTilt(tiltAngle1, tiltAngle2)
	end)
end

function RageModule:_stopFreestand()
	if self._freestandConn then
		self._freestandConn:Disconnect()
		self._freestandConn = nil
	end
	
	-- Reset body tilt and disable anti-aim
	self:_resetBodyTilt()
	self:_disableAntiAim()
end

function RageModule:SetFreestandEnabled(value)
	self.FREESTAND_ENABLED = value
	
	if value then
		self:_startFreestand()
	else
		self:_stopFreestand()
	end
end

function RageModule:SetRapidfireShots(value)
	self.RAPIDFIRE_SHOTS = value
end

function RageModule:SetRapidfireMode(value)
	self.RAPIDFIRE_MODE = value
	if self.RAPIDFIRE_ENABLED then
		self:SetRapidfireEnabled(false)
		task.defer(function()
			self:SetRapidfireEnabled(true)
		end)
	end
end

function RageModule:SetRapidfireReequip(value)
	self.RAPIDFIRE_REEQUIP = value
end

function RageModule:SetRapidfireCycleDelay(value)
	self.RAPIDFIRE_CYCLE_DELAY = value
end

-- ============================================
-- CONFIG FUNCTIONS
-- ============================================
function RageModule:GetSettings()
	return {
		RAGE_ENABLED = self.RAGE_ENABLED,
		RAGE_HITPART = self.RAGE_HITPART,
		RAGE_HITCHANCE = self.RAGE_HITCHANCE,
		RAGE_HITCHANCE_ENABLED = self.RAGE_HITCHANCE_ENABLED,
		RAGE_AUTOSHOOT = self.RAGE_AUTOSHOOT,
		RAGE_NOSPREAD = self.RAGE_NOSPREAD,
		AUTO_EQUIP_SSG = self.AUTO_EQUIP_SSG,
		MAX_DISTANCE = self.MAX_DISTANCE,
		PREDICTION_ENABLED = self.PREDICTION_ENABLED,
		PREDICTION_STRENGTH = self.PREDICTION_STRENGTH,
		MIN_DAMAGE_ENABLED = self.MIN_DAMAGE_ENABLED,
		MIN_DAMAGE_VALUE = self.MIN_DAMAGE_VALUE,
		DOUBLETAP_ENABLED = self.DOUBLETAP_ENABLED,
		DOUBLETAP_TELEPORT = self.DOUBLETAP_TELEPORT,
		DOUBLETAP_MAX_TP_DIST = self.DOUBLETAP_MAX_TP_DIST,
		DT_COOLDOWN = self.DT_COOLDOWN,
		RAPIDFIRE_ENABLED = self.RAPIDFIRE_ENABLED,
		RAPIDFIRE_SHOTS = self.RAPIDFIRE_SHOTS,
		RAPIDFIRE_MODE = self.RAPIDFIRE_MODE,
		RAPIDFIRE_REEQUIP = self.RAPIDFIRE_REEQUIP,
		RAPIDFIRE_CYCLE_DELAY = self.RAPIDFIRE_CYCLE_DELAY,
	}
end

function RageModule:ApplySettings(settings)
	if not settings then return end

	if settings.RAGE_ENABLED ~= nil then self:SetEnabled(settings.RAGE_ENABLED) end
	if settings.RAGE_HITPART ~= nil then self:SetHitpart(settings.RAGE_HITPART) end
	if settings.RAGE_HITCHANCE ~= nil then self:SetHitchance(settings.RAGE_HITCHANCE) end
	if settings.RAGE_HITCHANCE_ENABLED ~= nil then self:SetHitchanceEnabled(settings.RAGE_HITCHANCE_ENABLED) end
	if settings.RAGE_AUTOSHOOT ~= nil then self:SetAutoShoot(settings.RAGE_AUTOSHOOT) end
	if settings.RAGE_NOSPREAD ~= nil then self:SetNoSpread(settings.RAGE_NOSPREAD) end
	if settings.AUTO_EQUIP_SSG ~= nil then self:SetAutoEquipSSG(settings.AUTO_EQUIP_SSG) end
	if settings.MAX_DISTANCE ~= nil then self:SetMaxDistance(settings.MAX_DISTANCE) end
	if settings.PREDICTION_ENABLED ~= nil then self:SetPredictionEnabled(settings.PREDICTION_ENABLED) end
	if settings.PREDICTION_STRENGTH ~= nil then self:SetPredictionStrength(settings.PREDICTION_STRENGTH) end
	if settings.MIN_DAMAGE_ENABLED ~= nil then self:SetMinDamageEnabled(settings.MIN_DAMAGE_ENABLED) end
	if settings.MIN_DAMAGE_VALUE ~= nil then self:SetMinDamageValue(settings.MIN_DAMAGE_VALUE) end
	if settings.DOUBLETAP_ENABLED ~= nil then self:SetDoubleTapEnabled(settings.DOUBLETAP_ENABLED) end
	if settings.DOUBLETAP_TELEPORT ~= nil then self:SetDoubleTapTeleport(settings.DOUBLETAP_TELEPORT) end
	if settings.DOUBLETAP_MAX_TP_DIST ~= nil then self:SetDoubleTapMaxDist(settings.DOUBLETAP_MAX_TP_DIST) end
	if settings.DT_COOLDOWN ~= nil then self:SetDoubleTapCooldown(settings.DT_COOLDOWN) end
	if settings.RAPIDFIRE_MODE ~= nil then self:SetRapidfireMode(settings.RAPIDFIRE_MODE) end
	if settings.RAPIDFIRE_REEQUIP ~= nil then self:SetRapidfireReequip(settings.RAPIDFIRE_REEQUIP) end
	if settings.RAPIDFIRE_CYCLE_DELAY ~= nil then self:SetRapidfireCycleDelay(settings.RAPIDFIRE_CYCLE_DELAY) end
	if settings.RAPIDFIRE_SHOTS ~= nil then self:SetRapidfireShots(settings.RAPIDFIRE_SHOTS) end
	if settings.RAPIDFIRE_ENABLED ~= nil then self:SetRapidfireEnabled(settings.RAPIDFIRE_ENABLED) end
end


-- ══════════════════════════════════════════════════════════════════
--  [ ANTI-AIM MODULE ]  — Universal (без зависимости от aahelp)
-- ══════════════════════════════════════════════════════════════════
local AntiAimModule = {}
AntiAimModule.__index = AntiAimModule

local _AAPlayers     = game:GetService("Players")
local _AALocalPlayer = _AAPlayers.LocalPlayer
local _AARunService  = game:GetService("RunService")
local _AAUIS         = game:GetService("UserInputService")
local _AAWorkspace   = game:GetService("Workspace")
local _AARep         = game:GetService("ReplicatedStorage")

local AAConfig = {
    Enabled      = false,
    PitchMode    = "Off",
    CustomPitch  = 0,
    YawBase      = "Local View",
    YawMode      = "Off",
    YawOffset    = 0,
    YawJitter    = "Off",
    JitterOffset = 45,
    SlowWalk     = false,
    SlowWalkSpeed= 50,
    SpinSpeed    = 10,
    _spinAngle   = 0,
    _jitterSign  = 1,
    _jitterTimer = 0,
    _origSpeed   = 16,
}

-- Попытка найти aahelp ремоуты (не обязательны)
local _aahelp1 = _AARep:FindFirstChild("aahelp1")
local _aahelpE = _AARep:FindFirstChild("aahelp")

-- ── Shot detection (universal) ────────────────────────────────────
local _lastShot  = 0
local _shooting  = false

local function _setupShotDet()
    local function bindTool(tool)
        tool.Activated:Connect(function()
            _lastShot = tick(); _shooting = true
            task.delay(0.3, function() _shooting = false end)
        end)
    end
    local function bindChar(char)
        char.ChildAdded:Connect(function(c) if c:IsA("Tool") then bindTool(c) end end)
        for _, c in ipairs(char:GetChildren()) do if c:IsA("Tool") then bindTool(c) end end
    end
    if _AALocalPlayer.Character then bindChar(_AALocalPlayer.Character) end
    _AALocalPlayer.CharacterAdded:Connect(bindChar)
    _AAUIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            local c = _AALocalPlayer.Character
            if c and c:FindFirstChildOfClass("Tool") then
                _lastShot = tick(); _shooting = true
                task.delay(0.3, function() _shooting = false end)
            end
        end
    end)
end


-- ── Pitch — через HRP CFrame (без поворота камеры) ────────────────
local function _applyPitchCamera(angleDeg)
    local char = _AALocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local rad      = math.rad(angleDeg)
    local _, cy, _ = hrp.CFrame:ToEulerAnglesYXZ()
    pcall(function()
        hrp.CFrame = CFrame.new(hrp.Position)
            * CFrame.Angles(0, cy, 0)
            * CFrame.Angles(rad, 0, 0)
    end)
end

-- aahelp1 remote если есть на сервере
local function _applyPitchRemote(a, b)
    if not _aahelp1 then return end
    pcall(function() _aahelp1:FireServer("apply", a, b) end)
end

local function _getPitch()
    local m = AAConfig.PitchMode
    if m == "Off"     then return nil end
    if m == "Down"    then return -89 end
    if m == "Up"      then return  89 end
    if m == "Minimal" then return -45 end
    if m == "Fake"    then return math.random(0,1) == 0 and -89 or 89 end
    if m == "Random"  then return math.random(-89, 89) end
    if m == "Custom"  then return math.clamp(AAConfig.CustomPitch, -89, 89) end
    return nil
end

-- ── Yaw ───────────────────────────────────────────────────────────
local function _getYawBase()
    local char = _AALocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end

    local base = AAConfig.YawBase
    if base == "At Targets" then
        -- Поворачиваемся к ближайшему врагу
        local minD, bestAngle = math.huge, 0
        for _, p in ipairs(_AAPlayers:GetPlayers()) do
            if p == _AALocalPlayer then continue end
            local c = p.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if not r then continue end
            local d = (r.Position - hrp.Position).Magnitude
            if d < minD then
                minD = d
                local dir = r.Position - hrp.Position
                bestAngle = math.atan2(-dir.X, -dir.Z)
            end
        end
        return bestAngle
    elseif base == "Freestanding" then
        -- Поворачиваемся к ближайшей стене
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { _AALocalPlayer.Character }
        local bestAngle = 0
        local bestDist  = 0
        for i = 0, 7 do
            local a    = i * (math.pi / 4)
            local dir  = Vector3.new(math.cos(a), 0, math.sin(a)) * 10
            local hit  = _AAWorkspace:Raycast(hrp.Position, dir, params)
            local dist = hit and hit.Distance or 10
            if dist > bestDist then bestDist = dist; bestAngle = a + math.pi end
        end
        return bestAngle
    end

    -- "Local View" — от камеры
    local cam = _AAWorkspace.CurrentCamera
    local lv  = cam and cam.CFrame.LookVector or hrp.CFrame.LookVector
    return math.atan2(-lv.X, -lv.Z)
end

local function _getYaw(dt)
    local m   = AAConfig.YawMode
    local off = math.rad(AAConfig.YawOffset)
    if m == "Off"      then return 0 end
    if m == "180"      then return math.pi + off end
    if m == "180 Z"    then return math.pi * 0.5 + off end
    if m == "Sideways" then return math.pi * 0.5 + off end
    if m == "Spin"     then
        AAConfig._spinAngle = AAConfig._spinAngle + math.rad(AAConfig.SpinSpeed * 10) * dt
        return AAConfig._spinAngle + off
    end
    return off
end

local function _getJitter(dt)
    local m = AAConfig.YawJitter
    if m == "Off" then return 0 end
    local range = math.rad(AAConfig.JitterOffset)
    if m == "Offset" then
        AAConfig._jitterTimer = AAConfig._jitterTimer + dt * 8
        return math.sin(AAConfig._jitterTimer) * range
    end
    if m == "Center" then
        AAConfig._jitterTimer = AAConfig._jitterTimer + dt * 12
        return math.sin(AAConfig._jitterTimer * 2) * range * 0.5
    end
    if m == "3-Way" then
        AAConfig._jitterTimer = AAConfig._jitterTimer + dt * 10
        local t = math.fmod(AAConfig._jitterTimer, 3)
        return (t < 1 and -range or t < 2 and 0 or range)
    end
    if m == "Random" then
        AAConfig._jitterTimer = AAConfig._jitterTimer + dt
        if AAConfig._jitterTimer > 0.05 then
            AAConfig._jitterTimer = 0
            AAConfig._jitterSign = math.random(-1,1)
        end
        return AAConfig._jitterSign * range
    end
    if m == "Sway" then
        AAConfig._jitterTimer = AAConfig._jitterTimer + dt * 5
        return math.sin(AAConfig._jitterTimer) * range * 0.7
            + math.cos(AAConfig._jitterTimer * 2.3) * range * 0.3
    end
    return 0
end

-- ── Slow Walk ─────────────────────────────────────────────────────
local function _applySlowWalk()
    if not AAConfig.SlowWalk then return end
    local char = _AALocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = AAConfig._origSpeed * (AAConfig.SlowWalkSpeed / 100)
    if math.abs(hum.WalkSpeed - target) > 0.5 then
        hum.WalkSpeed = target
    end
end

local function _restoreWalkSpeed()
    local char = _AALocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = AAConfig._origSpeed end
end

-- ── Main loop ─────────────────────────────────────────────────────
local _aaConn    = nil
local _aaDead    = false
local _lastPitch = 0

local function _startAA()
    if _aaConn then return end
    _setupShotDet()

    local _lastAahelpT = 0

    _aaConn = _AARunService.Heartbeat:Connect(function(dt)
        if not AAConfig.Enabled then return end
        local char = _AALocalPlayer.Character
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end

        local now = tick()

        -- Pitch через HRP, не камеру
        local pitch = _getPitch()
        if pitch then
            _applyPitchCamera(pitch)
            _applyPitchRemote(pitch, -pitch)
        end

        -- Yaw через HRP
        if AAConfig.YawMode ~= "Off"
            and not _shooting
            and (now - _lastShot > 0.25) then
            local total = _getYawBase() + _getYaw(dt) + _getJitter(dt)
            pcall(function()
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, total, 0)
            end)
        end

        _applySlowWalk()

        -- aahelp protect раз в секунду, не каждый кадр
        if _aahelpE and (now - _lastAahelpT > 1) then
            _lastAahelpT = now
            pcall(function() _aahelpE:FireServer("enable") end)
        end
    end)
end

local function _stopAA()
    if _aaConn then _aaConn:Disconnect(); _aaConn = nil end
    if _aahelp1 then pcall(function() _aahelp1:FireServer("disable") end) end
    _restoreWalkSpeed()
    -- Восстанавливаем голову если меняли
    local char = _AALocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        pcall(function()
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
        end)
    end
end

-- Character reconnect
local function _setupChar(char)
    _aaDead = false
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        AAConfig._origSpeed = hum.WalkSpeed
        hum.Died:Connect(function()
            _aaDead = true
            if _aahelp1 then pcall(function() _aahelp1:FireServer("disable") end) end
        end)
    end
    task.wait(0.15)
    _aaDead = false
end

if _AALocalPlayer.Character then _setupChar(_AALocalPlayer.Character) end
_AALocalPlayer.CharacterAdded:Connect(_setupChar)

-- ── Public API ────────────────────────────────────────────────────
function AntiAimModule.new()
    local self = setmetatable({}, AntiAimModule)
    _startAA()
    return self
end

function AntiAimModule:SetEnabled(v)
    AAConfig.Enabled = v
    if not v then _stopAA(); _startAA() end
end
function AntiAimModule:SetPitchMode(v)      AAConfig.PitchMode     = v end
function AntiAimModule:SetCustomPitch(v)    AAConfig.CustomPitch   = v end
function AntiAimModule:SetYawBase(v)        AAConfig.YawBase       = v end
function AntiAimModule:SetYawMode(v)        AAConfig.YawMode       = v; AAConfig._spinAngle = 0 end
function AntiAimModule:SetYawOffset(v)      AAConfig.YawOffset     = v end
function AntiAimModule:SetYawJitter(v)      AAConfig.YawJitter     = v; AAConfig._jitterTimer = 0 end
function AntiAimModule:SetJitterOffset(v)   AAConfig.JitterOffset  = v end
function AntiAimModule:SetSlowWalk(v)       AAConfig.SlowWalk      = v; if not v then _restoreWalkSpeed() end end
function AntiAimModule:SetSlowWalkSpeed(v)  AAConfig.SlowWalkSpeed = v end
function AntiAimModule:SetSpinSpeed(v)      AAConfig.SpinSpeed     = v end

--  [ WORLD / MISC / CONFIG MANAGER ]
-- ══════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TS = game:GetService("TweenService")

local player = Players.LocalPlayer

local World = {}
World.__index = World

function World.new()
	local self = setmetatable({}, World)

	self.ORIGINAL_LIGHTING = {
		Brightness = Lighting.Brightness,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		ClockTime = Lighting.ClockTime,
	}

	self.WORLD_TIME_ENABLED = false
	self.CUSTOM_CLOCKTIME = Lighting.ClockTime

	self.CUSTOM_SKY_ENABLED = false
	self.CUSTOM_SKY_PRESET = "Original"

	self.SKY_PRESETS = {
		Original = {
			SkyboxBk = "rbxassetid://148345460",
			SkyboxDn = "rbxassetid://148345469",
			SkyboxFt = "rbxassetid://148345455",
			SkyboxLf = "rbxassetid://148345446",
			SkyboxRt = "rbxassetid://148345440",
			SkyboxUp = "rbxassetid://148345466",
			SunTextureId = "rbxassetid://1345009717",
			MoonTextureId = "rbxasset://sky/moon.jpg",
			StarCount = 3000,
		},
		Blue = {
			SkyboxBk = "rbxassetid://124106120273678",
			SkyboxDn = "rbxassetid://72406028001064",
			SkyboxFt = "rbxassetid://139238600782726",
			SkyboxLf = "rbxassetid://139363840022859",
			SkyboxRt = "rbxassetid://122628916393316",
			SkyboxUp = "rbxassetid://104354476381566",
			StarCount = 3000,
		},
		Gray = {
			CelestialBodiesShown = true,
			MoonAngularSize = 6,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://15063412549",
			SkyboxDn = "rbxassetid://15063431496",
			SkyboxFt = "rbxassetid://15063442046",
			SkyboxLf = "rbxassetid://15063637382",
			SkyboxRt = "rbxassetid://15063435355",
			SkyboxUp = "rbxassetid://15063533447",
			StarCount = 3000,
			SunAngularSize = 9,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
		Dark = {
			CelestialBodiesShown = true,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://2013298",
			SkyboxDn = "rbxassetid://2013298",
			SkyboxFt = "rbxassetid://2013298",
			SkyboxLf = "rbxassetid://2013298",
			SkyboxRt = "rbxassetid://2013298",
			SkyboxUp = "rbxassetid://2013298",
			StarCount = 3000,
			SunAngularSize = 21,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
		Green = {
			CelestialBodiesShown = false,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://56661187",
			SkyboxDn = "rbxassetid://566611398",
			SkyboxFt = "rbxassetid://566611142",
			SkyboxLf = "rbxassetid://566611266",
			SkyboxRt = "rbxassetid://566611300",
			SkyboxUp = "rbxassetid://566611218",
			StarCount = 3000,
			SunAngularSize = 21,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
		Pink = {
			CelestialBodiesShown = false,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://271042516",
			SkyboxDn = "rbxassetid://271077243",
			SkyboxFt = "rbxassetid://271042556",
			SkyboxLf = "rbxassetid://271042310",
			SkyboxRt = "rbxassetid://271042467",
			SkyboxUp = "rbxassetid://271077958",
			StarCount = 0,
			SunAngularSize = 21,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
		Orange = {
			CelestialBodiesShown = true,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://150939022",
			SkyboxDn = "rbxassetid://150939038",
			SkyboxFt = "rbxassetid://150939047",
			SkyboxLf = "rbxassetid://150939056",
			SkyboxRt = "rbxassetid://150939063",
			SkyboxUp = "rbxassetid://150939082",
			StarCount = 3000,
			SunAngularSize = 21,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
		Purple = {
			CelestialBodiesShown = true,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://75339068650022",
			SkyboxDn = "rbxassetid://103288557260150",
			SkyboxFt = "rbxassetid://131140417030026",
			SkyboxLf = "rbxassetid://91178363674210",
			SkyboxRt = "rbxassetid://91811655162047",
			SkyboxUp = "rbxassetid://70646477316976",
			StarCount = 3000,
			SunAngularSize = 14,
			SunTextureId = "rbxassetid://13683514089",
		},
		Red = {
			CelestialBodiesShown = false,
			MoonAngularSize = 11,
			MoonTextureId = "rbxasset://sky/moon.jpg",
			SkyboxBk = "rbxassetid://108929045660200",
			SkyboxDn = "rbxassetid://78646480540009",
			SkyboxFt = "rbxassetid://90546017435179",
			SkyboxLf = "rbxassetid://109838453114563",
			SkyboxRt = "rbxassetid://94190734796082",
			SkyboxUp = "rbxassetid://126944775797063",
			StarCount = 3000,
			SunAngularSize = 21,
			SunTextureId = "rbxasset://sky/sun.jpg",
		},
	}

	local s = Lighting:FindFirstChildOfClass("Sky")
	if s then
		self.ORIGINAL_SKY = s:Clone()
	end

	self.BLUR_ENABLED = false
	self.BLUR_SIZE = 10
	self._blurEffect = nil

	self.BHOP_ENABLED = false
	self.BHOP_SPEED = 25
	self._bhopConn = nil

	self.NOCLIP_ENABLED = false
	self._noclipConn = nil

	self.FLY_ENABLED = false
	self.FLY_SPEED = 50
	self._flyConn = nil
	self._flyBV = nil

	self.SPAWN_TP_ENABLED = false
	self._spawnTpConn = nil
	
	self.SPAWN_BOX_TP_ENABLED = false
	self._spawnBoxTpConn = nil
	self._spawnBoxTpCharConn = nil

	self.TRASHTALK_ENABLED = false
	self.TRASHTALK_MODE = "Kill Talk"
	self.TRASHTALK_MESSAGES = {
		{text = "ez", chance = 100},
		{text = "gg ez", chance = 100},
		{text = "too easy", chance = 100},
		{text = "sit down", chance = 100},
		{text = "get good", chance = 100},
		{text = "nice try", chance = 80},
		{text = "better luck next time", chance = 80},
		{text = "outplayed", chance = 100},
		{text = "owned", chance = 100},
		{text = "rekt", chance = 100},
		{text = "1", chance = 100},
		{text = "get better", chance = 100},
		{text = "imagine losing", chance = 90},
		{text = "skill issue", chance = 100},
		{text = "cope", chance = 100},
		{text = "cry about it", chance = 90},
		{text = "why r u so bad?", chance = 70},
		{text = "mad?", chance = 100},
		{text = "stay mad", chance = 90},
		{text = "L + ratio", chance = 100},
		{text = "touch grass", chance = 80},
		{text = "no skill", chance = 100},
		{text = "aim diff", chance = 100},
		{text = "game sense diff", chance = 90},
		{text = "you're cooked", chance = 100},
		{text = "nt tho", chance = 80},
		{text = "close one", chance = 70},
		{text = "'almost' had me", chance = 60},
	}
	self.TRASHTALK_COOLDOWN = 3
	self._ttMsgIndex = 1
	self._ttSpamConn = nil
	self._ttKillConn = nil
	self._ttRoundConn = nil
	self._ttDeathConn = nil

	-- Weather
	self.RAIN_ENABLED = false
	self.RAIN_DENSITY = 50
	self.RAIN_SPEED = 30
	self._rainPart = nil
	self._rainEmitter = nil
	self._rainConn = nil

	self.SNOW_ENABLED = false
	self.SNOW_DENSITY = 40
	self.SNOW_SPEED = 10
	self._snowPart = nil
	self._snowEmitter = nil
	self._snowConn = nil

	self.THUNDER_ENABLED = false
	self.THUNDER_DENSITY = 50
	self.THUNDER_SPEED = 30
	self.THUNDER_FREQUENCY = 8
	self._thunderPart = nil
	self._thunderEmitter = nil
	self._thunderConn = nil
	self._thunderPosConn = nil

	self.FOG_ENABLED = false
	self.FOG_START = 0
	self.FOG_END = 500
	self.FOG_COLOR = Color3.fromRGB(180, 180, 190)
	self._origFog = {
		FogStart = Lighting.FogStart,
		FogEnd = Lighting.FogEnd,
		FogColor = Lighting.FogColor,
	}

	-- Model Changer
	-- Format: {headIds, torsoIds, headTransparency, bodyTransparency, keepHead, isHeadAccessory, rotation}
	self.MODEL_CHANGER_ENABLED = false
	self.MODEL_CHANGER_CURRENT = "None"
	self._modelCharConn = nil

	self.MODEL_PRESETS = {
		["Big Smoke"]       = {{}, {109672142364753}, 1, 1, false, false, nil},
		["CT Agent"]        = {{}, {17492888433}, 1, 1, false, false, nil},
		["Omni Man"]        = {{}, {116337723668725}, 1, 1, false, false, nil},
		["Tommy"]           = {{}, {78897905328829}, 1, 1, false, false, nil},
		["Knight"]          = {{}, {110422361106705}, 1, 1, false, false, nil},
		["Meowl"]           = {{}, {125560415251749}, 1, 1, false, false, nil},
		["Chicken"]         = {{}, {111084270237373}, 1, 1, false, false, nil},
		["Wither Skeleton"] = {{}, {88917815539525}, 1, 1, false, false, nil},
		["Pepe"]            = {{}, {18922025660}, 1, 1, false, false, nil},
		["El Gato"]         = {{}, {16300856317}, 1, 1, false, false, nil},
		["Freddy"]          = {{}, {18621834175}, 1, 1, false, false, nil},
		["Hulk"]            = {{}, {126877150690640}, 1, 1, false, false, nil},
		["R.E.P.O."]        = {{}, {133854315052737}, 1, 1, false, false, nil},
		["Minion"]          = {{}, {18402028966}, 1, 1, false, false, nil},
		["Mike Wazowski"]   = {{}, {108792046953186}, 1, 1, false, false, nil},
		["Mcqueen"]         = {{}, {106172409404094}, 1, 1, false, false, nil},
		["Goose"]           = {{}, {131077718703383}, 1, 1, false, false, nil},
		["MC Kitty"]        = {{}, {127788518295444}, 1, 1, false, false, nil},
		["Skipper"]         = {{}, {93610479545526}, 1, 1, false, false, nil},
		["Thomas"]          = {{}, {73707867955193}, 1, 1, false, false, nil},
		["Sammy"]           = {{}, {110689893916951}, 1, 1, false, false, nil},
		["Godzilla"]        = {{}, {111104115419296}, 1, 1, false, false, nil},
		["Invincible"]      = {{}, {113914088428629}, 1, 1, false, false, nil},
		["Tung Tung Sahur"] = {{}, {117976702168543}, 1, 1, false, false, nil},
		["SCP"]             = {{}, {87000744418491}, 1, 1, false, false, nil},
		["The Boiled One"]  = {{}, {18580369062}, 1, 1, false, false, nil},
	}

	-- Viewmodel (first person weapon visibility)
	self.VIEWMODEL_ENABLED = false
	self._viewmodelConn = nil
	self._viewmodelCharConn = nil

	self._unloadCallbacks = {}
	self._connections = {}

	return self
end

-- ═══════════════════════════════════════════════════
--  World Time Changer
-- ═══════════════════════════════════════════════════

function World:applyTime()
	if self.WORLD_TIME_ENABLED then
		Lighting.ClockTime = self.CUSTOM_CLOCKTIME
	else
		Lighting.ClockTime = self.ORIGINAL_LIGHTING.ClockTime
	end
end

function World:SetTimeEnabled(v)
	self.WORLD_TIME_ENABLED = v
	self:applyTime()
end

function World:SetClockTime(v)
	self.CUSTOM_CLOCKTIME = v
	self:applyTime()
end

-- ═══════════════════════════════════════════════════
--  Skybox Changer
-- ═══════════════════════════════════════════════════

function World:wipeSky()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then v:Destroy() end
	end
end

function World:buildSky(name)
	local data = self.SKY_PRESETS[name]
	if not data then return end
	local sky = Instance.new("Sky")
	for k, v in pairs(data) do
		sky[k] = v
	end
	sky.Name = "NemesisSky"
	sky.Parent = Lighting
end

function World:applySky()
	self:wipeSky()
	if self.CUSTOM_SKY_ENABLED then
		self:buildSky(self.CUSTOM_SKY_PRESET)
	else
		if self.ORIGINAL_SKY then
			self.ORIGINAL_SKY:Clone().Parent = Lighting
		end
	end
end

function World:SetSkyEnabled(v)
	self.CUSTOM_SKY_ENABLED = v
	self:applySky()
end

function World:SetSkyPreset(v)
	self.CUSTOM_SKY_PRESET = v
	self:applySky()
end

-- ═══════════════════════════════════════════════════
--  Blur (Post Processing)
-- ═══════════════════════════════════════════════════

function World:SetBlurEnabled(v)
	self.BLUR_ENABLED = v
	if v then
		if not self._blurEffect then
			self._blurEffect = Instance.new("BlurEffect")
			self._blurEffect.Name = "ArcBlur"
			self._blurEffect.Size = self.BLUR_SIZE
			self._blurEffect.Parent = Lighting
		end
		self._blurEffect.Enabled = true
	else
		if self._blurEffect then
			self._blurEffect.Enabled = false
		end
	end
end

function World:SetBlurSize(v)
	self.BLUR_SIZE = v
	if self._blurEffect then
		self._blurEffect.Size = v
	end
end

-- ═══════════════════════════════════════════════════
--  Bunny Hop
-- ═══════════════════════════════════════════════════

function World:SetBhopEnabled(v)
	self.BHOP_ENABLED = v
	if v then
		self:StartBhop()
	else
		self:StopBhop()
	end
end

function World:SetBhopSpeed(v)
	self.BHOP_SPEED = v
end

function World:StartBhop()
	self:StopBhop()
	self._bhopConn = RS.Heartbeat:Connect(function()
		if not self.BHOP_ENABLED then return end
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		hum.WalkSpeed = self.BHOP_SPEED
	end)
	table.insert(self._connections, self._bhopConn)
end

function World:StopBhop()
	if self._bhopConn then
		self._bhopConn:Disconnect()
		self._bhopConn = nil
	end
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
end

-- ═══════════════════════════════════════════════════
--  Noclip
-- ═══════════════════════════════════════════════════

function World:SetNoclipEnabled(v)
	self.NOCLIP_ENABLED = v
	if v then
		self:StartNoclip()
	else
		self:StopNoclip()
	end
end

function World:StartNoclip()
	self:StopNoclip()
	self._noclipConn = RS.Stepped:Connect(function()
		if not self.NOCLIP_ENABLED then return end
		local char = player.Character
		if not char then return end
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
	table.insert(self._connections, self._noclipConn)
end

function World:StopNoclip()
	if self._noclipConn then
		self._noclipConn:Disconnect()
		self._noclipConn = nil
	end
end

-- ═══════════════════════════════════════════════════
--  Fly
-- ═══════════════════════════════════════════════════

function World:SetFlyEnabled(v)
	self.FLY_ENABLED = v
	if v then
		self:StartFly()
	else
		self:StopFly()
	end
end

function World:SetFlySpeed(v)
	self.FLY_SPEED = v
end

function World:StartFly()
	self:StopFly()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local bv = Instance.new("BodyVelocity")
	bv.Name = "ArcFlyBV"
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.Parent = hrp
	self._flyBV = bv

	self._flyConn = RS.Heartbeat:Connect(function()
		if not self.FLY_ENABLED then return end
		if not hrp or not hrp.Parent then self:StopFly(); return end

		local cam = Workspace.CurrentCamera
		local dir = Vector3.new(0, 0, 0)
		local speed = self.FLY_SPEED

		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0 then
			dir = dir + cam.CFrame:VectorToWorldSpace(
				cam.CFrame:VectorToObjectSpace(moveDir).Unit
			) * speed
		end

		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			dir = dir + Vector3.new(0, speed, 0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
			dir = dir - Vector3.new(0, speed, 0)
		end

		bv.Velocity = dir

		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
	table.insert(self._connections, self._flyConn)
end

function World:StopFly()
	if self._flyConn then
		self._flyConn:Disconnect()
		self._flyConn = nil
	end
	if self._flyBV then
		self._flyBV:Destroy()
		self._flyBV = nil
	end
end

-- ═══════════════════════════════════════════════════
--  Enemy Spawn Teleport
-- ═══════════════════════════════════════════════════

function World:SetSpawnTpEnabled(v)
	self.SPAWN_TP_ENABLED = v
	if v then
		self:StartSpawnTp()
	else
		self:StopSpawnTp()
	end
end

function World:GetPlayerTeam()
	local char = player.Character
	if not char then return nil end

	local teamFolder = Workspace:FindFirstChild("Teams") or Workspace:FindFirstChild("teams")
	if teamFolder then
		for _, folder in pairs(teamFolder:GetChildren()) do
			local name = folder.Name:lower()
			for _, obj in pairs(folder:GetChildren()) do
				if obj.Name == player.Name or (obj:IsA("ObjectValue") and obj.Value == player) then
					if name:find("t") and not name:find("ct") then
						return "T"
					elseif name:find("ct") or name:find("counter") then
						return "CT"
					end
				end
			end
		end
	end

	if player.Team then
		local tn = player.Team.Name:lower()
		if tn:find("terrorist") and not tn:find("counter") then return "T" end
		if tn:find("counter") or tn:find("ct") then return "CT" end
		if tn == "t" then return "T" end
	end

	local teamVal = char:FindFirstChild("Team") or char:FindFirstChild("team")
	if teamVal and teamVal:IsA("StringValue") then
		local tv = teamVal.Value:lower()
		if tv:find("t") and not tv:find("ct") then return "T" end
		if tv:find("ct") or tv:find("counter") then return "CT" end
	end

	return nil
end

function World:TeleportToSpawn()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local team = self:GetPlayerTeam()
	if not team then return end

	if team == "T" then
		hrp.CFrame = CFrame.new(-201, 24, -10)
	elseif team == "CT" then
		hrp.CFrame = CFrame.new(-303, 19, 55)
	end
end

function World:StartSpawnTp()
	self:StopSpawnTp()

	local roundEvent = ReplicatedStorage:FindFirstChild("GameEvent")
		or ReplicatedStorage:FindFirstChild("RoundStart")
		or ReplicatedStorage:FindFirstChild("round")

	if roundEvent and roundEvent:IsA("RemoteEvent") then
		self._spawnTpConn = roundEvent.OnClientEvent:Connect(function()
			if not self.SPAWN_TP_ENABLED then return end
			task.delay(5.1, function()
				self:TeleportToSpawn()
			end)
		end)
		table.insert(self._connections, self._spawnTpConn)
	end

	local charConn
	charConn = player.CharacterAdded:Connect(function(char)
		if not self.SPAWN_TP_ENABLED then return end
		char:WaitForChild("HumanoidRootPart", 10)
		task.delay(5.1, function()
			if self.SPAWN_TP_ENABLED then
				self:TeleportToSpawn()
			end
		end)
	end)
	self._spawnTpCharConn = charConn
	table.insert(self._connections, charConn)
end

function World:StopSpawnTp()
	if self._spawnTpConn then
		self._spawnTpConn:Disconnect()
		self._spawnTpConn = nil
	end
	if self._spawnTpCharConn then
		self._spawnTpCharConn:Disconnect()
		self._spawnTpCharConn = nil
	end
end

-- ═══════════════════════════════════════════════════
--  Teleport to Spawn Box
-- ═══════════════════════════════════════════════════

function World:SetSpawnBoxTpEnabled(v)
	self.SPAWN_BOX_TP_ENABLED = v
	if v then
		self:StartSpawnBoxTp()
	else
		self:StopSpawnBoxTp()
	end
end

function World:TeleportToSpawnBox()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.CFrame = CFrame.new(-216, 26, -165)
end

function World:StartSpawnBoxTp()
	self:StopSpawnBoxTp()

	local roundEvent = ReplicatedStorage:FindFirstChild("GameEvent")
		or ReplicatedStorage:FindFirstChild("RoundStart")
		or ReplicatedStorage:FindFirstChild("round")

	if roundEvent and roundEvent:IsA("RemoteEvent") then
		self._spawnBoxTpConn = roundEvent.OnClientEvent:Connect(function()
			if not self.SPAWN_BOX_TP_ENABLED then return end
			task.delay(5.1, function()
				self:TeleportToSpawnBox()
			end)
		end)
		table.insert(self._connections, self._spawnBoxTpConn)
	end

	local charConn
	charConn = player.CharacterAdded:Connect(function(char)
		if not self.SPAWN_BOX_TP_ENABLED then return end
		char:WaitForChild("HumanoidRootPart", 10)
		task.delay(5.1, function()
			if self.SPAWN_BOX_TP_ENABLED then
				self:TeleportToSpawnBox()
			end
		end)
	end)
	self._spawnBoxTpCharConn = charConn
	table.insert(self._connections, charConn)
end

function World:StopSpawnBoxTp()
	if self._spawnBoxTpConn then
		self._spawnBoxTpConn:Disconnect()
		self._spawnBoxTpConn = nil
	end
	if self._spawnBoxTpCharConn then
		self._spawnBoxTpCharConn:Disconnect()
		self._spawnBoxTpCharConn = nil
	end
end

-- ═══════════════════════════════════════════════════
--  Trash Talk
-- ═══════════════════════════════════════════════════

function World:SetTrashtalkEnabled(v)
	self.TRASHTALK_ENABLED = v
	if v then
		self:StartTrashtalk()
	else
		self:StopTrashtalk()
	end
end

function World:SetTrashtalkMode(v)
	self.TRASHTALK_MODE = v
	if self.TRASHTALK_ENABLED then
		self:StopTrashtalk()
		self:StartTrashtalk()
	end
end

function World:SetTrashtalkCooldown(v)
	self.TRASHTALK_COOLDOWN = v
end

function World:AddTrashtalkMessage(msg, chance)
	if msg and msg ~= "" then
		table.insert(self.TRASHTALK_MESSAGES, {
			text = msg,
			chance = chance or 100
		})
	end
end

function World:RemoveTrashtalkMessage(index)
	if index > 0 and index <= #self.TRASHTALK_MESSAGES then
		table.remove(self.TRASHTALK_MESSAGES, index)
	end
end

function World:ClearTrashtalkMessages()
	self.TRASHTALK_MESSAGES = {}
	self._ttMsgIndex = 1
end

function World:GetNextMessage()
	if #self.TRASHTALK_MESSAGES == 0 then return nil end
	
	-- Filter messages by chance
	local availableMessages = {}
	for _, msgData in ipairs(self.TRASHTALK_MESSAGES) do
		local msg = type(msgData) == "table" and msgData.text or msgData
		local chance = type(msgData) == "table" and msgData.chance or 100
		
		-- Roll chance
		if math.random(1, 100) <= chance then
			table.insert(availableMessages, msg)
		end
	end
	
	-- If no messages passed chance check, use all messages
	if #availableMessages == 0 then
		for _, msgData in ipairs(self.TRASHTALK_MESSAGES) do
			local msg = type(msgData) == "table" and msgData.text or msgData
			table.insert(availableMessages, msg)
		end
	end
	
	if #availableMessages == 0 then return nil end
	
	-- For Random mode, pick random message
	if self.TRASHTALK_MODE == "Random" then
		return availableMessages[math.random(1, #availableMessages)]
	end
	
	-- For other modes, cycle through available messages
	local msg = availableMessages[self._ttMsgIndex]
	if not msg then
		self._ttMsgIndex = 1
		msg = availableMessages[1]
	end
	
	self._ttMsgIndex = self._ttMsgIndex + 1
	if self._ttMsgIndex > #availableMessages then
		self._ttMsgIndex = 1
	end
	
	return msg
end

function World:FindChatRemote()
	if self._chatRemote then return self._chatRemote end

	local function deepSearch(parent, depth)
		if depth > 3 then return nil end
		for _, child in pairs(parent:GetChildren()) do
			local n = child.Name:lower()
			if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
				if n:find("chat") or n:find("message") or n:find("msg")
					or n:find("send") or n:find("say") or n:find("talk") then
					return child
				end
			end
			if child:IsA("Folder") or child:IsA("Configuration") or child:IsA("ModuleScript") then
				local found = deepSearch(child, depth + 1)
				if found then return found end
			end
		end
		return nil
	end

	local legacy = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if legacy then
		local sayMsg = legacy:FindFirstChild("SayMessageRequest")
		if sayMsg then self._chatRemote = sayMsg; return sayMsg end
	end

	local found = deepSearch(ReplicatedStorage, 0)
	if found then self._chatRemote = found; return found end

	return nil
end

function World:SendChat(msg)
	if not msg or msg == "" then return end

	local sent = false

	-- PRIORITY 1: Mirage HVH specific (from stupidresolver)
	pcall(function()
		local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
		if RemoteEvents then
			local ChatEvent = RemoteEvents:FindFirstChild("ChatEvent")
			if ChatEvent and ChatEvent:IsA("RemoteEvent") then
				ChatEvent:FireServer(tostring(msg))
				sent = true
				return
			end
		end
	end)
	if sent then return end

	-- PRIORITY 2: TextChatService (new Roblox chat)
	pcall(function()
		local TCS = game:GetService("TextChatService")
		if TCS then
			local textChannels = TCS:FindFirstChild("TextChannels")
			if textChannels then
				for _, ch in pairs(textChannels:GetChildren()) do
					if ch:IsA("TextChannel") then
						ch:SendAsync(msg)
						sent = true
						return
					end
				end
			end
		end
	end)
	if sent then return end

	-- PRIORITY 3: Legacy chat system
	pcall(function()
		local legacy = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if legacy then
			local sayMsg = legacy:FindFirstChild("SayMessageRequest")
			if sayMsg then
				sayMsg:FireServer(msg, "All")
				sent = true
				return
			end
		end
	end)
	if sent then return end

	-- PRIORITY 4: Custom chat remote search
	pcall(function()
		local remote = self:FindChatRemote()
		if remote then
			if remote:IsA("RemoteEvent") then
				remote:FireServer(msg)
				sent = true
			elseif remote:IsA("RemoteFunction") then
				remote:InvokeServer(msg)
				sent = true
			end
		end
	end)
	if sent then return end

	-- PRIORITY 5: Fallback - search all RemoteEvents
	pcall(function()
		for _, v in pairs(ReplicatedStorage:GetDescendants()) do
			if v:IsA("RemoteEvent") then
				local n = v.Name:lower()
				if n:find("chat") or n:find("msg") or n:find("message") or n:find("say") or n:find("send") or n:find("talk") then
					v:FireServer(msg, "All")
					sent = true
					return
				end
			end
		end
	end)
	if sent then return end

	-- PRIORITY 6: Last resort - try all RemoteEvents
	pcall(function()
		for _, v in pairs(ReplicatedStorage:GetDescendants()) do
			if v:IsA("RemoteEvent") then
				pcall(function()
					v:FireServer(msg)
				end)
				return
			end
		end
	end)
end

function World:StartTrashtalk()
	self:StopTrashtalk()
	local mode = self.TRASHTALK_MODE

	if mode == "Spam" then
		self._ttSpamConn = task.spawn(function()
			while self.TRASHTALK_ENABLED and self.TRASHTALK_MODE == "Spam" do
				local msg = self:GetNextMessage()
				if msg then self:SendChat(msg) end
				task.wait(self.TRASHTALK_COOLDOWN)
			end
		end)

	elseif mode == "Kill Talk" then
		local infEvent = ReplicatedStorage:FindFirstChild("inf", 5)
		if infEvent then
			self._ttKillConn = infEvent.OnClientEvent:Connect(function()
				if not self.TRASHTALK_ENABLED then return end
				local msg = self:GetNextMessage()
				if msg then
					task.delay(0.3, function() self:SendChat(msg) end)
				end
			end)
			table.insert(self._connections, self._ttKillConn)
		end

	elseif mode == "Death Talk" then
		local function hookChar(char)
			local hum = char:WaitForChild("Humanoid", 10)
			if not hum then return end
			self._ttDeathConn = hum.Died:Connect(function()
				if not self.TRASHTALK_ENABLED then return end
				local msg = self:GetNextMessage()
				if msg then
					task.delay(0.5, function() self:SendChat(msg) end)
				end
			end)
			table.insert(self._connections, self._ttDeathConn)
		end
		if player.Character then hookChar(player.Character) end
		self._ttDeathCharConn = player.CharacterAdded:Connect(function(c) hookChar(c) end)
		table.insert(self._connections, self._ttDeathCharConn)

	elseif mode == "Round Start" then
		self._ttRoundCharConn = player.CharacterAdded:Connect(function()
			if not self.TRASHTALK_ENABLED then return end
			task.delay(5.5, function()
				if self.TRASHTALK_ENABLED then
					local msg = self:GetNextMessage()
					if msg then self:SendChat(msg) end
				end
			end)
		end)
		table.insert(self._connections, self._ttRoundCharConn)

	elseif mode == "Random" then
		self._ttSpamConn = task.spawn(function()
			while self.TRASHTALK_ENABLED and self.TRASHTALK_MODE == "Random" do
				if #self.TRASHTALK_MESSAGES > 0 then
					local msg = self.TRASHTALK_MESSAGES[math.random(1, #self.TRASHTALK_MESSAGES)]
					if msg then self:SendChat(msg) end
				end
				task.wait(self.TRASHTALK_COOLDOWN + math.random() * 3)
			end
		end)
	end
end

function World:StopTrashtalk()
	if self._ttKillConn then pcall(function() self._ttKillConn:Disconnect() end); self._ttKillConn = nil end
	if self._ttDeathConn then pcall(function() self._ttDeathConn:Disconnect() end); self._ttDeathConn = nil end
	if self._ttDeathCharConn then pcall(function() self._ttDeathCharConn:Disconnect() end); self._ttDeathCharConn = nil end
	if self._ttRoundConn then pcall(function() self._ttRoundConn:Disconnect() end); self._ttRoundConn = nil end
	if self._ttRoundCharConn then pcall(function() self._ttRoundCharConn:Disconnect() end); self._ttRoundCharConn = nil end
	if self._ttSpamConn then pcall(function() task.cancel(self._ttSpamConn) end); self._ttSpamConn = nil end
end

-- ═══════════════════════════════════════════════════
--  Weather: Rain
-- ═══════════════════════════════════════════════════

function World:_createWeatherPart(name)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(200, 1, 200)
	part.Parent = Workspace
	return part
end

function World:_updateWeatherPartPos(part)
	local cam = Workspace.CurrentCamera
	if cam then
		part.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 30, 0))
	end
end

function World:SetRainEnabled(v)
	self.RAIN_ENABLED = v
	if v then
		self:StartRain()
	else
		self:StopRain()
	end
end

function World:SetRainDensity(v)
	self.RAIN_DENSITY = v
	if self._rainEmitter then
		self._rainEmitter.Rate = v * 20
	end
end

function World:SetRainSpeed(v)
	self.RAIN_SPEED = v
	if self._rainEmitter then
		local sp = NumberRange.new(v, v + 10)
		self._rainEmitter.Speed = sp
	end
end

function World:StartRain()
	self:StopRain()
	local part = self:_createWeatherPart("ArcRain")
	self._rainPart = part

	local att = Instance.new("Attachment")
	att.Parent = part

	local pe = Instance.new("ParticleEmitter")
	pe.Parent = att
	pe.Texture = "rbxassetid://241876428"
	pe.Rate = self.RAIN_DENSITY * 20
	pe.Lifetime = NumberRange.new(1.5, 3)
	pe.Speed = NumberRange.new(self.RAIN_SPEED, self.RAIN_SPEED + 15)
	pe.SpreadAngle = Vector2.new(25, 25)
	pe.Rotation = NumberRange.new(0, 0)
	pe.RotSpeed = NumberRange.new(0, 0)
	pe.EmissionDirection = Enum.NormalId.Bottom
	pe.Acceleration = Vector3.new(0, -20, 0)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(1, 0.06),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.6, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Color = ColorSequence.new(Color3.fromRGB(200, 215, 235))
	pe.LightEmission = 0.15
	pe.Drag = 0
	self._rainEmitter = pe

	self._rainConn = RS.Heartbeat:Connect(function()
		if part and part.Parent then
			self:_updateWeatherPartPos(part)
		end
	end)
end

function World:StopRain()
	if self._rainConn then
		pcall(function() self._rainConn:Disconnect() end)
		self._rainConn = nil
	end
	if self._rainPart then
		pcall(function() self._rainPart:Destroy() end)
		self._rainPart = nil
	end
	self._rainEmitter = nil
end

-- ═══════════════════════════════════════════════════
--  Weather: Snow
-- ═══════════════════════════════════════════════════

function World:SetSnowEnabled(v)
	self.SNOW_ENABLED = v
	if v then
		self:StartSnow()
	else
		self:StopSnow()
	end
end

function World:SetSnowDensity(v)
	self.SNOW_DENSITY = v
	if self._snowEmitter then
		self._snowEmitter.Rate = v * 15
	end
end

function World:SetSnowSpeed(v)
	self.SNOW_SPEED = v
	if self._snowEmitter then
		self._snowEmitter.Speed = NumberRange.new(v, v + 5)
	end
end

function World:StartSnow()
	self:StopSnow()
	local part = self:_createWeatherPart("ArcSnow")
	self._snowPart = part

	local att = Instance.new("Attachment")
	att.Parent = part

	local pe = Instance.new("ParticleEmitter")
	pe.Texture = "rbxassetid://6490035152"
	pe.Rate = self.SNOW_DENSITY * 15
	pe.Lifetime = NumberRange.new(4, 8)
	pe.Speed = NumberRange.new(self.SNOW_SPEED, self.SNOW_SPEED + 5)
	pe.SpreadAngle = Vector2.new(60, 60)
	pe.Rotation = NumberRange.new(0, 360)
	pe.RotSpeed = NumberRange.new(-40, 40)
	pe.EmissionDirection = Enum.NormalId.Bottom
	pe.Acceleration = Vector3.new(0, -2, 0)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 0.08),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.8, 0.15),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Color = ColorSequence.new(Color3.fromRGB(245, 248, 255))
	pe.LightEmission = 0.3
	pe.Drag = 3
	pe.Parent = att
	self._snowEmitter = pe

	self._snowConn = RS.Heartbeat:Connect(function()
		if part and part.Parent then
			self:_updateWeatherPartPos(part)
		end
	end)
end

function World:StopSnow()
	if self._snowConn then
		pcall(function() self._snowConn:Disconnect() end)
		self._snowConn = nil
	end
	if self._snowPart then
		pcall(function() self._snowPart:Destroy() end)
		self._snowPart = nil
	end
	self._snowEmitter = nil
end

-- ═══════════════════════════════════════════════════
--  Weather: Thunder
-- ═══════════════════════════════════════════════════

function World:SetThunderEnabled(v)
	self.THUNDER_ENABLED = v
	if v then
		self:StartThunder()
	else
		self:StopThunder()
	end
end

function World:SetThunderDensity(v)
	self.THUNDER_DENSITY = v
	if self._thunderEmitter then
		self._thunderEmitter.Rate = v * 20
	end
end

function World:SetThunderSpeed(v)
	self.THUNDER_SPEED = v
	if self._thunderEmitter then
		self._thunderEmitter.Speed = NumberRange.new(v, v + 10)
	end
end

function World:SetThunderFrequency(v)
	self.THUNDER_FREQUENCY = v
end

function World:_flashLightning()
	local origBrightness = Lighting.Brightness
	local origAmbient = Lighting.Ambient

	Lighting.Brightness = 8
	Lighting.Ambient = Color3.fromRGB(200, 210, 255)

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://1907349676"
	sound.Volume = 0.6
	sound.PlayOnRemove = false
	sound.Parent = Workspace
	sound:Play()

	task.delay(0.12, function()
		TS:Create(Lighting, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Brightness = origBrightness,
			Ambient = origAmbient,
		}):Play()
	end)
	task.delay(3, function()
		pcall(function() sound:Destroy() end)
	end)
end

function World:StartThunder()
	self:StopThunder()
	self.THUNDER_ENABLED = true

	local part = self:_createWeatherPart("ArcThunder")
	self._thunderPart = part

	local att = Instance.new("Attachment")
	att.Parent = part

	local pe = Instance.new("ParticleEmitter")
	pe.Parent = att
	pe.Texture = "rbxassetid://241876428"
	pe.Rate = self.THUNDER_DENSITY * 20
	pe.Lifetime = NumberRange.new(1.5, 3)
	pe.Speed = NumberRange.new(self.THUNDER_SPEED, self.THUNDER_SPEED + 15)
	pe.SpreadAngle = Vector2.new(25, 25)
	pe.Rotation = NumberRange.new(0, 0)
	pe.RotSpeed = NumberRange.new(0, 0)
	pe.EmissionDirection = Enum.NormalId.Bottom
	pe.Acceleration = Vector3.new(0, -20, 0)
	pe.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.08),
		NumberSequenceKeypoint.new(1, 0.03),
	})
	pe.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(0.7, 0.4),
		NumberSequenceKeypoint.new(1, 1),
	})
	pe.Color = ColorSequence.new(Color3.fromRGB(160, 175, 200))
	pe.LightEmission = 0.1
	pe.Drag = 0
	self._thunderEmitter = pe

	self._thunderPosConn = RS.Heartbeat:Connect(function()
		if part and part.Parent then
			self:_updateWeatherPartPos(part)
		end
	end)

	task.spawn(function()
		while self.THUNDER_ENABLED do
			local interval = math.random(
				math.max(2, self.THUNDER_FREQUENCY - 3),
				self.THUNDER_FREQUENCY + 5
			)
			task.wait(interval)
			if self.THUNDER_ENABLED then
				self:_flashLightning()
			end
		end
	end)
end

function World:StopThunder()
	self.THUNDER_ENABLED = false
	if self._thunderPosConn then
		pcall(function() self._thunderPosConn:Disconnect() end)
		self._thunderPosConn = nil
	end
	if self._thunderPart then
		pcall(function() self._thunderPart:Destroy() end)
		self._thunderPart = nil
	end
	self._thunderEmitter = nil
end

-- ═══════════════════════════════════════════════════
--  Weather: Fog
-- ═══════════════════════════════════════════════════

function World:SetFogEnabled(v)
	self.FOG_ENABLED = v
	if v then
		self:ApplyFog()
	else
		self:RemoveFog()
	end
end

function World:SetFogStart(v)
	self.FOG_START = v
	if self.FOG_ENABLED then
		Lighting.FogStart = v
	end
end

function World:SetFogEnd(v)
	self.FOG_END = v
	if self.FOG_ENABLED then
		Lighting.FogEnd = v
	end
end

function World:SetFogColor(c)
	self.FOG_COLOR = c
	if self.FOG_ENABLED then
		Lighting.FogColor = c
	end
end

function World:ApplyFog()
	Lighting.FogStart = self.FOG_START
	Lighting.FogEnd = self.FOG_END
	Lighting.FogColor = self.FOG_COLOR

	if self._fogConn then
		pcall(function() self._fogConn:Disconnect() end)
	end
	self._fogConn = RS.Heartbeat:Connect(function()
		if not self.FOG_ENABLED then return end
		Lighting.FogStart = self.FOG_START
		Lighting.FogEnd = self.FOG_END
		Lighting.FogColor = self.FOG_COLOR
	end)
end

function World:RemoveFog()
	if self._fogConn then
		pcall(function() self._fogConn:Disconnect() end)
		self._fogConn = nil
	end
	Lighting.FogStart = self._origFog.FogStart
	Lighting.FogEnd = self._origFog.FogEnd
	Lighting.FogColor = self._origFog.FogColor
end

-- ═══════════════════════════════════════════════════
--  Viewmodel (First Person Weapon)
-- ═══════════════════════════════════════════════════

function World:SetViewmodelEnabled(v)
	self.VIEWMODEL_ENABLED = v
	if v then
		self:StartViewmodel()
	else
		self:StopViewmodel()
	end
end

function World:StartViewmodel()
	self:StopViewmodel()

	local armSet = {
		RightHand = true, LeftHand = true,
		RightLowerArm = true, LeftLowerArm = true,
		RightUpperArm = true, LeftUpperArm = true,
		["Right Arm"] = true, ["Left Arm"] = true,
	}

	local arms, toolParts, camParts = {}, {}, {}
	local toolRef, camVer = nil, 0
	local frame = 0

	local function rebuildArms(char)
		arms = {}
		local n = 0
		for _, d in ipairs(char:GetChildren()) do
			if d:IsA("BasePart") and armSet[d.Name] then
				n = n + 1; arms[n] = d
			end
		end
	end

	local function rebuildTool(char)
		toolParts = {}
		toolRef = nil
		for _, c in ipairs(char:GetChildren()) do
			if c:IsA("Tool") then
				toolRef = c
				local n = 0
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then
						n = n + 1; toolParts[n] = p
					end
				end
				return
			end
		end
	end

	local function rebuildCam()
		camParts = {}
		local cam = Workspace.CurrentCamera
		if not cam then return end
		camVer = #cam:GetChildren()
		local n = 0
		for _, c in ipairs(cam:GetChildren()) do
			if c:IsA("Model") or c:IsA("BasePart") or c:IsA("Tool") then
				if c:IsA("BasePart") then n = n + 1; camParts[n] = c end
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then n = n + 1; camParts[n] = p end
				end
			end
		end
	end

	local function hookCharacter(char)
		if not char then return end
		if self._viewmodelConn then self._viewmodelConn:Disconnect(); self._viewmodelConn = nil end

		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end

		rebuildArms(char)
		rebuildTool(char)
		rebuildCam()
		frame = 0

		hum.CameraOffset = Vector3.new(0, 1.3, 0)

		self._viewmodelConn = RS.RenderStepped:Connect(function()
			if not self.VIEWMODEL_ENABLED or not char.Parent then return end

			frame = frame + 1

			for i = 1, #arms do
				local p = arms[i]
				if p.Parent then p.LocalTransparencyModifier = 0 end
			end

			local ct = char:FindFirstChildOfClass("Tool")
			if ct ~= toolRef then rebuildTool(char) end
			for i = 1, #toolParts do
				local p = toolParts[i]
				if p.Parent then
					p.LocalTransparencyModifier = 0
					if p.Transparency > 0.5 then p.Transparency = 0 end
				end
			end

			if frame % 5 == 0 then
				local cam = Workspace.CurrentCamera
				if cam and #cam:GetChildren() ~= camVer then rebuildCam() end
				for i = 1, #camParts do
					local p = camParts[i]
					if p.Parent then
						p.LocalTransparencyModifier = 0
						if p.Transparency > 0.5 then p.Transparency = 0 end
					end
				end
			end

			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local cam = Workspace.CurrentCamera
				if cam then
					local lv = cam.CFrame.LookVector
					local flat = Vector3.new(lv.X, 0, lv.Z)
					if flat.Magnitude > 0.01 then
						hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flat.Unit)
					end
				end
			end
		end)
	end

	if self._viewmodelCharConn then self._viewmodelCharConn:Disconnect(); self._viewmodelCharConn = nil end

	self._viewmodelCharConn = player.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		hookCharacter(char)
	end)

	if player.Character then hookCharacter(player.Character) end
end

function World:StopViewmodel()
	if self._viewmodelConn then self._viewmodelConn:Disconnect(); self._viewmodelConn = nil end
	if self._viewmodelCharConn then self._viewmodelCharConn:Disconnect(); self._viewmodelCharConn = nil end
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
	end
end

-- ═══════════════════════════════════════════════════
--  Model Changer
-- ═══════════════════════════════════════════════════

function World:ApplyModel(name)
	if name == "None" or not self.MODEL_PRESETS[name] then return end
	local d = self.MODEL_PRESETS[name]
	local headIds, torsoIds, headT, bodyT, keepHead, isHeadAcc, rotation = d[1], d[2], d[3], d[4], d[5], d[6], d[7]

	local function onChar(char)
		task.wait(0.5)
		if not char or not char.Parent then return end

		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") then
				local isHA = false
				local handle = child:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChildOfClass("Weld")
					if weld and ((weld.Part0 and weld.Part0.Name == "Head") or (weld.Part1 and weld.Part1.Name == "Head")) then
						isHA = true
					end
				end
				if not keepHead or not isHA then child:Destroy() end
			end
		end

		for _, desc in ipairs(char:GetChildren()) do
			if desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" then
				desc.Transparency = desc.Name == "Head" and headT or bodyT
				if desc.Name == "UpperTorso" then
					for _, decal in ipairs(desc:GetChildren()) do
						if decal:IsA("Decal") then decal:Destroy() end
					end
				end
			end
		end

		local head = char:FindFirstChild("Head")
		if headT == 1 and head then
			local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
			if face then face:Destroy() end
		end

		local torsoPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

		for _, id in ipairs(headIds) do
			task.spawn(function()
				local ok, acc = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
				if ok and acc and head then
					if isHeadAcc then
						acc.Parent = char
						local handle = acc:FindFirstChild("Handle")
						if handle then
							handle.CanCollide = false
							local w = Instance.new("Weld")
							w.Part0, w.Part1 = head, handle
							w.C0 = rotation or CFrame.new(0, 0, 0)
							w.Parent = head
						end
					else
						acc.Parent = char
						local handle = acc:FindFirstChild("Handle")
						if handle then
							handle.CanCollide = false
							local w = Instance.new("Weld")
							w.Part0, w.Part1 = head, handle
							local baseOffset = CFrame.new(0, head.Size.Y / 2, 0)
							w.C0 = rotation and (baseOffset * rotation) or baseOffset
							w.Parent = head
						end
					end
				end
			end)
		end

		if torsoPart then
			for _, id in ipairs(torsoIds) do
				task.spawn(function()
					local ok, acc = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
					if ok and acc then
						acc.Parent = char
						local handle = acc:FindFirstChild("Handle")
						if handle then
							handle.CanCollide = false
							local w = Instance.new("Weld")
							w.Part0, w.Part1, w.C0 = torsoPart, handle, CFrame.new(0, 0, 0)
							w.Parent = torsoPart
						end
					end
				end)
			end
		end
	end

	if self._modelCharConn then
		self._modelCharConn:Disconnect()
		self._modelCharConn = nil
	end
	self._modelCharConn = player.CharacterAdded:Connect(onChar)
	if player.Character then onChar(player.Character) end
end

function World:SetModelChangerEnabled(v)
	self.MODEL_CHANGER_ENABLED = v
	if v then
		if self.MODEL_CHANGER_CURRENT ~= "None" then
			self:ApplyModel(self.MODEL_CHANGER_CURRENT)
		end
	else
		if self._modelCharConn then
			self._modelCharConn:Disconnect()
			self._modelCharConn = nil
		end
	end
end

function World:SetModelPreset(name)
	self.MODEL_CHANGER_CURRENT = name
	if self.MODEL_CHANGER_ENABLED then
		self:ApplyModel(name)
	end
end

function World:GetModelNames()
	local names = {"None"}
	for name, _ in pairs(self.MODEL_PRESETS) do
		table.insert(names, name)
	end
	table.sort(names, function(a, b)
		if a == "None" then return true end
		if b == "None" then return false end
		return a < b
	end)
	return names
end

-- ═══════════════════════════════════════════════════
--  Unload
-- ═══════════════════════════════════════════════════

function World:RegisterUnloadCallback(fn)
	table.insert(self._unloadCallbacks, fn)
end

function World:Unload()
	self:StopBhop()
	self:StopNoclip()
	self:StopFly()
	self:StopViewmodel()
	self:StopSpawnTp()
	self:StopTrashtalk()
	self:StopRain()
	self:StopSnow()
	self:StopThunder()
	self:RemoveFog()
	if self.MODEL_CHANGER_ENABLED then
		self:SetModelChangerEnabled(false)
	end

	if self.BLUR_ENABLED and self._blurEffect then
		self._blurEffect:Destroy()
		self._blurEffect = nil
	end

	if self.WORLD_TIME_ENABLED then
		Lighting.ClockTime = self.ORIGINAL_LIGHTING.ClockTime
	end
	if self.CUSTOM_SKY_ENABLED then
		self:wipeSky()
		if self.ORIGINAL_SKY then
			self.ORIGINAL_SKY:Clone().Parent = Lighting
		end
	end

	for _, conn in ipairs(self._connections) do
		pcall(function() conn:Disconnect() end)
	end
	self._connections = {}

	for _, fn in ipairs(self._unloadCallbacks) do
		pcall(fn)
	end
end

-- ═══════════════════════════════════════════════════
--  Export / Import
-- ═══════════════════════════════════════════════════

function World:Export()
	return {
		WORLD_TIME_ENABLED = self.WORLD_TIME_ENABLED,
		CUSTOM_CLOCKTIME = self.CUSTOM_CLOCKTIME,
		CUSTOM_SKY_ENABLED = self.CUSTOM_SKY_ENABLED,
		CUSTOM_SKY_PRESET = self.CUSTOM_SKY_PRESET,
		BLUR_ENABLED = self.BLUR_ENABLED,
		BLUR_SIZE = self.BLUR_SIZE,
		BHOP_ENABLED = self.BHOP_ENABLED,
		BHOP_SPEED = self.BHOP_SPEED,
		NOCLIP_ENABLED = self.NOCLIP_ENABLED,
		FLY_ENABLED = self.FLY_ENABLED,
		FLY_SPEED = self.FLY_SPEED,
		SPAWN_TP_ENABLED = self.SPAWN_TP_ENABLED,
		TRASHTALK_ENABLED = self.TRASHTALK_ENABLED,
		TRASHTALK_MODE = self.TRASHTALK_MODE,
		TRASHTALK_MESSAGES = self.TRASHTALK_MESSAGES,
		TRASHTALK_COOLDOWN = self.TRASHTALK_COOLDOWN,
	}
end

function World:Import(t)
	if t.WORLD_TIME_ENABLED ~= nil then self.WORLD_TIME_ENABLED = t.WORLD_TIME_ENABLED end
	if t.CUSTOM_CLOCKTIME then self.CUSTOM_CLOCKTIME = t.CUSTOM_CLOCKTIME end
	if t.CUSTOM_SKY_ENABLED ~= nil then self.CUSTOM_SKY_ENABLED = t.CUSTOM_SKY_ENABLED end
	if t.CUSTOM_SKY_PRESET then self.CUSTOM_SKY_PRESET = t.CUSTOM_SKY_PRESET end
	if t.BLUR_ENABLED ~= nil then self:SetBlurEnabled(t.BLUR_ENABLED) end
	if t.BLUR_SIZE then self:SetBlurSize(t.BLUR_SIZE) end
	if t.BHOP_ENABLED ~= nil then self:SetBhopEnabled(t.BHOP_ENABLED) end
	if t.BHOP_SPEED then self:SetBhopSpeed(t.BHOP_SPEED) end
	if t.NOCLIP_ENABLED ~= nil then self:SetNoclipEnabled(t.NOCLIP_ENABLED) end
	if t.FLY_ENABLED ~= nil then self:SetFlyEnabled(t.FLY_ENABLED) end
	if t.FLY_SPEED then self:SetFlySpeed(t.FLY_SPEED) end
	if t.SPAWN_TP_ENABLED ~= nil then self:SetSpawnTpEnabled(t.SPAWN_TP_ENABLED) end
	if t.SPAWN_BOX_TP_ENABLED ~= nil then self:SetSpawnBoxTpEnabled(t.SPAWN_BOX_TP_ENABLED) end
	if t.TRASHTALK_MODE then self.TRASHTALK_MODE = t.TRASHTALK_MODE end
	if t.TRASHTALK_MESSAGES then self.TRASHTALK_MESSAGES = t.TRASHTALK_MESSAGES end
	if t.TRASHTALK_COOLDOWN then self.TRASHTALK_COOLDOWN = t.TRASHTALK_COOLDOWN end
	if t.TRASHTALK_ENABLED ~= nil then self:SetTrashtalkEnabled(t.TRASHTALK_ENABLED) end

	self:applyTime()
	self:applySky()
end

-- ═══════════════════════════════════════════════════
--  Config Manager Module
-- ═══════════════════════════════════════════════════

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(rageModule, visualsModule, espModule, worldModule)
	local self = setmetatable({}, ConfigManager)
	
	self.Rage = rageModule
	self.Visuals = visualsModule
	self.ESP = espModule
	self.World = worldModule
	
	self.HttpService = game:GetService("HttpService")
	self.CONFIG_FOLDER = "ArcanumNextgen"
	self.CONFIG_EXT = ".json"
	
	self.configs = {}
	self.selectedConfig = nil
	
	return self
end

function ConfigManager:HasFileSystem()
	return writefile and readfile and isfile and listfiles and makefolder and isfolder and delfile
end

function ConfigManager:EnsureFolder()
	if not self:HasFileSystem() then return false end
	if not isfolder(self.CONFIG_FOLDER) then
		pcall(function() makefolder(self.CONFIG_FOLDER) end)
	end
	return isfolder(self.CONFIG_FOLDER)
end

function ConfigManager:GetAllSettings()
	local s = {}
	if self.Rage then
		for k, v in pairs(self.Rage:GetSettings()) do s[k] = v end
	end
	if self.Visuals then
		for k, v in pairs(self.Visuals:GetSettings()) do s[k] = v end
	end
	if self.ESP then
		for k, v in pairs(self.ESP:GetSettings()) do s[k] = v end
	end
	if self.World then
		for k, v in pairs(self.World:Export()) do s[k] = v end
	end
	return s
end

function ConfigManager:ApplyAllSettings(s)
	if not s then return end
	if self.Rage then self.Rage:ApplySettings(s) end
	if self.Visuals then self.Visuals:ApplySettings(s) end
	if self.ESP then self.ESP:ApplySettings(s) end
	if self.World then self.World:Import(s) end
end

function ConfigManager:SaveConfig(name)
	if not self:EnsureFolder() then return false end
	local settings = self:GetAllSettings()
	local json = self.HttpService:JSONEncode(settings)
	local success = pcall(function()
		writefile(self.CONFIG_FOLDER .. "/" .. name .. self.CONFIG_EXT, json)
	end)
	return success
end

function ConfigManager:LoadConfig(name)
	if not self:HasFileSystem() then return false end
	local path = self.CONFIG_FOLDER .. "/" .. name .. self.CONFIG_EXT
	if not isfile(path) then return false end
	
	local ok, result = pcall(function()
		return self.HttpService:JSONDecode(readfile(path))
	end)
	
	if ok and result then
		self:ApplyAllSettings(result)
		return true
	end
	return false
end

function ConfigManager:DeleteConfig(name)
	if not self:HasFileSystem() then return false end
	local path = self.CONFIG_FOLDER .. "/" .. name .. self.CONFIG_EXT
	if isfile(path) then
		local success = pcall(function() delfile(path) end)
		return success
	end
	return false
end

function ConfigManager:RenameConfig(oldName, newName)
	if not self:HasFileSystem() then return false end
	local oldPath = self.CONFIG_FOLDER .. "/" .. oldName .. self.CONFIG_EXT
	local newPath = self.CONFIG_FOLDER .. "/" .. newName .. self.CONFIG_EXT
	
	if isfile(oldPath) and not isfile(newPath) then
		local success = pcall(function()
			local content = readfile(oldPath)
			writefile(newPath, content)
			delfile(oldPath)
		end)
		return success
	end
	return false
end

function ConfigManager:GetConfigList()
	if not self:HasFileSystem() then return {} end
	if not self:EnsureFolder() then return {} end
	
	local configs = {}
	local ok, files = pcall(function() return listfiles(self.CONFIG_FOLDER) end)
	
	if ok and files then
		for _, path in ipairs(files) do
			local name = path:match("([^/\\]+)" .. self.CONFIG_EXT .. "$")
			if name then
				table.insert(configs, name)
			end
		end
	end
	
	table.sort(configs)
	return configs
end

function ConfigManager:CreateNewConfig()
	local configName = "config_" .. tostring(os.time()):sub(-6)
	if self:SaveConfig(configName) then
		self.selectedConfig = configName
		return configName
	end
	return nil
end

function ConfigManager:SetSelectedConfig(name)
	self.selectedConfig = name
end

function ConfigManager:GetSelectedConfig()
	return self.selectedConfig
end

World.ConfigManager = ConfigManager

local WorldModule = World
local ConfigManagerClass = World.ConfigManager

-- ════════════════════════════════════════════════════════════════
--  INIT
-- ════════════════════════════════════════════════════════════════
local modCfg = { Player = LocalPlayer, Services = Services }

local ESPInstance   = ESPModule.new(modCfg)
local WorldInstance = WorldModule.new()
local guiParent     = LocalPlayer:WaitForChild("PlayerGui")

local VisualsInstance = VisualsModule.new({
    Player    = LocalPlayer,
    GuiParent = guiParent,
    Services  = Services,
    Notification = function(t, d)
        Library:Notification({ Title = t, Description = d, Duration = 5 })
    end,
    IsFakeLagEnabled = function() return false end,
})

local RageNotify = {}
RageNotify.Notify = function(_, tbl)
    Library:Notification({
        Title       = tbl.Title or tbl.title or "Eclipse",
        Description = tbl.Content or tbl.message or tbl.desc or "",
        Duration    = tbl.Duration or tbl.duration or 4,
    })
end
setmetatable(RageNotify, { __index = RageNotify })

local RageInstance = RageModule.new({
    Player            = LocalPlayer,
    Services          = Services,
    Notification      = RageNotify,
    Visuals           = VisualsInstance,
})

local AntiAimInstance = AntiAimModule.new()

-- ══════════════════════════════════════════════════════════════════
--  AIMBOT MODULE
-- ══════════════════════════════════════════════════════════════════
local AimbotModule = {}
AimbotModule.__index = AimbotModule

function AimbotModule.new(cfg)
    local self = setmetatable({}, AimbotModule)
    self.player     = cfg.Player
    self.Services   = cfg.Services
    self.RageInst   = cfg.RageInstance
    self.Workspace  = cfg.Services.Workspace
    self.RunService = cfg.Services.RunService
    self.UIS        = cfg.Services.UserInputService

    self.ENABLED       = false
    self.MODE          = "Body"    -- Body / Silent / Combined / Velocity
    self.FOV           = 90
    self.SMOOTH        = 5         -- 1=slow .. 10=instant
    self.PREDICTION    = true
    self.WALL_CHECK    = true
    self.TARGET_PART   = "Head"
    self.HOLD_KEY      = Enum.KeyCode.Unknown
    self.SHOW_FOV      = true
    self.FOV_COLOR     = Color3.fromRGB(255, 65, 65)
    self.FOV_THICKNESS = 1.5

    self.THIRD_PERSON  = false
    self.TP_MAX_ZOOM   = 30
    self.TP_DISTANCE   = 12
    self._tpActive     = false
    self._origZoom     = nil

    self._conn        = nil
    self._fovGui      = nil
    self._fovCircle   = nil
    self._fovPulse    = nil
    self._crossH      = nil
    self._crossV      = nil
    self._distLabel   = nil
    self._fovFrame    = nil
    return self
end

function AimbotModule:IsAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function AimbotModule:IsTeammate(p)
    local me = self.player
    if not me.Team or not p.Team then return false end
    return me.Team == p.Team
end

function AimbotModule:HasWallBetween(targetPos)
    local char = self.player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return true end
    local origin = head.Position
    local dir    = targetPos - origin
    if dir.Magnitude < 0.1 then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    -- Exclude self + target char
    local excl = {char}
    params.FilterDescendantsInstances = excl
    local result = workspace:Raycast(origin, dir, params)
    -- If ray hits something that isn't the target area → wall
    if result then
        local hit = result.Instance
        -- Check if it belongs to an enemy character
        local hitChar = hit:FindFirstAncestorOfClass("Model")
        if hitChar then
            local hum = hitChar:FindFirstChildOfClass("Humanoid")
            if hum then return false end  -- hit enemy body = no wall
        end
        return true  -- hit something else = wall
    end
    return false
end

function AimbotModule:FindTarget()
    local cam    = self.Workspace.CurrentCamera
    local vp     = cam.ViewportSize
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    local fov2   = self.FOV * self.FOV
    local me     = self.player
    local best, bestD = nil, math.huge

    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p == me then continue end
        if self:IsTeammate(p) then continue end
        local char = p.Character
        if not self:IsAlive(char) then continue end
        local part = char:FindFirstChild(self.TARGET_PART)
            or char:FindFirstChild("Head")
        if not part then continue end

        local sp = cam:WorldToViewportPoint(part.Position)
        if sp.Z < 0 then continue end
        local dx, dy = sp.X - cx, sp.Y - cy
        local d2 = dx*dx + dy*dy
        if d2 < fov2 and d2 < bestD then
            -- Wall check
            if self.WALL_CHECK and self:HasWallBetween(part.Position) then continue end
            bestD = d2; best = p
        end
    end
    return best
end

function AimbotModule:PredictPos(char)
    local part = char:FindFirstChild(self.TARGET_PART) or char:FindFirstChild("Head")
    if not part then return nil end
    if not self.PREDICTION then return part.Position end
    local root = char:FindFirstChild("HumanoidRootPart")
    local vel  = root and root.AssemblyLinearVelocity or Vector3.new()
    local ping = self.Services.Players.LocalPlayer:GetNetworkPing()
    return part.Position + Vector3.new(vel.X, 0, vel.Z) * (ping * 0.5 + 0.04)
end

-- smooth 1..10 → alpha 0.015..1.0 (экспоненциальная)
local function _smoothAlpha(smooth)
    local s = math.clamp(smooth, 1, 10)
    -- 1 → ~0.015  (очень медленно)
    -- 5 → ~0.18
    -- 10 → 1.0   (моментально)
    return (s / 10) ^ 2
end

-- Поворот HRP через CFrame без поворота камеры
function AimbotModule:AimBody(tp)
    local char = self.player.Character
    if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local flat  = Vector3.new(tp.X, hrp.Position.Y, tp.Z)
    local dist  = (flat - hrp.Position).Magnitude
    if dist < 0.5 then return end
    local goal  = CFrame.new(hrp.Position, flat)
    hrp.CFrame  = hrp.CFrame:Lerp(goal, _smoothAlpha(self.SMOOTH))
end

-- Silent — цель не видит поворота, стреляем через override
function AimbotModule:AimSilent(target, tp)
    if self.RageInst then
        self.RageInst._silentAimOverride = tp
        self.RageInst._silentAimTarget   = target
    end
end

-- Velocity — упреждение + Body поворот
function AimbotModule:AimVelocity(target, tp)
    local char = target.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then self:AimBody(tp); return end
    -- Дополнительное упреждение по скорости
    local vel  = root.AssemblyLinearVelocity
    local ping = self.Services.Players.LocalPlayer:GetNetworkPing()
    local extra = Vector3.new(vel.X, 0, vel.Z) * ping
    self:AimBody(tp + extra)
end

-- Combined = Body + Silent
function AimbotModule:AimCombined(target, tp)
    self:AimBody(tp)
    self:AimSilent(target, tp)
end

function AimbotModule:EnableThirdPerson()
    if self._tpActive then return end
    local cam = self.Workspace.CurrentCamera
    local lp  = self.Services.Players.LocalPlayer
    self._origZoom   = lp.CameraMaxZoomDistance
    self._tpActive   = true
    cam.CameraType   = Enum.CameraType.Custom
    lp.CameraMaxZoomDistance = self.TP_MAX_ZOOM
    task.spawn(function()
        for i = 1, 25 do
            if not self._tpActive then break end
            lp.CameraMinZoomDistance = math.min(
                lp.CameraMinZoomDistance + self.TP_DISTANCE / 25, self.TP_DISTANCE)
            task.wait(0.016)
        end
        lp.CameraMinZoomDistance = self.TP_DISTANCE
    end)
end

function AimbotModule:DisableThirdPerson()
    if not self._tpActive then return end
    self._tpActive = false
    local lp = self.Services.Players.LocalPlayer
    local cam = self.Workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    lp.CameraMaxZoomDistance = self._origZoom or 400
    lp.CameraMinZoomDistance = 0.5
end

function AimbotModule:UpdateTP()
    if not self.THIRD_PERSON then
        if self._tpActive then self:DisableThirdPerson() end
        return
    end
    local cam  = self.Workspace.CurrentCamera
    local char = self.player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local d = (cam.CFrame.Position - head.Position).Magnitude
    if d < 2.5 and not self._tpActive then self:EnableThirdPerson() end
end

function AimbotModule:_setupFov()
    local pg = self.player:FindFirstChildOfClass("PlayerGui")
    if not pg then return end

    -- Главный ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "EclipseFOV"; sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 9999
    sg.Parent = pg
    self._fovGui = sg

    -- ── Drawing API (если есть) ───────────────────────────────────
    if Drawing then
        -- Основной FOV-круг
        local c = Drawing.new("Circle")
        c.Visible = false; c.Filled = false; c.NumSides = 80
        c.Color = self.FOV_COLOR; c.Thickness = self.FOV_THICKNESS
        c.Radius = self.FOV
        self._fovCircle = c

        -- Пульсирующий внутренний круг
        local cp = Drawing.new("Circle")
        cp.Visible = false; cp.Filled = false; cp.NumSides = 60
        cp.Color = self.FOV_COLOR; cp.Thickness = 0.8
        cp.Radius = self.FOV * 0.85
        self._fovPulse = cp

        -- Крест по центру
        local cx1 = Drawing.new("Line")
        cx1.Visible = false; cx1.Thickness = 1
        cx1.Color = Color3.new(1,1,1); cx1.Transparency = 0.6
        self._crossH = cx1
        local cx2 = Drawing.new("Line")
        cx2.Visible = false; cx2.Thickness = 1
        cx2.Color = Color3.new(1,1,1); cx2.Transparency = 0.6
        self._crossV = cx2

        -- Лейбл дистанции до цели
        local dl = Drawing.new("Text")
        dl.Visible = false; dl.Size = 13
        dl.Color = self.FOV_COLOR; dl.Outline = true
        dl.OutlineColor = Color3.new(0,0,0)
        dl.Font = Drawing.Fonts.Plex
        self._distLabel = dl

        return
    end

    -- ── Fallback: Frame-кольцо ────────────────────────────────────
    local img = Instance.new("ImageLabel")
    img.Name = "FOVRing"; img.BackgroundTransparency = 1
    img.Image = "rbxassetid://3570695787"
    img.ImageColor3 = self.FOV_COLOR; img.ImageTransparency = 0.25
    img.AnchorPoint = Vector2.new(0.5,0.5)
    img.Position = UDim2.new(0.5,0,0.5,0)
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = sg
    self._fovFrame = img

    -- Crosshair через Lines в Frame
    local function makeLine(w,h,ax,ay)
        local f = Instance.new("Frame")
        f.BackgroundColor3 = Color3.new(1,1,1)
        f.BorderSizePixel = 0
        f.AnchorPoint = Vector2.new(ax,ay)
        f.Position = UDim2.new(0.5,0,0.5,0)
        f.Size = UDim2.new(0,w,0,h)
        f.BackgroundTransparency = 0.5
        f.Parent = sg
        return f
    end
    self._crossHF = makeLine(10,1,0.5,0.5)
    self._crossVF = makeLine(1,10,0.5,0.5)
end

function AimbotModule:_updateFov(target)
    local cam = self.Workspace.CurrentCamera
    local vp  = cam.ViewportSize
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    local r   = self.FOV
    local vis = self.SHOW_FOV and self.ENABLED
    local t   = tick()

    -- Пульс: ±3% от FOV с частотой 1.5 Гц
    local pulse = r + math.sin(t * 9.4) * r * 0.03

    if self._fovCircle then
        self._fovCircle.Position  = Vector2.new(cx, cy)
        self._fovCircle.Radius    = r
        self._fovCircle.Color     = self.FOV_COLOR
        self._fovCircle.Thickness = self.FOV_THICKNESS
        self._fovCircle.Visible   = vis

        -- Пульс-круг ярче когда есть цель
        if self._fovPulse then
            self._fovPulse.Position  = Vector2.new(cx, cy)
            self._fovPulse.Radius    = pulse
            self._fovPulse.Color     = target and Color3.new(1,1,1) or self.FOV_COLOR
            self._fovPulse.Transparency = target and 0.55 or 0.8
            self._fovPulse.Visible   = vis
        end

        -- Crosshair — маленький когда нет цели, подсвечен когда есть
        if self._crossH and self._crossV then
            local sz = target and 6 or 4
            local col = target and self.FOV_COLOR or Color3.new(1,1,1)
            self._crossH.From = Vector2.new(cx - sz, cy)
            self._crossH.To   = Vector2.new(cx + sz, cy)
            self._crossH.Color = col; self._crossH.Visible = vis
            self._crossV.From = Vector2.new(cx, cy - sz)
            self._crossV.To   = Vector2.new(cx, cy + sz)
            self._crossV.Color = col; self._crossV.Visible = vis
        end

        -- Дистанция до цели
        if self._distLabel then
            if target and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                local myChar = self.player.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if root and myRoot then
                    local d = math.floor((root.Position - myRoot.Position).Magnitude)
                    self._distLabel.Text     = d .. "m"
                    self._distLabel.Position = Vector2.new(cx + r + 6, cy - 7)
                    self._distLabel.Color    = self.FOV_COLOR
                    self._distLabel.Visible  = vis
                end
            else
                self._distLabel.Visible = false
            end
        end
    elseif self._fovFrame then
        local d = r * 2
        self._fovFrame.Size = UDim2.new(0, d, 0, d)
        self._fovFrame.ImageColor3 = self.FOV_COLOR
        self._fovGui.Enabled = vis
    end
end

function AimbotModule:Start()
    pcall(function() self:_setupFov() end)
    local _nextAB = 0
    self._conn = self.RunService.Heartbeat:Connect(function()
        local now = tick()
        if now < _nextAB then return end
        _nextAB = now + (1/60)
        self:UpdateTP()
        local target = self:IsActive() and self:FindTarget() or nil
        pcall(function() self:_updateFov(target) end)
        if not target then
            if self.RageInst then
                self.RageInst._silentAimOverride = nil
                self.RageInst._silentAimTarget   = nil
            end
            return
        end
        if not target.Character then return end
        local tp = self:PredictPos(target.Character)
        if not tp then return end
        local mode = self.MODE
        if     mode == "Body"     then self:AimBody(tp)
        elseif mode == "Silent"   then self:AimSilent(target, tp)
        elseif mode == "Velocity" then self:AimVelocity(target, tp)
        elseif mode == "Combined" then self:AimCombined(target, tp)
        end
    end)
end

function AimbotModule:Stop()
    if self._conn then self._conn:Disconnect(); self._conn = nil end
    pcall(function()
        if self._fovGui and self._fovGui.Parent then self._fovGui:Destroy() end
        for _, k in ipairs({"_fovCircle","_fovPulse","_crossH","_crossV","_distLabel"}) do
            if self[k] then pcall(function() self[k]:Remove() end); self[k] = nil end
        end
    end)
    self._fovGui = nil; self._fovFrame = nil
    self._crossHF = nil; self._crossVF = nil
    self:DisableThirdPerson()
end

function AimbotModule:Set(k, v) self[k] = v end
function AimbotModule:SetEnabled(v)      self.ENABLED       = v end
function AimbotModule:SetMode(v)         self.MODE          = v end
function AimbotModule:SetFov(v)          self.FOV           = v end
function AimbotModule:SetSmooth(v)       self.SMOOTH        = math.clamp(v, 1, 10) end
function AimbotModule:SetPrediction(v)   self.PREDICTION    = v end
function AimbotModule:SetWallCheck(v)    self.WALL_CHECK    = v end
function AimbotModule:SetTargetPart(v)   self.TARGET_PART   = v end
function AimbotModule:SetHoldKey(v)      self.HOLD_KEY      = v or Enum.KeyCode.Unknown end
function AimbotModule:SetShowFov(v)      self.SHOW_FOV      = v end
function AimbotModule:SetFovColor(v)     self.FOV_COLOR     = v end
function AimbotModule:SetFovThickness(v) self.FOV_THICKNESS = v end
function AimbotModule:SetThirdPerson(v)  self.THIRD_PERSON  = v; if not v then self:DisableThirdPerson() end end
function AimbotModule:SetTPMaxZoom(v)    self.TP_MAX_ZOOM   = v end
function AimbotModule:SetTPDistance(v)   self.TP_DISTANCE   = v end

local AimbotInstance = AimbotModule.new({
    Player       = LocalPlayer,
    Services     = Services,
    RageInstance = RageInstance,
})

local _ConfigMgr = ConfigManagerClass.new(RageInstance, VisualsInstance, ESPInstance, WorldInstance)

VisualsInstance._resolverOnHit  = function(plr) RageInstance:RegisterHit(plr)  end
VisualsInstance._resolverOnMiss = function(plr) RageInstance:RegisterMiss(plr) end

task.spawn(function()
    pcall(function() ESPInstance:Start()    end)
    pcall(function() RageInstance:Start()   end)
    pcall(function() AimbotInstance:Start() end)
end)

local function Notify(title, desc)
    Library:Notification({ Title = title, Description = desc, Duration = 4 })
end

local function dv(v) return type(v) == "table" and v[1] or v end

-- ════════════════════════════════════════════════════════════════
--  WINDOW
-- ════════════════════════════════════════════════════════════════
local Window      = Library:Window({ Name = "Eclipse", SubName = "v5", Logo = "120959262762131" })
local KeybindList = Library:KeybindList("Keybinds")

Library:Watermark({ "Eclipse", "v5", 120959262762131 })
task.spawn(function()
    while true do
        local ok, fps = pcall(function()
            return math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        end)
        if ok then Library:Watermark({ "Eclipse", "v5", 120959262762131, "FPS: "..fps }) end
        task.wait(1)
    end
end)

-- ════════════════════════════════════════════════════════════════
Window:Category("Combat")

-- ── Ragebot ──────────────────────────────────────────────────────
local RagePage = Window:Page({ Name = "Ragebot", Icon = "" })
local RMain    = RagePage:Section({ Name = "Main",      Side = 1 })
local RTarget  = RagePage:Section({ Name = "Targeting", Side = 2 })

RMain:Toggle({ Name = "Enable Ragebot",    Flag = "RageEnabled",   Default = false,
    Callback = function(v) RageInstance:SetEnabled(v) end })
RMain:Toggle({ Name = "Auto Shoot",        Flag = "RageAutoShoot", Default = false,
    Callback = function(v) RageInstance:SetAutoShoot(v) end })
RMain:Toggle({ Name = "Auto Stop",         Flag = "RageAutoStop",  Default = false,
    Callback = function(v) RageInstance:SetAutoStopEnabled(v) end })
RMain:Slider({ Name = "Stop Threshold",    Flag = "RageStopThresh",Min=1,Max=30,Default=8,Suffix=" st/s",
    Callback = function(v) RageInstance:SetAutoStopThreshold(v) end })
RMain:Toggle({ Name = "Airshot (NoSpread)",Flag = "RageNoSpread",  Default = false,
    Callback = function(v) RageInstance:SetNoSpread(v) end })
RMain:Toggle({ Name = "Auto Equip SSG",    Flag = "RageSSG",       Default = false,
    Callback = function(v) RageInstance:SetAutoEquipSSG(v) end })
RMain:Slider({ Name = "Max Distance",      Flag = "RageMaxDist",   Min=50,Max=3000,Default=2000,Suffix=" st",
    Callback = function(v) RageInstance:SetMaxDistance(v) end })
RMain:Toggle({ Name = "Prediction",        Flag = "RagePred",      Default = true,
    Callback = function(v) RageInstance:SetPredictionEnabled(v) end })
-- Слайдер 0-200 → реально 0.00-2.00 (делится на 100 в сеттере)
-- 100 = физически правильный предикт, 135 = 1.35x упреждение
RMain:Slider({ Name = "Prediction (x100)", Flag = "RagePredStr",   Min=0,Max=200,Default=100,
    Callback = function(v) RageInstance:SetPredictionStrength(v) end })
RMain:Toggle({ Name = "Remove Head",       Flag = "RageRemHead",   Default = false,
    Callback = function(v) RageInstance:SetRemoveHeadEnabled(v) end })
RMain:Toggle({ Name = "Freestand",         Flag = "RageFreestand", Default = false,
    Callback = function(v) RageInstance:SetFreestandEnabled(v) end })

RTarget:Dropdown({ Name = "Hit Part",      Flag = "RageHitPart",   Default={"Head"},
    Items={"Head","Body","Arms","Legs"}, Multi=false,
    Callback = function(v) RageInstance:SetHitpart(dv(v)) end })
RTarget:Toggle({ Name = "Multi-Point",     Flag = "RageMultiPt",   Default = false,
    Callback = function(v) RageInstance:SetMultiPointEnabled(v) end })
RTarget:Slider({ Name = "Point Scale",     Flag = "RagePtScale",   Min=10,Max=100,Default=80,Suffix="%",
    Callback = function(v) RageInstance:SetMultiPointScale(v / 100) end })
RTarget:Toggle({ Name = "Safe Point",      Flag = "RageSafePt",    Default = false,
    Callback = function(v) RageInstance:SetSafePointEnabled(v) end })
RTarget:Toggle({ Name = "Baim On Miss",    Flag = "RageBaim",      Default = false,
    Callback = function(v) RageInstance:SetBaimOnMiss(v) end })
RTarget:Slider({ Name = "Miss → Baim",     Flag = "RageBaimMiss",  Min=1,Max=5,Default=2,Suffix="x",
    Callback = function(v) RageInstance:SetBaimMissThreshold(v) end })
RTarget:Toggle({ Name = "Hitchance",       Flag = "RageHCOn",      Default = false,
    Callback = function(v) RageInstance:SetHitchanceEnabled(v) end })
RTarget:Slider({ Name = "Hitchance %",     Flag = "RageHCVal",     Min=1,Max=100,Default=100,Suffix="%",
    Callback = function(v) RageInstance:SetHitchance(v) end })
RTarget:Toggle({ Name = "Min Damage",      Flag = "RageMinDmgOn",  Default = false,
    Callback = function(v) RageInstance:SetMinDamageEnabled(v) end })
RTarget:Slider({ Name = "Min Damage",      Flag = "RageMinDmgVal", Min=1,Max=220,Default=50,Suffix=" hp",
    Callback = function(v) RageInstance:SetMinDamageValue(v) end })
RTarget:Toggle({ Name = "Wallbang",        Flag = "RageWB",        Default = false,
    Callback = function(v) RageInstance:SetWallbangEnabled(v) end })
RTarget:Keybind({ Name = "Wallbang Key",   Flag = "WBKey",         Default=Enum.KeyCode.V,
    Callback = function() RageInstance:SetWallbangEnabled(not RageInstance.WALLBANG_ENABLED) end })
RTarget:Toggle({ Name = "Resolver",        Flag = "RageResolver",  Default = true,
    Callback = function(v) RageInstance.RESOLVER_ENABLED = v end })


local ABPage = Window:Page({ Name = "Aimbot", Icon = "" })
local ABMain = ABPage:Section({ Name = "Main",              Side = 1 })
local ABAdv  = ABPage:Section({ Name = "3rd Person",        Side = 2 })

ABMain:Toggle({ Name = "Enable Aimbot",    Flag = "ABEnabled",    Default = false,
    Callback = function(v) AimbotInstance:SetEnabled(v) end })
ABMain:Dropdown({ Name = "Mode",           Flag = "ABMode",       Default = {"Body"},
    Items = {"Body","Silent","Combined","Velocity"}, Multi = false,
    Callback = function(v) AimbotInstance:SetMode(dv(v)) end })
ABMain:Dropdown({ Name = "Target Part",    Flag = "ABPart",       Default = {"Head"},
    Items = {"Head","UpperTorso","HumanoidRootPart"}, Multi = false,
    Callback = function(v) AimbotInstance:SetTargetPart(dv(v)) end })
ABMain:Slider({ Name = "FOV Size",         Flag = "ABFOV",        Min=10,Max=400,Default=90,Suffix=" px",
    Callback = function(v) AimbotInstance:SetFov(v) end })
ABMain:Slider({ Name = "Smooth",           Flag = "ABSmooth",     Min=1,Max=10,Default=5,
    Callback = function(v) AimbotInstance:SetSmooth(v) end })
ABMain:Toggle({ Name = "Prediction",       Flag = "ABPred",       Default = true,
    Callback = function(v) AimbotInstance:SetPrediction(v) end })
ABMain:Toggle({ Name = "Wall Check",       Flag = "ABWall",       Default = true,
    Callback = function(v) AimbotInstance:SetWallCheck(v) end })
ABMain:Toggle({ Name = "Show FOV Circle",  Flag = "ABShowFOV",    Default = true,
    Callback = function(v) AimbotInstance:SetShowFov(v) end })
ABMain:Label("FOV Color"):Colorpicker({ Name = "FOVColor", Flag = "ABFOVColor",
    Default = Color3.fromRGB(255,65,65),
    Callback = function(v) AimbotInstance:SetFovColor(v) end })
ABMain:Slider({ Name = "FOV Thickness",    Flag = "ABFOVThick",   Min=1,Max=5,Default=1.5,
    Callback = function(v) AimbotInstance:SetFovThickness(v) end })
ABMain:Keybind({ Name = "Hold Key",        Flag = "ABHoldKey",    Default = Enum.KeyCode.Unknown,
    Callback = function(key) AimbotInstance:SetHoldKey(key) end })

ABAdv:Toggle({ Name = "Auto 3rd Person",   Flag = "ABThirdPerson",Default = false,
    Callback = function(v) AimbotInstance:SetThirdPerson(v) end })
ABAdv:Slider({ Name = "Max Zoom",          Flag = "ABMaxZoom",    Min=5,Max=30,Default=30,
    Callback = function(v) AimbotInstance:SetTPMaxZoom(v) end })
ABAdv:Slider({ Name = "Camera Distance",   Flag = "ABTPDist",     Min=5,Max=25,Default=12,Suffix=" st",
    Callback = function(v) AimbotInstance:SetTPDistance(v) end })
ABAdv:Button({ Name = "Force 3rd Person",  Callback = function() AimbotInstance:EnableThirdPerson() end })
ABAdv:Button({ Name = "First Person",      Callback = function() AimbotInstance:DisableThirdPerson() end })

-- ── Anti-Aim ─────────────────────────────────────────────────────
local AAPage = Window:Page({ Name = "Anti-Aim", Icon = "" })
local AASec1 = AAPage:Section({ Name = "Pitch / Yaw",   Side = 1 })
local AASec2 = AAPage:Section({ Name = "Jitter / Misc", Side = 2 })

AASec1:Toggle({ Name = "Enable Anti-Aim",  Flag = "AAEnabled",     Default = false,
    Callback = function(v) AntiAimInstance:SetEnabled(v) end })
AASec1:Dropdown({ Name = "Pitch Mode",     Flag = "AAPitch",       Default = {"Off"},
    Items = {"Off","Down","Up","Minimal","Fake","Random","Custom"}, Multi = false,
    Callback = function(v) AntiAimInstance:SetPitchMode(dv(v)) end })
AASec1:Slider({ Name = "Custom Pitch",     Flag = "AACustomPitch", Min=-89,Max=89,Default=0,Suffix="°",
    Callback = function(v) AntiAimInstance:SetCustomPitch(v) end })
AASec1:Dropdown({ Name = "Yaw Base",       Flag = "AAYawBase",     Default = {"Local View"},
    Items = {"Local View","At Targets","Freestanding"}, Multi = false,
    Callback = function(v) AntiAimInstance:SetYawBase(dv(v)) end })
AASec1:Dropdown({ Name = "Yaw Mode",       Flag = "AAYawMode",     Default = {"Off"},
    Items = {"Off","180","Spin","180 Z","Sideways"}, Multi = false,
    Callback = function(v) AntiAimInstance:SetYawMode(dv(v)) end })
AASec1:Slider({ Name = "Yaw Offset",       Flag = "AAYawOff",      Min=-180,Max=180,Default=0,Suffix="°",
    Callback = function(v) AntiAimInstance:SetYawOffset(v) end })
AASec2:Dropdown({ Name = "Jitter Mode",    Flag = "AAJitter",      Default = {"Off"},
    Items = {"Off","Offset","Center","Random","3-Way","Sway"}, Multi = false,
    Callback = function(v) AntiAimInstance:SetYawJitter(dv(v)) end })
AASec2:Slider({ Name = "Jitter Range",     Flag = "AAJitterOff",   Min=0,Max=180,Default=45,Suffix="°",
    Callback = function(v) AntiAimInstance:SetJitterOffset(v) end })
AASec2:Toggle({ Name = "Slow Walk",        Flag = "AASlowWalk",    Default = false,
    Callback = function(v) AntiAimInstance:SetSlowWalk(v) end })
AASec2:Slider({ Name = "Slow Walk Speed",  Flag = "AASlowSpd",     Min=1,Max=100,Default=50,Suffix="%",
    Callback = function(v) AntiAimInstance:SetSlowWalkSpeed(v) end })
AASec2:Slider({ Name = "Spin Speed",       Flag = "AASpinSpd",     Min=1,Max=50,Default=10,
    Callback = function(v) AntiAimInstance:SetSpinSpeed(v) end })

-- ════════════════════════════════════════════════════════════════
Window:Category("Visuals")
-- ── ESP ──────────────────────────────────────────────────────────
local ESPPage = Window:Page({ Name = "ESP", Icon = "" })
local ESPSec1 = ESPPage:Section({ Name = "Box / Skeleton / Tracers", Side = 1 })
local ESPSec2 = ESPPage:Section({ Name = "Info / Chams / Backtrack", Side = 2 })

ESPSec1:Toggle({ Name = "Enable ESP",        Flag = "ESPEnabled",    Default = false, Callback = function(v) ESPInstance:SetEnabled(v) end })
ESPSec1:Toggle({ Name = "Self ESP",          Flag = "ESPSelf",       Default = false, Callback = function(v) ESPInstance:SetSelfESP(v) end })
ESPSec1:Toggle({ Name = "Team Check",        Flag = "ESPTeamCheck",  Default = true,  Callback = function(v) ESPInstance:SetTeamCheck(v) end })
ESPSec1:Toggle({ Name = "Hide Teammates",    Flag = "ESPTeamHide",   Default = true,  Callback = function(v) ESPInstance:SetTeamHide(v) end })
ESPSec1:Toggle({ Name = "Box",               Flag = "ESPBox",        Default = true,  Callback = function(v) ESPInstance:SetBoxEnabled(v) end })
ESPSec1:Dropdown({ Name = "Box Type",        Flag = "ESPBoxType",    Default={"Corner"}, Items={"Corner","Full"}, Multi=false, Callback=function(v) ESPInstance:SetBoxType(dv(v)) end })
ESPSec1:Label("Box Color"):Colorpicker({ Name="BoxColor",Flag="ESPBoxColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) ESPInstance:SetBoxColor(v) end })
ESPSec1:Toggle({ Name = "Box Fill",          Flag = "ESPBoxFill",    Default = true,  Callback = function(v) ESPInstance:SetBoxFillEnabled(v) end })
ESPSec1:Label("Fill Color"):Colorpicker({ Name="FillColor",Flag="ESPBoxFillColor",Default=Color3.fromRGB(200,20,20), Callback=function(v) ESPInstance:SetBoxFillColor(v) end })
ESPSec1:Slider({ Name = "Fill Alpha",        Flag = "ESPBoxFillTrans",Min=0,Max=1,Default=0.87, Callback=function(v) ESPInstance:SetBoxFillTransparency(v) end })
ESPSec1:Toggle({ Name = "Skeleton",          Flag = "ESPSkel",       Default = true,  Callback = function(v) ESPInstance:SetSkeletonEnabled(v) end })
ESPSec1:Label("Skeleton Color"):Colorpicker({ Name="SkelColor",Flag="ESPSkelColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) ESPInstance:SetSkeletonColor(v) end })
ESPSec1:Slider({ Name = "Skeleton Width",    Flag = "ESPSkelThick",  Min=1,Max=4,Default=1.5, Callback=function(v) ESPInstance:SetSkeletonThickness(v) end })
ESPSec1:Toggle({ Name = "Tracers",           Flag = "ESPTracers",    Default = false, Callback = function(v) ESPInstance:SetTracersEnabled(v) end })
ESPSec1:Dropdown({ Name = "Tracer Origin",   Flag = "ESPTracerOrig", Default={"Bottom"}, Items={"Bottom","Center","Top"}, Multi=false, Callback=function(v) ESPInstance:SetTracerOrigin(dv(v)) end })
ESPSec1:Label("Tracer Color"):Colorpicker({ Name="TracerColor",Flag="ESPTracerColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) ESPInstance:SetTracerColor(v) end })
ESPSec1:Slider({ Name = "Tracer Width",      Flag = "ESPTracerThick",Min=1,Max=4,Default=1, Callback=function(v) ESPInstance:SetTracerThickness(v) end })

ESPSec2:Toggle({ Name = "Name",              Flag = "ESPName",       Default = true,  Callback = function(v) ESPInstance:SetNameEnabled(v) end })
ESPSec2:Label("Name Color"):Colorpicker({ Name="NameColor",Flag="ESPNameColor",Default=Color3.fromRGB(255,255,255), Callback=function(v) ESPInstance:SetNameColor(v) end })
ESPSec2:Toggle({ Name = "Distance",          Flag = "ESPDist",       Default = true,  Callback = function(v) ESPInstance:SetDistanceEnabled(v) end })
ESPSec2:Label("Dist Color"):Colorpicker({ Name="DistColor",Flag="ESPDistColor",Default=Color3.fromRGB(190,190,190), Callback=function(v) ESPInstance:SetDistanceColor(v) end })
ESPSec2:Toggle({ Name = "Weapon",            Flag = "ESPWeapon",     Default = true,  Callback = function(v) ESPInstance:SetWeaponEnabled(v) end })
ESPSec2:Label("Weapon Color"):Colorpicker({ Name="WeaponColor",Flag="ESPWeaponColor",Default=Color3.fromRGB(200,200,200), Callback=function(v) ESPInstance:SetWeaponColor(v) end })
ESPSec2:Toggle({ Name = "Health Bar",        Flag = "ESPHealth",     Default = true,  Callback = function(v) ESPInstance:SetHealthEnabled(v) end })
ESPSec2:Toggle({ Name = "Health Gradient",   Flag = "ESPHealthGrad", Default = true,  Callback = function(v) ESPInstance:SetHealthGradient(v) end })
ESPSec2:Toggle({ Name = "Chams",             Flag = "ESPChams",      Default = true,  Callback = function(v) ESPInstance:SetChamsEnabled(v) end })
ESPSec2:Dropdown({ Name = "Chams Type",      Flag = "ESPChamsType",  Default={"Glow"},
    Items={"Outline","Solid","Outline+Solid","Glow","Pulse","Neon","Ghost","Wireframe"}, Multi=false,
    Callback=function(v) ESPInstance:SetChamsType(dv(v)) end })
ESPSec2:Label("Outline Color"):Colorpicker({ Name="ChamsOC",Flag="ESPChamsOC",Default=Color3.fromRGB(255,55,55), Callback=function(v) ESPInstance:SetChamsOutlineColor(v) end })
ESPSec2:Label("Fill Color"):Colorpicker({ Name="ChamsFC",Flag="ESPChamsFC",Default=Color3.fromRGB(180,20,20), Callback=function(v) ESPInstance:SetChamsFillColor(v) end })
ESPSec2:Slider({ Name = "Fill Alpha",        Flag = "ESPChamsFillTrans",Min=0,Max=1,Default=0.45, Callback=function(v) ESPInstance:SetChamsFillTransparency(v) end })
ESPSec2:Slider({ Name = "Outline Alpha",     Flag = "ESPChamsOutTrans", Min=0,Max=1,Default=0, Callback=function(v) ESPInstance:SetChamsOutlineTransparency(v) end })
ESPSec2:Toggle({ Name = "Always On Top",     Flag = "ESPChamsAOT",   Default = true,  Callback = function(v) ESPInstance:SetChamsDepth(v and "AlwaysOnTop" or "Occluded") end })
ESPSec2:Toggle({ Name = "Backtrack",         Flag = "ESPBacktrack",  Default = false, Callback = function(v) ESPInstance:SetBacktrackEnabled(v) end })
ESPSec2:Label("BT Color"):Colorpicker({ Name="BTColor",Flag="ESPBTColor",Default=Color3.fromRGB(255,55,55), Callback=function(v) ESPInstance:SetBacktrackColor(v) end })
ESPSec2:Slider({ Name = "BT Duration",       Flag = "ESPBTDur",      Min=0.1,Max=1,Default=0.5,Suffix="s", Callback=function(v) ESPInstance:SetBacktrackDuration(v) end })
ESPSec2:Slider({ Name = "BT Alpha",          Flag = "ESPBTTrans",    Min=0,Max=1,Default=0.45, Callback=function(v) ESPInstance:SetBacktrackTransparency(v) end })

-- ── Hit Effects ───────────────────────────────────────────────────
local HitPage = Window:Page({ Name = "Hit Effects", Icon = "" })
local HitSec1 = HitPage:Section({ Name = "Kill / Hit FX",           Side = 1 })
local HitSec2 = HitPage:Section({ Name = "Marker / Sound / Tracer", Side = 2 })

HitSec1:Toggle({ Name = "Hit Log",           Flag = "VisHitLog",     Default = true, Callback = function(v) VisualsInstance:SetHitlogEnabled(v) end })
HitSec1:Toggle({ Name = "Kill Banner",       Flag = "VisKillBanner", Default = true, Callback = function(v) VisualsInstance.KILLBANNER_ENABLED = v end })
HitSec1:Toggle({ Name = "Auto-Detect",       Flag = "VisAutoDetect", Default = true, Callback = function(v) VisualsInstance:SetAutoDetectEnabled(v) end })
HitSec1:Button({ Name = "Re-Scan Game Now",  Callback = function() VisualsInstance:RerunAutoDetect() end })
HitSec1:Toggle({ Name = "Kill FX",           Flag = "VisKillFX",     Default = true, Callback = function(v) VisualsInstance:SetKillFXEnabled(v) end })
HitSec1:Dropdown({ Name = "Kill FX Type",    Flag = "VisKFXType",    Default={"Nova"},
    Items={"Sparkle","Ring","Beam","Inferno","Vortex","Shatter","Nova","Cascade","Plasma","Reaper","Pixel"},
    Multi=false, Callback=function(v) VisualsInstance:SetKillFXType(dv(v)) end })
HitSec1:Label("Kill FX Color"):Colorpicker({ Name="KFXColor",Flag="VisKFXColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetKillFXColor(v) end })
HitSec1:Slider({ Name = "Kill FX Duration",  Flag = "VisKFXDur",     Min=0.05,Max=1,Default=0.25,Suffix="s", Callback=function(v) VisualsInstance:SetKillFXDuration(v) end })
HitSec1:Toggle({ Name = "Offscreen Arrows",  Flag = "VisOffscreen",  Default = true, Callback = function(v) VisualsInstance:SetOffscreenEnabled(v) end })
HitSec1:Label("Arrow Color"):Colorpicker({ Name="OffColor",Flag="VisOffColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetOffscreenColor(v) end })
HitSec1:Toggle({ Name = "Backtrack Ghost",   Flag = "VisBTGhost",    Default = false, Callback = function(v) VisualsInstance:SetBacktrackGhostEnabled(v) end })
HitSec1:Label("Ghost Color"):Colorpicker({ Name="BTGhostColor",Flag="VisBTGhostColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetBacktrackGhostColor(v) end })
HitSec1:Toggle({ Name = "Wallbang Markers",  Flag = "VisWB",         Default = false, Callback = function(v) VisualsInstance:SetWallbangEnabled(v) end })
HitSec1:Label("Entry Color"):Colorpicker({ Name="WBEntry",Flag="VisWBEntry",Default=Color3.fromRGB(255,50,50), Callback=function(v) VisualsInstance:SetWallbangEntryColor(v) end })
HitSec1:Label("Exit Color"):Colorpicker({ Name="WBExit",Flag="VisWBExit",Default=Color3.fromRGB(50,255,50), Callback=function(v) VisualsInstance:SetWallbangExitColor(v) end })

HitSec2:Toggle({ Name = "Hit Marker",        Flag = "VisHitMarker",  Default = true, Callback = function(v) VisualsInstance:SetHitMarkerEnabled(v) end })
HitSec2:Toggle({ Name = "Hit Sound",         Flag = "VisHitSound",   Default = true, Callback = function(v) VisualsInstance:SetHitSoundEnabled(v) end })
HitSec2:Dropdown({ Name = "Sound Preset",    Flag = "VisHitSndPre",  Default={"bell"},
    Items={"bell","clap","bloop","punch","headshot","orb","tank1","bell2","skeet","correct"},
    Multi=false, Callback=function(v) VisualsInstance:SetHitSoundPreset(dv(v)) end })
HitSec2:Slider({ Name = "Sound Volume",      Flag = "VisHitSndVol",  Min=0,Max=1,Default=0.75, Callback=function(v) VisualsInstance:SetHitSoundVolume(v) end })
HitSec2:Toggle({ Name = "Bullet Tracer",     Flag = "VisBTracer",    Default = true, Callback = function(v) VisualsInstance:SetTracerEnabled(v) end })
HitSec2:Dropdown({ Name = "Tracer Style",    Flag = "VisBTracerStyle",Default={"Classic"},
    Items={"Classic","Lightning","Helix","Pulse","Comet","Razor"},
    Multi=false, Callback=function(v) VisualsInstance:SetTracerStyle(dv(v)) end })
HitSec2:Label("Tracer Color"):Colorpicker({ Name="BTracerColor",Flag="VisBTracerColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetTracerColor(v) end })
HitSec2:Slider({ Name = "Tracer Lifetime",   Flag = "VisBTracerLife",Min=0.1,Max=2,Default=0.45,Suffix="s", Callback=function(v) VisualsInstance:SetTracerLifetime(v) end })
HitSec2:Slider({ Name = "Tracer Width",      Flag = "VisBTracerW",   Min=0.05,Max=5,Default=0.5, Callback=function(v) VisualsInstance:SetTracerWidth(v) end })

-- ── Cosmetics ─────────────────────────────────────────────────────
local CosPage = Window:Page({ Name = "Cosmetics", Icon = "" })
local CosSec1 = CosPage:Section({ Name = "Player Effects", Side = 1 })
local CosSec2 = CosPage:Section({ Name = "Post-FX",        Side = 2 })

CosSec1:Toggle({ Name = "Aura",              Flag = "VisAura",       Default = false, Callback = function(v) VisualsInstance:SetAuraEnabled(v) end })
CosSec1:Label("Aura Color"):Colorpicker({ Name="AuraColor",Flag="VisAuraColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetAuraColor(v) end })
CosSec1:Dropdown({ Name = "Aura Material",   Flag = "VisAuraMat",    Default={"Neon"},
    Items={"Neon","SmoothPlastic","Glass","Metal","ForceField","DiamondPlate"}, Multi=false,
    Callback=function(v) VisualsInstance:SetAuraMaterial(dv(v)) end })
CosSec1:Toggle({ Name = "China Hat",         Flag = "VisChinaHat",   Default = false, Callback = function(v) VisualsInstance:SetChinaHatEnabled(v) end })
CosSec1:Label("Hat Color"):Colorpicker({ Name="ChinaHatColor",Flag="VisChinaHatColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetChinaHatColor(v) end })
CosSec1:Dropdown({ Name = "Hat Material",    Flag = "VisChinaHatMat",Default={"Neon"},
    Items={"Neon","SmoothPlastic","Glass","Metal","ForceField","DiamondPlate"}, Multi=false,
    Callback=function(v) VisualsInstance:SetChinaHatMaterial(dv(v)) end })
CosSec1:Slider({ Name = "Hat Size",          Flag = "VisChinaHatSz", Min=1,Max=6,Default=2.8, Callback=function(v) VisualsInstance:SetChinaHatSize(v) end })
CosSec1:Slider({ Name = "Hat Spin Speed",    Flag = "VisChinaHatSpd",Min=0,Max=180,Default=15,Suffix="°/s", Callback=function(v) VisualsInstance:SetChinaHatSpeed(v) end })
CosSec1:Toggle({ Name = "Wings",             Flag = "VisWings",      Default = false, Callback = function(v) VisualsInstance:SetWingsEnabled(v) end })
CosSec1:Label("Wings Color"):Colorpicker({ Name="WingsColor",Flag="VisWingsColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetWingsColor(v) end })
CosSec1:Dropdown({ Name = "Wings Material",  Flag = "VisWingsMat",   Default={"Neon"},
    Items={"Neon","SmoothPlastic","Glass","Metal","ForceField"}, Multi=false,
    Callback=function(v) VisualsInstance:SetWingsMaterial(dv(v)) end })
CosSec1:Toggle({ Name = "Jump Circles",      Flag = "VisJumpCirc",   Default = false, Callback = function(v) VisualsInstance:SetJumpCirclesEnabled(v) end })
CosSec1:Label("Jump Color"):Colorpicker({ Name="JumpColor",Flag="VisJumpCircColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetJumpCirclesColor(v) end })
CosSec1:Toggle({ Name = "Neon Player",       Flag = "VisNeon",       Default = false, Callback = function(v) VisualsInstance:SetNeonPlayerEnabled(v) end })
CosSec1:Label("Neon Color"):Colorpicker({ Name="NeonColor",Flag="VisNeonColor",Default=Color3.fromRGB(255,65,65), Callback=function(v) VisualsInstance:SetNeonPlayerColor(v) end })

CosSec2:Toggle({ Name = "Bloom",             Flag = "VisBloom",      Default = true,  Callback = function(v) VisualsInstance:SetBloomEnabled(v) end })
CosSec2:Slider({ Name = "Bloom Intensity",   Flag = "VisBloomI",     Min=0,Max=10,Default=1.2, Callback=function(v) VisualsInstance:SetBloomIntensity(v) end })
CosSec2:Slider({ Name = "Bloom Size",        Flag = "VisBloomS",     Min=0,Max=100,Default=20, Callback=function(v) VisualsInstance:SetBloomSize(v) end })
CosSec2:Slider({ Name = "Bloom Threshold",   Flag = "VisBloomT",     Min=0,Max=1,Default=0.95, Callback=function(v) VisualsInstance:SetBloomThreshold(v) end })
CosSec2:Toggle({ Name = "Color Correction",  Flag = "VisCC",         Default = true,  Callback = function(v) VisualsInstance:SetColorCorrectionEnabled(v) end })
CosSec2:Slider({ Name = "Brightness",        Flag = "VisCCBright",   Min=-1,Max=1,Default=0.03, Callback=function(v) VisualsInstance:SetColorCorrectionBrightness(v) end })
CosSec2:Slider({ Name = "Contrast",          Flag = "VisCCCont",     Min=-1,Max=1,Default=0.08, Callback=function(v) VisualsInstance:SetColorCorrectionContrast(v) end })
CosSec2:Slider({ Name = "Saturation",        Flag = "VisCCSat",      Min=-1,Max=1,Default=0.06, Callback=function(v) VisualsInstance:SetColorCorrectionSaturation(v) end })
CosSec2:Toggle({ Name = "Atmosphere",        Flag = "VisAtmo",       Default = false, Callback = function(v) VisualsInstance:SetAtmosphereEnabled(v) end })
CosSec2:Slider({ Name = "Atmo Density",      Flag = "VisAtmoDens",   Min=0,Max=1,Default=0.25, Callback=function(v) VisualsInstance:SetAtmosphereDensity(v) end })
CosSec2:Slider({ Name = "Atmo Haze",         Flag = "VisAtmoHaze",   Min=0,Max=2,Default=0.4, Callback=function(v) VisualsInstance:SetAtmosphereHaze(v) end })

-- ════════════════════════════════════════════════════════════════
Window:Category("Misc")
local MiscPage = Window:Page({ Name = "Movement / World", Icon = "" })
local MiscSec1 = MiscPage:Section({ Name = "Movement",   Side = 1 })
local MiscSec2 = MiscPage:Section({ Name = "World / Fog",Side = 2 })

MiscSec1:Toggle({ Name = "Bunny Hop",        Flag = "MiscBhop",      Default = false, Callback = function(v) WorldInstance:SetBhopEnabled(v) end })
MiscSec1:Slider({ Name = "Bhop Speed",       Flag = "MiscBhopSpd",   Min=5,Max=150,Default=25,Suffix=" st", Callback=function(v) WorldInstance:SetBhopSpeed(v) end })
MiscSec1:Toggle({ Name = "Noclip",           Flag = "MiscNoclip",    Default = false, Callback = function(v) WorldInstance:SetNoclipEnabled(v) end })
MiscSec1:Keybind({ Name = "Noclip Key",      Flag = "NoclipKey",     Default=Enum.KeyCode.N, Callback=function() WorldInstance:SetNoclipEnabled(not WorldInstance.NOCLIP_ENABLED) end })
MiscSec1:Toggle({ Name = "Fly",              Flag = "MiscFly",       Default = false, Callback = function(v) WorldInstance:SetFlyEnabled(v) end })
MiscSec1:Slider({ Name = "Fly Speed",        Flag = "MiscFlySpd",    Min=10,Max=500,Default=50,Suffix=" st", Callback=function(v) WorldInstance:SetFlySpeed(v) end })
MiscSec1:Keybind({ Name = "Fly Key",         Flag = "FlyKey",        Default=Enum.KeyCode.G, Callback=function() WorldInstance:SetFlyEnabled(not WorldInstance.FLY_ENABLED) end })
MiscSec1:Toggle({ Name = "Viewmodel",        Flag = "MiscVM",        Default = false, Callback = function(v) WorldInstance:SetViewmodelEnabled(v) end })
MiscSec1:Toggle({ Name = "Spawn TP",         Flag = "MiscSpawnTP",   Default = false, Callback = function(v) WorldInstance:SetSpawnTpEnabled(v) end })
MiscSec1:Button({ Name = "TP to Spawn Now",  Callback = function() WorldInstance:TeleportToSpawn() end })

MiscSec2:Toggle({ Name = "Custom Time",      Flag = "MiscTime",      Default = false, Callback = function(v) WorldInstance:SetTimeEnabled(v) end })
MiscSec2:Slider({ Name = "Clock Time",       Flag = "MiscClock",     Min=0,Max=24,Default=14, Callback=function(v) WorldInstance:SetClockTime(v) end })
MiscSec2:Toggle({ Name = "Custom Sky",       Flag = "MiscSky",       Default = false, Callback = function(v) WorldInstance:SetSkyEnabled(v) end })
MiscSec2:Dropdown({ Name = "Sky Preset",     Flag = "MiscSkyPre",    Default={"Original"},
    Items={"Original","Blue","Gray","Dark","Green","Pink","Orange","Purple","Red"}, Multi=false,
    Callback=function(v) WorldInstance:SetSkyPreset(dv(v)) end })
MiscSec2:Toggle({ Name = "Blur",             Flag = "MiscBlur",      Default = false, Callback = function(v) WorldInstance:SetBlurEnabled(v) end })
MiscSec2:Slider({ Name = "Blur Size",        Flag = "MiscBlurSz",    Min=0,Max=56,Default=10, Callback=function(v) WorldInstance:SetBlurSize(v) end })
MiscSec2:Toggle({ Name = "Fog",              Flag = "MiscFog",       Default = false, Callback = function(v) WorldInstance:SetFogEnabled(v) end })
MiscSec2:Slider({ Name = "Fog Start",        Flag = "MiscFogStart",  Min=0,Max=1000,Default=0,Suffix=" st", Callback=function(v) WorldInstance:SetFogStart(v) end })
MiscSec2:Slider({ Name = "Fog End",          Flag = "MiscFogEnd",    Min=50,Max=5000,Default=500,Suffix=" st", Callback=function(v) WorldInstance:SetFogEnd(v) end })
MiscSec2:Label("Fog Color"):Colorpicker({ Name="FogColor",Flag="MiscFogColor",Default=Color3.fromRGB(180,180,190), Callback=function(v) WorldInstance:SetFogColor(v) end })

-- ════════════════════════════════════════════════════════════════
Window:Category("Settings")
local _SP = Library:CreateSettingsPage(Window, KeybindList)

Window:Init()
Notify("Eclipse v5", "Loaded successfully")
