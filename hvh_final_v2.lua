--[[
    HvH FINAL v2 | NeverLose UI
    ИЗМЕНЕНИЯ:
    - Хитлог: показывает ТОЛЬКО мои убийства (killer == LP.Name)
    - Хитлог: формат  ХИТ/МИСС  НИК  ДИСТАНЦИЯ
    - Хитлог: красивое прозрачное меню с fade-out
    - Килл-эффекты: добавлена чёрная дыра (blackhole) из blackhole.lua
    - Чёрная дыра исчезает через 3 секунды
    - Рейджбот: убрана проверка на оружие в руках
    - Рейджбот: semi-prediction логика из ragebot_improved.lua
    - Прочие фиксы и улучшения
]]

local UIS      = game:GetService("UserInputService")
local RS       = game:GetService("RunService")
local Plrs     = game:GetService("Players")
local WS       = game:GetService("Workspace")
local LP       = Plrs.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RS_rep   = game:GetService("ReplicatedStorage")
local Debris   = game:GetService("Debris")
local TICK = tick

-- ══════════════════════════════════════════
--  НАСТРОЙКИ
-- ══════════════════════════════════════════
local S = {
    -- ANTI-AIM
    aaEnabled          = false,
    aaMode             = "Jitter",
    aaPitch            = "Down",
    aaPitchAngle       = 89,
    aaPitchJitterSpeed = 150,
    aaRemoveHead       = false,
    aaYaw              = 180,
    aaBaseYaw          = "Real",
    aaJitterLeft       = -120,
    aaJitterRight      =  120,
    aaJitterSpeed      =  120,
    aaSpinSpeed        =  250,
    aaDesyncEnabled    = false,
    aaDesyncSide       = "Jitter",
    aaDesyncLimit      = 58,
    aaFakeLag          = false,
    aaFakeLagAmount    = 4,
    aaHeadOffset       = false,
    aaHeadOffsetY      = 1.5,
    aaHeadOffsetMode   = "Down",
    aaAnimDesync       = false,
    aaInvisLimbs       = false,
    aaConditions = {
        moving   = false,
        inAir    = false,
        standing = false,
        onKey    = false,
    },
    aaKey = Enum.KeyCode.LeftAlt,

    -- FAKEDUCK
    fdEnabled = false,
    fdMode    = "Hold",
    fdKey     = Enum.KeyCode.C,
    fdAmount  = 2.5,

    -- RAGEBOT
    rbEnabled         = false,
    rbTeamCheck       = true,
    rbHitbox          = "Head",
    rbMaxDistance     = 1000,
    rbFireRate        = 0.03,
    rbPrediction      = true,
    rbPredictionMult  = 1.15,
    rbBulletSpeed     = 3000,
    rbWallbang        = true,
    rbResolver        = true,
    rbHitchance       = 85,
    rbMinDamage       = 1,
    rbDoubleTap       = false,
    rbDoubleTapDelay  = 0.01,
    rbRapidFire       = false,
    rbRapidFireShots  = 5,
    rbRapidFireDelay  = 0.005,
    rbMultipoint      = true,
    rbMultipointScale = 0.75,
    rbSilentAim       = true,

    -- SEMI-PREDICTION (из ragebot_improved)
    semiPred         = true,
    semiPredMinSpeed = 8,
    semiPredMaxDist  = 250,
    semiPredHeadDist = 80,
    semiPredAirOff   = true,

    -- VISUALS / CHAMS
    chamsEnabled       = false,
    chamsSelfEnabled   = false,
    chamsTeamEnabled   = false,
    chamsEnemyEnabled  = false,
    chamsWeaponEnabled = false,
    chamsSelfStyle     = "Flat",
    chamsTeamStyle     = "Flat",
    chamsEnemyStyle    = "Neon",
    chamsWeaponStyle   = "Neon",
    chamsSelfColorVis    = Color3.fromRGB(100,200,255),
    chamsSelfColorHid    = Color3.fromRGB(50,100,180),
    chamsTeamColorVis    = Color3.fromRGB(60,255,120),
    chamsTeamColorHid    = Color3.fromRGB(30,130,60),
    chamsEnemyColorVis   = Color3.fromRGB(255,60,60),
    chamsEnemyColorHid   = Color3.fromRGB(180,20,20),
    chamsWeaponColor     = Color3.fromRGB(255,200,50),
    chamsSelfTransp    = 20,
    chamsTeamTransp    = 25,
    chamsEnemyTransp   = 20,
    chamsWeaponTransp  = 0,
    chamsSelfWall      = true,
    chamsTeamWall      = true,
    chamsEnemyWall     = true,
    chamsEnemyHPColor  = false,
    chamsWeaponRainbow = false,

    -- WORLD
    skyboxEnabled   = false,
    skyboxPreset    = "Night City",
    worldColor      = false,
    worldAmbient    = Color3.fromRGB(30,30,50),
    worldOutdoor    = Color3.fromRGB(20,20,40),
    worldBrightness = 30,
    worldFogStart   = 200,
    worldFogEnd     = 800,
    worldFogColor   = Color3.fromRGB(20,20,40),
}

-- ══════════════════════════════════════════
--  RUNTIME
-- ══════════════════════════════════════════
local R = {
    myChar=nil, myHRP=nil, myHead=nil, myHum=nil, cam=nil,
    playerData={}, playerDataTime=0,
    originalSizes=nil,
    fakeLagPositions={}, fakeLagIdx=0, fakeLagFrame=0,
    fireShot=nil, fireShotTime=0,
    rbLastShot=0,
    fdOriginalHip=nil, fdActive=false,
}

local aaLastSwitch      = 0
local aaCurrentSide     = "left"
local aaOriginalNeckC0  = nil
local aaOriginalWaistC0 = nil
local aaOriginalHeadC0  = nil
local fdToggleState     = false

local RBRayParams = RaycastParams.new()
RBRayParams.FilterType = Enum.RaycastFilterType.Exclude

-- ══════════════════════════════════════════
--  VELOCITY HISTORY (semi-prediction)
-- ══════════════════════════════════════════
local velocityHistory = {}
local VEL_HISTORY_SIZE = 6

local function recordVelocity(player, vel)
    if not velocityHistory[player] then velocityHistory[player] = {} end
    local hist = velocityHistory[player]
    table.insert(hist, {vel=vel, t=tick()})
    while #hist > VEL_HISTORY_SIZE do table.remove(hist, 1) end
end

local function getSmoothedVelocity(player)
    local hist = velocityHistory[player]
    if not hist or #hist == 0 then return Vector3.zero end
    local sumVel, sumWeight = Vector3.zero, 0
    local now = tick()
    for _, entry in ipairs(hist) do
        local w = math.exp(-(now - entry.t) * 3)
        sumVel = sumVel + entry.vel * w
        sumWeight = sumWeight + w
    end
    if sumWeight < 0.001 then return Vector3.zero end
    return sumVel / sumWeight
end

-- ══════════════════════════════════════════
--  LIBRARY
-- ══════════════════════════════════════════
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"
))()

local CheatName = "MyProject"
Library.Folders = {
    Directory = CheatName,
    Configs   = CheatName .. "/Configs",
    Assets    = CheatName .. "/Assets",
}

Library:ChangeTheme("Accent",         Color3.fromRGB(255, 80, 80))
Library:ChangeTheme("AccentGradient", Color3.fromRGB(120, 20, 20))

local Window = Library:Window({
    Name    = "MyProject",
    SubName = "hvh edition",
    Logo    = "120959262762131",
})
local KeybindList = Library:KeybindList("Keybinds")
Library:Watermark({"MyProject", "hvh edition", 120959262762131})

task.spawn(function()
    while true do
        local ok, fps = pcall(function() return math.floor(1 / RS.RenderStepped:Wait()) end)
        Library:Watermark({"MyProject", "hvh edition", 120959262762131, "FPS: "..(ok and fps or "?")})
        task.wait(0.5)
    end
end)

-- ══════════════════════════════════════════
--  CATEGORY: MAIN
-- ══════════════════════════════════════════
Window:Category("Main")
local LegitPage   = Window:Page({Name="Legit", Icon="138827881557940"})
local MainSection = LegitPage:Section({Name="Main Features", Side=1})
local MiscSection = LegitPage:Section({Name="Misc",          Side=2})

MainSection:Toggle({Name="Enabled",    Flag="LegitEnabled", Default=true,  Callback=function() end})
MainSection:Slider({Name="Speed Hack", Flag="SpeedSlider", Min=1, Max=100, Default=16, Suffix=" studs", Callback=function() end})
MainSection:Dropdown({Name="Hitbox Type", Flag="HitboxType", Default={"Head"}, Items={"Head","Torso","Arms","Legs"}, Multi=true, Callback=function() end})

MiscSection:Button({
    Name="Test Notification",
    Callback=function()
        Library:Notification({Title="System", Description="Script работает!", Duration=4, Icon="73789337996373"})
    end
})
MiscSection:Keybind({Name="Menu Toggle", Flag="MenuToggle", Default=Enum.KeyCode.Insert, Callback=function() end})

-- ══════════════════════════════════════════
--  CATEGORY: RAGEBOT
-- ══════════════════════════════════════════
Window:Category("Ragebot")

local RagePage     = Window:Page({Name="Ragebot",  Icon="138827881557940"})
local RageMain     = RagePage:Section({Name="General",   Side=1})
local RageAim      = RagePage:Section({Name="Aimbot",    Side=1})
local RageFireSec  = RagePage:Section({Name="Fire",      Side=2})
local RageAdvanced = RagePage:Section({Name="Advanced",  Side=2})
local RagePredSec  = RagePage:Section({Name="Semi-Pred", Side=2})

RageMain:Toggle({Name="Enable Ragebot", Flag="RBEnabled", Default=false,
    Callback=function(v) S.rbEnabled=v end})
RageMain:Toggle({Name="Team Check", Flag="RBTeamCheck", Default=true,
    Callback=function(v) S.rbTeamCheck=v end})
RageMain:Dropdown({Name="Hitbox", Flag="RBHitbox", Default={"Head"}, Items={"Head","Torso"}, Multi=false,
    Callback=function(v) S.rbHitbox=v[1] or "Head" end})
RageMain:Slider({Name="Max Distance", Flag="RBMaxDist", Min=100, Max=1000, Default=1000, Suffix=" studs",
    Callback=function(v) S.rbMaxDistance=v end})
RageMain:Slider({Name="Min Damage", Flag="RBMinDmg", Min=1, Max=352, Default=1, Suffix=" dmg",
    Callback=function(v) S.rbMinDamage=v end})
RageMain:Slider({Name="Hitchance", Flag="RBHitchance", Min=1, Max=100, Default=85, Suffix="%",
    Callback=function(v) S.rbHitchance=v end})

RageAim:Toggle({Name="Prediction", Flag="RBPrediction", Default=true,
    Callback=function(v) S.rbPrediction=v end})
RageAim:Slider({Name="Prediction Mult", Flag="RBPredMult", Min=10, Max=20, Default=12, Suffix="x",
    Callback=function(v) S.rbPredictionMult=v/10 end})
RageAim:Toggle({Name="Multipoint", Flag="RBMultipoint", Default=true,
    Callback=function(v) S.rbMultipoint=v end})
RageAim:Slider({Name="Multipoint Scale", Flag="RBMPScale", Min=1, Max=10, Default=7,
    Callback=function(v) S.rbMultipointScale=v/10 end})
RageAim:Toggle({Name="Wallbang",   Flag="RBWallbang",  Default=true,  Callback=function(v) S.rbWallbang=v  end})
RageAim:Toggle({Name="Resolver",   Flag="RBResolver",  Default=true,  Callback=function(v) S.rbResolver=v  end})
RageAim:Toggle({Name="Silent Aim", Flag="RBSilentAim", Default=true,  Callback=function(v) S.rbSilentAim=v end})

RageFireSec:Slider({Name="Fire Rate", Flag="RBFireRate", Min=10, Max=500, Default=30, Suffix="ms",
    Callback=function(v) S.rbFireRate=v/1000 end})
RageFireSec:Toggle({Name="Double Tap",  Flag="RBDoubleTap",  Default=false, Callback=function(v) S.rbDoubleTap=v  end})
RageFireSec:Slider({Name="DT Delay",    Flag="RBDTDelay",    Min=1, Max=100, Default=10, Suffix="ms",
    Callback=function(v) S.rbDoubleTapDelay=v/1000 end})
RageFireSec:Toggle({Name="Rapid Fire",  Flag="RBRapidFire",  Default=false, Callback=function(v) S.rbRapidFire=v  end})
RageFireSec:Slider({Name="RF Shots",    Flag="RBRFShots",    Min=1, Max=20,  Default=5,
    Callback=function(v) S.rbRapidFireShots=v end})
RageFireSec:Slider({Name="RF Delay",    Flag="RBRFDelay",    Min=1, Max=50,  Default=5, Suffix="ms",
    Callback=function(v) S.rbRapidFireDelay=v/1000 end})

RageAdvanced:Slider({Name="Bullet Speed", Flag="RBBulletSpeed", Min=500, Max=5000, Default=3000, Suffix=" s/u",
    Callback=function(v) S.rbBulletSpeed=v end})

-- Semi-Prediction настройки
RagePredSec:Toggle({Name="Semi-Prediction", Flag="RBSemiPred", Default=true,
    Callback=function(v) S.semiPred=v end})
RagePredSec:Slider({Name="Min Speed", Flag="RBSemiMinSpd", Min=1, Max=50, Default=8, Suffix=" s/u",
    Callback=function(v) S.semiPredMinSpeed=v end})
RagePredSec:Slider({Name="Max Dist",  Flag="RBSemiMaxDist", Min=50, Max=500, Default=250, Suffix=" st",
    Callback=function(v) S.semiPredMaxDist=v end})
RagePredSec:Toggle({Name="Air Off",   Flag="RBSemiAirOff", Default=true,
    Callback=function(v) S.semiPredAirOff=v end})

-- ══════════════════════════════════════════
--  CATEGORY: ANTI-AIM
-- ══════════════════════════════════════════
local AAPage    = Window:Page({Name="Anti-Aim", Icon="138827881557940"})
local AAGenSec  = AAPage:Section({Name="General",       Side=1})
local AAJitSec  = AAPage:Section({Name="Jitter / Spin", Side=1})
local AAHeadSec = AAPage:Section({Name="Head Offset",   Side=1})
local AAFDSec   = AAPage:Section({Name="Fakeduck",      Side=1})
local AADesSec  = AAPage:Section({Name="Desync",        Side=2})
local AAFLSec   = AAPage:Section({Name="Fake Lag",      Side=2})
local AAExtSec  = AAPage:Section({Name="Extra",         Side=2})

AAGenSec:Toggle({Name="Enable Anti-Aim", Flag="AAEnabled", Default=false,
    Callback=function(v)
        S.aaEnabled = v
        Library:Notification({Title="Anti-Aim", Description=v and "Enabled" or "Disabled", Duration=2})
    end
})
AAGenSec:Dropdown({Name="Mode", Flag="AAMode", Default={"Jitter"}, Items={"Static","Jitter","Spin"}, Multi=false,
    Callback=function(v) S.aaMode=v[1] or "Jitter"; aaLastSwitch=TICK() end})
AAGenSec:Dropdown({Name="Pitch", Flag="AAPitch", Default={"Down"}, Items={"Up","Down","Zero","Jitter"}, Multi=false,
    Callback=function(v) S.aaPitch=v[1] or "Down" end})
AAGenSec:Slider({Name="Pitch Angle", Flag="AAPitchAngle", Min=0, Max=89, Default=89, Suffix="°",
    Callback=function(v) S.aaPitchAngle=v end})
AAGenSec:Slider({Name="Pitch Jitter Speed", Flag="AAPitchJitterSpd", Min=50, Max=500, Default=150, Suffix="ms",
    Callback=function(v) S.aaPitchJitterSpeed=v end})
AAGenSec:Slider({Name="Yaw Offset", Flag="AAYawOffset", Min=-180, Max=180, Default=180, Suffix="°",
    Callback=function(v) S.aaYaw=v end})
AAGenSec:Dropdown({Name="Base Yaw", Flag="AABaseYaw", Default={"Real"}, Items={"Real","Target","Velocity","Static"}, Multi=false,
    Callback=function(v) S.aaBaseYaw=v[1] or "Real" end})

AAJitSec:Slider({Name="Jitter Left",  Flag="AAJitterLeft",  Min=-180, Max=180, Default=-120, Suffix="°",
    Callback=function(v) S.aaJitterLeft=v  end})
AAJitSec:Slider({Name="Jitter Right", Flag="AAJitterRight", Min=-180, Max=180, Default=120,  Suffix="°",
    Callback=function(v) S.aaJitterRight=v end})
AAJitSec:Slider({Name="Jitter Speed", Flag="AAJitterSpd",   Min=50,   Max=500, Default=120,  Suffix="ms",
    Callback=function(v) S.aaJitterSpeed=v end})
AAJitSec:Slider({Name="Spin Speed",   Flag="AASpinSpd",     Min=30,   Max=3600, Default=250,
    Callback=function(v) S.aaSpinSpeed=v  end})

AAHeadSec:Toggle({Name="Head Offset", Flag="AAHeadOffset", Default=false,
    Callback=function(v)
        S.aaHeadOffset=v
        if not v then aaOriginalHeadC0=nil end
        Library:Notification({Title="Head Offset", Description=v and "On" or "Off", Duration=2})
    end
})
AAHeadSec:Dropdown({Name="Head Mode", Flag="AAHeadMode", Default={"Down"}, Items={"Up","Down","Side","Random"}, Multi=false,
    Callback=function(v) S.aaHeadOffsetMode=v[1] or "Down" end})
AAHeadSec:Slider({Name="Offset Amount", Flag="AAHeadAmt", Min=5, Max=50, Default=15,
    Callback=function(v) S.aaHeadOffsetY=v/10 end})

AAFDSec:Toggle({Name="Enable Fakeduck", Flag="FDEnabled", Default=false,
    Callback=function(v)
        S.fdEnabled=v
        if not v and R.myHum and R.fdOriginalHip then
            R.myHum.HipHeight=R.fdOriginalHip; R.fdOriginalHip=nil
        end
        Library:Notification({Title="Fakeduck", Description=v and "On" or "Off", Duration=2})
    end
})
AAFDSec:Dropdown({Name="Mode", Flag="FDMode", Default={"Hold"}, Items={"Hold","Toggle"}, Multi=false,
    Callback=function(v) S.fdMode=v[1] or "Hold" end})
AAFDSec:Slider({Name="Duck Amount", Flag="FDAmount", Min=5, Max=40, Default=25,
    Callback=function(v) S.fdAmount=v/10 end})
AAFDSec:Keybind({Name="Fakeduck Key", Flag="FDKey", Default=Enum.KeyCode.C,
    Callback=function(v) S.fdKey=v end})

AADesSec:Toggle({Name="Desync", Flag="AADesync", Default=false,
    Callback=function(v) S.aaDesyncEnabled=v end})
AADesSec:Dropdown({Name="Desync Side", Flag="AADesyncSide", Default={"Jitter"}, Items={"Left","Right","Jitter"}, Multi=false,
    Callback=function(v) S.aaDesyncSide=v[1] or "Jitter" end})
AADesSec:Slider({Name="Desync Limit", Flag="AADesyncLimit", Min=10, Max=58, Default=58, Suffix="°",
    Callback=function(v) S.aaDesyncLimit=v end})

AAFLSec:Toggle({Name="Fake Lag", Flag="AAFakeLag", Default=false,
    Callback=function(v)
        S.aaFakeLag=v
        Library:Notification({Title="Fake Lag", Description=v and "On" or "Off", Duration=2})
    end
})
AAFLSec:Slider({Name="Lag Amount", Flag="AAFakeLagAmt", Min=1, Max=12, Default=4, Suffix=" ticks",
    Callback=function(v) S.aaFakeLagAmount=v end})

AAExtSec:Toggle({Name="Remove Head", Flag="AARemoveHead", Default=false,
    Callback=function(v)
        S.aaRemoveHead=v
        if not v then AA_RemoveHead_Stop() end
        Library:Notification({Title="Remove Head", Description=v and "On" or "Off", Duration=2})
    end
})
AAExtSec:Toggle({Name="Only Moving",   Flag="AAOnlyMoving",   Default=false, Callback=function(v) S.aaConditions.moving=v   end})
AAExtSec:Toggle({Name="Only In Air",   Flag="AAOnlyInAir",    Default=false, Callback=function(v) S.aaConditions.inAir=v    end})
AAExtSec:Toggle({Name="Only Standing", Flag="AAOnlyStanding", Default=false, Callback=function(v) S.aaConditions.standing=v end})
AAExtSec:Toggle({Name="On Key (LAlt)", Flag="AAOnKey",        Default=false, Callback=function(v) S.aaConditions.onKey=v    end})
AAExtSec:Toggle({Name="Anim Desync",   Flag="AAAnimDesync",   Default=false, Callback=function(v) S.aaAnimDesync=v          end})
AAExtSec:Toggle({Name="Invis Limbs",   Flag="AAInvisLimbs",   Default=false,
    Callback=function(v)
        S.aaInvisLimbs=v
        if not v then AA_InvisLimbs_Stop() end
        Library:Notification({Title="Invis Limbs", Description=v and "On" or "Off", Duration=2})
    end
})

-- ══════════════════════════════════════════
--  CATEGORY: VISUALS
-- ══════════════════════════════════════════
Window:Category("Visuals")

local ChamsPage   = Window:Page({Name="Chams",  Icon="138827881557940"})
local ChamsSelf   = ChamsPage:Section({Name="Self",   Side=1})
local ChamsTeam   = ChamsPage:Section({Name="Team",   Side=1})
local ChamsEnemy  = ChamsPage:Section({Name="Enemy",  Side=2})
local ChamsWeapon = ChamsPage:Section({Name="Weapon", Side=2})

ChamsSelf:Toggle({Name="Enable", Flag="ChamsSelf", Default=false, Callback=function(v) S.chamsSelfEnabled=v end})
ChamsSelf:Dropdown({Name="Style", Flag="ChamsSelfStyle", Default={"Flat"}, Items={"Flat","Neon","Outlined","Glass","Rainbow"}, Multi=false, Callback=function(v) S.chamsSelfStyle=v[1] or "Flat" end})
ChamsSelf:Label("Fill Color"):Colorpicker({Name="Self Fill", Flag="ChamsSelfFill", Default=Color3.fromRGB(100,200,255), Callback=function(v) S.chamsSelfColorVis=v end})
ChamsSelf:Label("Outline Color"):Colorpicker({Name="Self Out", Flag="ChamsSelfOut", Default=Color3.fromRGB(50,100,180), Callback=function(v) S.chamsSelfColorHid=v end})
ChamsSelf:Slider({Name="Transparency", Flag="ChamsSelfTransp", Min=0, Max=100, Default=20, Suffix="%", Callback=function(v) S.chamsSelfTransp=v end})
ChamsSelf:Toggle({Name="Through Walls", Flag="ChamsSelfWall", Default=true, Callback=function(v) S.chamsSelfWall=v end})

ChamsTeam:Toggle({Name="Enable", Flag="ChamsTeam", Default=false, Callback=function(v) S.chamsTeamEnabled=v end})
ChamsTeam:Dropdown({Name="Style", Flag="ChamsTeamStyle", Default={"Flat"}, Items={"Flat","Neon","Outlined","Glass","Rainbow"}, Multi=false, Callback=function(v) S.chamsTeamStyle=v[1] or "Flat" end})
ChamsTeam:Label("Fill Vis"):Colorpicker({Name="Team FillVis", Flag="ChamsTeamFillVis", Default=Color3.fromRGB(60,255,120), Callback=function(v) S.chamsTeamColorVis=v end})
ChamsTeam:Label("Fill Hid"):Colorpicker({Name="Team FillHid", Flag="ChamsTeamFillHid", Default=Color3.fromRGB(30,130,60), Callback=function(v) S.chamsTeamColorHid=v end})
ChamsTeam:Slider({Name="Transparency", Flag="ChamsTeamTransp", Min=0, Max=100, Default=25, Suffix="%", Callback=function(v) S.chamsTeamTransp=v end})
ChamsTeam:Toggle({Name="Through Walls", Flag="ChamsTeamWall", Default=true, Callback=function(v) S.chamsTeamWall=v end})

ChamsEnemy:Toggle({Name="Enable", Flag="ChamsEnemy", Default=false, Callback=function(v) S.chamsEnemyEnabled=v end})
ChamsEnemy:Dropdown({Name="Style", Flag="ChamsEnemyStyle", Default={"Neon"}, Items={"Flat","Neon","Outlined","Glass","Rainbow"}, Multi=false, Callback=function(v) S.chamsEnemyStyle=v[1] or "Neon" end})
ChamsEnemy:Label("Fill Vis"):Colorpicker({Name="Enemy FillVis", Flag="ChamsEnemyFillVis", Default=Color3.fromRGB(255,60,60), Callback=function(v) S.chamsEnemyColorVis=v end})
ChamsEnemy:Label("Fill Hid"):Colorpicker({Name="Enemy FillHid", Flag="ChamsEnemyFillHid", Default=Color3.fromRGB(180,20,20), Callback=function(v) S.chamsEnemyColorHid=v end})
ChamsEnemy:Slider({Name="Transparency", Flag="ChamsEnemyTransp", Min=0, Max=100, Default=20, Suffix="%", Callback=function(v) S.chamsEnemyTransp=v end})
ChamsEnemy:Toggle({Name="Through Walls", Flag="ChamsEnemyWall", Default=true, Callback=function(v) S.chamsEnemyWall=v end})
ChamsEnemy:Toggle({Name="HP Color",      Flag="ChamsEnemyHP",   Default=false, Callback=function(v) S.chamsEnemyHPColor=v end})

ChamsWeapon:Toggle({Name="Enable", Flag="ChamsWeapon", Default=false, Callback=function(v) S.chamsWeaponEnabled=v end})
ChamsWeapon:Dropdown({Name="Style", Flag="ChamsWeaponStyle", Default={"Neon"}, Items={"Flat","Neon","Outlined","Glass","Rainbow"}, Multi=false, Callback=function(v) S.chamsWeaponStyle=v[1] or "Neon" end})
ChamsWeapon:Label("Color"):Colorpicker({Name="Weapon Color", Flag="ChamsWeaponColor", Default=Color3.fromRGB(255,200,50), Callback=function(v) S.chamsWeaponColor=v end})
ChamsWeapon:Toggle({Name="Rainbow", Flag="ChamsWeaponRainbow", Default=false, Callback=function(v) S.chamsWeaponRainbow=v end})

-- World
local WorldPage = Window:Page({Name="World", Icon="138827881557940"})
local SkyboxSec = WorldPage:Section({Name="Skybox",      Side=1})
local WorldSec  = WorldPage:Section({Name="World Color", Side=2})

SkyboxSec:Toggle({Name="Enable Skybox", Flag="SkyboxEnabled", Default=false,
    Callback=function(v) S.skyboxEnabled=v end})
SkyboxSec:Dropdown({Name="Preset", Flag="SkyboxPreset", Default={"Night City"},
    Items={"Night City","Arctic","Deep Space","Sunset","Stormy","Dawn","Neon Night"}, Multi=false,
    Callback=function(v) S.skyboxPreset=v[1] or "Night City" end})

WorldSec:Toggle({Name="Enable World Color", Flag="WorldColor", Default=false,
    Callback=function(v) S.worldColor=v end})
WorldSec:Label("Ambient"):Colorpicker({Name="WorldAmb", Flag="WorldAmb", Default=Color3.fromRGB(30,30,50),
    Callback=function(v) S.worldAmbient=v end})
WorldSec:Slider({Name="Brightness", Flag="WorldBri", Min=0, Max=100, Default=30, Suffix="%",
    Callback=function(v) S.worldBrightness=v end})
WorldSec:Slider({Name="Fog Start", Flag="WorldFogS", Min=0, Max=1000, Default=200, Suffix=" st",
    Callback=function(v) S.worldFogStart=v end})
WorldSec:Slider({Name="Fog End",   Flag="WorldFogE", Min=100, Max=5000, Default=800, Suffix=" st",
    Callback=function(v) S.worldFogEnd=v end})

-- ══════════════════════════════════════════
--  CATEGORY: FEED & FX
-- ══════════════════════════════════════════
Window:Category("Feed & FX")
local FeedPage = Window:Page({Name="Feed & FX", Icon="138827881557940"})
local HLSec    = FeedPage:Section({Name="Hit Log",      Side=1})
local KESec    = FeedPage:Section({Name="Kill Effects",  Side=2})

-- ── НАСТРОЙКИ ХИТЛОГА ────────────────────
local HL = {
    enabled     = true,
    maxEntries  = 8,
    lifetime    = 5,   -- секунды до fade-out
}

HLSec:Toggle({Name="Enable Hit Log", Flag="HLEnabled", Default=true,
    Callback=function(v) HL.enabled=v end})
HLSec:Slider({Name="Max Entries", Flag="HLMaxEntries", Min=3, Max=15, Default=8, Suffix=" lines",
    Callback=function(v) HL.maxEntries=v end})
HLSec:Slider({Name="Entry Lifetime", Flag="HLLifetime", Min=2, Max=15, Default=5, Suffix="s",
    Callback=function(v) HL.lifetime=v end})

-- ── НАСТРОЙКИ КИЛЛ-ЭФФЕКТОВ ──────────────
local KE = {
    enabled       = true,
    style         = "Blackhole",  -- "Particles" / "Flash" / "Blackhole" / "All"
    particleColor = Color3.fromRGB(255, 60, 60),
    flashColor    = Color3.fromRGB(255, 60, 60),
    size          = 1,
}

KESec:Toggle({Name="Enable Kill Effects", Flag="KEEnabled", Default=true,
    Callback=function(v) KE.enabled=v end})
KESec:Dropdown({Name="Style", Flag="KEStyle", Default={"Blackhole"},
    Items={"Particles","Flash","Blackhole","All"}, Multi=false,
    Callback=function(v) KE.style=v[1] or "Blackhole" end})
KESec:Label("Particle Color"):Colorpicker({Name="KE ParticleColor", Flag="KEParticleColor",
    Default=Color3.fromRGB(255,60,60), Callback=function(v) KE.particleColor=v end})
KESec:Slider({Name="Effect Size", Flag="KESize", Min=1, Max=5, Default=1, Suffix="x",
    Callback=function(v) KE.size=v end})

-- ══════════════════════════════════════════
--  GUI: ХИТЛОГ — красивый прозрачный
--  Показывает только МОИ килы
--  Формат: ХИТ/МИСС  НИК  РАССТОЯНИЕ
-- ══════════════════════════════════════════
local hlGui, hlFrame

pcall(function()
    local pg = LP:WaitForChild("PlayerGui", 5)
    if not pg then return end

    local sg = Instance.new("ScreenGui")
    sg.Name           = "HitLogGui"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent         = pg

    -- Основной контейнер — правый нижний угол
    hlFrame = Instance.new("Frame")
    hlFrame.Name                = "HitLog"
    hlFrame.Size                = UDim2.new(0, 260, 0, 340)
    hlFrame.Position            = UDim2.new(1, -268, 1, -350)
    hlFrame.BackgroundTransparency = 1
    hlFrame.ClipsDescendants    = false
    hlFrame.Parent              = sg

    -- Заголовок панели
    local header = Instance.new("Frame")
    header.Name                = "Header"
    header.Size                = UDim2.new(1, 0, 0, 20)
    header.Position            = UDim2.new(0, 0, 0, -24)
    header.BackgroundColor3    = Color3.fromRGB(20, 20, 28)
    header.BackgroundTransparency = 0.35
    header.BorderSizePixel     = 0
    header.Parent              = hlFrame

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 4)
    hCorner.Parent = header

    local hStroke = Instance.new("UIStroke")
    hStroke.Color = Color3.fromRGB(220, 40, 40)
    hStroke.Thickness = 1
    hStroke.Transparency = 0.4
    hStroke.Parent = header

    local hLabel = Instance.new("TextLabel")
    hLabel.Size                = UDim2.new(1, -8, 1, 0)
    hLabel.Position            = UDim2.new(0, 8, 0, 0)
    hLabel.BackgroundTransparency = 1
    hLabel.Text                = "◈ HIT LOG"
    hLabel.TextColor3          = Color3.fromRGB(220, 40, 40)
    hLabel.TextSize            = 10
    hLabel.Font                = Enum.Font.GothamBold
    hLabel.TextXAlignment      = Enum.TextXAlignment.Left
    hLabel.Parent              = header

    -- Layout для записей
    local layout = Instance.new("UIListLayout")
    layout.SortOrder          = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment  = Enum.VerticalAlignment.Bottom
    layout.Padding            = UDim.new(0, 3)
    layout.Parent             = hlFrame

    hlGui = sg
end)

-- Создание одной строки хитлога
-- isHit: true=ХИТ, false=МИСС
-- victimName: ник жертвы
-- dist: дистанция в стёрсах
local function createHLEntry(isHit, victimName, dist, headshot)
    if not hlFrame then return end

    -- Строка
    local row = Instance.new("Frame")
    row.Name                   = "HLEntry"
    row.Size                   = UDim2.new(1, 0, 0, 24)
    row.BackgroundColor3       = isHit
        and Color3.fromRGB(28, 8, 8)
        or  Color3.fromRGB(8, 8, 28)
    row.BackgroundTransparency = 1  -- начинаем прозрачным
    row.BorderSizePixel        = 0
    row.ClipsDescendants       = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = row

    -- Декоративная полоска слева
    local stripe = Instance.new("Frame")
    stripe.Size             = UDim2.new(0, 2, 1, -4)
    stripe.Position         = UDim2.new(0, 0, 0, 2)
    stripe.BackgroundColor3 = isHit
        and Color3.fromRGB(220, 40, 40)
        or  Color3.fromRGB(60, 60, 220)
    stripe.BorderSizePixel  = 0
    stripe.BackgroundTransparency = 1
    stripe.Parent           = row

    local stripeCorner = Instance.new("UICorner")
    stripeCorner.CornerRadius = UDim.new(0, 2)
    stripeCorner.Parent = stripe

    -- Обводка строки
    local stroke = Instance.new("UIStroke")
    stroke.Color       = isHit
        and Color3.fromRGB(200, 30, 30)
        or  Color3.fromRGB(30, 30, 200)
    stroke.Thickness   = 0.8
    stroke.Transparency = 1  -- начинаем прозрачным
    stroke.Parent      = row

    -- ХИТ / МИСС тэг
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size                = UDim2.new(0, 42, 1, 0)
    tagLabel.Position            = UDim2.new(0, 6, 0, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text                = isHit and (headshot and "★HIT" or "✔HIT") or "✘MISS"
    tagLabel.TextColor3          = isHit
        and (headshot and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(200, 200, 80))
        or  Color3.fromRGB(120, 120, 255)
    tagLabel.TextSize            = 10
    tagLabel.Font                = Enum.Font.GothamBold
    tagLabel.TextXAlignment      = Enum.TextXAlignment.Left
    tagLabel.TextTransparency    = 1
    tagLabel.Parent              = row

    -- Ник жертвы
    local nickLabel = Instance.new("TextLabel")
    nickLabel.Size                = UDim2.new(0, 110, 1, 0)
    nickLabel.Position            = UDim2.new(0, 52, 0, 0)
    nickLabel.BackgroundTransparency = 1
    nickLabel.Text                = tostring(victimName)
    nickLabel.TextColor3          = Color3.fromRGB(220, 220, 220)
    nickLabel.TextSize            = 11
    nickLabel.Font                = Enum.Font.Gotham
    nickLabel.TextXAlignment      = Enum.TextXAlignment.Left
    nickLabel.TextStrokeTransparency = 0.6
    nickLabel.TextTransparency    = 1
    nickLabel.Parent              = row

    -- Дистанция
    local distLabel = Instance.new("TextLabel")
    distLabel.Size                = UDim2.new(0, 60, 1, 0)
    distLabel.Position            = UDim2.new(1, -64, 0, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text                = string.format("%.0f st", dist)
    distLabel.TextColor3          = Color3.fromRGB(140, 140, 160)
    distLabel.TextSize            = 10
    distLabel.Font                = Enum.Font.Gotham
    distLabel.TextXAlignment      = Enum.TextXAlignment.Right
    distLabel.TextTransparency    = 1
    distLabel.Parent              = row

    -- Сортировка — новые сверху
    for _, ch in ipairs(hlFrame:GetChildren()) do
        if ch:IsA("Frame") then ch.LayoutOrder = ch.LayoutOrder + 1 end
    end
    row.LayoutOrder = 0
    row.Parent = hlFrame

    -- Удаляем лишние
    local entries = {}
    for _, ch in ipairs(hlFrame:GetChildren()) do
        if ch:IsA("Frame") then table.insert(entries, ch) end
    end
    table.sort(entries, function(a,b) return a.LayoutOrder > b.LayoutOrder end)
    for i = HL.maxEntries+1, #entries do
        pcall(function() entries[i]:Destroy() end)
    end

    -- Анимация появления
    local fadeIn = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
    TweenService:Create(row,       fadeIn, {BackgroundTransparency=0.35}):Play()
    TweenService:Create(stripe,    fadeIn, {BackgroundTransparency=0}):Play()
    TweenService:Create(stroke,    fadeIn, {Transparency=0.5}):Play()
    TweenService:Create(tagLabel,  fadeIn, {TextTransparency=0}):Play()
    TweenService:Create(nickLabel, fadeIn, {TextTransparency=0}):Play()
    TweenService:Create(distLabel, fadeIn, {TextTransparency=0}):Play()

    -- Fade-out через lifetime секунд
    task.delay(HL.lifetime, function()
        if not row or not row.Parent then return end
        local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
        TweenService:Create(row,       fadeOut, {BackgroundTransparency=1}):Play()
        TweenService:Create(stripe,    fadeOut, {BackgroundTransparency=1}):Play()
        TweenService:Create(stroke,    fadeOut, {Transparency=1}):Play()
        TweenService:Create(tagLabel,  fadeOut, {TextTransparency=1}):Play()
        TweenService:Create(nickLabel, fadeOut, {TextTransparency=1}):Play()
        TweenService:Create(distLabel, fadeOut, {TextTransparency=1}):Play()
        task.wait(0.55)
        if row and row.Parent then row:Destroy() end
    end)
end

-- ══════════════════════════════════════════
--  КИЛЛ-ЭФФЕКТЫ
-- ══════════════════════════════════════════
local function getCharByName(name)
    local pl = Plrs:FindFirstChild(name)
    return pl and pl.Character
end

-- Частицы (кровь/искры)
local function spawnKillParticles(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        local anchor = Instance.new("Part")
        anchor.Size = Vector3.new(0.1,0.1,0.1); anchor.Anchored = true
        anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false
        anchor.Transparency = 1; anchor.CFrame = hrp.CFrame; anchor.Parent = WS

        local attach = Instance.new("Attachment", anchor)

        local pe = Instance.new("ParticleEmitter", attach)
        pe.Color = ColorSequence.new(KE.particleColor, Color3.fromRGB(80,0,0))
        pe.LightEmission = 0.5; pe.LightInfluence = 0.3
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.3*KE.size),NumberSequenceKeypoint.new(1,0)})
        pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.7,0.3),NumberSequenceKeypoint.new(1,1)})
        pe.Speed = NumberRange.new(8*KE.size,18*KE.size)
        pe.SpreadAngle = Vector2.new(80,80); pe.RotSpeed = NumberRange.new(-200,200)
        pe.Rotation = NumberRange.new(0,360); pe.Lifetime = NumberRange.new(0.4,0.9)
        pe.Rate = 0; pe.Texture = "rbxasset://textures/particles/smoke_main.dds"
        pe:Emit(math.floor(12*KE.size))

        local pe2 = Instance.new("ParticleEmitter", attach)
        pe2.Color = ColorSequence.new(Color3.fromRGB(255,200,50), Color3.fromRGB(255,80,0))
        pe2.LightEmission = 1
        pe2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.08),NumberSequenceKeypoint.new(1,0)})
        pe2.Speed = NumberRange.new(12,25); pe2.SpreadAngle = Vector2.new(90,90)
        pe2.Lifetime = NumberRange.new(0.2,0.6); pe2.Rate = 0
        pe2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        pe2:Emit(math.floor(20*KE.size))

        Debris:AddItem(anchor, 1.5)
    end)
end

-- Вспышка хайлайтом
local function spawnKillFlash(char)
    if not char then return end
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Adornee = char; hl.FillColor = KE.flashColor
        hl.OutlineColor = Color3.new(1,1,1)
        hl.FillTransparency = 0; hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        TweenService:Create(hl, TweenInfo.new(0.3), {FillTransparency=1, OutlineTransparency=1}):Play()
        task.delay(0.35, function() if hl and hl.Parent then hl:Destroy() end end)
    end)
end

-- Чёрная дыра (из blackhole.lua) — появляется в точке смерти жертвы, исчезает через 3 сек
local function spawnBlackhole(cframe)
    pcall(function()
        local anchor = Instance.new("Part")
        anchor.Size         = Vector3.new(1,1,1)
        anchor.Transparency = 1
        anchor.Anchored     = true
        anchor.CanCollide   = false
        anchor.CastShadow   = false
        anchor.CFrame       = cframe
        anchor.Parent       = WS

        local att = Instance.new("Attachment", anchor)

        local light = Instance.new("PointLight", anchor)
        light.Color      = Color3.fromRGB(255,100,0)
        light.Brightness = 5
        light.Range      = 16

        -- Вспомогательная функция для частиц
        local function makeP(cfg)
            local p = Instance.new("ParticleEmitter", att)
            for k,v in pairs(cfg) do p[k]=v end
        end

        makeP({
            Name="blackhole",
            RotSpeed=NumberRange.new(10,10),
            SpreadAngle=Vector2.new(-360,360),
            Color=ColorSequence.new(Color3.new(0,0,0)),
            VelocityInheritance=0, Rate=20,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.7,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=NumberRange.new(0,0), Lifetime=NumberRange.new(0.5,0.5),
            LightEmission=0, Speed=NumberRange.new(0.074,0.074),
            Texture="rbxassetid://14770848042",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2.22),NumberSequenceKeypoint.new(1,2.22)}),
        })
        makeP({
            Name="blackring",
            RotSpeed=NumberRange.new(-360,360),
            SpreadAngle=Vector2.new(-360,360),
            Color=ColorSequence.new(Color3.new(0,0,0)),
            VelocityInheritance=0, Rate=20,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.2,1),NumberSequenceKeypoint.new(0.4,0),NumberSequenceKeypoint.new(0.6,0),NumberSequenceKeypoint.new(0.8,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=NumberRange.new(0,0), Lifetime=NumberRange.new(0.4,0.4),
            LightEmission=0, Speed=NumberRange.new(0.37,0.37),
            Texture="rbxassetid://2763450503",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2.96),NumberSequenceKeypoint.new(1,2.96)}),
        })
        makeP({
            Name="whitecenter",
            RotSpeed=NumberRange.new(10,10),
            SpreadAngle=Vector2.new(-360,360),
            Color=ColorSequence.new(Color3.new(1,1,1)),
            VelocityInheritance=0, Rate=20,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.2,1),NumberSequenceKeypoint.new(0.4,1),NumberSequenceKeypoint.new(0.6,0),NumberSequenceKeypoint.new(0.8,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=NumberRange.new(0,0), Lifetime=NumberRange.new(0.5,0.5),
            LightEmission=1, Speed=NumberRange.new(0.37,0.37),
            Texture="rbxassetid://6644617442",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2.4),NumberSequenceKeypoint.new(1,2.4)}),
        })
        makeP({
            Name="whitering",
            RotSpeed=NumberRange.new(-360,360),
            SpreadAngle=Vector2.new(-360,360),
            Color=ColorSequence.new(Color3.new(1,1,1)),
            VelocityInheritance=0, Rate=20,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.2,1),NumberSequenceKeypoint.new(0.4,1),NumberSequenceKeypoint.new(0.6,0),NumberSequenceKeypoint.new(0.8,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=NumberRange.new(0,0), Lifetime=NumberRange.new(0.4,0.4),
            LightEmission=0.5, Speed=NumberRange.new(0.37,0.74),
            Texture="rbxassetid://2763450503",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,3.7),NumberSequenceKeypoint.new(1,3.7)}),
        })
        makeP({
            Name="dustring1",
            RotSpeed=NumberRange.new(-10,10),
            SpreadAngle=Vector2.new(-360,360),
            Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(242,189,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,120,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}),
            VelocityInheritance=0, Rate=10,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.1,0),NumberSequenceKeypoint.new(1,1)}),
            Lifetime=NumberRange.new(0.7,1), LightEmission=0.8,
            Speed=NumberRange.new(0.37,0.37),
            Texture="rbxassetid://11745241946",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,7.4),NumberSequenceKeypoint.new(1,7.4)}),
        })
        makeP({
            Name="disk1",
            RotSpeed=NumberRange.new(360,720),
            SpreadAngle=Vector2.new(0,0),
            Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,160,0))}),
            VelocityInheritance=0, Rate=10,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.2,0),NumberSequenceKeypoint.new(1,1)}),
            Lifetime=NumberRange.new(1,2), LightEmission=0.5,
            Speed=NumberRange.new(0.037,0.037),
            Texture="rbxassetid://9864060085",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,4.81),NumberSequenceKeypoint.new(1,4.81)}),
        })
        makeP({
            Name="outerdisk",
            RotSpeed=NumberRange.new(360,720),
            SpreadAngle=Vector2.new(0,0),
            Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,140,140)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(84,84,84)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}),
            VelocityInheritance=0, Rate=10,
            EmissionDirection=Enum.NormalId.Top, LightInfluence=0,
            Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.2,0),NumberSequenceKeypoint.new(0.74,0),NumberSequenceKeypoint.new(1,1)}),
            Rotation=NumberRange.new(-360,360), Lifetime=NumberRange.new(1,2),
            LightEmission=0.5, Speed=NumberRange.new(0.037,0.037),
            Texture="rbxassetid://7150933366",
            Size=NumberSequence.new({NumberSequenceKeypoint.new(0,29.6),NumberSequenceKeypoint.new(1,29.6)}),
        })

        -- Исчезновение через 3 секунды — плавно гасим Rate у всех эмиттеров
        task.delay(3, function()
            if not anchor or not anchor.Parent then return end
            for _, em in ipairs(att:GetChildren()) do
                if em:IsA("ParticleEmitter") then
                    TweenService:Create(em, TweenInfo.new(0.5), {Rate=0}):Play()
                end
            end
            -- Ждём пока последние частицы угаснут и удаляем
            task.delay(0.8, function()
                if anchor and anchor.Parent then anchor:Destroy() end
            end)
        end)
    end)
end

-- ══════════════════════════════════════════
--  KFD — подключение к RemoteEvent игры
-- ══════════════════════════════════════════
task.spawn(function()
    local kfd = RS_rep:WaitForChild("kfd", 30)
    if not kfd then
        warn("[MyProject] kfd RemoteEvent not found")
        return
    end

    -- killer, victim, headshot, weapon, airkill
    -- ВАЖНО: игра также может слать дистанцию как 5й аргумент вместо airkill
    -- Адаптируем под оба варианта
    kfd.OnClientEvent:Connect(function(killer, victim, headshot, weapon, extra)
        local killerStr = tostring(killer or "?")
        local victimStr = tostring(victim or "?")
        local isHS      = headshot == true

        -- extra может быть дистанцией (число) или airkill (bool)
        local dist = 0
        if type(extra) == "number" then
            dist = extra
        else
            -- Считаем дистанцию сами по позиции жертвы
            pcall(function()
                if R.myHRP then
                    local vChar = getCharByName(victimStr)
                    if vChar then
                        local vHRP = vChar:FindFirstChild("HumanoidRootPart")
                        if vHRP then
                            dist = math.floor((vHRP.Position - R.myHRP.Position).Magnitude)
                        end
                    end
                end
            end)
        end

        -- ── ХИТЛОГ: только если МЫ убийца ──
        if HL.enabled and killerStr == LP.Name then
            pcall(function()
                -- isHit = true (это килл — значит хит)
                createHLEntry(true, victimStr, dist, isHS)
            end)
        end

        -- ── КИЛЛ-ЭФФЕКТЫ: только если МЫ убийца ──
        if KE.enabled and killerStr == LP.Name then
            local victimChar = getCharByName(victimStr)
            local killCFrame = CFrame.new(0,0,0)
            if victimChar then
                local vHRP = victimChar:FindFirstChild("HumanoidRootPart")
                if vHRP then killCFrame = vHRP.CFrame end
            end

            if KE.style == "Particles" or KE.style == "All" then
                spawnKillParticles(victimChar)
            end
            if KE.style == "Flash" or KE.style == "All" then
                spawnKillFlash(victimChar)
            end
            if KE.style == "Blackhole" or KE.style == "All" then
                spawnBlackhole(killCFrame)
            end
        end
    end)

    Library:Notification({
        Title="MyProject",
        Description="kfd подключён! Хитлог и килл-эффекты активны.",
        Duration=4
    })
end)

-- ══════════════════════════════════════════
--  RAGEBOT HELPERS
-- ══════════════════════════════════════════
local function CacheChar()
    local c = LP.Character
    if not c then R.myChar=nil; R.myHRP=nil; R.myHead=nil; R.myHum=nil; return end
    R.myChar = c
    R.myHRP  = c:FindFirstChild("HumanoidRootPart")
    R.myHead = c:FindFirstChild("Head")
    R.myHum  = c:FindFirstChildOfClass("Humanoid")
    R.cam    = WS.CurrentCamera
end

local function RB_GetFireShot()
    local now = TICK()
    if R.fireShot and now-R.fireShotTime<30 then return R.fireShot end
    -- Ищем fireShot везде в WS — без проверки на инструмент!
    local function search(inst)
        for _, ch in ipairs(inst:GetChildren()) do
            if ch:IsA("RemoteEvent") and ch.Name:lower():find("fire") then
                R.fireShot=ch; R.fireShotTime=now; return ch
            end
            local r=search(ch); if r then return r end
        end
    end
    return search(WS)
end

local resolverDB = {}
local function getRD(player)
    if not resolverDB[player] then resolverDB[player]={offset=0,misses=0} end
    return resolverDB[player]
end

local function RB_IsVisible(from,to,ignoreChar)
    RBRayParams.FilterDescendantsInstances={ignoreChar}
    local res=WS:Raycast(from,(to-from)*0.99,RBRayParams)
    return res==nil
end

local function RB_GenPoints(part,ptype,scale)
    local sz=part.Size*0.5*scale
    if ptype=="Head" then
        return {part.Position,part.Position+Vector3.new(sz.X,0,0),part.Position+Vector3.new(-sz.X,0,0),part.Position+Vector3.new(0,sz.Y,0)}
    end
    return {part.Position,part.Position+Vector3.new(sz.X,0,0),part.Position-Vector3.new(sz.X,0,0),part.Position+Vector3.new(0,sz.Y*0.6,0),part.Position-Vector3.new(0,sz.Y*0.6,0)}
end

local function RB_ApplyResolver(player,pos)
    local d=getRD(player); if d.offset==0 then return pos end
    local char=player.Character; if not char then return pos end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return pos end
    local a=math.rad(d.offset); local off=pos-root.Position
    return root.Position+Vector3.new(off.X*math.cos(a)-off.Z*math.sin(a),off.Y,off.X*math.sin(a)+off.Z*math.cos(a))
end

local function RB_GetBestPoint(pd)
    local from=R.myHead.Position
    if not S.rbMultipoint then
        local part=S.rbHitbox=="Head" and pd.head or pd.torso or pd.r
        if part then return RB_ApplyResolver(pd.p,part.Position),part end
        return nil,nil
    end
    local visible={}
    if pd.head then
        for _,pt in ipairs(RB_GenPoints(pd.head,"Head",S.rbMultipointScale)) do
            local res=RB_ApplyResolver(pd.p,pt)
            if RB_IsVisible(from,res,R.myChar) then table.insert(visible,{pos=res,part=pd.head}) end
        end
    end
    if #visible==0 and pd.torso then
        for _,pt in ipairs(RB_GenPoints(pd.torso,"Body",S.rbMultipointScale)) do
            local res=RB_ApplyResolver(pd.p,pt)
            if RB_IsVisible(from,res,R.myChar) then table.insert(visible,{pos=res,part=pd.torso}) end
        end
    end
    if #visible==0 then return nil,nil end
    if R.cam and #visible>1 then
        local cx=R.cam.ViewportSize.X/2; local cy=R.cam.ViewportSize.Y/2
        local best,bestD=visible[1],math.huge
        for _,vp in ipairs(visible) do
            local sp=R.cam:WorldToViewportPoint(vp.pos)
            local d=(sp.X-cx)^2+(sp.Y-cy)^2
            if d<bestD then bestD=d; best=vp end
        end
        return best.pos,best.part
    end
    return visible[1].pos,visible[1].part
end

-- Semi-Prediction: умная логика вкл/выкл
local function shouldPredict(pd, targetPart, myPos)
    if not S.rbPrediction then return false end
    if not S.semiPred then return true end

    local rootPart = pd.r
    local vel = getSmoothedVelocity(pd.p)
    local speed = Vector3.new(vel.X,0,vel.Z).Magnitude
    local dist = (rootPart.Position - myPos).Magnitude

    if dist > S.semiPredMaxDist then return false end
    if speed < S.semiPredMinSpeed then return false end
    if targetPart.Name == "Head" and dist <= S.semiPredHeadDist then return false end

    if S.semiPredAirOff then
        local hum = rootPart.Parent:FindFirstChildOfClass("Humanoid")
        if hum then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Freefall
            or st == Enum.HumanoidStateType.Jumping
            or st == Enum.HumanoidStateType.FallingDown then
                return false
            end
        end
    end
    return true
end

local function RB_Predict(pd, targetPos, targetPart, dist)
    local myPos = R.myHead and R.myHead.Position or Vector3.zero
    if not shouldPredict(pd, targetPart, myPos) then return targetPos end

    local vel = getSmoothedVelocity(pd.p)
    if vel.Magnitude < 0.3 then return targetPos end

    local ping = math.min((LP.GetNetworkPing and LP:GetNetworkPing()) or 0.08, 0.3)
    local travelTime = dist / math.max(S.rbBulletSpeed, 100)
    local spd = vel.Magnitude
    local speedMult = spd>60 and 1.35 or spd>50 and 1.25 or spd>30 and 1.18 or spd>16 and 1.12 or 1.06
    local distMult  = dist>400 and 1.28 or dist>300 and 1.22 or dist>150 and 1.16 or 1.08
    local gravity   = Vector3.zero
    local hum = pd.r.Parent:FindFirstChildOfClass("Humanoid")
    if hum then
        local st = hum:GetState()
        if st==Enum.HumanoidStateType.Freefall or math.abs(vel.Y)>5 then
            gravity = Vector3.new(0,-WS.Gravity*travelTime*0.65,0)
        end
    end
    local predTime = (ping+travelTime)*S.rbPredictionMult*speedMult*distMult

    -- Компенсация ускорения
    local rawVel = pd.r.AssemblyLinearVelocity
    local accel  = (rawVel - vel) * 0.3

    return targetPos + vel*predTime + accel*predTime + gravity
end

local function RB_Damage(part,dist)
    local mults={Head=4.0,UpperTorso=1.0,LowerTorso=0.9,Torso=1.0}
    return math.floor(88*(mults[part.Name] or 0.75)*math.max(0.85,1-dist/5000))
end

local function RB_Shoot(fs,from,to,part)
    pcall(function() fs:FireServer(from,(to-from).Unit,part) end)
end

-- UpdatePlayerData — кэшируем врагов
local function UpdatePlayerData()
    local now = TICK()
    if now - R.playerDataTime < 0.05 then return end
    R.playerDataTime = now
    R.playerData = {}
    if not R.myHRP then return end

    local list = {}
    for _,pl in ipairs(Plrs:GetPlayers()) do
        if pl == LP then continue end
        local char = pl.Character; if not char then continue end
        local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local dist = (hrp.Position-R.myHRP.Position).Magnitude
        table.insert(list,{
            p=pl, char=char, r=hrp,
            head=char:FindFirstChild("Head"),
            torso=char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
            hum=hum,
            dist=dist,
            team=LP.Team~=nil and (pl.Team==LP.Team),
        })
    end
    table.sort(list,function(a,b) return a.dist<b.dist end)
    R.playerData = list
end

local rbFrame = 0
local function RB_MainLoop()
    if not S.rbEnabled then return end
    rbFrame = rbFrame+1
    if not R.myHead or not R.myChar then return end
    local now = TICK()
    if now-R.rbLastShot < S.rbFireRate then return end

    RBRayParams.FilterDescendantsInstances = {R.myChar}
    local bestPD, bestDmg = nil, 0

    for i = 1, #R.playerData do
        local pd = R.playerData[i]
        if pd.dist > S.rbMaxDistance then continue end
        if S.rbTeamCheck and pd.team then continue end
        local targetPos, targetPart = RB_GetBestPoint(pd)
        if not targetPart or not targetPos then continue end
        local dmg = RB_Damage(targetPart, pd.dist)
        if dmg < S.rbMinDamage then continue end
        if not bestPD or dmg > bestDmg then bestPD=pd; bestDmg=dmg end
    end
    if not bestPD then return end

    -- Hitchance
    if S.rbHitchance < 100 and math.random(1,100) > S.rbHitchance then return end

    -- Ищем fireShot БЕЗ проверки на инструмент
    local fs = RB_GetFireShot()
    if not fs then return end

    local targetPos, targetPart = RB_GetBestPoint(bestPD)
    if not targetPart or not targetPos then return end

    local pred = RB_Predict(bestPD, targetPos, targetPart, bestPD.dist)

    if S.rbRapidFire then
        task.spawn(function()
            for i = 1, S.rbRapidFireShots do
                if R.myHead then RB_Shoot(fs, R.myHead.Position, pred, targetPart) end
                if i < S.rbRapidFireShots then task.wait(S.rbRapidFireDelay) end
            end
        end)
    else
        if R.myHead then RB_Shoot(fs, R.myHead.Position, pred, targetPart) end
        if S.rbDoubleTap then
            task.spawn(function()
                task.wait(S.rbDoubleTapDelay)
                local fs2 = RB_GetFireShot()
                if fs2 and R.myHead and targetPart and targetPart.Parent then
                    local p2, tp2 = RB_GetBestPoint(bestPD)
                    if p2 and tp2 then
                        RB_Shoot(fs2, R.myHead.Position, RB_Predict(bestPD, p2, tp2, bestPD.dist), tp2)
                    end
                end
            end)
        end
    end
    R.rbLastShot = now
end

-- ══════════════════════════════════════════
--  ANTI-AIM
-- ══════════════════════════════════════════
local function AA_ShouldActivate()
    if not S.aaEnabled then return false end
    if not R.myChar or not R.myHRP or not R.myHum then return false end
    if S.aaConditions.onKey    and not UIS:IsKeyDown(S.aaKey)                          then return false end
    if S.aaConditions.moving   and R.myHum.MoveDirection.Magnitude<0.1                 then return false end
    if S.aaConditions.standing and R.myHum.MoveDirection.Magnitude>0.1                 then return false end
    if S.aaConditions.inAir    and R.myHum:GetState()~=Enum.HumanoidStateType.Freefall then return false end
    return true
end

local function AA_GetBaseYaw()
    if not R.myHRP then return 0 end
    local cam = R.cam; if not cam then return 0 end
    if S.aaBaseYaw=="Real" then
        local lv=cam.CFrame.LookVector; return math.atan2(lv.X,lv.Z)
    elseif S.aaBaseYaw=="Target" then
        for _,pd in pairs(R.playerData) do
            if not pd.team and pd.r then local d=pd.r.Position-R.myHRP.Position; return math.atan2(d.X,d.Z) end
        end; return 0
    elseif S.aaBaseYaw=="Velocity" then
        local v=R.myHRP.AssemblyLinearVelocity
        if v.Magnitude>0.5 then return math.atan2(v.X,v.Z) end; return 0
    else return math.rad(S.aaYaw) end
end

local function AA_GenYaw()
    local base=AA_GetBaseYaw(); local yaw=base
    if S.aaMode=="Static" then
        yaw=base+math.rad(S.aaYaw)
    elseif S.aaMode=="Jitter" then
        local now=TICK()
        if now-aaLastSwitch>S.aaJitterSpeed/1000 then
            aaCurrentSide=aaCurrentSide=="left" and "right" or "left"; aaLastSwitch=now
        end
        yaw=base+math.rad(aaCurrentSide=="left" and S.aaJitterLeft or S.aaJitterRight)
    elseif S.aaMode=="Spin" then
        yaw=base+math.rad((TICK()%(360/math.max(S.aaSpinSpeed,1)))*S.aaSpinSpeed%360)
    end
    if S.aaDesyncEnabled then
        local off=math.rad(S.aaDesyncLimit)
        if     S.aaDesyncSide=="Left"   then yaw=yaw-off
        elseif S.aaDesyncSide=="Right"  then yaw=yaw+off
        elseif S.aaDesyncSide=="Jitter" then yaw=yaw+(aaCurrentSide=="left" and -off or off)
        end
    end
    return yaw
end

local function AA_FakeLag_Update()
    if not S.aaFakeLag or not R.myHRP then return end
    R.fakeLagFrame=R.fakeLagFrame+1; if R.fakeLagFrame%3~=0 then return end
    table.insert(R.fakeLagPositions,R.myHRP.CFrame)
    if #R.fakeLagPositions>10 then table.remove(R.fakeLagPositions,1) end
    R.fakeLagIdx=R.fakeLagIdx+1
    if R.fakeLagIdx>=math.min(math.floor(S.aaFakeLagAmount),10) and #R.fakeLagPositions>0 then
        R.myHRP.CFrame=R.fakeLagPositions[1]; R.fakeLagIdx=0
    end
end

local function AA_HeadOffset()
    if not S.aaHeadOffset then
        if R.myChar and aaOriginalHeadC0 then
            local neck=(R.myChar:FindFirstChild("Head") and R.myChar.Head:FindFirstChild("Neck"))
                    or (R.myChar:FindFirstChild("Torso") and R.myChar.Torso:FindFirstChild("Neck"))
            if neck then neck.C0=aaOriginalHeadC0 end
        end; return
    end
    if not R.myChar or not R.myHead then return end
    local neck=R.myHead:FindFirstChild("Neck")
            or (R.myChar:FindFirstChild("Torso") and R.myChar.Torso:FindFirstChild("Neck"))
    if not neck then return end
    if not aaOriginalHeadC0 then aaOriginalHeadC0=neck.C0 end
    local oy=S.aaHeadOffsetY
    if     S.aaHeadOffsetMode=="Up"     then neck.C0=aaOriginalHeadC0*CFrame.new(0,oy,0)
    elseif S.aaHeadOffsetMode=="Down"   then neck.C0=aaOriginalHeadC0*CFrame.new(0,-oy,0)
    elseif S.aaHeadOffsetMode=="Side"   then neck.C0=aaOriginalHeadC0*CFrame.new(oy,0,0)
    elseif S.aaHeadOffsetMode=="Random" then
        local t=TICK()
        neck.C0=aaOriginalHeadC0*CFrame.new(math.sin(t*3.7)*oy,math.cos(t*2.1)*oy,0)
    end
end

function AA_RemoveHead_Stop()
    if not R.myChar then return end
    local head=R.myChar:FindFirstChild("Head")
    if head then head.Transparency=0; for _,ch in pairs(head:GetChildren()) do if ch:IsA("Decal") then ch.Transparency=0 end end end
    local ut=R.myChar:FindFirstChild("UpperTorso"); local torso=R.myChar:FindFirstChild("Torso")
    local neck=(ut and ut:FindFirstChild("Neck")) or (torso and torso:FindFirstChild("Neck"))
    if neck and aaOriginalNeckC0 then neck.C0=aaOriginalNeckC0; aaOriginalNeckC0=nil end
end

local function AA_RemoveHead_Apply()
    if not S.aaRemoveHead or not R.myChar then return end
    local head=R.myChar:FindFirstChild("Head"); if not head then return end
    head.Transparency=1
    for _,ch in pairs(head:GetChildren()) do if ch:IsA("Decal") then ch.Transparency=1 end end
    local ut=R.myChar:FindFirstChild("UpperTorso"); local torso=R.myChar:FindFirstChild("Torso")
    local neck=(ut and ut:FindFirstChild("Neck")) or (torso and torso:FindFirstChild("Neck"))
    if neck and neck:IsA("Motor6D") then
        if not aaOriginalNeckC0 then aaOriginalNeckC0=neck.C0 end
        neck.C0=aaOriginalNeckC0*CFrame.new(0,-5,0)
    end
end

local animDesyncFrame=0
local function AA_AnimDesync_Update()
    if not S.aaAnimDesync or not R.myHum then return end
    animDesyncFrame=animDesyncFrame+1; if animDesyncFrame%5~=0 then return end
    local anim=R.myHum:FindFirstChildOfClass("Animator"); if not anim then return end
    for i,track in ipairs(anim:GetPlayingAnimationTracks()) do
        if i>3 then break end
        track.TimePosition=track.TimePosition+(math.random()-0.5)*0.3
    end
end

function AA_InvisLimbs_Stop()
    if not R.myChar then return end
    for _,p in pairs(R.myChar:GetDescendants()) do
        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Transparency=0 end
    end
end

local function AA_InvisLimbs_Apply()
    if not R.myChar then return end
    local limbs={"Left Arm","Right Arm","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","Left Leg","Right Leg","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
    for _,nm in ipairs(limbs) do
        local p=R.myChar:FindFirstChild(nm)
        if p and p:IsA("BasePart") then p.Transparency=1 end
    end
end

local function AA_Apply()
    if not AA_ShouldActivate() then
        if R.myChar then
            local head=R.myChar:FindFirstChild("Head"); local ut=R.myChar:FindFirstChild("UpperTorso"); local torso=R.myChar:FindFirstChild("Torso")
            local neck=(head and head:FindFirstChild("Neck")) or (ut and ut:FindFirstChild("Neck")) or (torso and torso:FindFirstChild("Neck"))
            local waist=ut and ut:FindFirstChild("Waist")
            if neck  and aaOriginalNeckC0  then neck.C0=aaOriginalNeckC0  end
            if waist and aaOriginalWaistC0 then waist.C0=aaOriginalWaistC0 end
            if R.myHum then R.myHum.AutoRotate=true end
        end; return
    end
    if not R.myHRP or not R.myChar then return end
    if R.myHum then R.myHum.AutoRotate=false end
    local yaw=AA_GenYaw()
    R.myHRP.CFrame=CFrame.new(R.myHRP.Position)*CFrame.Angles(0,yaw,0)
    if not S.aaRemoveHead then
        local head=R.myChar:FindFirstChild("Head"); local ut=R.myChar:FindFirstChild("UpperTorso"); local torso=R.myChar:FindFirstChild("Torso")
        local neck=(head and head:FindFirstChild("Neck")) or (ut and ut:FindFirstChild("Neck")) or (torso and torso:FindFirstChild("Neck"))
        local waist=ut and ut:FindFirstChild("Waist")
        if neck  and not aaOriginalNeckC0  then aaOriginalNeckC0=neck.C0   end
        if waist and not aaOriginalWaistC0 then aaOriginalWaistC0=waist.C0 end
        local pitch=0
        if     S.aaPitch=="Up"     then pitch=-math.rad(S.aaPitchAngle)
        elseif S.aaPitch=="Down"   then pitch= math.rad(S.aaPitchAngle)
        elseif S.aaPitch=="Jitter" then
            local interval=S.aaPitchJitterSpeed/1000
            pitch=(TICK()%(interval*2)<interval) and -math.rad(S.aaPitchAngle) or math.rad(S.aaPitchAngle)
        end
        if pitch~=0 then
            if neck  and aaOriginalNeckC0  then neck.C0=aaOriginalNeckC0*CFrame.Angles(pitch*0.5,0,0)   end
            if waist and aaOriginalWaistC0 then waist.C0=aaOriginalWaistC0*CFrame.Angles(pitch*0.5,0,0) end
        else
            if neck  and aaOriginalNeckC0  then neck.C0=aaOriginalNeckC0   end
            if waist and aaOriginalWaistC0 then waist.C0=aaOriginalWaistC0 end
        end
    end
end

-- FAKEDUCK
local function FakeDuck_Update()
    if not R.myHum or not R.myHRP then return end
    local shouldDuck=false
    if S.fdEnabled then
        if S.fdMode=="Hold" then shouldDuck=UIS:IsKeyDown(S.fdKey)
        else shouldDuck=fdToggleState end
    end
    if shouldDuck then
        if not R.fdOriginalHip then R.fdOriginalHip=R.myHum.HipHeight end
        R.myHum.HipHeight=R.fdOriginalHip-S.fdAmount; R.fdActive=true
    else
        if R.fdOriginalHip then R.myHum.HipHeight=R.fdOriginalHip; R.fdOriginalHip=nil end
        R.fdActive=false
    end
end

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if S.fdEnabled and S.fdMode=="Toggle" and input.KeyCode==S.fdKey then
        fdToggleState=not fdToggleState
    end
end)

-- ══════════════════════════════════════════
--  CHAMS
-- ══════════════════════════════════════════
local chamsMap={}; local weapHL=nil; local rainbowT=0
local STYLE_FILL={Flat={ft=0.5,ot=0.0},Neon={ft=0.25,ot=0.0},Outlined={ft=1.0,ot=0.0},Glass={ft=0.7,ot=0.2},Rainbow={ft=0.35,ot=0.0}}

local function removeChams(char)
    if chamsMap[char] then pcall(function() chamsMap[char]:Destroy() end); chamsMap[char]=nil end
end

local function applyChams(char,fillC,outC,transp,style,wall)
    removeChams(char)
    pcall(function()
        local cfg=STYLE_FILL[style] or STYLE_FILL.Flat
        local hl=Instance.new("Highlight")
        hl.Adornee=char; hl.FillColor=fillC; hl.OutlineColor=outC
        hl.FillTransparency=math.clamp(cfg.ft+transp/100,0,1)
        hl.OutlineTransparency=cfg.ot
        hl.DepthMode=wall and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        hl.Parent=char; chamsMap[char]=hl
    end)
end

local function updateChams(dt)
    rainbowT=(rainbowT+(dt or 0.05))%1
    local myChar=LP.Character
    if myChar then
        if S.chamsSelfEnabled then
            local fillC=S.chamsSelfColorVis
            if S.chamsSelfStyle=="Rainbow" then fillC=Color3.fromHSV(rainbowT,1,1) end
            applyChams(myChar,fillC,S.chamsSelfColorHid,S.chamsSelfTransp,S.chamsSelfStyle,S.chamsSelfWall)
        else removeChams(myChar) end
    end
    for _,pl in ipairs(Plrs:GetPlayers()) do
        if pl==LP then continue end
        local char=pl.Character; if not char then continue end
        local isTeam=LP.Team~=nil and (pl.Team==LP.Team)
        if isTeam and S.chamsTeamEnabled then
            local fillC=S.chamsTeamColorVis
            if S.chamsTeamStyle=="Rainbow" then fillC=Color3.fromHSV((rainbowT+0.33)%1,1,1) end
            applyChams(char,fillC,S.chamsTeamColorHid,S.chamsTeamTransp,S.chamsTeamStyle,S.chamsTeamWall)
        elseif not isTeam and S.chamsEnemyEnabled then
            local fillC=S.chamsEnemyColorVis
            if S.chamsEnemyHPColor then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                if hum2 then local hp=math.clamp(hum2.Health/math.max(hum2.MaxHealth,1),0,1); fillC=Color3.fromRGB(math.floor((1-hp)*255),math.floor(hp*200),0) end
            end
            if S.chamsEnemyStyle=="Rainbow" then fillC=Color3.fromHSV((rainbowT+0.66)%1,1,1) end
            applyChams(char,fillC,S.chamsEnemyColorHid,S.chamsEnemyTransp,S.chamsEnemyStyle,S.chamsEnemyWall)
        else removeChams(char) end
    end
    if weapHL then pcall(function() weapHL:Destroy() end); weapHL=nil end
    if S.chamsWeaponEnabled and myChar then
        local tool=myChar:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                local cfg=STYLE_FILL[S.chamsWeaponStyle] or STYLE_FILL.Neon
                local color=S.chamsWeaponColor
                if S.chamsWeaponRainbow then color=Color3.fromHSV(rainbowT,1,1) end
                local hl=Instance.new("Highlight")
                hl.Adornee=tool; hl.FillColor=color; hl.OutlineColor=Color3.new(1,1,1)
                hl.FillTransparency=math.clamp(cfg.ft+S.chamsWeaponTransp/100,0,1)
                hl.OutlineTransparency=0.4; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent=tool; weapHL=hl
            end)
        end
    end
end

-- ══════════════════════════════════════════
--  WORLD COLOR / SKYBOX
-- ══════════════════════════════════════════
local origAmb,origOut,origBri,origFS,origFE,origFC
pcall(function()
    origAmb=Lighting.Ambient; origOut=Lighting.OutdoorAmbient; origBri=Lighting.Brightness
    origFS=Lighting.FogStart; origFE=Lighting.FogEnd; origFC=Lighting.FogColor
end)
local wcActive=false

local SKYBOX_IDS={
    ["Night City"]={Stars=3000},Arctic={Stars=500},["Deep Space"]={Stars=7000},
    Sunset={Stars=300},Stormy={Stars=0},Dawn={Stars=200},["Neon Night"]={Stars=5000},
}
local origSky=Lighting:FindFirstChildWhichIsA("Sky")
local customSky,lastSkyPreset=nil,nil

local function applySkybox(name)
    pcall(function()
        if customSky then customSky:Destroy(); customSky=nil end
        local ex=Lighting:FindFirstChildWhichIsA("Sky"); if ex then ex.Parent=nil end
        local cfg=SKYBOX_IDS[name] or {Stars=3000}
        local sky=Instance.new("Sky"); sky.StarCount=cfg.Stars or 3000
        sky.Parent=Lighting; customSky=sky
    end)
end
local function removeSkybox()
    pcall(function() if customSky then customSky:Destroy(); customSky=nil end; if origSky then origSky.Parent=Lighting end end)
    lastSkyPreset=nil
end

-- ══════════════════════════════════════════
--  VELOCITY HISTORY UPDATE
-- ══════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(0.05)
        for _, pl in ipairs(Plrs:GetPlayers()) do
            if pl == LP then continue end
            local char = pl.Character; if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then recordVelocity(pl, hrp.AssemblyLinearVelocity) end
        end
    end
end)

Plrs.PlayerRemoving:Connect(function(pl) velocityHistory[pl] = nil end)

-- ══════════════════════════════════════════
--  ГЛАВНЫЙ ЦИКЛ
-- ══════════════════════════════════════════
local frame = 0
RS.Heartbeat:Connect(function()
    frame=(frame%1000)+1
    if frame%8==0 then CacheChar() end
    UpdatePlayerData()
    FakeDuck_Update()
    AA_Apply()
    AA_HeadOffset()
    AA_FakeLag_Update()
    AA_AnimDesync_Update()
    if frame%3==0 then
        if S.aaInvisLimbs then AA_InvisLimbs_Apply() end
    end
    if S.aaRemoveHead then AA_RemoveHead_Apply()
    elseif frame%30==0 then AA_RemoveHead_Stop() end
    RB_MainLoop()

    if S.worldColor then
        pcall(function()
            Lighting.Ambient=S.worldAmbient; Lighting.OutdoorAmbient=S.worldOutdoor
            Lighting.Brightness=(S.worldBrightness/100)*2
            Lighting.FogStart=S.worldFogStart; Lighting.FogEnd=S.worldFogEnd; Lighting.FogColor=S.worldFogColor
        end)
        wcActive=true
    elseif wcActive then
        pcall(function()
            if origAmb then Lighting.Ambient=origAmb end; if origOut then Lighting.OutdoorAmbient=origOut end
            if origBri then Lighting.Brightness=origBri end; if origFS then Lighting.FogStart=origFS end
            if origFE  then Lighting.FogEnd=origFE end;     if origFC  then Lighting.FogColor=origFC end
        end)
        wcActive=false
    end
end)

task.spawn(function()
    while true do
        task.wait(0.25)
        if S.skyboxEnabled then
            if S.skyboxPreset~=lastSkyPreset then applySkybox(S.skyboxPreset); lastSkyPreset=S.skyboxPreset end
        elseif lastSkyPreset then removeSkybox() end
        updateChams(0.25)
    end
end)

-- CLEANUP
LP.CharacterRemoving:Connect(function()
    aaOriginalNeckC0=nil; aaOriginalWaistC0=nil; aaOriginalHeadC0=nil
    R.fakeLagPositions={}; R.fakeLagIdx=0; R.fakeLagFrame=0; R.fireShot=nil
    resolverDB={}; fdToggleState=false
    for char in pairs(chamsMap) do removeChams(char) end
    if weapHL then pcall(function() weapHL:Destroy() end); weapHL=nil end
    CacheChar()
end)

LP.CharacterAdded:Connect(function()
    aaOriginalNeckC0=nil; aaOriginalWaistC0=nil; aaOriginalHeadC0=nil
    R.fakeLagPositions={}; R.fakeLagIdx=0; R.fakeLagFrame=0; R.fireShot=nil
    resolverDB={}
    CacheChar()
end)

Plrs.PlayerRemoving:Connect(function(pl)
    if pl.Character then removeChams(pl.Character) end
end)

Library:Notification({Title="MyProject", Description="✔ Loaded! AA + Ragebot + Chams + HitLog + Blackhole", Duration=5, Icon="73789337996373"})
print("[MyProject v2] Loaded! Semi-Pred ON | Blackhole ON | HitLog (my kills only)")
