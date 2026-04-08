

-- Автор: KitRit

-- если ты ребенок шлюхи расшифровал данный скрипт, то я ебал все твое родное, я ебал всю твою семью и все что у тебя только есть. я расчленю каждого члена твоего семьи при первой возможности, я желаю чтобы ты умер в муках. 


local scriptPath = gg.getFile()              
local saveFile = scriptPath .. ".time"       
local expiredFile = scriptPath .. ".expired" 

local LIFETIME = 1000 * 360000 

local function now()
    return os.time()
end


local f = io.open(expiredFile, "r")
if f then
    f:close()
    gg.alert("⏰ Срок действия истёк!\nУстановите новый скрипт из бота.")
    os.exit()
end


local startTime
local file = io.open(saveFile, "r")
if file then
    startTime = tonumber(file:read("*a"))
    file:close()
else
    startTime = now()
    file = io.open(saveFile, "w")
    file:write(startTime)
    file:close()
end


local elapsed = now() - startTime

if elapsed >= LIFETIME then
    
    local ef = io.open(expiredFile, "w")
    ef:write("expired")
    ef:close()

    gg.alert("⏰ Срок действия истёк!\nУстановите новый скрипт из бота.")
    os.exit()
else
    local left = LIFETIME - elapsed
    local hours = math.floor(left / 3600)
    local mins = math.floor((left % 3600) / 60)
    gg.toast("✅ Чит активирован. Осталось: " .. hours .. " ч " .. mins .. " мин")
end



local gg = gg
local info = gg.getTargetInfo()
local pointerType = (info.x64 == true and gg.TYPE_QWORD or gg.TYPE_DWORD)
local pointerOffset = (info.x64 == true and 0x18 or 0xC)
local metadata = gg.getRangesList("libil2cpp.so")
local VOID = (info.x64 == true and "h C0 03 5F D6" or "h 1E FF 2F E1")
local TRUE = (info.x64 == true and "h 20 00 80 D2 C0 03 5F D6" or "h 01 00 A0 E3 1E FF 2F E1")
local FALSE = (info.x64 == true and "h 00 00 80 D2 C0 03 5F D6" or "h 00 00 A0 E3 1E FF 2F E1")
local SAVE = (info.x64 == true and "h")

local GetUnityMethod = function(method, flag)
    local results = {}
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP)
    gg.searchNumber(':' .. method, gg.TYPE_BYTE, false, gg.SIGH_EQUAL, metadata[1]['start'], metadata[#metadata]['end'], 0)
    local count = gg.getResultsCount()
    if (count ~= 0) then
        gg.refineNumber(tonumber(gg.getResults(1)[1].value) .. '', gg.TYPE_BYTE)
        local t = gg.getResults(count)
        gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
        gg.loadResults(t)
        gg.searchPointer(0)
        t = gg.getResults(count)
        for i, v in ipairs(t) do
            v.address = v.address - pointerOffset
            v.flags = pointerType
        end
        t = gg.getValues(t)
        for i, v in ipairs(t) do
            table.insert(results, {
                address = v.value,
                flags = flag
            })
        end
        gg.loadResults(results)
        else
        gg.toast(method .. ' Not Found\nIt Is Possible To Obfuscate The Method')
    end
end


off = " off"
on = " on"

sosadi = off

SSDI = off
SSDI2 = off
SSDI3 = off
SSDI4 = off
SSDI5 = off
SSDI6 = off
SSDI7 = off
SSDI8 = off
SSDI9 = off
SSDI10 = off
SSDI11 = off
SSDI12 = off
SSDI13 = off
SSDI14 = off
SSDI15 = off
SSDI16 = off
SSDI17 = off
SSDI18 = off
SSDI19 = off
SSDI20 = off
SSDI21 = off
SSDI22 = off
SSDI23 = off
SSDI24 = off
SSDI25 = off
SSDI26 = off
SSDI27 = off
SSDI28 = off
SSDI29 = off
SSDI30 = off
SSDI31 = off
SSDI32 = off
SSDI33 = off
SSDI34 = off
SSDI35 = off
SSDI36 = off
SSDI37 = off
SSDI38 = off
SSDI39 = off
SSDI40 = off
SSDI41 = off
SSDI42 = off
SSDI43 = off
SSDI44 = off
SSDI45 = off
SSDI46 = off
SSDI47 = off
SSDI48 = off
SSDI49 = off
SSDI50 = off
SSDI51 = off
SSDI52 = off
SSDI53 = off
SSDI54 = off
SSDI55 = off
SSDI56 = off
SSDI57 = off
SSDI58 = off
SSDI59 = off
SSDI60 = off
SSDI61 = off
SSDI62 = off
SSDI63 = off
SSDI64 = off
SSDI65 = off
SSDI66 = off
SSDI67 = off
SSDI68 = off
SSDI69 = off
SSDI70 = off
SSDI71 = off
SSDI72 = off
SSDI73 = off
SSDI74 = off
SSDI75 = off
SSDI76 = off
SSDI77 = off
SSDI78 = off
SSDI79 = off
SSDI80 = off
SSDI81 = off
SSDI82 = off
SSDI83 = off
SSDI84 = off
SSDI85 = off
SSDI86 = off
SSDI87 = off
SSDI88 = off
SSDI89 = off
SSDI90 = off
SSDI91 = off
SSDI92 = off
SSDI93 = off
SSDI94 = off
SSDI95 = off
SSDI96 = off
SSDI97 = off
SSDI98 = off
SSDI99 = off
SSDI100 = off
SSDI101 = off
SSDI102 = off
SSDI103 = off
SSDI104 = off
SSDI105 = off
SSDI106 = off
SSDI107 = off
SSDI108 = off
SSDI109 = off
SSDI110 = off
SSDI111 = off
SSDI112 = off
SSDI113 = off
SSDI114 = off
SSDI115 = off
SSDI116 = off
SSDI117 = off
SSDI118 = off
SSDI119 = off
SSDI120 = off
SSDI121 = off
SSDI122 = off
SSDI123 = off
SSDI124 = off
SSDI125 = off
SSDI126 = off
SSDI127 = off
SSDI128 = off
SSDI129 = off
SSDI130 = off
SSDI131 = off
SSDI132 = off
SSDI133 = off
SSDI134 = off
SSDI135 = off
SSDI136 = off
SSDI137 = off
SSDI138 = off
SSDI139 = off
SSDI140 = off
SSDI141 = off
SSDI142 = off
SSDI143 = off
SSDI144 = off
SSDI145 = off
SSDI146 = off
SSDI147 = off
SSDI148 = off
SSDI149 = off
SSDI150 = off

local sosi

function Main()
print("sosi exists?", type(sosi) == "function") -- Должно быть true
filst = gg.choice({
"Option : Main", -- 1
"Option : Account", -- 2
"Option : Server", -- 3
"Option : Visual", -- 4
"Option : Weapons", -- 5
"Option : Other", -- 6
"Option : Server Settings", -- 7
"Option : Info Script", -- 9
"Function : Exit"},nil,
"Select Option")
if filst == nil then else
if filst == 1 then giga() end
if filst == 2 then sosi() end
if filst == 3 then ser() end
if filst == 4 then viz() end
if filst == 5 then gun() end
if filst == 6 then oth() end
if filst == 7 then set() end
if filst == 8 then info() end
if filst == 9 then os.exit() end end end


function giga()
filsst3 = gg.multiChoice({
    "Anti kick" .. SSDI,
    "God mode" .. SSDI2,
    "Multimine" .. SSDI3,
    "Crash Text" .. SSDI4,
    "Ownership props" .. SSDI5,
    "Delete All props" .. SSDI6,
    "Unfreeze All props" .. SSDI7,
    "Explode All Vehicles" .. SSDI8,
    "Invisible V2" .. SSDI9,
"Back"
}, nil, "кто прочитал тот гей")

if filsst3 == nil then return end
    if filsst3[1] == true then kick1() end
    if filsst3[2] == true then god1() end
    if filsst3[3] == true then multimine() end
    if filsst3[4] == true then crash1() end
    if filsst3[5] == true then ownProps() end
    if filsst3[6] == true then deleteProps() end
    if filsst3[7] == true then unfreezeProps() end
    if filsst3[8] == true then explodeVehicles() end
    if filsst3[9] == true then invisibleV2() end
    if filsst3[10] == true then Main() end 
	end



function invisibleV2()
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x1638DDC+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x1638DDC+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
end


function explodeVehicles()
local gg = gg;
local info = gg.getTargetInfo();
local LibTable = {};
v = gg.getTargetInfo();
L = v.label;
V = v.versionName;
function isProcess64Bit()
    local regions = gg.getRangesList();
    local lastAddress = regions[#regions]["end"];
    return (lastAddress >> 32) ~= 0;
end
local ISA = isProcess64Bit();
function ISAOffsets()
    if (ISA == false) then
        edi = "+0x";
        ed = "-0x";
    elseif (ISA == true) then
        edi = "0x";
        ed = "-0x";
    end
end
ISAOffsets();
function ISAOffsetss()
    if (ISA == false) then
        edit = "~A B " .. edits;
    elseif (ISA == true) then
        edit = "~A8 B     [PC,#" .. edits .. "]";
    end
end
liby = 1;
libf = 0;
libzz = "libil2cpp.so";
libx = gg.getRangesList("libil2cpp.so");
for i, v in ipairs(libx) do
    if (libx[i].state == "Xa") then
        libz = "libil2cpp.so[" .. liby .. "].start";
        xand = gg.getRangesList("libil2cpp.so")[liby].start;
        libf = 1;
        break;
    end
    liby = liby + 1;
end
if (libf == 0) then
    liby = 1;
    libzz = "libUE4.so";
    libx = gg.getRangesList("libUE4.so");
    for i, v in ipairs(libx) do
        if (libx[i].state == "Xa") then
            libz = "libUE4.so[" .. liby .. "].start";
            xand = gg.getRangesList("libUE4.so")[liby].start;
            libf = 1;
            break;
        end
        liby = liby + 1;
    end
end
lib = xand;
local sf = string.format;
function tohex(Data)
    if (type(Data) == "number") then
        return sf("0x%08X", Data);
    end
    return Data:gsub(".", function(a)
        return string.format("%02X", (string.byte(a)));
    end):gsub(" ", "");
end
function __()
    xHEX = string.format("%X", aaaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = edi .. xHEX;
    ISAOffsetss();
end
function _()
    aaa = b - a;
    xHEX = string.format("%X", aaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = ed .. xHEX;
    ISAOffsetss();
end
function hook_void(cc, bb)
    LibStart = lib;
    local m = {};
    m[1] = {address=(LibStart + bb),flags=gg.TYPE_DWORD};
    gg.addListItems(m);
    a = m[1].address;
    gg.clearList();
    local p = {};
    p[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(p);
    gg.loadResults(p);
    endhook = gg.getResults(1);
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(n);
    b = n[1].address;
    gg.clearResults();
    gg.clearList();
    aaaa = a - b;
    if (tonumber(aaaa) < 0) then
        _();
    end
    if (tonumber(aaaa) > 0) then
        __();
    end
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD,value=edit,freeze=true};
    gg.addListItems(n);
    gg.clearList();
end

local void1=0x3C6B18 --Апдейт
local void2=0x3C7A60 --Метод вызова
hook_void(void1,void2)
end



function unfreezeProps()
if SSDI7 == off then
      SSDI7 = on
gg.clearResults()
GetUnityMethod("isKinematic", 4)
gg.getResults(gg.getResultsCount())
gg.editAll(VOID, 4)
gg.clearResults()
else if SSDI7 == on then
      SSDI7 = off
endhook(0x37D4E0, 1)
      gg.toast("Deactivated")
      end
end
end


function deleteProps()
local gg = gg;
local info = gg.getTargetInfo();
local LibTable = {};
v = gg.getTargetInfo();
L = v.label;
V = v.versionName;
function isProcess64Bit()
    local regions = gg.getRangesList();
    local lastAddress = regions[#regions]["end"];
    return (lastAddress >> 32) ~= 0;
end
local ISA = isProcess64Bit();
function ISAOffsets()
    if (ISA == false) then
        edi = "+0x";
        ed = "-0x";
    elseif (ISA == true) then
        edi = "0x";
        ed = "-0x";
    end
end
ISAOffsets();
function ISAOffsetss()
    if (ISA == false) then
        edit = "~A B " .. edits;
    elseif (ISA == true) then
        edit = "~A8 B     [PC,#" .. edits .. "]";
    end
end
liby = 1;
libf = 0;
libzz = "libil2cpp.so";
libx = gg.getRangesList("libil2cpp.so");
for i, v in ipairs(libx) do
    if (libx[i].state == "Xa") then
        libz = "libil2cpp.so[" .. liby .. "].start";
        xand = gg.getRangesList("libil2cpp.so")[liby].start;
        libf = 1;
        break;
    end
    liby = liby + 1;
end
if (libf == 0) then
    liby = 1;
    libzz = "libUE4.so";
    libx = gg.getRangesList("libUE4.so");
    for i, v in ipairs(libx) do
        if (libx[i].state == "Xa") then
            libz = "libUE4.so[" .. liby .. "].start";
            xand = gg.getRangesList("libUE4.so")[liby].start;
            libf = 1;
            break;
        end
        liby = liby + 1;
    end
end
lib = xand;
local sf = string.format;
function tohex(Data)
    if (type(Data) == "number") then
        return sf("0x%08X", Data);
    end
    return Data:gsub(".", function(a)
        return string.format("%02X", (string.byte(a)));
    end):gsub(" ", "");
end
function __()
    xHEX = string.format("%X", aaaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = edi .. xHEX;
    ISAOffsetss();
end
function _()
    aaa = b - a;
    xHEX = string.format("%X", aaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = ed .. xHEX;
    ISAOffsetss();
end
function hook_void(cc, bb)
    LibStart = lib;
    local m = {};
    m[1] = {address=(LibStart + bb),flags=gg.TYPE_DWORD};
    gg.addListItems(m);
    a = m[1].address;
    gg.clearList();
    local p = {};
    p[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(p);
    gg.loadResults(p);
    endhook = gg.getResults(1);
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(n);
    b = n[1].address;
    gg.clearResults();
    gg.clearList();
    aaaa = a - b;
    if (tonumber(aaaa) < 0) then
        _();
    end
    if (tonumber(aaaa) > 0) then
        __();
    end
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD,value=edit,freeze=true};
    gg.addListItems(n);
    gg.clearList();
end

local void1=0x3A6C70 --Апдейт
local void2=0x3A72AC --Метод вызова
hook_void(void1,void2)
end

function ownProps()
local gg = gg;
local info = gg.getTargetInfo();
local LibTable = {};
v = gg.getTargetInfo();
L = v.label;
V = v.versionName;
function isProcess64Bit()
    local regions = gg.getRangesList();
    local lastAddress = regions[#regions]["end"];
    return (lastAddress >> 32) ~= 0;
end
local ISA = isProcess64Bit();
function ISAOffsets()
    if (ISA == false) then
        edi = "+0x";
        ed = "-0x";
    elseif (ISA == true) then
        edi = "0x";
        ed = "-0x";
    end
end
ISAOffsets();
function ISAOffsetss()
    if (ISA == false) then
        edit = "~A B " .. edits;
    elseif (ISA == true) then
        edit = "~A8 B     [PC,#" .. edits .. "]";
    end
end
liby = 1;
libf = 0;
libzz = "libil2cpp.so";
libx = gg.getRangesList("libil2cpp.so");
for i, v in ipairs(libx) do
    if (libx[i].state == "Xa") then
        libz = "libil2cpp.so[" .. liby .. "].start";
        xand = gg.getRangesList("libil2cpp.so")[liby].start;
        libf = 1;
        break;
    end
    liby = liby + 1;
end
if (libf == 0) then
    liby = 1;
    libzz = "libUE4.so";
    libx = gg.getRangesList("libUE4.so");
    for i, v in ipairs(libx) do
        if (libx[i].state == "Xa") then
            libz = "libUE4.so[" .. liby .. "].start";
            xand = gg.getRangesList("libUE4.so")[liby].start;
            libf = 1;
            break;
        end
        liby = liby + 1;
    end
end
lib = xand;
local sf = string.format;
function tohex(Data)
    if (type(Data) == "number") then
        return sf("0x%08X", Data);
    end
    return Data:gsub(".", function(a)
        return string.format("%02X", (string.byte(a)));
    end):gsub(" ", "");
end
function __()
    xHEX = string.format("%X", aaaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = edi .. xHEX;
    ISAOffsetss();
end
function _()
    aaa = b - a;
    xHEX = string.format("%X", aaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = ed .. xHEX;
    ISAOffsetss();
end
function hook_void(cc, bb)
    LibStart = lib;
    local m = {};
    m[1] = {address=(LibStart + bb),flags=gg.TYPE_DWORD};
    gg.addListItems(m);
    a = m[1].address;
    gg.clearList();
    local p = {};
    p[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(p);
    gg.loadResults(p);
    endhook = gg.getResults(1);
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(n);
    b = n[1].address;
    gg.clearResults();
    gg.clearList();
    aaaa = a - b;
    if (tonumber(aaaa) < 0) then
        _();
    end
    if (tonumber(aaaa) > 0) then
        __();
    end
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD,value=edit,freeze=true};
    gg.addListItems(n);
    gg.clearList();
end

local void1=0x3A6C70 --Апдейт
local void2=0x3A7268 --Метод вызова
hook_void(void1,void2)
end

function kick1()
if SSDI == off then
      SSDI = on
gg.clearResults()
GetUnityMethod("LeaveRoom", 4)
gg.getResults(gg.getResultsCount())
gg.editAll(VOID, 4)
gg.clearResults()
      gg.toast("Activated")
else if SSDI == on then
      SSDI = off
      reset(0x11FDD08)
      gg.toast("Deactivated")
      end
end
end

function god1()
if SSDI2 == off then
      SSDI2 = on
gg.clearResults()
GetUnityMethod("TakeDamageLocal", 4)
gg.getResults(gg.getResultsCount())
gg.editAll(VOID, 4)
gg.clearResults()
      gg.toast("Activated")
else if SSDI2 == on then
      SSDI2 = off
      gg.clearResults()
  reset(0x37172C)
      gg.toast("Deactivated")
      end
end
end

function multimine()
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x37D1EC+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x37D1EC+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
end

function crash1()
if sosadi == off then
    sosadi = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
if SSDI4 == off then
      SSDI4 = on
gg.copyText("<quad size=-99999999 width=991111199999>")
gg.searchNumber(":<color=red", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":сосухомеру", gg.TYPE_BYTE)
gg.clearResults()

gg.searchNumber(";<color=red", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";сосухомеру", gg.TYPE_WORD)
gg.clearResults()
gg.alert("вставь скопированный текст в чат. Всех крашнет а тебя нет. У тебя пропадет чат. Потом когда ливнешь с сервера нажми еще раз на функцию чтобы отключить ее.")
      gg.toast("Activated")
else if SSDI4 == on then
      SSDI4 = off
	  g.searchNumber(":сосухомеру", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":<color=red", gg.TYPE_BYTE)
gg.clearResults()

gg.searchNumber(";сосухомеру", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";<color=red", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end
end




function sosi()
filsst4 = gg.multiChoice({
    "No Ads" .. SSDI10,
    "Infinity Nick•" .. SSDI11,
    "Color Text" .. SSDI12,
    "Corpse Skin" .. SSDI13,
    "Butcher Skin" .. SSDI14,
    "Swat Skin" .. SSDI15,
    "Wizart Hat" .. SSDI16,
    "Santa Hat" .. SSDI17,
    "Backflip Anim" .. SSDI18,
    "Flair Anim" .. SSDI19,
	"No Password" .. SSDI20,
	"Украсть Карту Adventure" .. SSDI21,
    "Back"
},nil, "абоба соснул хуец")
if filsst4 == nil then return end
    if filsst4[1] == true then NoAds() end
    if filsst4[2] == true then InfNick() end
    if filsst4[3] == true then ColorText() end
    if filsst4[4] == true then CorpseSkin() end
    if filsst4[5] == true then ButcherSkin() end
    if filsst4[6] == true then SwatSkin() end
    if filsst4[7] == true then WizartHat() end
    if filsst4[8] == true then SantaHat() end
    if filsst4[9] == true then BackflipAnim() end
    if filsst4[10] == true then FlairAnim() end
    if filsst4[11] == true then NoPassword() end
    if filsst4[12] == true then StealAdventureMap() end
    if filsst4[13] == true then Main() end
	end

function StealAdventureMap()
if SSDI21 == off then
      SSDI21 = on
	  gg.alert("врубите функцию перед заходом на сервер, затем зайдите и сохраните карту. Отключите функцию и выйдите в меню.")
gg.searchNumber(";GameMode", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";kingpidr", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI21 == on then
      SSDI21 = off
	  gg.searchNumber(";kingpidr", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Password", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function NoPassword()
if SSDI20 == off then
      SSDI20 = on
gg.searchNumber(";Password", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";sosihaho", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI20 == on then
      SSDI20 = off
	  gg.searchNumber(";sosihaho", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Password", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function FlairAnim()
if SSDI19 == off then
      SSDI19 = on
gg.searchNumber(";Twerk", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Flair", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI19 == on then
      SSDI19 = off
	  gg.searchNumber(";Flair", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Twerk", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function BackflipAnim()
if SSDI18 == off then
      SSDI18 = on
gg.searchNumber(";Disagree", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Backflip", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI18 == on then
      SSDI18 = off
	  gg.searchNumber(";Backflip", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Disagree", gg.TYPE_WORD)
      gg.toast("Deactivated")
      end
end
end


function SantaHat()
if SSDI17 == off then
      SSDI17 = on
gg.searchNumber(";Debug", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Santa", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI17 == on then
      SSDI17 = off
	  gg.searchNumber(";Santa", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Debug", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function WizartHat()
if SSDI16 == off then
      SSDI16 = on
	  gg.toast("Hetmet Edit")
gg.searchNumber(";Helmet", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Wizard", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI16 == on then
      SSDI16 = off
	  gg.searchNumber(";Wizard", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Helmet", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function SwatSkin()
if SSDI15 == off then
      SSDI15 = on
	  gg.toast("Jean Skin Edit, Can choice hat")
gg.searchNumber(";Jean", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Swat", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI15 == on then
      SSDI16 = off
	  gg.searchNumber(";Swat", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Jean", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function ButcherSkin()
if SSDI14 == off then
      SSDI14 = on
	  gg.toast("Soldier Skin Edit, Can choice hat")
gg.searchNumber(";Soldier", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Butcher", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI14 == on then
      SSDI14 = off
	 gg.searchNumber(";Butcher", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Soldier", gg.TYPE_WORD)
gg.clearResults() 
      gg.toast("Deactivated")
      end
end
end


function CorpseSkin()
if SSDI13 == off then
      SSDI13 = on
--оыоа
      gg.toast("Activated")
else if SSDI13 == on then
      SSDI13 = off
      gg.toast("Deactivated")
      end
end
end


function ColorText()
if SSDI12 == off then
      SSDI12 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI12 == on then
      SSDI12 = off
      gg.toast("ты далбаеб")
      end
end
end

function InfNick()
SSDI11 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.clearResults()
gg.clearResults()
gg.setRanges(32)
gg.searchNumber(5357803930, gg.TYPE_QWORD)
HackersHouse = gg.getResults(250000)
Offsets = {}
Offsets['FirstOffset'] = {}
Offsets['SecondOffset'] = {}
Offsets['FinalResults'] = {}
OffsetsIndex = 1
for index, value in ipairs(HackersHouse) do
 Offsets['FirstOffset'][OffsetsIndex] = {}
 Offsets['FirstOffset'][OffsetsIndex].address = HackersHouse[index].address + -16
 Offsets['FirstOffset'][OffsetsIndex].flags = gg.TYPE_QWORD
 Offsets['SecondOffset'][OffsetsIndex] = {}
 Offsets['SecondOffset'][OffsetsIndex].address = HackersHouse[index].address + -28
 Offsets['SecondOffset'][OffsetsIndex].flags = gg.TYPE_QWORD OffsetsIndex = OffsetsIndex + 1
end
Offsets['FirstOffset'] = gg.getValues(Offsets['FirstOffset'])
Offsets['SecondOffset'] = gg.getValues(Offsets['SecondOffset'])
OffsetsIndex = 1
for index, value in ipairs(Offsets['FirstOffset']) do
 if (Offsets['FirstOffset'][index].value == 1061208257) and (Offsets['SecondOffset'][index].value == 4561810862086072489) then
  Offsets['FinalResults'][OffsetsIndex] = {}
  Offsets['FinalResults'][OffsetsIndex] =  Offsets['FirstOffset'][index]
  OffsetsIndex = OffsetsIndex + 1
 end
end
for index, value in ipairs(Offsets['FinalResults']) do
 Offsets['FinalResults'][index].address = Offsets['FinalResults'][index].address + -68
 Offsets['FinalResults'][index].flags = 4
end
gg.loadResults(Offsets['FinalResults'])
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999999", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
end



function NoAds()
    local _={
        ["8573629"] = gg,
        ["4928371"] = gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP,
        ["7293846"] = gg.TYPE_BYTE,
        ["3648295"] = gg.TYPE_DWORD,
        ["1837462"] = gg.TYPE_QWORD,
        ["6382917"] = "ShowInterstitial",
        ["9273648"] = "h C0 03 5F D6",
        ["4827365"] = "h 1E FF 2F E1"
    }
    
    local info = _["8573629"].getTargetInfo()
    local is64 = info.x64
    local pType = is64 and _["1837462"] or _["3648295"]
    local pOffset = is64 and 0x18 or 0xC
    local ranges = _["8573629"].getRangesList("libil2cpp.so")
    local VOID = is64 and _["9273648"] or _["4827365"]

    local function FindMethod(method, flag)
        _["8573629"].clearResults()
        _["8573629"].setRanges(_["4928371"])
        local startAddr = ranges[1].start
        local endAddr = ranges[#ranges]['end']
        _["8573629"].searchNumber(':'..method, _["7293846"], false, _["3648295"], startAddr, endAddr)
        
        if _["8573629"].getResultsCount() == 0 then
            gg.toast(method..' not found')
            return
        end
        
        _["8573629"].refineNumber(tostring(_["8573629"].getResults(1)[1].value), _["7293846"])
        local t = _["8573629"].getResults(_["8573629"].getResultsCount())
        _["8573629"].setRanges(_["4928371"])
        _["8573629"].loadResults(t)
        _["8573629"].searchPointer(0)
        
        t = _["8573629"].getResults(_["8573629"].getResultsCount())
        for i,v in ipairs(t) do 
            v.address = v.address - pOffset 
            v.flags = pType 
        end
        t = _["8573629"].getValues(t)
        
        local results = {}
        for i,v in ipairs(t) do results[i] = {address = v.value, flags = flag} end
        _["8573629"].loadResults(results)
    end

    FindMethod(_["6382917"], _["3648295"])
    _["8573629"].getResults(_["8573629"].getResultsCount())
    _["8573629"].editAll(VOID, _["3648295"])
    _["8573629"].clearResults()
    gg.toast("Ａｃｔｉｖａｔｅｄ!")
end



function ser()
local filsst5 = gg.multiChoice({
    "Fly" .. SSDI22,
    "Noclip" .. SSDI23,
    "Jump Fly" .. SSDI24,
    "Anti Repulsor" .. SSDI25,
    "Anti Glith Polar Parher" .. SSDI26,
    "Anti Crash LogicGate" .. SSDI27,
    "No Collision Prop" .. SSDI28,
    "Speed Hack" .. SSDI29,
    "Zero Gravity Prop" .. SSDI30,
    "Spawn Object" .. SSDI31,
    "Crash ToolBaton•" .. SSDI32,
    "Player Gravity" .. SSDI33,
    "Avatar Edit" .. SSDI34,
	"Air Walk" .. SSDI35,
	"Double Jump" .. SSDI140,
    "Back"
}, nil, "если кал не работает я выпилюсь")

if filsst5 == nil then return end
if filsst5[1] then fly() end
if filsst5[2] then noclip() end
if filsst5[3] then jumpFly() end
if filsst5[4] then antiRepulsor() end
if filsst5[5] then antiCrashPP() end
if filsst5[6] then antiCrashLogicGate() end
if filsst5[7] then noCollisionProp() end
if filsst5[8] then speedHackMenu() end
if filsst5[9] then zeroGravityProp() end
if filsst5[10] then spawnObject() end
if filsst5[11] then crashToolBaton() end
if filsst5[12] then playerGravity() end
if filsst5[13] then avatarEdit() end
if filsst5[14] then AirWalk() end
if filsst5[15] then DoJump() end
if filsst5[16] then Main() end
end

function DoJump()
    local _={
        ["8392591"] = gg,
        ["4728163"] = gg.REGION_ANONYMOUS,
        ["1856342"] = gg.TYPE_BYTE,
        ["6937254"] = gg.SIGN_EQUAL,
        ["3274891"] = "h C3 F5 1C C1 00 00 00 00 CD CC 8C 3F 00 00 80 3F CD CC 4C 3E",
        ["5489126"] = "h C3 F5 1C C1 00 00 00 00 66 66 06 40 00 00 80 3F CD CC 4C 3E"
    }
    
    if S1 == off then
        S1 = on
        _["8392591"].setRanges(_["4728163"])
        _["8392591"].searchNumber(_["3274891"], _["1856342"], false, _["6937254"], 0, -1, 0)
        revert1 = _["8392591"].getResults(99999)
        _["8392591"].editAll(_["5489126"], _["1856342"])
        _["8392591"].clearResults()
        gg.toast("Ａｃｔｉｖａｔｅｄ!")
    else
        S1 = off
        _["8392591"].setRanges(_["4728163"])
        _["8392591"].searchNumber(_["5489126"], _["1856342"], false, _["6937254"], 0, -1, 0)
        revert1 = _["8392591"].getResults(99999)
        _["8392591"].editAll(_["3274891"], _["1856342"])
        _["8392591"].clearResults()
        gg.toast("Ｄｅａｃｔｉｖａｔｅｄ!")
    end
end

function WizardHat()
    local _={
        ["6298471"] = gg,
        ["3847265"] = gg.TYPE_WORD,
        ["9273648"] = gg.SIGN_EQUAL,
        ["7462953"] = ";Police",
        ["5184736"] = ";Wizard"
    }
    
    if S2 == off then
        S2 = on
        _["6298471"].searchNumber(_["7462953"], _["3847265"], false, _["9273648"], 0, -1, 0)
        revert1 = _["6298471"].getResults(99999)
        _["6298471"].editAll(_["5184736"], _["3847265"])
        _["6298471"].clearResults()
        gg.toast("Ａｃｔｉｖａｔｅｄ!")
    else
        S2 = off
        _["6298471"].searchNumber(_["5184736"], _["3847265"], false, _["9273648"], 0, -1, 0)
        revert1 = _["6298471"].getResults(99999)
        _["6298471"].editAll(_["7462953"], _["3847265"])
        _["6298471"].clearResults()
        gg.toast("Ｄｅａｃｔｉｖａｔｅｄ!")
    end
end

function AirWalk()
    SSDI35 = on
gg.searchNumber("-9.81", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(50000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
end

function avatarEdit()
      SSDI34 = on
PR = gg.prompt({
    "<Hero","<Начо менять (впишите любой проп на 4 буквы)"}, {";Hero",nil}, {"number","number"})
if PR == nil then gg.alert("<Nothing.........") else
    gg.searchNumber(PR[1], gg.TYPE_WORD)
gg.getResults(100000)
gg.editAll(PR[2], gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
	  end
end


function playerGravity()
SSDI33 = on
GR = gg.prompt({
    "<Твоя гравитация","<Начо менять"}, {"-9.81000041962",nil}, {"number","number"})
if GR == nil then gg.alert("<Nothing.........") else
    gg.searchNumber(GR[1], gg.TYPE_FLOAT)
gg.getResults(100000)
gg.editAll(GR[2], gg.TYPE_FLOAT)
gg.clearResults()
end
end

function crashToolBaton()
if SSDI32 == off then
      SSDI32 = on
gg.alert("после загрузки поставь дубликатом клумбу/камень под жертвой") 
gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("3 239 900 611;4 776 067 405 843 781 386;", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("-1", gg.TYPE_QWORD)
  gg.clearResults()
  gg.toast("Activated") 
else if SSDI32 == on then
      SSDI32 = off
	  gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0;4 776 067 405 843 781 386;", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("3 239 900 611", gg.TYPE_QWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function spawnObject()
if SSDI31 == off then
      SSDI31 = on
gg.searchNumber(";DisableSpawnObject", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";KitRithaholopitek", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI31 == on then
      SSDI31 = off
	  gg.searchNumber(";KitRithaholopitek", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";DisablespawnObject", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function zeroGravityProp()
if SSDI30 == off then
      SSDI30 = on
gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("3 239 900 611;4 776 067 405 843 781 386;", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI30 == on then
      SSDI30 = off
	  gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0;4 776 067 405 843 781 386;", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("3 239 900 611", gg.TYPE_QWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function speedHackMenu()
SSDI29 = on
speedcum = gg.choice({
"x2 speed",
"x5 speed",
"x10 speed",
"x100 speed",
"Back"},nil,
"Hypper 0.4.9.9")
if speedcum == nil then else
if speedcum == 1 then x2() end
if speedcum == 2 then x5() end
if speedcum == 3 then x10() end
if speedcum == 3 then x100() end
if speedcum == 4 then ser() end end end

function x2()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
gg.clearResults()
end

function x5()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
gg.clearResults()
end

function x10()
--пасиба кошаку
gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("4515609228873826304Q;4392630932057270955Q", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
        gg.editAll("4515609228892700672", gg.TYPE_QWORD)
        gg.clearResults()
end

function x100()
gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_CODE_APP)
        gg.searchNumber("4515609228873826304Q;4392630932057270955Q", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
        gg.editAll("4 515 609 228 894 797 824", gg.TYPE_QWORD)
        gg.clearResults()
		end
		
function noCollisionProp()
if SSDI28 == off then
      SSDI28 = on
gg.searchNumber("-10X4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.processResume()
  gg.refineNumber("-10X8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.processResume()
  revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("10", gg.TYPE_FLOAT)
  gg.processResume()
  gg.clearResults()
      gg.toast("Activated")
else if SSDI28 == on then
      SSDI28 = off
      gg.toast("выйди и зайди на серв далбаеб")
      end
end
end

function antiCrashLogicGate()
if SSDI27 == off then
      SSDI27 = on
gg.toast("Function is Premium, Discord: xomer2, ssdishnik")
      gg.toast("Activated")
else if SSDI27 == on then
      SSDI27 = off
gg.toast("Function is Premium, Discord: xomer2, ssdishnik")
      end
end
end

function antiCrashPP()
      SSDI26 = on
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x11C4984+0
APEX[1].value='D2800000h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x11C4984+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
      gg.toast("Activated")
end

function antiRepulsor()
if SSDI25 == off then
      SSDI25 = on
gg.toast("Function is Premium, Discord: xomer2, ssdishnik")
else if SSDI25 == on then
      SSDI25 = off
gg.toast("Function is Premium, Discord: xomer2, ssdishnik")
      end
end
end

function jumpFly()

      SSDI24 = on
gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("hCDCC8C3F0000803FCDCC4C3E0000A040", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert1 = gg.getResults(99999)
    gg.editAll("hA66FA56A0000803FCDCC4C3E0000A040", gg.TYPE_BYTE)
    gg.clearResults()
    end

function noclip()
SSDI23 = on
gg.searchNumberSmart(40.0)  
gg.editAllSmart(150.0)    
gg.clearResults()
      gg.toast("Activated")
      end

function fly()
SSDI22 = on
 gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("16 777 472", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("0", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("-10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("999", gg.TYPE_FLOAT)
  gg.clearResults()
      gg.toast("Activated")
end


function viz()
filsst4 = gg.multiChoice({
    "FOV" .. SSDI36,
    "Convulsions" .. SSDI37,
    "Free Camera" .. SSDI38,
    "Rainbow Chams (V1)" .. SSDI39,
    "Rainbow Chams (V2)" .. SSDI40,
    "Giga Chams (top)" .. SSDI41,
    "Red" .. SSDI42,
    "Green" .. SSDI43,
    "Blue" .. SSDI44,
    "Blue Neon" .. SSDI45,
    "Green Neon" .. SSDI46,
    "Green+Violet" .. SSDI47,
    "Green+Violet Neon" .. SSDI48,
    "Green+Violet Fast" .. SSDI49,
    "Partially Blue" .. SSDI50,
    "Чамсы ссди" .. SSDI51,
    "Дефолт Чамси" .. SSDI52,
    "Back"
}, nil, "топка чамсы")

if filsst4 == nil then return end
    if filsst4[1] == true then FOV() end
    if filsst4[2] == true then Convulsions() end
    if filsst4[3] == true then FreeCamera() end
    if filsst4[4] == true then RainbowChamsV1() end
    if filsst4[5] == true then RainbowChamsV2() end
    if filsst4[6] == true then GigaChams() end
    if filsst4[7] == true then RedChams() end
    if filsst4[8] == true then GreenChams() end
    if filsst4[9] == true then BlueChams() end
    if filsst4[10] == true then BlueNeon() end
    if filsst4[11] == true then GreenNeon() end
    if filsst4[12] == true then GreenViolet() end
    if filsst4[13] == true then GreenVioletNeon() end
    if filsst4[14] == true then GreenVioletFast() end
    if filsst4[15] == true then PartiallyBlue() end
    if filsst4[16] == true then Chamsssdi() end
	if filsst4[17] == true then Chamshahol() end
    if filsst4[18] == true then Main() end
end

function Chamshahol()
if SSDI52 == off then
      SSDI52 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('1073741897', gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741899',gg.TYPE_DWORD)
      gg.toast("Activated")
else if SSDI52 == on then
      SSDI52 = off
      gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('1073741899', gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741897',gg.TYPE_DWORD)
      gg.toast("Deactivated")
      end
end
end


function Chamsssdi()
if SSDI51 == off then
      SSDI51 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741897", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI51 == on then
      SSDI51 = off
	gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741897", gg.TYPE_DWORD)
gg.clearResults()gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741897", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function PartiallyBlue()
if SSDI50 == off then
      SSDI50 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741899", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI50 == on then
      SSDI50 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741897", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end



function GreenVioletFast()
if SSDI49 == off then
      SSDI49 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741903', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI49 == on then
      SSDI49 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741893', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end



function GreenVioletNeon()
if SSDI48 == off then
      SSDI48 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741903", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI48 == on then
      SSDI48 = off
	 gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.refineNumber("1073741903", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741896", gg.TYPE_DWORD)
gg.clearResults() 
      gg.toast("Deactivated")
      end
end
end



function GreenViolet()
if SSDI47 == off then
      SSDI47 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741902", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI47 == on then
      SSDI47 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741902", gg.TYPE_DWORD)
gg.refineNumber("1073741902", gg.TYPE_DWORD)
gg.refineNumber("1073741902", gg.TYPE_DWORD)
gg.refineNumber("1073741902", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741893" , gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function GreenNeon()
if SSDI46 == off then
      SSDI46 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741899", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI46 == on then
      SSDI46 = off
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.refineNumber("1073741899", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741896", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function BlueNeon()
if SSDI45 == off then
      SSDI45 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1 073 741 862", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI45 == on then
      SSDI45 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1 073 741 862", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 073 741 862", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 073 741 862", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 073 741 862", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 073 741 862", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741898", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function BlueChams()
if SSDI44 == off then
      SSDI44 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741900", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI44 == on then
      SSDI44 = off
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741894", gg.TYPE_DWORD)
gg.clearResults()  
      gg.toast("Deactivated")
      end
end
end

function GreenChams()
if SSDI43 == off then
      SSDI43 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741904', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI43 == on then
      SSDI43 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741904", gg.TYPE_DWORD)
gg.refineNumber("1073741904", gg.TYPE_DWORD)
gg.refineNumber("1073741904", gg.TYPE_DWORD)
gg.refineNumber("1073741904", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741893', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function RedChams()
if SSDI42 == off then
      SSDI42 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741900", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI42 == on then
      SSDI42 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.refineNumber("1073741900", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741895", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function GigaChams()
if SSDI41 == off then
      SSDI41 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1;3;4;257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if SSDI41 == on then
      gg.toast("Not Deactivated")
      end
end
end

function RainbowChamsV2()
if SSDI40 == off then
      SSDI40 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741902", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI40 == on then
      SSDI40 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741902", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741902", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741898", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function RainbowChamsV1()
if SSDI39 == off then
      SSDI39 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741901", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI39 == on then
      SSDI39 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741901", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741901", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741898", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function FreeCamera()
SSDI38 = on
frcam = gg.choice({
"𐂡 1",
"𐂡 2",
"𐂡 3",
"Back"},nil,
"Hypper 0.4.9.9")
if frcam == nil then else
if frcam == 1 then fre1() end
if frcam == 2 then fre2() end
if frcam == 3 then fre3() end
if frcam == 4 then viz() end end end

function fre1()
gg.processPause()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.clearResults()
gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("16 777 472", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("-10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("999", gg.TYPE_FLOAT)
gg.processResume()
end

function fre2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.clearResults()
gg.searchNumber('0.71239751577',  gg.TYPE_FLOAT)
gg.getResults(90000)
gg.editAll('3000', gg.TYPE_FLOAT)
end

function fre3()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.clearResults()
gg.searchNumber('0.72000002861', gg.TYPE_FLOAT)
gg.getResults(90000)
gg.editAll('-2998', gg.TYPE_FLOAT)
end

function Convulsions()
if SSDI37 == off then
      SSDI37 = on
gg.searchNumber("1.57079637051", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15000", gg.TYPE_FLOAT)
gg.toast("Activated")
      gg.toast("Activated")
else if SSDI37 == on then
      SSDI37 = off
      gg.toast("Not Deactivated")
      end
end
end

function FOV()
SSDI36 = on
  fov = gg.prompt({
    "Вставьте сейчасное значение фова (60 изначально)",
    "Вставьте желаемое значение фова"
  }, {"60", nil}, {"number", "number"})
  if fov == nil then
    gg.alert("Значение не верно или не найдено")
  else
  gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber(fov[1], gg.TYPE_FLOAT)
    gg.getResults(100000)
    gg.editAll(fov[2], gg.TYPE_FLOAT)
    gg.toast("👓FOV активирован")
    gg.clearResults()
  end
end


function gun()
filst11 = gg.choice({
"Gun Mode",
"Give Gun",
"SMG",
"ShotGun",
"Revolver",
"Sniper",
"Akm",
"All Gun Infinity Ammo" .. SSDI101,
"All Gun Rapidfire" .. SSDI102,
"Back"
},nil,
"тута я потратил больше всего времени")
if filst11 == nil then Main() else
if filst11 == 1 then gunammo() end
if filst11 == 2 then gungive() end
if filst11 == 3 then smg() end
if filst11 == 4 then shotgun() end
if filst11 == 5 then revolver() end
if filst11 == 6 then sniper() end
if filst11 == 7 then akm() end
if filst11 == 8 then rapidall() end
if filst11 == 9 then infall() end
if filst11 == 10 then Main() end end end

function infall()
SSDI101 = on
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x395ACC+0
APEX[1].value='5280F460h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x395ACC+4
APEX[2].value='72A00C80h'
APEX[2].flags=4
APEX[3]={}
APEX[3].address=ACKA01+0x395ACC+8
APEX[3].value='D65F03C0h'
APEX[3].flags=4
gg.setValues(APEX)

ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x3CAF4C+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x3CAF4C+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
end

function rapidall()
SSDI102 = on
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x395F40+0
APEX[1].value='5280F460h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x395F40+4
APEX[2].value='72A00C80h'
APEX[2].flags=4
APEX[3]={}
APEX[3].address=ACKA01+0x395F40+8
APEX[3].value='D65F03C0h'
APEX[3].flags=4
gg.setValues(APEX)

ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x1CF93D0+0
APEX[1].value='52880000h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x1CF93D0+4
APEX[2].value='72A88F40h'
APEX[2].flags=4
APEX[3]={}
APEX[3].address=ACKA01+0x1CF93D0+8
APEX[3].value='1E270000h'
APEX[3].flags=4
APEX[4]={}
APEX[4].address=ACKA01+0x1CF93D0+12
APEX[4].value='D65F03C0h'
APEX[4].flags=4
gg.setValues(APEX)
end

function gunammo()
filsst12 = gg.multiChoice({
"SMG&Pistol RPG" .. SSDI53,
"SMG&Pistol Crossbowl" .. SSDI54,
"SMG&Pistol ShotGun" .. SSDI55,
"Give NaN Pistol" .. SSDI56,
"Back"
},nil,
"gigain")
if filsst12 == nil then gun() else
if filsst12[1] == true then smgrpg() end
if filsst12[2] == true then smgbowl() end
if filsst12[3] == true then smgshot() end
if filsst12[4] == true then nanpisun() end
if filsst12[5] == true then gun() end end end

function smgrpg()
if SSDI53 == off then
      SSDI53 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("3", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI53 == on then
      SSDI53 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;3D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("3", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function smgbowl()
if SSDI54 == off then
      SSDI54 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI54 == on then
      SSDI54 = off
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;4D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("4", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function smgshot()
if SSDI55 == off then
      SSDI55 = on
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI55 == on then
      SSDI55 = off
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;8D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("8", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function nanpisun()
if SSDI56 == off then
      SSDI56 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("10D;1097859072D;1137180672D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1097859072", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI56 == on then
      SSDI56 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("10D;-1D;1137180672D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("-1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1097859072", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("соси не офается")
      end
end
end

function gungive()
filsst13 = gg.multiChoice({
"RPG Give" .. SSDI57,
"SMG Give" .. SSDI58,
"AKM Give" .. SSDI59,
"Bat Give" .. SSDI60,
"Sniper Give" .. SSDI61,
"Pistol Give" .. SSDI62,
"PhysicsGun Give" .. SSDI63,
"Back"
},nil,
"gigain")
if filsst13 == nil then gun() else
if filsst13[1] == true then giveRPG() end
if filsst13[2] == true then giveSMG() end
if filsst13[3] == true then giveAKM() end
if filsst13[4] == true then giveBat() end
if filsst13[5] == true then giveSniper() end
if filsst13[6] == true then givePistol() end
if filsst13[7] == true then givePhysicsGun() end
if filsst13[8] == true then gun() end end end

function givePhysicsGun()
if SSDI63 == off then
      SSDI63 = on
	  gg.alert("вруби, затем перезайди в адвенчур. У тебя в руках будет гравитиган, если сменить его на другое оружие - прийдется перезаходить")
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":hahol", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI63 == on then
      SSDI63 = off
      gg.searchNumber(":hahol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Hands", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function givePistol()
if SSDI62 == off then
      SSDI62 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Pistol", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI62 == on then
      SSDI62 = off
      gg.searchNumber(":Pistol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveSniper()
if SSDI61 == off then
      SSDI61 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Sniper", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI61 == on then
      SSDI61 = off
      gg.searchNumber(":Sniper", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveBat()
if SSDI60 == off then
      SSDI60 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Bat", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI60 == on then
      SSDI60 = off
      gg.searchNumber(":Bat", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveRPG()
if SSDI57 == off then
      SSDI57 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":RPG", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI57 == on then
      SSDI57 = off
      gg.searchNumber(":RPG", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveSMG()
if SSDI58 == off then
      SSDI58 = on
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Smg", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI58 == on then
      SSDI58 = off
      gg.searchNumber(":Pistol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveAKM()
if SSDI58 == off then
      SSDI58 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Akm", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI58 == on then
      SSDI58 = off
      gg.searchNumber(":Akm", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function smg()
filsst14 = gg.multiChoice({
"SMG Ammo+Speed" .. SSDI64,
"SMG Bust" .. SSDI65,
"Back"
},nil,
"gigain")
if filsst14 == nil then gun() else
if filsst14[1] == true then smgammo() end
if filsst14[2] == true then smgbust() end
if filsst14[3] == true then gun() end end end

function smgammo()
if SSDI64 == off then
      SSDI64 = on
	  gg.alert("После того как уберешь смг из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;10F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI64 == on then
      SSDI64 = off
gg.searchNumber("30D;10F;200F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function smgbust()
if SSDI65 == off then
      SSDI65 = on
	  gg.alert("После того как уберешь смг из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;10F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI64 == on then
      SSDI64 = off
gg.searchNumber("30D;100F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function shotgun()
filsst15 = gg.multiChoice({
"ShotGun Ammo+Speed" .. SSDI66,
"ShotGun Bust" .. SSDI67,
"Back"
},nil,
"gigain")
if filsst15 == nil then gun() else
if filsst15[1] == true then shotammo() end
if filsst15[2] == true then shotbust() end
if filsst15[3] == true then gun() end end end

function shotammo()
if SSDI66 == off then
      SSDI66 = on
	  gg.alert("После того как уберешь двобовик из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;20F;400F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI66 == on then
      SSDI66 = off
gg.searchNumber("6D;20F;400F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function shotbust()
if SSDI67 == off then
      SSDI67 = on
	  gg.alert("После того как уберешь дробовик из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;20F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI67 == on then
      SSDI67 = off
gg.searchNumber("30D;100F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("20", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function revolver()
filsst17 = gg.multiChoice({
"𐂡 Revolver Ammo•" .. SSDI68,
"𐂡 Revolver Bust•" .. SSDI69,
"Back"
},nil,
"gigain")
if filsst17 == nil then gun() else
if filsst17[1] == true then revammo() end
if filsst17[2] == true then revbust() end
if filsst17[3] == true then gun() end end end

function revammo()
if SSDI68 == off then
      SSDI68 = on
	  gg.alert("После того как уберешь револьвер из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;40F;100F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI64 == on then
      SSDI64 = off
gg.searchNumber("6D;40F;100F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function revbust()
if SSDI69 == off then
      SSDI69 = on
	  gg.alert("После того как уберешь револьвер из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;40F;100F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("40", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI69 == on then
      SSDI69 = off
gg.searchNumber("6D;100F;100F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("40", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function sniper()
filsst19 = gg.multiChoice({
"Sniper Ammo+Speed" .. SSDI70,
"Sniper Bust" .. SSDI71,
"Back"
},nil,
"gigain")
if filsst19 == nil then gun() else
if filsst19[1] == true then sniperammo() end
if filsst19[3] == true then sniperbust() end
if filsst19[4] == true then gun() end end end

function sniperammo()
if SSDI70 == off then
      SSDI70 = on
	  gg.alert("После того как уберешь снайперку из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("5D;90F;500F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI70 == on then
      SSDI70 = off
gg.searchNumber("5D;90F;500F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function sniperbust()
if SSDI71 == off then
      SSDI71 = on
	  gg.alert("После того как уберешь снайперку из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("5D;90F;500F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("90", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI71 == on then
      SSDI71 = off
gg.searchNumber("5D;100F;500F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function akm()
filsst30 = gg.multiChoice({
"Akm Ammo+Speed" .. SSDI72,
"Akm Bust" .. SSDI73,
"Back"
},nil,
"gigain")
if filsst30 == nil then gun() else
if filsst30[1] == true then akmammo() end
if filsst30[2] == true then akmbust() end
if filsst30[3] == true then gun() end end end

function akmammo()
if SSDI72 == off then
      SSDI72 = on
	  gg.alert("После того как уберешь акм из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;15F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI72 == on then
      SSDI72 = off
gg.searchNumber("30D;15F;200F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end


function akmbust()
if SSDI73 == off then
      SSDI73 = on
	  gg.alert("После того как уберешь акм из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;15F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("15", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI73 == on then
      SSDI73 = off
gg.searchNumber("100D;15F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function oth()
filsst31 = gg.multiChoice({
    "Multigun" .. SSDI73,
    "Multigun+Speed" .. SSDI74,
    "All Car NaN" .. SSDI75,
    "Car Speed Boost" .. SSDI76,
    "Fly Car" .. SSDI77,
    "NaN Mine" .. SSDI78,
    "FPS Boost" .. SSDI79,
    "Telo Svinini" .. SSDI80,
    "Xray" .. SSDI81,
    "Fun Lug" .. SSDI82,
    "Gun no Animation" .. SSDI83,
    "1.228 - NaN" .. SSDI84,
    "1.454 - Infinity" .. SSDI85,
    "Hands RPG" .. SSDI86,
    "Helicopter NaN" .. SSDI87,
    "Freeze Rocket" .. SSDI88,
    "Freeze Arrow" .. SSDI89,
    "Crash RPG" .. SSDI90,
    "Monitor (wall_12 = Monitor)" .. SSDI91,
    "Not Spawnpoint (Adventure)" .. SSDI92,
    "All Password Panel - 0000" .. SSDI93,
    "Nextbot Allow" .. SSDI94,
    "No PvP Mode" .. SSDI95,
    "No Props in Server" .. SSDI96,
	"NaN Spawn" .. SSDI96,
	"Anti Crash" .. SSDI141,
	"Anti Crash Chat" .. SSDI142,
	"Anti LogicGate" .. SSDI143,
    "Inf Dance" .. SSDI144,
	"Rocket axuet" .. SSDI145,
    "Back"
}, nil, "gigain")
if filsst31 == nil then return end
    if filsst31[1] == true then multigun() end
    if filsst31[2] == true then multigunSpeed() end
    if filsst31[3] == true then carNan() end
    if filsst31[4] == true then carSpeedBoost() end
    if filsst31[5] == true then flyCar() end
    if filsst31[6] == true then nanMine() end
    if filsst31[7] == true then fpsBoost() end
    if filsst31[8] == true then teloSvinini() end
    if filsst31[9] == true then xray() end
    if filsst31[10] == true then funLug() end
    if filsst31[11] == true then gunNoAnim() end
    if filsst31[12] == true then PIZDAAANaN() end
    if filsst31[13] == true then HYESOSInfinity() end
    if filsst31[14] == true then handsRPG() end
    if filsst31[15] == true then helicopterNaN() end
    if filsst31[16] == true then freezeRocket() end
    if filsst31[17] == true then freezeArrow() end
    if filsst31[18] == true then crashRPG() end
    if filsst31[19] == true then monitorWall() end
    if filsst31[20] == true then notSpawnpointAdventure() end
    if filsst31[21] == true then allPassword0000() end
    if filsst31[22] == true then nextbotAllow() end
    if filsst31[23] == true then noPvPMode() end
    if filsst31[24] == true then noPropsInServer() end
	if filsst31[25] == true then nanspawn() end
	if filsst31[26] == true then anticrashe() end
	if filsst31[27] == true then antichatcrash() end
	if filsst31[28] == true then antilogic() end
	if filsst31[29] == true then infdance() end
	if filsst31[30] == true then rockinf() end
    if filsst31[31] == true then giga() end
end


function rockinf()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.clearResults()
gg.searchNumber("h 00 00 F0 41 00 00 7A 43 00 00 C0 40 00 00 20 41 00 00 16 44 00 40 1C 45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
--[[ found: 0 ]]
gg.getResults(9996, nil, nil, nil, nil, nil, nil, nil, nil)
--[[ count: 0 ]]
gg.editAll("h 00 80 3B 45 FF FF FF FF F9 02 15 50 CD CC CC 3D 00 40 1C C5 00 40 1C C5", gg.TYPE_BYTE)
gg.clearResults()
gg.setVisible(false)
end

function infdance()
local gg = gg;
local info = gg.getTargetInfo();
local LibTable = {};
v = gg.getTargetInfo();
L = v.label;
V = v.versionName;
function isProcess64Bit()
    local regions = gg.getRangesList();
    local lastAddress = regions[#regions]["end"];
    return (lastAddress >> 32) ~= 0;
end
local ISA = isProcess64Bit();
function ISAOffsets()
    if (ISA == false) then
        edi = "+0x";
        ed = "-0x";
    elseif (ISA == true) then
        edi = "0x";
        ed = "-0x";
    end
end
ISAOffsets();
function ISAOffsetss()
    if (ISA == false) then
        edit = "~A B " .. edits;
    elseif (ISA == true) then
        edit = "~A8 B     [PC,#" .. edits .. "]";
    end
end
liby = 1;
libf = 0;
libzz = "libil2cpp.so";
libx = gg.getRangesList("libil2cpp.so");
for i, v in ipairs(libx) do
    if (libx[i].state == "Xa") then
        libz = "libil2cpp.so[" .. liby .. "].start";
        xand = gg.getRangesList("libil2cpp.so")[liby].start;
        libf = 1;
        break;
    end
    liby = liby + 1;
end
if (libf == 0) then
    liby = 1;
    libzz = "libUE4.so";
    libx = gg.getRangesList("libUE4.so");
    for i, v in ipairs(libx) do
        if (libx[i].state == "Xa") then
            libz = "libUE4.so[" .. liby .. "].start";
            xand = gg.getRangesList("libUE4.so")[liby].start;
            libf = 1;
            break;
        end
        liby = liby + 1;
    end
end
lib = xand;
local sf = string.format;
function tohex(Data)
    if (type(Data) == "number") then
        return sf("0x%08X", Data);
    end
    return Data:gsub(".", function(a)
        return string.format("%02X", (string.byte(a)));
    end):gsub(" ", "");
end
function __()
    xHEX = string.format("%X", aaaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = edi .. xHEX;
    ISAOffsetss();
end
function _()
    aaa = b - a;
    xHEX = string.format("%X", aaa);
    if (#xHEX > 8) then
        act = (#xHEX - 8) + 1;
        xHEX = string.sub(xHEX, act);
    end
    edits = ed .. xHEX;
    ISAOffsetss();
end
function hook_void(cc, bb)
    LibStart = lib;
    local m = {};
    m[1] = {address=(LibStart + bb),flags=gg.TYPE_DWORD};
    gg.addListItems(m);
    a = m[1].address;
    gg.clearList();
    local p = {};
    p[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(p);
    gg.loadResults(p);
    endhook = gg.getResults(1);
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD};
    gg.addListItems(n);
    b = n[1].address;
    gg.clearResults();
    gg.clearList();
    aaaa = a - b;
    if (tonumber(aaaa) < 0) then
        _();
    end
    if (tonumber(aaaa) > 0) then
        __();
    end
    local n = {};
    n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD,value=edit,freeze=true};
    gg.addListItems(n);
    gg.clearList();
end

local void1=0x39E7B8 --Апдейт
local void2=0x39E12C --Метод вызова
hook_void(void1,void2)
end

function antichatcrash()
gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber(":<color=red>", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert1 = gg.getResults(99999)
    gg.editAll(":", gg.TYPE_BYTE)
    gg.freeze = true
    gg.clearResults()
    end



function antilogic()
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x3CF9A8+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x3CF9A8+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
end

function anticrashe()
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x1631FE4+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x1631FE4+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x1631E68+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x1631E68+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
ACKA01=gg.getRangesList('libil2cpp.so')[3].start
APEX=nil  APEX={}
APEX[1]={}
APEX[1].address=ACKA01+0x1631DC4+0
APEX[1].value='D2800020h'
APEX[1].flags=4
APEX[2]={}
APEX[2].address=ACKA01+0x1631DC4+4
APEX[2].value='D65F03C0h'
APEX[2].flags=4
gg.setValues(APEX)
end

function nanspawn()
end

function noPropsInServer()
      SSDI96 = on
	  GR3 = gg.prompt({
    "<Выбери проп","<тут не трогай"}, {":Container1",nil},{":",nil}, {"number","number"})
if GR3 == nil then gg.alert("<Nothing.........") else
    gg.searchNumber(GR3[1], gg.TYPE_BYTE)
gg.getResults(100000)
gg.editAll(GR3[2], gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
end
end

function noPvPMode()
if SSDI95 == off then
      SSDI95 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";TakeDamage", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";abcdefghij", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI95 == on then
      SSDI95 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";abcdefghij", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";TakeDamage", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function nextbotAllow()
if SSDI94 == off then
      SSDI94 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Nextbot", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";abcdefg", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI94 == on then
      SSDI94 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";abcdefg", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";Nextbot", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function allPassword0000()
if SSDI93 == off then
      SSDI93 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Password", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";qwertyui", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI93 == on then
      SSDI93 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";qwertyui", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";Password", gg.TYPE_WORD)
gg.clearResults()

      gg.toast("Deactivated")
      end
end
end

function notSpawnpointAdventure()
if SSDI92 == off then
      SSDI92 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":SpawnPoint", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":abcdefghij", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if SSDI92 == on then
      SSDI92 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":abcdefghij", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":SpawnPoint", gg.TYPE_BYTE)
gg.clearResults()

      gg.toast("Deactivated")
      end
end
end

function monitorWall()
if SSDI91 == off then
      SSDI91 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":wall_12", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":Monitor", gg.TYPE_BYTE)
gg.clearResults()


      gg.toast("Activated")
else if SSDI91 == on then
      SSDI91 = off
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":Monitor", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":wall_12", gg.TYPE_BYTE)
gg.clearResults()


      gg.toast("Deactivated")
      end
end
end


function CrashRPG()
if SSDI90 == off then
      SSDI90 = on
	  gg.setVisible(false)
gg.toast("Стрельните под себя РПГ когда включили")
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('4979925657851396096', gg.TYPE_QWORD)
gg.refineNumber('4979925657851396096', gg.TYPE_QWORD)
gg.getResults(500000)
gg.editAll('4979925661004070911', gg.TYPE_QWORD)
gg.clearResults()
gg.sleep(500)

      gg.toast("Activated")
else if SSDI90 == on then
      SSDI90 = off
	  gg.setVisible(false)
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('4979925661004070911', gg.TYPE_QWORD)
gg.refineNumber('4979925661004070911', gg.TYPE_QWORD)
gg.getResults(500000)
gg.editAll('4979925657851396096', gg.TYPE_QWORD)
gg.processResume()
gg.clearResults()

      gg.toast("Deactivated")
      end
end
end


function freezeArrow()
if SSDI89 == off then
      SSDI89 = on
	  gg["setVisible"](false)

             gg["setRanges"](gg["REGION_ANONYMOUS"])

           gg["searchNumber"]('1117782016D;70F;80,0F', gg["TYPE_FLOAT"])

           gg["refineNumber"]('70', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('0', gg["TYPE_FLOAT"])
           gg["processResume"]()
           gg["clearResults"]()
           gg.sleep(500)
      gg.toast("Activated")
else if SSDI89 == on then
      SSDI89 = off
	   gg["setVisible"](false)
           gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('1117782016D;0F;80,0F;600F', gg["TYPE_FLOAT"])
           gg["refineNumber"]('0', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('70', gg["TYPE_FLOAT"])
           gg["processResume"]()
           gg["clearResults"]()
      gg.toast("Deactivated")
      end
end
end


function freezeRocket()
if SSDI88 == off then
      SSDI88 = on
	               gg["setVisible"](false)
             gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('30F;2500.0F', gg["TYPE_FLOAT"])
           gg["refineNumber"]('30', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('0', gg["TYPE_FLOAT"])
           gg["processResume"]()
           gg["clearResults"]()
           gg.sleep(500)
      gg.toast("Activated")
else if SSDI88 == on then
      SSDI88 = off
	  gg["setVisible"](false)
           gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('0F;600F;2500.0F', gg["TYPE_FLOAT"])
           gg["refineNumber"]('0', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('30', gg["TYPE_FLOAT"])
           gg["processResume"]()
           gg["clearResults"]()
      gg.toast("Deactivated")
      end
end
end

function helicopterNaN()
if SSDI87 == off then
      SSDI87 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("300F;1 133 903 872D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 133 903 872D", gg.TYPE_DWORD)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI87 == on then
      SSDI87 = off
      gg.toast("Прост выйди с верта, заспауни другой")
      end
end
end

function HandsRPG()
if SSDI86 == off then
      SSDI86 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2D;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI86 == on then
      SSDI86 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;4D;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("4", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function HYESOSInfinity()
if SSDI85 == off then
      SSDI85 = on
	  gg.alert("впиши 1.454 в моторе, репульсоре, триггере и тд, затем вруби и поставь. Будет Infinity")
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1069161644", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("2139095040", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI85 == on then
      SSDI85 = off
      gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1069161644", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("2139095040", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
      end
end
end

function PIZDAAANaN()
if SSDI84 == off then
      SSDI84 = on
	  gg.alert("впиши 1.228 в моторе, репульсоре, триггере и тд, затем вруби и поставь. Будет NaN")
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1067265819", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if SSDI84 == on then
      SSDI84 = off
     gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1067265819", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end

function gunNoAnim()
if SSDI83 == off then
      SSDI83 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150.7", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if SSDI83 == on then
      SSDI83 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("150.7", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("30", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function funLug()
if SSDI82 == off then
      SSDI82 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE)
gg.toast("Делай респ")
gg.clearResults()
      gg.toast("Activated")
else if SSDI82 == on then
      SSDI82 = off
	  	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE)
      gg.toast("Deactivated")
      end
end
end

function xray()
if SSDI81 == off then
      SSDI81 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE)
gg.toast("Сделайте респавн и опустите камеру вниз")
gg.sleep(4599)

gg.toast("Делай респавн и жди 5 секунд")
gg.sleep(5000)
gg.searchNumber("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE)

    gg.processResume()
    gg.clearResults()
    gg.toast("Если хотите отключить эту функцию, то переключите камеру. Если не сработало вруби функцию еще раз")
    gg.sleep(500)
      gg.toast("Activated")
else if SSDI81 == on then
      SSDI81 = off
      gg.toast("Not Deactivated")
      end
end
end



function teloSvinini()
if SSDI80 == off then
      SSDI80 = on
	               gg["setVisible"](false)

             gg["setRanges"](gg["REGION_ANONYMOUS"])

           gg["searchNumber"]('1.57079637051', gg["TYPE_FLOAT"])

           gg["refineNumber"]('1.57079637051', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('15000', gg["TYPE_FLOAT"])
           
           gg["searchNumber"]('h824A833F0000003F0000003F0000003F0000003FCDCC4C3DCDCC4C3D', gg["TYPE_BYTE"])
           gg["refineNumber"]('h824A833F0000003F0000003F0000003F0000003FCDCC4C3DCDCC4C3D', gg["TYPE_BYTE"])
           gg["getResults"](500000)
           gg["editAll"]('h824A833F001BB749001BB749001BB749001BB749001BB749001BB749', gg["TYPE_BYTE"])
           gg["processResume"]()
           gg["clearResults"]()
           gg.sleep(500)
      gg.toast("Activated")
else if SSDI80 == on then
      SSDI80 = off
	  gg["setVisible"](false)
           gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('15000', gg["TYPE_FLOAT"])
           gg["refineNumber"]('15000', gg["TYPE_FLOAT"])
           gg["getResults"](500000)
           gg["editAll"]('1.57079637051', gg["TYPE_FLOAT"])
           
           gg["searchNumber"]('h824A833F001BB749001BB749001BB749001BB749001BB749001BB749', gg["TYPE_BYTE"])
           gg["refineNumber"]('h824A833F001BB749001BB749001BB749001BB749001BB749001BB749', gg["TYPE_BYTE"])
           gg["getResults"](500000)
           gg["editAll"]('h824A833F0000003F0000003F0000003F0000003FCDCC4C3DCDCC4C3D', gg["TYPE_BYTE"])
           gg["processResume"]()
           gg["clearResults"]()
      gg.toast("Deactivated")
      end
end
end

function fpsBoost()
if SSDI79 == off then
      SSDI79 = on
	  gg.searchNumber(":4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":4 515 609 228 871 570 691", gg.TYPE_QWORD)
gg.processResume()
gg.clearResults()
      gg.toast("Activated")
else if SSDI79 == on then
      SSDI79 = off
      gg.toast("После перезахода офается само")
      end
end
end


function nanMine()
if SSDI78 == off then
      SSDI78 = on
gg.searchNumber('1 060 528 047', gg.TYPE_DWORD)
gg.getResults(50000)
gg.editAll('-1', gg.TYPE_DWORD)
gg.clearResults()
gg.freeze = true
      gg.toast("Activated")
else if SSDI78 == on then
      SSDI78 = off
      gg.toast("Not Deactivated")
      end
end
end


function flyCar()
if SSDI77 == off then
      SSDI77 = on
gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["refineNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["getResults"](500000)
           gg["editAll"]('h9D74000020C10000003F', gg["TYPE_BYTE"])
           gg["processResume"]()
           gg["clearResults"]()
      gg.toast("Activated")
else if SSDI77 == on then
      SSDI77 = off
      gg.toast("просто с тачки вылези")
      end
end
end


function carSpeedBoost()
if SSDI76 == off then
      SSDI76 = on
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if SSDI76 == on then
      SSDI76 = off
      gg.toast("Not Deactivated")
      end
end
end

function CarNan()
      SSDI75 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("400X4", gg.TYPE_AUTO, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("400", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("999999", gg.TYPE_FLOAT)
gg.processResume()
      gg.toast("Activated")
end

function multigunSpeed()
      SSDI74 = on
gg.clearResults()
gg.searchNumber("30D;10F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()

gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("3", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("4", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("8", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("1", gg.TYPE_DWORD)
    gg.sleep(1500)
end
end

function multigun()
      SSDI73 = on
gg.clearResults()
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("3", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("4", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("8", gg.TYPE_DWORD)
    gg.sleep(1500)
    gg.setValues(revert)
    gg.editAll("1", gg.TYPE_DWORD)
    gg.sleep(1500)
end
end

function set()
filsst3 = gg.multiChoice({
    "Player Set" .. SSDI97,
    "Props Set" .. SSDI98,
    "Vehicles Set" .. SSDI99,
"Back"
}, nil, "тута китрит догадался")

if filsst3 == nil then return end
    if filsst3[1] == true then Player() end
    if filsst3[2] == true then Props() end
    if filsst3[3] == true then Vehicles() end
    if filsst3[4] == true then Main() end
end

function Vehicles()
SSDI99 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1000", gg.TYPE_DWORD)
gg.getResults(40)
gg.alert("Изначально должно стоять 40 транспорта, затем поменяйте значение в игре на 4. У вас есть 5 секунд. После чего вам даст панель с выбором игроков (от -1000 до 2 147 483 647)")
gg.sleep(5000)
gg.refineNumber("4", gg.TYPE_DWORD)
local results = gg.getResults(1000)
if #results == 0 then
    gg.alert("схахахах тормозная свинья")
    os.exit()
end

local input = gg.prompt({"Select value :[-1000;2 147 483 647]"}, {0}, {"number"})

if input == nil then
    gg.alert("Отмена")
    os.exit()
end

local selectedValue = input[1]
gg.editAll(selectedValue, gg.TYPE_DWORD)
gg.clearResults()

gg.alert("лимит пропов: " .. selectedValue)
end

function Props()
SSDI98 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1000", gg.TYPE_DWORD)
gg.getResults(1000)
gg.alert("Изначально должно стоять 1000 пропов, затем поменяйте значение в игре на 100. У вас есть 5 секунд. После чего вам даст панель с выбором игроков (от -1000 до 2 147 483 647)")
gg.sleep(5000)
gg.refineNumber("100", gg.TYPE_DWORD)
local results = gg.getResults(1000)
if #results == 0 then
    gg.alert("схахахах тормозная свинья")
    os.exit()
end

local input = gg.prompt({"Select value :[-1000;2 147 483 647]"}, {0}, {"number"})

if input == nil then
    gg.alert("Отмена")
    os.exit()
end

local selectedValue = input[1]
gg.editAll(selectedValue, gg.TYPE_DWORD)
gg.clearResults()

gg.alert("лимит пропов: " .. selectedValue)
end

function Player()
SSDI97 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("6", gg.TYPE_DWORD)
gg.getResults(1000)
gg.alert("Изначально должно стоять 6 игроков, затем поменяйте значение в игре на 10. У вас есть 5 секунд. После чего вам даст панель с выбором игроков (от 0 до 10)")
gg.sleep(5000)
gg.refineNumber("10", gg.TYPE_DWORD)
local results = gg.getResults(1000)
if #results == 0 then
    gg.alert("pig detected")
    os.exit()
end

local input = gg.prompt({"Select value :[0;12]"}, {0}, {"number"})

if input == nil then
    gg.alert("Отмена")
    os.exit()
end

local selectedValue = input[1]
gg.editAll(selectedValue, gg.TYPE_DWORD)
gg.clearResults()

gg.alert("лимит игроков: " .. selectedValue)
end

function nety()
-- мне лень щас добавлять це в скрипт, такчоуш будет такой секреткой. краш фпс
gg.searchNumber('0x1C', gg.TYPE_FLOAT)
gg.getResults(500000)
gg.editAll('99999999', gg.TYPE_FLOAT)
end

function info()
end


while(true)
do
menuend = 0
if gg.isVisible(true) then gg.setVisible(false)
menuend = 1 end
if menuend == 1 then Main() end end