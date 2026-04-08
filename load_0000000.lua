function getXaSegment()
    local segments = {}
    for _, range in ipairs(gg.getRangesList("libil2cpp.so")) do
        if range.state == "Xa" then table.insert(segments, range) end
    end
    return segments[1]
end

function getCdSegment()
    local segments = {}
    for _, range in ipairs(gg.getRangesList("libil2cpp.so")) do
        if range.state == "Cd" then table.insert(segments, range) end
    end
    return segments[2] or segments[1]
end

function gg.edits(addr, tbl, name)
    local t1, t2 = {}, {}
    for _, v in ipairs(tbl) do
        local val = {address=addr+v[3], value=v[1], flags=v[2], freeze=v[4]}
        if v[4] then t2[#t2+1]=val else t1[#t1+1]=val end
    end
    gg.addListItems(t2)
    gg.setValues(t1)
    gg.toast(name or "")
end

gg.clearResults()
gg.toast("ʷᵉˡᶜᵒᵐᵉ ᵗᵒ ᵐʸ ˢᶜʳᶦᵖᵗ")
local gg = gg
local info = gg.getTargetInfo()
local pointerType = info.x64 == true and gg.TYPE_QWORD or gg.TYPE_DWORD
local pointerOffset = info.x64 == true and 24 or 12
local metadata = gg.getRangesList("libil2cpp.so")
local VOID = info.x64 == true and "h C0 03 5F D6" or "h 1E FF 2F E1"
local TRUE = info.x64 == true and "h 20 00 80 D2 C0 03 5F D6" or "h 01 00 A0 E3 1E FF 2F E1"
local FALSE = info.x64 == true and "h 00 00 80 D2 C0 03 5F D6" or "h 00 00 A0 E3 1E FF 2F E1"
local SAVE = info.x64 == true and "h C0 03 5F D6 EF 3B 09 6D ED 33 0A 6D EB 2B 0B 6D E9 23 0C 6D FC 6B 00 F9 F7 5B 0E A9 F5 53 0F A9 F3 7B 10 A9 B6 53 01 90 C8 52 61 39"
local INF = info.x64 == true and "h FA 04 44 E3 1E FF 2F E1"
local PLAY = info.x64 == true and "h 37 00 A0 E3 1E FF 2F E1"
local INT = info.x64 == true and "FA 04 44 E3 1E FF 2F E1"
local GetUnityMethod = function(method, flag)
  local results = {}
  gg.clearResults()
  gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP)
  gg.searchNumber(":" .. method, gg.TYPE_BYTE, false, gg.SIGH_EQUAL, metadata[1].start, metadata[#metadata]["end"], 0)
  local count = gg.getResultsCount()
  if count ~= 0 then
    gg.refineNumber(tonumber(gg.getResults(1)[1].value) .. "", gg.TYPE_BYTE)
    local t = gg.getResults(count)
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    gg.loadResults(t)
    gg.searchPointer(0)
    t = gg.getResults(count)
    do
      do
        for SRD1_8_, SRD1_9_ in ipairs(t) do
          SRD1_9_.address = SRD1_9_.address - pointerOffset
          SRD1_9_.flags = pointerType
        end
      end
    end
    t = gg.getValues(t)
    do
      do
        for SRD1_8_, SRD1_9_ in ipairs(t) do
          table.insert(results, {
            address = SRD1_9_.value,
            flags = flag
          })
        end
      end
    end
    gg.loadResults(results)
  else
    gg.toast("try restart game again")
  end
end

function editString(oldName, newName)
    local stringTag = ';'
    local addressJump = 2
    
    gg.setVisible(false)
    
    if not _G.GG then _G.GG = {} end
    if not _G.GG.stringBackups then _G.GG.stringBackups = {} end
    
    gg.searchNumber(stringTag..oldName)
    local results = gg.getResults(gg.getResultsCount())
    
    if #results == 0 then
        gg.clearResults()
        local searchPattern = table.concat({string.byte(oldName, 1, -1)}, ';')
        gg.searchNumber(searchPattern, gg.TYPE_WORD)
        results = gg.getResults(gg.getResultsCount())
        
        if #results == 0 then
            return false
        end
    end

    local filteredResults = {}
    for i = 1, #results do
        if i <= #results - #oldName + 1 then
            local match = true
            for j = 0, #oldName - 1 do
                local charCode = string.byte(oldName, j + 1)
                if results[i + j].value ~= charCode then
                    match = false
                    break
                end
            end
            if match then
                filteredResults[#filteredResults + 1] = results[i]
            end
        end
    end

    if #filteredResults == 0 then
        return false
    end

    local replaceString = {}
    local stringSize = {}
    
    for i = 1, #filteredResults do
        stringSize[#stringSize + 1] = {address = filteredResults[i].address - 0x4, flags = gg.TYPE_WORD}
    end
    stringSize = gg.getValues(stringSize)
    
    for i = 1, #filteredResults do
        if stringSize[i].value >= #oldName then
            local originalSize = stringSize[i].value
            local originalChars = {}
            
            for j = 1, originalSize do
                local charAddr = filteredResults[i].address + ((j-1) * addressJump)
                local charValue = gg.getValues({{address = charAddr, flags = gg.TYPE_WORD}})[1].value
                table.insert(originalChars, {
                    address = charAddr,
                    value = charValue
                })
            end
            
            table.insert(_G.GG.stringBackups, {
                baseAddress = filteredResults[i].address,
                oldName = oldName,
                newName = newName,
                originalSize = originalSize,
                originalChars = originalChars,
                sizeAddress = filteredResults[i].address - 0x4
            })
            
            gg.setValues({{address = filteredResults[i].address - 0x4, flags = gg.TYPE_WORD, value = #newName}})
            
            for j = 1, #newName do
                local charValue = string.byte(string.sub(newName, j, j))
                replaceString[#replaceString + 1] = {
                    address = filteredResults[i].address + ((j-1) * addressJump), 
                    flags = gg.TYPE_WORD, 
                    value = charValue
                }
            end
            
            for j = #newName + 1, stringSize[i].value do
                replaceString[#replaceString + 1] = {
                    address = filteredResults[i].address + ((j-1) * addressJump), 
                    flags = gg.TYPE_WORD, 
                    value = 0
                }
            end
        end
    end
    
    if #replaceString > 0 then
        gg.setValues(replaceString)
        return true
    end
    
    return false
end

function endString(oldName, newName)
    if not _G.GG or not _G.GG.stringBackups or #_G.GG.stringBackups == 0 then
        return false
    end
    
    local foundBackup = false
    
    for i = #_G.GG.stringBackups, 1, -1 do
        local backup = _G.GG.stringBackups[i]
        if backup.oldName == oldName and backup.newName == newName then
            foundBackup = true
            
            gg.setValues({{
                address = backup.sizeAddress,
                flags = gg.TYPE_WORD,
                value = backup.originalSize
            }})
            
            local restoreData = {}
            for j, charData in ipairs(backup.originalChars) do
                table.insert(restoreData, {
                    address = charData.address,
                    flags = gg.TYPE_WORD,
                    value = charData.value
                })
            end
            
            gg.setValues(restoreData)
            
            table.remove(_G.GG.stringBackups, i)
            break
        end
    end
    
    if not foundBackup then
        return false
    end
    
    return true
end



_G.OffsetBackups = _G.OffsetBackups or {}

function editOffset(baseOffset, patchValues, backupKey)
    if not _G.OffsetBackups[backupKey] then
        _G.OffsetBackups[backupKey] = {}
    end
    
    local base = gg.getRangesList('libil2cpp.so')[3].start
    local mainAddress = base + baseOffset
    
    local originalValues = {}
    for i, patch in ipairs(patchValues) do
        local address = mainAddress + patch.offset
        local original = gg.getValues({{address = address, flags = patch.flags}})[1]
        table.insert(originalValues, {
            address = address,
            flags = patch.flags,
            value = original.value
        })
    end
    
    _G.OffsetBackups[backupKey].original = originalValues
    
    local patchData = {}
    for i, patch in ipairs(patchValues) do
        table.insert(patchData, {
            address = mainAddress + patch.offset,
            flags = patch.flags,
            value = patch.value
        })
    end
    
    gg.setValues(patchData)
    return true
end

function endOffset(backupKey)
    if not _G.OffsetBackups[backupKey] or not _G.OffsetBackups[backupKey].original then
        return false
    end
    
    local originalValues = _G.OffsetBackups[backupKey].original
    gg.setValues(originalValues)
    _G.OffsetBackups[backupKey] = nil
    return true
end

if gg.isVisible(true) then
  gg.setVisible(false)
end

off = " ☐"
on = " ☑"

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
SSSI16 = off
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

Notch = 1


function menu()
Notch = 0
choice1  = gg.choice({
'ᵇᵉᵗᵃ ᶠᵘⁿᶜᵗᶦᵒⁿ', -- 1
'ˢᵖᵉᵉᵈʰᵃᶜᵏ', --2
'ᶠᵒᵛ ᶜᵃᵐᵉʳᵃ', --3
'ᵃᶜᶜᵒᵘⁿᵗ', --4
'ᵍᵒᵈᵐᵒᵈᵉ ᵃⁿᵈ ᴺᵃᴺ', --5
'ʲᵘᵐᵖ ʰᵃᶜᵏ', --6
'ᶦⁿᶠᶦⁿᶦᵗᵉ ᵈᵃⁿᶜᵉ', --7
'ˢᵉʳᵛᵉʳ', --8
'ʷᵉᵃᵖᵒⁿ', --9
'ᵛᶦᵖ ᶠᵘⁿᶜᵗᶦᵒⁿ ᵃⁿᵈ ᵖʳᵉᵐᶦᵘᵐ ᶠᵘⁿᶜᵗᶦᵒⁿ', --10
'ᵉˣᶦᵗ'},nil,'ʰʸᵖᵖᵉʳ ˢᵃⁿᵈᵇᵒˣ ᵐᵒᵈ ᵐᵉⁿᵘ ᵇʸ ᴳᴳᴹ- ᴰᵉᵃᵍˡᵉ- ᵁᴷ ᵃⁿᵈ ᵃᵛᶦᵃᵗᶦᵒⁿ-ˢʰᵃᶜᵏᵉʳ')

  if choice1 == 1 then
    beta()
  end
  if choice1 == 2 then
    speedHackMenu()
  end
  if choice1 == 3 then
    GGfovGG()
  end
  if choice1 == 4 then
   gg5()
  end
  if choice1 == 5 then
    nanhp()
  end
  if choice1 == 6 then
    jumphacks()
  end
  if choice1 == 7 then
    infinitedance()
  end
  if choice1 == 8 then
    server()
  end
  if choice1 == 9 then
    GGWEAPONGG()
  end
  if choice1 == 10 then
    vipandpre()
  end
  if choice1 == 11 then
    best() 
  end
end

function beta()
  choice2 = gg.choice({
    "ʳᵒᶜᵏᵉᵗ ᵗʰʳᵒʷ ᵃˡˡ ᵖʳᵒᵖ",
    "ˢˡᶦᵈᵉ ᶠˡᵒᵒʳ",
    "ˢᵘᵖᵉʳ ʳᵒᶜᵏᵉᵗ",
    "ᵍᶦᵛᵉ ᵐᶦⁿᶦᵍᵘⁿ ᵐ¹³⁴ ˢᵐᵍ",
    "ʳᵒᶜᵏᵉᵗ ʲᵘᵐᵖ",
    "ᵘᵖᵗᵒᵈᵒʷⁿ ᶜᵃᵐᵉʳᵃ ᵛ² 'ᵗᵘʳⁿ ᵃⁿᵗᶦ-ᵍˡᶦᵗᶜʰ ᵒⁿ'",
    "ᶠᵃˢᵗᵉˢᵗ ʰᵉᵃʳᵗ",
    "ˢᵘᵖᵉʳ ᶠˡᵃˢʰ",
    "ᵇᶦᵍ ˢᵐᵒᵏᵉ ʷᵉᵃᵖᵒⁿ",
    "ᵗᵒᵒˡᵇᵃᵗᵒⁿ",
    "ᵈʳᵃʷ ᵗᵒᵒˡᵇᵃᵗᵒⁿ ᵛ²",
    "ⁿᵘᵏᵉ ʳᵖᵍ ᵛ²",
    "ᵗᵉˡᵉᵖᵒʳᵗ ʰᵃᶜᵏ",
    "ˢᵖᵉᵉᵈʰᵃᶜᵏ",
    "ˢᵘᵖᵉʳ ᶠˡᵃˢʰ ᶜᵃʳ",
    "ᵃˡˡ ʷᵉᵃᵖᵒⁿ ˢⁿᶦᵖᵉʳ",
    "ᵍᵒᵈᵐᵒᵈᵉ ᶜᵃʳ",
    "ᵍᵒˡᵈᵉⁿ ʷᵒʳˡᵈ ᶜʰᵃᵐ",
    "ᵈᶦᶠᶠᵉʳᵉⁿᵗ ʷʰᵉᵉˡ ᵐᵒᵗᵒ",
    "ˡᵒⁿᵍ ᵖʰʸˢᶦᶜˢᵍᵘⁿ",
    "ᵐᵘˡᵗᶦ ᵐᶦⁿᵉ",
    "ˢᵉᵗᵗᶦⁿᵍ ᵇᵘˡˡᵉᵗ",
    "ᵖʳᵒ ᵍᵃᵐᵉʳ ᵐᵒᵈᵉ",
    "ˢᵒˡᵈᶦᵉʳ ᵐᵃᶦⁿ ᶠʳᵒᵐ ᵗᵉᵃᵐ ᶠᵒʳᵗʳᵉˢˢ ²",
    "ⁿᵃⁿ ʳᵉᵖᵘˡˢᵒʳ",
    "ʳᵒᶜᵏᵉᵗ ᶜᵃⁿⁿᵒᵗ ᵉˣᵖˡᵒᵈᵉˢ",
    "ⁿᵉˣᵗᵇᵒᵗ ᵐᵒᵈ",
    "ˢᵐᵍ ʳᶦᶠˡᵉ",
    "ˡᶦᵍʰᵗ ᵖʰʸˢᶦᶜˢᵍᵘⁿ",
    "ᵃⁿᵗᶦ-ᵍˡᶦᵗᶜʰ",
    "ˢʰᵒᵗᵍᵘⁿ ᵇᵃᶻᵒᵒᵏᵃ",
    "ˢᵘᵖᵉʳ ˢᵖᵉᵉᵈ ʷᵃˡᵏ ᵛ² 'ᵗᵘʳⁿ ᵃⁿᵗᶦ-ᵍˡᶦᵗᶜʰ ᵒⁿ ᵃⁿᵈ ᶜˡᶦᶜᵏ ᵉˣᶦᵗ'",
    "ᶜʳᵃˢʰᵉᵈ ˢᵐᵍ",
    "ᵇᵘⁿⁿʸ ʰᵒᵖ 'ᵗᵘʳⁿ ᵃⁿᵗᶦ-ᵍˡᶦᵗᶜʰ ᵒⁿ'",
    "ᵗᵉˡᵉᵖᵒʳᵗ ʰᵃᶜᵏ ᵛ² 'ᵗᵘʳⁿ ᵃⁿᵗᶦ-ᵍˡᶦᵗᶜʰ ᵒⁿ'",
  }, nil, "ᵇᵉᵗᵃ ᶠᵘⁿᶜᵗᶦᵒⁿ")
  if choice2 == 1 then
    a3()
  end
  if choice2 == 2 then
    slidev2()
  end
  if choice2 == 3 then
    aaa3()
  end
  if choice2 == 4 then
    aaaa3()
  end
  if choice2 == 5 then
    aaaaa3()
  end
  if choice2 == 6 then
    aaaaaa3()
  end
  if choice2 == 7 then
    speedheart3()
  end
  if choice2 == 8 then
    aaaaaaaa3()
  end
  if choice2 == 9 then
    aaaaaaaaa3()
  end
  if choice2 == 10 then
    aaaaaaaaaa3()
  end
  if choice2 == 11 then
    a40()
  end
  if choice2 == 12 then
    a41()
  end
  if choice2 == 13 then
    onegun()
  end
  if choice2 == 14 then
    onegunauto()
  end
  if choice2 == 15 then
    flycar()
  end
  if choice2 == 16 then
    smgkick()
  end
  if choice2 == 17 then
    godcar()
  end
  if choice2 == 18 then
    goldw()
  end
  if choice2 == 19 then
   coolmoto()
  end
  if choice2 == 20 then
   longestgun()
  end
  if choice2 == 21 then
   multimine()
  end
  if choice2 == 22 then
   hideid()
  end
  if choice2 == 23 then
   promode()
  end
  if choice2 == 24 then
   soldier()
  end
  if choice2 == 25 then
   crashp()
  end
  if choice2 == 26 then
   rpgnot()
  end
  if choice2 == 27 then
   nextmod()
  end
  if choice2 == 28 then
   smgrl()
  end
  if choice2 == 29 then
   physicalgun()
  end
  if choice2 == 30 then
   antiglitch()
  end
  if choice2 == 31 then
   blueprint()
  end
  if choice2 == 32 then
   superwalk()
  end
  if choice2 == 33 then
   smgcrash()
  end
  if choice2 == 34 then
   bunny()
  end
  if choice2 == 35 then
   teleport2()
  end
  if choice2 == nil then
  else
  end
end

function a3() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ʳᵒᶜᵏᵉᵗ ᵗʰʳᵒʷ ᵃˡˡ ᵖʳᵒᵖ')
if gun == nil then else
if gun[1] == true then turnon55555() end
if gun[2] == true then turnoff55555() end
end
end

function turnon55555()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE)
  gg.clearResults()
end

function turnoff55555()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("h00803B45FFFFFFFFF9021550CDCCCC3D00401CC500401CC5", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h0000F04100007A430000C040000020410000164400401C45", gg.TYPE_BYTE)
  gg.clearResults()
end

function slidev2()
  GetUnityMethod("get_linearVelocity", 4)
  gg.getResults(gg.getResultsCount())
  gg.editAll(VOID, 4)
  gg.clearResults()
end

function aaa3() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ˢᵘᵖᵉʳ ʳᵒᶜᵏᵉᵗ')
if gun == nil then else
if gun[1] == true then turnon999999() end
if gun[2] == true then turnoff999999() end
end
end

function turnon999999()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("30;250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("80.55", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber("0.4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("3.4542", gg.TYPE_FLOAT)
  gg.clearResults()
end

function turnoff999999()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("80.55;250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("80.55", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("30", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber("3.4542", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("0.4", gg.TYPE_FLOAT)
  gg.clearResults()
end

function aaaa3()
  gg.searchNumber("30F;2500.0F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("150", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("7", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll(":Smg", gg.TYPE_BYTE)
  gg.clearResults()
  ACKA01 = gg.getRangesList("libil2cpp.so")[3].start
  APEX = nil
  APEX = {}
  APEX[1] = {}
  APEX[1].address = ACKA01 + 3977036 + 0
  APEX[1].value = "D65F03C0h"
  APEX[1].flags = 4
  gg.setValues(APEX)
  gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 877 605 304", gg.TYPE_QWORD)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 03 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function aaaaa3() 
ACKA01 = gg.getRangesList("libil2cpp.so")[3].start
  APEX = nil
  APEX = {}
  APEX[1] = {}
  APEX[1].address = ACKA01 + 3977036 + 0
  APEX[1].value = "D65F03C0h"
  APEX[1].flags = 4
  gg.setValues(APEX)
  gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("0", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll(":RPG", gg.TYPE_BYTE)
  gg.clearResults()
end

function aaaaaa3()
  gg.searchNumber("90", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("200", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.searchNumber("-90", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("-200", gg.TYPE_FLOAT)
  gg.clearResults()
end

function speedheart3()
gg.searchNumber("0.4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
end

function aaaaaaaa3() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ˢᵘᵖᵉʳ ᶠˡᵃˢʰ')
if gun == nil then else
if gun[1] == true then runon4() end
if gun[2] == true then runoff4() end
end
end

function runon4()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 899 605 304", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("1", gg.TYPE_DOUBLE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2000000000", gg.TYPE_DOUBLE)
gg.clearResults()
gg.searchNumber("60", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("124.4", gg.TYPE_FLOAT)
gg.clearResults()
end

function runoff4()
gg.searchNumber("4 515 609 228 899 605 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("2000000000", gg.TYPE_DOUBLE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DOUBLE)
gg.clearResults()
gg.searchNumber("124.4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("60", gg.TYPE_FLOAT)
gg.clearResults()
end

function aaaaaaaaa3()
gg.searchNumber("0.6", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_FLOAT)
gg.clearResults()
end

function aaaaaaaaaa3()
choice3=gg.choice({"ᵃʳʳᵒʷ ᵗᵒᵒˡᵇᵃᵗᵒⁿ","ʳᵖᵍ ᵗᵒᵒˡᵇᵃᵗᵒⁿ"})
if choice3 == 1 then gg9000() end
if choice3 == 2 then gg10000() end
end

function gg9000() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵗᵒᵒˡᵇᵃᵗᵒⁿ ˣ ᵃʳʳᵒʷ ˣ ᶠᵃˢᵗ"},nil,'ᵃʳʳᵒʷ ᵗᵒᵒˡᵇᵃᵗᵒⁿ')
if gun == nil then else
if gun[1] == true then handon7() end
if gun[2] == true then handoff7() end
if gun[3] == true then handfast7() end
end
end

function handoff7() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h04000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h07000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function handon7() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h07000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h04000000E384", gg.TYPE_BYTE)
gg.clearResults()
end

function handfast7() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h07000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h04000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function gg10000() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵗᵒᵒˡᵇᵃᵗᵒⁿ ˣ ʳᵖᵍ ˣ ᶠᵃˢᵗ"},nil,'ʳᵖᵍ ᵗᵒᵒˡᵇᵃᵗᵒⁿ')
if gun == nil then else
if gun[1] == true then handon8() end
if gun[2] == true then handoff8() end
if gun[3] == true then handfast8() end
end
end

function handoff8() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h03000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h07000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function handon8() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h07000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h03000000E384", gg.TYPE_BYTE)
gg.clearResults()
end

function handfast8() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h07000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h03000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function a40()
choice3=gg.choice({"ᵗᵒᵒˡᵇᵃᵗᵒⁿ ᵈʳᵃʷ","ᵃʳʳᵒʷ ⁿᵉᵛᵉʳ ᵈᶦˢᵃᵖᵖᵉᵃʳ","ᶠʳᵉᵉᶻᵉ ᵃʳʳᵒʷ","ᶠˡʸ"})
if choice3 == 1 then h10() end
if choice3 == 2 then h20() end
if choice3 == 3 then h30() end
if choice3 == 4 then h40() end
end

function h10() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ʰᵒˡᵈ ʸᵒᵘ ᵗᵒᵒˡᵇᵃᵗᵒⁿ')
if gun == nil then else
if gun[1] == true then handon543() end
if gun[2] == true then handoff543() end
end
end

function handoff543() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h04000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h07000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function handon543() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h07000000E384", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h04000000E384", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h000000000000803F01010000B9F09D56", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h000000000000803F01000000B9F09D56", gg.TYPE_BYTE)
gg.clearResults()
end

function h20() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᵃʳʳᵒʷ ⁿᵉᵛᵉʳ ᵈᶦˢᵃᵖᵖᵉᵃʳ')
if gun == nil then else
if gun[1] == true then handon28000() end
if gun[2] == true then handoff28000() end
end
end

function handoff28000() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("9999999999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.clearResults()
end

function handon28000() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("10;80;600", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(3000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("9999999999", gg.TYPE_FLOAT)
gg.clearResults()
end

function h30() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᶠʳᵉᵉᶻᵉ ᵃʳʳᵒʷ')
if gun == nil then else
if gun[1] == true then handon3453() end
if gun[2] == true then handoff3453() end
end
end

function handoff3453() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("600;0;80", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("70", gg.TYPE_FLOAT)
gg.clearResults()
end

function handon3453() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("600;70;80", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("70", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
end

function h40()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.processPause()
gg.clearResults()
gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("16 777 472", gg.TYPE_QWORD)

gg.clearResults()
gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.processResume() 
gg.freeze = true
end

function a41() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ⁿᵘᵏᵉ')
if gun == nil then else
if gun[1] == true then nuke1() end
if gun[2] == true then nuke2() end
end
end

function nuke2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("99", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(30000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("30", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("230.5", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(30000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("10000097", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.clearResults()
gg.setVisible(false)
        if editString('NUKE','RPG') then
            gg.clearResults()
            end
            end

function nuke1()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(30000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(30000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("230.5", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10000097", gg.TYPE_FLOAT)
gg.clearResults()
gg.setVisible(false)
        if editString('RPG','NUKE') then
            gg.clearResults()
            end
            end

function onegun()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 930 700 672", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("4 515 609 228 930 700 672", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
gg.clearResults()
end

function onegunauto() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ˢᵘᵖᵉʳ ˢᵖᵉᵉᵈ')
if gun == nil then else
if gun[1] == true then superon() end
if gun[2] == true then superoff() end
end
end

function superon()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 893 826 304", gg.TYPE_QWORD)
gg.clearResults()
end

function superoff()
  gg.searchNumber("4 515 609 228 893 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.clearResults()
end

function flycar()
gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["refineNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["getResults"](500000)
           gg["editAll"]('h9D74000020C10000003F', gg["TYPE_BYTE"])
           gg["processResume"]()
           gg["clearResults"]()
end

function smgkick()
gg.searchNumber("30D;10F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("6D;20F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("30D;15F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("15", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("6D;40F;100F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("40", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90000", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("15;1D;2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("15", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("10D;15;100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("15", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("50", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
end

function godcar()
GetUnityMethod("VehicleExplode", 4)
gg.getResults(gg.getResultsCount())
gg.editAll(VOID, 4)
gg.clearResults()
end

function goldw() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᵍᵒˡᵈᵉⁿ')
if gun == nil then else
if gun[1] == true then goldon() end
if gun[2] == true then goldoff() end
end
end

function goldon()
gg.searchNumber("1073741859", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741865", gg.TYPE_DWORD)
gg.clearResults()
end

function goldoff()
gg.searchNumber("1073741865", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741859", gg.TYPE_DWORD)
gg.clearResults()
end

function coolmoto() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᵐᵒᵗᵒ')
if gun == nil then else
if gun[1] == true then motoon() end
if gun[2] == true then motooff() end
end
end

function motoon()
gg.searchNumber("0.03", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.36", gg.TYPE_FLOAT)
end

function motooff()
gg.searchNumber("0.36", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.03", gg.TYPE_FLOAT)
end

function longestgun() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᵖʰʸˢᶦᶜˢᵍᵘⁿ')
if gun == nil then else
if gun[1] == true then gragun1() end
if gun[2] == true then gragun2() end
end
end

function gragun1()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("311D;1112014848D;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("1112014848", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("1148829696", gg.TYPE_DWORD)
  gg.clearResults()
end

function gragun2()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("311D;1148829696D;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("1148829696", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("1112014848", gg.TYPE_DWORD)
  gg.clearResults()
end

function multimine()
  GetUnityMethod("PropExplode", 4)
  gg.getResults(gg.getResultsCount())
  gg.editAll(VOID, 4)
  gg.clearResults()
end

function crashp()
gg.searchNumber("1,069,161,644", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
end

function hideid()
  fov = gg.prompt({
    "ʸᵒᵘ'ʳᵉ ᵇᵘˡˡᵉᵗˢ ˢᶦᶻᵉ",
    "ᵉᵈᶦᵗ ᵗᵒ"
  }, {"7", nil}, {"number", "number"})
  if fov == nil then
  else
  gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber(fov[1], gg.TYPE_FLOAT)
    gg.getResults(100000)
    gg.editAll(fov[2], gg.TYPE_FLOAT)
    gg.clearResults()
  end
end

function promode()
gg.searchNumber("60", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("105", gg.TYPE_FLOAT)
gg.searchNumber("124", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("139", gg.TYPE_FLOAT)
gg.searchNumber("124", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("139", gg.TYPE_FLOAT)
gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4.9", gg.TYPE_FLOAT)
gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4.9", gg.TYPE_FLOAT)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("h 25 E1 AD 97 FF 03 01 D1 FE 57 02 A9 F4 4F 03 A9", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h C0 03 5F D6 C0 03 5F D6 C0 03 5F D6 C0 03 5F D6", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("h 25 E1 AD 97 FF 03 01 D1 FE 57 02 A9 F4 4F 03 A9", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h C0 03 5F D6 C0 03 5F D6 C0 03 5F D6 C0 03 5F D6", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
end

function soldier()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
gg.searchNumber("109900", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1.1", gg.TYPE_FLOAT)
gg.searchNumber("109900", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1.1", gg.TYPE_FLOAT)
gg.searchNumber("0.2;1.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 876 605 304", gg.TYPE_QWORD)
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 876 605 304", gg.TYPE_QWORD)
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 876 605 304", gg.TYPE_QWORD)
gg.searchNumber("124", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("149", gg.TYPE_FLOAT)
gg.searchNumber("124", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("149", gg.TYPE_FLOAT)
gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("7", gg.TYPE_FLOAT)
gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("7", gg.TYPE_FLOAT)
gg.searchNumber("60", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.searchNumber("250", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.searchNumber("60", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":RPG", gg.TYPE_BYTE)
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":RPG", gg.TYPE_BYTE)
gg.searchNumber(";Hands", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";RPG", gg.TYPE_WORD)
gg.clearResults()
gg.searchNumber(";Hands", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";RPG", gg.TYPE_WORD)
gg.clearResults()
end

function rpgnot()
  GetUnityMethod("Explode", 4)
  gg.getResults(gg.getResultsCount())
  gg.editAll(VOID, 4)
  gg.clearResults()
end

function nextmod() 
gun=gg.multiChoice({"oi oi oi kid","sandbox cheat","invisible nextbot","Car","funny clown","fighter jet"},nil,'ᑎᗴ᙭TᗷOT ᗰOᗪ')
if gun == nil then else
if gun[1] == true then oioi() end
if gun[2] == true then sc5() end
if gun[3] == true then invisible() end
if gun[4] == true then car544() end
if gun[5] == true then funny() end
if gun[6] == true then fighter() end
end
end

function oioi()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1475437685261865055/1770784056264.jpg?ex=699f762c&is=699e24ac&hm=f972e509311216073c33eb7d0cce3a6e84dba31ebbd420839b712185d739c6c1&")
end

function sc5()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1476057865138733118/Untitled2_20260225062629.png?ex=699fbd82&is=699e6c02&hm=ef4fb1ee474f758685d025830ea36db7db1c5860cc32d18731e7b8f397ea419d&")
end

function invisible()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1474603624935063722/images_2.png?ex=699fb924&is=699e67a4&hm=12d6001b75c069ebcc6afb541636e09c33744a7e3bb9d64d9cf11347b28a5d00&")
end

function car544()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1474021846625030297/descarga_12.jpg?ex=699f9592&is=699e4412&hm=963d58fd91f80658c394d25280d6f2708bcc23173466595e88d9a980b6fd391b&")
end

function funny()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1473387524348051517/1770146360781.jpg?ex=699f4110&is=699def90&hm=8282508f6774066d739c734cdda78feca1483fd673d357ddd5ba9828532635bf&")
end

function fighter()
gg.copyText("https://cdn.discordapp.com/attachments/1028598242482606170/1476355095003136020/Untitled4_20260226020718.png?ex=69a0d254&is=699f80d4&hm=3a2da1c1df7afa12a73e293751ceff0baf0078f5ce7dd572c84f78f47590f8a7&")
end

function smgrl()
gg.searchNumber("30D;0;1D;10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.searchNumber("30D;0F;1D;90F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("5", gg.TYPE_DWORD)
gg.searchNumber("30D;0;5D;90", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.searchNumber("0.01499999966", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
end

function physicalgun()
gg.searchNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10.358", gg.TYPE_FLOAT)
gg.clearResults()
end

function antiglitch()
    gg.setRanges(gg.REGION_CODE_APP)
    local seg = getXaSegment()
    if not seg then 
        gg.toast("ᵗʰᶦˢ ᶠᵘⁿᶜᵗᶦᵒⁿ ᶦˢ ⁿᵒᵗ ʳᵘⁿ")
        return 
    end
    local addr = seg.start + 0x165219C
    local ret = 0xD65F03C0
    gg.edits(addr, {{ret, gg.TYPE_DWORD, 0, false}}, "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ")
end

function blueprint()
gg.searchNumber("48", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("13", gg.TYPE_FLOAT)
gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h 08 00 00 00 30 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 03 00 00 00 30 DE 06 50", gg.TYPE_BYTE)
gg.clearResults()
end

function superwalk()
gg.searchNumber("6", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(252, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("85.505", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("999888", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(200000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1.1", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("1;1.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("9999999999", gg.TYPE_FLOAT)
gg.clearResults()
gun=gg.multiChoice({"ʸᵉˢ","ⁿᵒ"},nil,'ᵈᵒ ʸᵒᵘ ʷᵃⁿᵗ ᶦⁿᶠᶦⁿᶦᵗʸ ʲᵘᵐᵖ')
if gun == nil then else
if gun[1] == true then yesjump() end
if gun[2] == true then nojump() end
end
end

function yesjump()
gg.searchNumber("1.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("999888", gg.TYPE_FLOAT)
gg.clearResults()
end

function nojump()
end

function smgcrash() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᶜʳᵃˢʰᵉᵈ ˢᵐᵍ')
if gun == nil then else
if gun[1] == true then crashsmgon() end
if gun[2] == true then crashsmgoff() end
end
end

function crashsmgon()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h47789E6F47D6782C0000000000004843", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h546714A9ABEB985600000000FFFFFFFF", gg.TYPE_BYTE)
gg.clearResults()
end

function crashsmgoff()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h546714A9ABEB985600000000FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h47789E6F47D6782C0000000000004843", gg.TYPE_BYTE)
gg.clearResults()
end

function bunny()
gg.clearResults()
gg.searchNumber("-9.81", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("11.5", gg.TYPE_FLOAT)
    gg.sleep(300)
    gg.setValues(revert)
    gg.editAll("-9.81", gg.TYPE_FLOAT)
    gg.sleep(500)
end
end

function teleport2()
gg.searchNumber("6", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(252, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("300.565", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("999888", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(200000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1.1", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("1;1.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("9999999999", gg.TYPE_FLOAT)
gg.clearResults()
gun=gg.multiChoice({"ʸᵉˢ","ⁿᵒ"},nil,'ᵈᵒ ʸᵒᵘ ʷᵃⁿᵗ ᶦⁿᶠᶦⁿᶦᵗʸ ʲᵘᵐᵖ')
if gun == nil then else
if gun[1] == true then yesjump() end
if gun[2] == true then nojump() end
end
end

function yesjump()
gg.searchNumber("1.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("999888", gg.TYPE_FLOAT)
gg.clearResults()
end

function nojump()
end

function speedHackMenu()
  filst9 = gg.choice({
    "ᵃˡˡ ˢᵖᵉᵉᵈʰᵃᶜᵏ ᵒᶠᶠ",
    "ˣ² ˢᵖᵉᵉᵈ",
    "ˣ³ ˢᵖᵉᵉᵈ",
    "ˣ⁴ ˢᵖᵉᵉᵈ",
    "ʷᵃˡᵏ ˢᵖᵉᵉᵈ",
  }, nil, "ˢᵖᵉᵉᵈʰᵃᶜᵏ ᵐᵉⁿᵘ")
  if filst9 == nil then
  else
    if filst9 == 1 then
      speedoff2()
    end
    if filst9 == 2 then
      speed22()
    end
    if filst9 == 3 then
      speed32()
    end
    if filst9 == 4 then
      spedd42()
    end
    if filst9 == 5 then
      runmode2()
    end
    if filst9 == 6 then
      ser()
    end
  end
end

function runmode2() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ʷᵃˡᵏ ˢᵖᵉᵉᵈ')
if gun == nil then else
if gun[1] == true then runon() end
if gun[2] == true then runoff() end
end
end

function runon()
gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 898 605 304", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("1", gg.TYPE_DOUBLE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.13", gg.TYPE_DOUBLE)
gg.clearResults()
end

function runoff()
gg.searchNumber("4 515 609 228 898 605 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("0.13", gg.TYPE_DOUBLE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DOUBLE)
gg.clearResults()
end

function spedd42()
  gg.clearResults()
  gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 882 214 912", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 886 409 216", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 890 603 520", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 892 700 672", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 892 700 672", gg.TYPE_QWORD)
  gg.processResume()
end

function speed32()
  gg.clearResults()
  gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 890 603 520", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 882 214 912", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 890 603 520", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 886 409 216", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 890 603 520", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 890 603 520", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 890 603 520", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 892 700 672", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 890 603 520", gg.TYPE_QWORD)
  gg.processResume()
end

function speed22()
  gg.clearResults()
  gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 882 214 912", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 886 409 216", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 890 603 520", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 892 700 672", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 886 409 216", gg.TYPE_QWORD)
  gg.processResume()
end

function speedoff2()
  gg.clearResults()
  gg.searchNumber("4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 882 214 912", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 886 409 216", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 890 603 520", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("4 515 609 228 892 700 672", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("4 515 609 228 873 826 304", gg.TYPE_QWORD)
  gg.processResume()
end

function GGfovGG()
  fov = gg.prompt({
    "ʸᵒᵘʳ ᶠᵒᵛ ᶜᵃᵐᵉʳᵃ",
    "ᵉᵈᶦᵗ ᵗᵒ"
  }, {"60", nil}, {"number", "number"})
  if fov == nil then
  else
  gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber(fov[1], gg.TYPE_FLOAT)
    gg.getResults(100000)
    gg.editAll(fov[2], gg.TYPE_FLOAT)
    gg.toast("ᶠᵒᵛ ᵃᶜᵗᶦᵛᵃᵗᵉᵈ")
    gg.clearResults()
  end
end

function gg5()
choice2=gg.choice({"ᶦⁿᶠᶦⁿᶦᵗᵉ ⁿᶦᶜᵏⁿᵃᵐᵉ","ᶜᵒˡᵒʳ ⁿᶦᶜᵏⁿᵃᵐᵉ","ᶦⁿᶜᵒʳʳᵉᶜᵗ ˢʸᵐᵇᵒˡ","ᵘⁿˡᵒᶜᵏ ᵃˡˡ ᵃⁿᶦᵐᵃᵗᶦᵒⁿ","ᵘⁿˡᵒᶜᵏ ʷᶦᶻᵃʳᵈ ʰᵃᵗ","ᵘⁿˡᵒᶜᵏ ˢᵃⁿᵗᵃ ʰᵃᵗ","ᵘⁿˡᵒᶜᵏ ᵃˡˡ ˢᵏᶦⁿ","ᵘⁿˡᵒᶜᵏ ᶜᵒʳᵖˢᵉ"},nil,'ᵃᶜᶜᵒᵘⁿᵗ')
if choice2 == 1 then infinitynick() end
if choice2 == 2 then colornick() end
if choice2 == 3 then symbol() end
if choice2 == 4 then unlockanim() end
if choice2 == 5 then unlockwizard() end
if choice2 == 6 then unlocksanta() end
if choice2 == 7 then unlockadskin() end
if choice2 == 8 then unlockcorpse() end

if choice2 == nil then else end
end

function infinitynick()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0;16;0;1044957385", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("16", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10000", gg.TYPE_DWORD)
gg.clearResults()
end

function colornick()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
-- <color=black>nickname</a>
end

function symbol()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
end

function unlockanim()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Twerk", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Flair", gg.TYPE_WORD)
gg.clearResults()
gg.searchNumber(";AirSquat", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Backflip", gg.TYPE_WORD)
end

function unlockwizard()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Helmet", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Wizard", gg.TYPE_WORD)
gg.clearResults()
end

function unlocksanta()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Debug", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Santa", gg.TYPE_WORD)
gg.clearResults()
end

function unlockadskin()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Soldier", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Butcher", gg.TYPE_WORD)
gg.clearResults()
gg.searchNumber(";Jean", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(55555, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Swat", gg.TYPE_WORD)
end

function unlockcorpse() 
        gg.setVisible(false)
        if editString('Hero','Corpse') then
            gg.clearResults()
            end
            end

function nanhp()
  god = gg.choice({
    "ᵍᵒᵈᵐᵒᵈᵉ ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵍᵒᵈᵐᵒᵈᵉ ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ⁿᵃⁿ ʰᵖ ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ⁿᵃⁿ ʰᵖ ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ᵍᵒᵈᵐᵒᵈᵉ ᵃⁿᵈ ⁿᵃⁿ ʰᵖ")
  if god == 1 then
    func1()
  end
  if god == 2 then
    turn15()
  end
  if god == 3 then
    GodModevOn()
  end
  if god == 4 then
    GodModevOff()
  end
  if god == nil then
  else
  end
end

function func1()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("h C0 03 5F D6 EF 3B 07 6D", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h FF 83 03 D1 EF 3B 07 6D ED 33 08 6D", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
end

function turn15()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("h FF 83 03 D1 EF 3B 07 6D ED 33 08 6D", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h C0 03 5F D6 EF 3B 07 6D", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
end

function GodModevOn()
gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1117782016D;600.0F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1117782016", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(50, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber("70.0F;600.0F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("70", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(50, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-10", gg.TYPE_FLOAT)
gg.clearResults()
end

function GodModevOff()
end

function jumphacks()
  choice4 = gg.choice({
    "ˡᵒʷ ʲᵘᵐᵖ",
    "ʲᵘᵐᵖ ᵖᵒʷᵉʳ ˣ¹²⁰",
    "ᶦⁿᶠᶦⁿᶦᵗʸ ʲᵘᵐᵖ"
  }, nil, "ʲᵘᵐᵖ ʰᵃᶜᵏ")
  if choice4 == 1 then
    jumplow()
  end
  if choice4 == 2 then
    jumppower()
  end
  if choice4 == 3 then
    jumphck()
  end
  if choice4 == nil then
  else
  end
end

function jumplow()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("40", gg.TYPE_FLOAT)
  gg.getResults(500000)
  gg.editAll("20", gg.TYPE_FLOAT)
  gg.clearResults()
end

function jumppower()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("40", gg.TYPE_FLOAT)
  gg.getResults(500000)
  gg.editAll("220", gg.TYPE_FLOAT)
  gg.clearResults()
end

function jumphck()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("1.1X4", gg.TYPE_FLOAT)
  gg.getResults(1000)
  gg.editAll("999888", gg.TYPE_FLOAT)
  gg.clearResults()
end

function infinitedance() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᶦⁿᶠᶦⁿᶦᵗᵉ ᵈᵃⁿᶜᵉ')
if gun == nil then else
if gun[1] == true then handon88() end
if gun[2] == true then handoff88() end
end
end

function handoff88() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("200000000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(400000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.25", gg.TYPE_FLOAT)
gg.clearResults()
end

function handon88() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.25", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(400000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("200000000", gg.TYPE_FLOAT)
gg.clearResults()
end

function server()
  choice6 = gg.choice({
    "ᵘⁿᵏⁿᵒʷⁿ",
    "ⁿᵒ ᵖᵃˢˢʷᵒʳᵈ",
    "ˢᵖᵃʷⁿ ᵒᵇʲᵉᶜᵗ",
    "ⁿᵒ ᵖʳᶦᵛᵃᵗᵉ ˢᵉʳᵛᵉʳ",
    "ᶠˡʸ ᵃⁿᵈ ⁿᵒᶜˡᶦᵖ",
    "ᵃⁿᵗᶦᵏᶦᶜᵏ"
  }, nil, "ˢᵉʳᵛᵉʳ")
  if choice6 == 1 then
    space()
  end
  if choice6 == 2 then
    nopass()
  end
  if choice6 == 3 then
    spawnobject()
  end
  if choice6 == 4 then
    nopriv()
  end
  if choice6 == 5 then
    flynoclip()
  end
  if choice6 == 6 then
    antikick()
  end
  if choice6 == nil then
  else
  end
end

function space()
gg.searchNumber(";bouncy_ball", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";SpaceShip", gg.TYPE_WORD)
gg.clearResults()
end

function nopass()
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber(";Password", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll(";", gg.TYPE_WORD)
  gg.clearResults()
end

function spawnobject()
gg.searchNumber(";DisableSpawnObject", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";subscribetogameguardianscriptmodded", gg.TYPE_WORD)
gg.clearResults()
end

function nopriv()
choice2=gg.choice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ⁿᵒ ᵖʳᶦᵛᵃᵗᵉ')
if choice2 == 1 then on() end
if choice2 == 2 then off() end

if choice2 == nil then else end
end

function on()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber(";GameMode", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll(";AaAaAaAa", gg.TYPE_WORD)
  gg.clearResults()
end

function off()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber(";AaAaAaAa", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll(";GameMode", gg.TYPE_WORD)
  gg.clearResults()
end

function flynoclip()
choice5=gg.choice({"ˣ² ᶠˡʸ ˢᵖᵉᵉᵈ","ˣ² ⁿᵒᶜˡᶦᵖ ˢᵖᵉᵉᵈ"},nil,'ᶠˡʸ * ⁿᵒᶜˡᶦᵖ')
if choice5 == 1 then fly2() end
if choice5 == 2 then noclip2() end
if choice5 == nil then else end
end

function fly2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.processPause()
gg.clearResults()
gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("16 777 472", gg.TYPE_QWORD)

gg.clearResults()
gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.processResume() 
gg.freeze = true
gg.searchNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10009", gg.TYPE_FLOAT)
gg.processResume() 
gg.clearResults()
gg.searchNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(200000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100009", gg.TYPE_FLOAT)
gg.processResume() 
gg.clearResults()
end

function noclip2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.processPause()
gg.clearResults()
gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("16 777 472", gg.TYPE_QWORD)
gg.clearResults()
gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.freeze = true
gg.clearResults()
gg.searchNumber("-10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(20000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.processResume() 
gg.clearResults()
gg.searchNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(200000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100009", gg.TYPE_FLOAT)
gg.processResume() 
gg.clearResults()
gg.searchNumber("0.2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(200000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100009", gg.TYPE_FLOAT)
gg.processResume() 
gg.clearResults()
end

function antikick()
  kick = gg.choice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ᵃⁿᵗᶦᵏᶦᶜᵏ")
  if kick == 1 then
    AntikickOn()
  end
  if kick == 2 then
    AntikickOff()
  end
  if kick == nil then
  else
  end
end

function AntikickOn()
  gg.setRanges(gg.REGION_CODE_APP)
  gg.searchNumber("h 25 E1 AD 97 FF 03 01 D1 FE 57 02 A9 F4 4F 03 A9", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h C0 03 5F D6 C0 03 5F D6 C0 03 5F D6 C0 03 5F D6", gg.TYPE_BYTE)
  gg.processResume()
  gg.clearResults()
end

function AntikickOff()
  gg.setRanges(gg.REGION_CODE_APP)
  gg.searchNumber("h C0 03 5F D6 C0 03 5F D6 C0 03 5F D6 C0 03 5F D6", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 25 E1 AD 97 FF 03 01 D1 FE 57 02 A9 F4 4F 03 A9", gg.TYPE_BYTE)
  gg.processResume()
  gg.clearResults()
end

function GGWEAPONGG()
  choice2 = gg.choice({
    "ᵍᵘⁿ ᵐᵒᵈᵉ",
    "ᵍᶦᵛᵉ ʷᵉᵃᵖᵒⁿ",
    "ʳᵃᵖᶦᵈᵃˡˡ",
    "ⁿᵒ ʳᵉˡᵒᵃᵈ",
    "ᵃˡˡ ʷᵉᵃᵖᵒⁿ ˢᵖᵉᵉᵈ ˣ ᵃᵐᵐᵒ",
    "ˢᵐᵍ ʳᵖᵍ",
    "ˢᵐᵍ ᵃʳʳᵒʷ",
    "ˢʰᵒᵗᵍᵘⁿ ʳᵖᵍ",
    "ˢᵐᵍ",
    "ˢʰᵒᵗᵍᵘⁿ",
    "ʳᵉᵛᵒˡᵛᵉʳ",
    "ˢⁿᶦᵖᵉʳ",
    "ᵃᵏᵐ",
    "ᵖᶦˢᵗᵒˡ",
    "ʳᵖᵍ",
    "ᶜʳᵒˢˢᵇᵒʷ",
  }, nil, "ʷᵉᵃᵖᵒⁿ")
    if choice2 == 1 then
    GGGG10()
  end
   if choice2 == 2 then
    GGGG20()
  end
  if choice2 == 3 then
    rapidall()
  end
  if choice2 == 4 then
    noreload()
  end
  if choice2 == 5then
    InfinityAmmo()
  end
  if choice2 == 6 then
    Smgrpg()
  end
  if choice2 == 7 then
    Smgarrow()
  end
  if choice2 == 8 then
    shotgunrpg()
  end
  if choice2 == 9 then
    GGGsmgGGG100()
  end
  if choice2 == 10 then
    GGGshotgunGGG200()
  end
  if choice2 == 11 then
    GGGrevolverGGG300()
  end
  if choice2 == 12 then
    GGGsniperGGG400()
  end
  if choice2 == 13 then
    GGGakmGGG500()
  end
  if choice2 == 14 then
    GGGPistolGGG600()
  end
  if choice2 == 15 then
    GGGrpgGGG700()
  end
  if choice2 == 16 then
    GGGcrossGGG800()
  end
  if choice2 == nil then
  else
  end
end

function GGGG10()
filsst12 = gg.multiChoice({
"ˢᵐᵍ&ᵖᶦˢᵗᵒˡ ʳᵖᵍ" .. SSDI17,
"ˢᵐᵍ&ᵖᶦˢᵗᵒˡ ᵃʳʳᵒʷ" .. SSDI18,
"ˢᵐᵍ&ᵖᶦˢᵗᵒˡ ˢʰᵒᵗᵍᵘⁿ" .. SSDI19,
"ᵍᶦᵛᵉ ⁿᵃⁿ ᵖᶦˢᵗᵒˡ" .. SSDI20,
"ᵃᵘᵗᵒ ˢʰᵒᵒᵗ",
},nil,
"ᵍᵘⁿ ᵐᵒᵈᵉ")
if filsst12 == nil then GGGG10() else
if filsst12[1] == true then smgrpg() end
if filsst12[2] == true then smgbowl() end
if filsst12[3] == true then smgshot() end
if filsst12[4] == true then nanpisun() end
if filsst12[5] == true then autoshoot() end
if filsst12[6] == true then GGGG10() end end end

function smgrpg()
if SSDI17 == off then
      SSDI17 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("3", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI17 == on then
      SSDI17 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;3D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("3", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end

function smgbowl()
if SSDI18 == off then
      SSDI18 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI18 == on then
      SSDI18 = off
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;4D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("4", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end

function smgshot()
if SSDI19 == off then
      SSDI19 = on
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI19 == on then
      SSDI19 = off
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;8D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("8", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end

function nanpisun()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("10D;1097859072D;1137180672D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1097859072", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
end

function autoshoot()
gg.alert("ʰᵒˡᵈ ᵗʰᵉ ˢʰᵒᵒᵗ ᵇᵘᵗᵗᵒⁿ ᶦⁿ ⁵ ˢᵉᶜᵒⁿᵈ","ᵒᵏᵃʸ")
gg.toast("1")
gg.sleep(1500)
gg.toast("2")
gg.sleep(1500)
gg.toast("3")
gg.sleep(1050)
gg.toast("4")
gg.sleep(1500)
gg.toast("5")
gg.sleep(1500)
gg.alert("ᴬᵘᵗᵒˢʰᵒᵒᵗ")
end

function GGGG20()
filsst13 = gg.multiChoice({
"ᵗᵒᵒˡᵇᵃᵗᵒⁿ ᵍᶦᵛᵉ" .. SSDI28,
"ʳᵖᵍ ᵍᶦᵛᵉ" .. SSDI27,
"ˢᵐᵍ ᵍᶦᵛᵉ" .. SSDI26,
"ᵃᵏᵐ ᵍᶦᵛᵉ" .. SSDI25,
"ᵇᵃᵗ ᵍᶦᵛᵉ" .. SSDI24,
"ˢⁿᶦᵖᵉʳ ᵍᶦᵛᵉ" .. SSDI23,
"ᵖᶦˢᵗᵒˡ ᵍᶦᵛᵉ" .. SSDI22,
"ᵖʰʸˢᶦᶜˢᵍᵘⁿ ᵍᶦᵛᵉ" .. SSDI21,
},nil,
"ᘜIᐯᗴ ᘜᑌᑎ")
if filsst13 == nil then GGGG20() else
if filsst13[1] == true then giveToolbaton() end
if filsst13[2] == true then giveRPG() end
if filsst13[3] == true then giveSMG() end
if filsst13[4] == true then giveAKM() end
if filsst13[5] == true then giveBat() end
if filsst13[6] == true then giveSniper() end
if filsst13[7] == true then givePistol() end
if filsst13[8] == true then givePhysicsGun() end
if filsst13[9] == true then GGGG20() end end end

function givePhysicsGun()
gg.searchNumber(":PhysicsGun", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Hands", gg.TYPE_BYTE)
gg.clearResults()
end

function givePistol()
gg.searchNumber(":Pistol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Hands", gg.TYPE_BYTE)
gg.clearResults()
end

function giveSniper()
gg.searchNumber(":Sniper", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Hands", gg.TYPE_BYTE)
gg.clearResults()
end

function giveBat()
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Bat", gg.TYPE_BYTE)
gg.clearResults()
end

function giveRPG()
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":RPG", gg.TYPE_BYTE)
gg.clearResults()
end

function giveSMG()
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Smg", gg.TYPE_BYTE)
gg.clearResults()
end

function giveAKM()
gg.searchNumber(":Hands", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Akm", gg.TYPE_BYTE)
gg.clearResults()
end

function giveToolbaton()
gg.searchNumber(":ToolBaton", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Hands", gg.TYPE_BYTE)
gg.clearResults()
end

function rapidall()
 weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"
  }, nil, "ʳᵃᵖᶦᵈᵃˡˡ")
  if weapons == nil then
  else
    if weapons[1] == true then
      rapidon()
    end
    if weapons[2] == true then
      rapidoff()
    end
  end
end

function rapidon()
  gg.setRanges(gg.REGION_CODE_APP)
  gg.searchNumber("QFE'O'BFA913\";\"D0'`fE'F9", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("Q\"@\"001CC003'_'D60000'A'", gg.TYPE_BYTE)
  gg.setRanges(gg.REGION_CODE_APP)
  gg.refineNumber("0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(1, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("79", gg.TYPE_BYTE)
end

function rapidoff()
end

function noreload() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ⁿᵒ ʳᵉˡᵒᵃᵈ')
if gun == nil then else
if gun[1] == true then runon2() end
if gun[2] == true then runoff2() end
end
end

function runon2()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
end

function runoff2()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("hC0035FD6F44F01A9B40401F0", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(99999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hFE0F1EF8F44F01A9B40401F0", gg.TYPE_BYTE)
gg.processResume()
gg.clearResults()
end

function InfinityAmmo()
 weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"
  }, nil, "ˢᵖᵉᵉᵈ ˣ ᵃᵐᵐᵒ")
  if weapons == nil then
  else
    if weapons[1] == true then
      InfinityAmmoOn()
    end
    if weapons[2] == true then
      InfinityAmmoOff()
    end
  end
end

function InfinityAmmoOn()
  gg.searchNumber("257D;20F;10F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("249", gg.TYPE_DWORD)
  gg.clearResults()
end

function InfinityAmmoOff()
  gg.searchNumber("249D;20F;10F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.refineNumber("249", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("257", gg.TYPE_DWORD)
  gg.clearResults()
end

function Smgrpg()
 weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ˢᵐᵍ ʳᵖᵍ")
  if weapons == nil then
  else
    if weapons[1] == true then
      SmgRpgOn()
    end
    if weapons[2] == true then
      SmgRpgOff()
    end
  end
end

function SmgRpgOn()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 03 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function SmgRpgOff()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 03 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function Smgarrow()
  weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ˢᵐᵍ ᵃʳʳᵒʷ")
  if weapons == nil then
  else
    if weapons[1] == true then
      SmgArrowOn()
    end
    if weapons[2] == true then
      SmgArrowOff()
    end
  end
end

function SmgArrowOn()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 04 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function SmgArrowOff()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 04 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function smgshotgun()
  weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ˢᵐᵍ ˢʰᵒᵗᵍᵘⁿ")
  if weapons == nil then
  else
    if weapons[1] == true then
      SmgShotgunOn()
    end
    if weapons[2] == true then
      SmgShotgunOff()
    end
  end
end

function SmgShotgunOn()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 08 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function SmgShotgunOff()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 08 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(25000000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 00 00 00 80 36 07 3F", gg.TYPE_FLOAT)
  gg.clearResults()
  gg.sleep(10)
  gg.searchNumber("h 01 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE)
  gg.clearResults()
end

function shotgunrpg()
  weapons = gg.multiChoice({
    "ᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
    "ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ",
  }, nil, "ˢʰᵒᵗᵍᵘⁿ ʳᵖᵍ")
  if weapons == nil then
  else
    if weapons[1] == true then
      ShotgunRpgOn()
    end
    if weapons[2] == true then
      ShotgunRpgOff()
    end
  end
end

function ShotgunRpgOn()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 08 00 00 00 30 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 03 00 00 00 30 DE 06 50", gg.TYPE_BYTE)
  gg.clearResults()
end

function ShotgunRpgOff()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("h 03 00 00 00 30 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("h 08 00 00 00 30 DE 06 50", gg.TYPE_BYTE)
  gg.clearResults()
end

function GGGsmgGGG100()
filsst14 = gg.multiChoice({
"ˢᵐᵍ ᵛ²",
"ˢᵐᵍ ᵛ¹" .. SSDI2,
"ˢᵐᵍ ˣ ˢⁿᶦᵖᵉʳ ᵈᵃᵐᵃᵍᵉ" .. SSDI3,
},nil,
"gigain")
if filsst14 == nil then GGWEAPONGG() else
if filsst14[1] == true then smgammoV2() end
if filsst14[2] == true then smgammo() end
if filsst14[3] == true then smgbust() end
if filsst14[4] == true then GGWEAPONGG() end end end

function smgammoV2() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ˢᵐᵍ ᵛ²')
if gun == nil then else
if gun[1] == true then FastSmgOn() end
if gun[2] == true then FastSmgOff() end

end
end


function FastSmgOn() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h 01 01 00 00 47 78 9E 6F", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 00 00 00 47 78 9E 6F", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 00 00 00 00 80 36 07 3F", gg.TYPE_BYTE)
gg.clearResults()
end


function FastSmgOff() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h 01 00 00 00 47 78 9E 6F", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 01 00 00 47 78 9E 6F", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber("h 00 00 00 00 80 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(6000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 01 01 00 00 80 36 07 3F", gg.TYPE_BYTE)
gg.clearResults()
end

function smgammo()
if SSDI2 == off then
      SSDI2 = on
gg.searchNumber("30D;10F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI2 == on then
      SSDI2 = off
gg.searchNumber("30D;10F;200F;150D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("150", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end


function smgbust()
if SSDI3 == off then
      SSDI3 = on
gg.searchNumber("30D;10F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI3 == on then
      SSDI3 = off
gg.searchNumber("30D;99999F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.clearResults()
      end
end
end

function GGGshotgunGGG200()
filsst15 = gg.multiChoice({
"ˢʰᵒᵗᵍᵘⁿ ᵛ²",
"ˢʰᵒᵗᵍᵘⁿ ᵛ¹" .. SSDI4,
"ˢʰᵒᵗᵍᵘⁿ ˣ ˢⁿᶦᵖᵉʳ ᵈᵃᵐᵃᵍᵉ" .. SSDI5,
},nil,
"gigain")
if filsst15 == nil then GGWEAPONGG() else
if filsst15[1] == true then shotammoV() end
if filsst15[2] == true then shotammo() end
if filsst15[3] == true then shotbust() end
if filsst15[4] == true then GGWEAPONGG() end end end

function shotammoV() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,"ˢʰᵒᵗᵍᵘⁿ ᵛ²") 
if gun == nil then else 
if gun[1] == true then FastShotgunOn() end
if gun[2] == true then FastShotgunOff() end
end
end

function FastShotgunOn() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h 01 01 00 00 58 F1 5B 68", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 01 00 00 00 58 F1 5B 68", gg.TYPE_BYTE)
gg.clearResults()
gg.sleep(10)
gg.searchNumber("h 01 01 00 00 30 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 01 00 00 00 30 DE 06 50", gg.TYPE_BYTE)
gg.clearResults()
end

function FastShotgunOff() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("h 01 00 00 00 58 F1 5B 68", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 01 01 00 00 58 F1 5B 68", gg.TYPE_BYTE)
gg.clearResults()
gg.sleep(10)
gg.searchNumber("h 01 00 00 00 30 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(10000000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h 01 01 00 00 30 DE 06 50", gg.TYPE_BYTE)
gg.clearResults()
end

function shotammo()
if SSDI4 == off then
      SSDI4 = on
gg.searchNumber("6D;20F;400F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI4 == on then
      SSDI4 = off
gg.searchNumber("6D;20F;400F;150D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("150", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      end
end
end


function shotbust()
if SSDI5 == off then
      SSDI5 = on
gg.searchNumber("6D;20F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI5 == on then
      SSDI5 = off
gg.searchNumber("30D;99999F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("20", gg.TYPE_FLOAT)
gg.clearResults()
      end
end
end

function GGGrevolverGGG300()
filsst17 = gg.multiChoice({
"ʳᵉᵛᵒˡᵛᵉʳ ᵛ¹" .. SSDI6,
"ʳᵉᵛᵒˡᵛᵉʳ ˣ ˢⁿᶦᵖᵉʳ ᵈᵃᵐᵃᵍᵉ" .. SSDI7,
},nil,
"gigain")
if filsst17 == nil then GGWEAPONGG() else
if filsst17[1] == true then revammo() end
if filsst17[2] == true then revbust() end
if filsst17[3] == true then GGWEAPONGG() end end end

function revammo()
if SSDI6 == off then
      SSDI6 = on
gg.searchNumber("6D;40F;100F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI6 == on then
      SSDI6 = off
gg.searchNumber("6D;40F;100F;150D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("150", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end


function revbust()
if SSDI7 == off then
      SSDI7 = on
gg.searchNumber("6D;40F;100F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("40", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI7 == on then
      SSDI7 = off
gg.searchNumber("6D;99999F;100F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("40", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function GGGsniperGGG400()
filsst19 = gg.multiChoice({
"ˢⁿᶦᵖᵉʳ ᵛ¹" .. SSDI8,
"ˢⁿᶦᵖᵉʳ ˣ ⁹⁹⁹ ᵈᵃᵐᵃᵍᵉ" .. SSDI9,
},nil,
"gigain")
if filsst19 == nil then GGWEAPONGG() else
if filsst19[1] == true then sniperammo() end
if filsst19[2] == true then sniperbust() end
if filsst19[3] == true then GGWEAPONGG() end end end

function sniperammo()
if SSDI8 == off then
      SSDI8 = on
gg.searchNumber("5D;90F;500F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI8 == on then
      SSDI8 = off
gg.searchNumber("5D;90F;500F;150D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("150", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end


function sniperbust()
if SSDI9 == off then
      SSDI9 = on
gg.searchNumber("5D;90F;500F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("90", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI9 == on then
      SSDI9 = off
gg.searchNumber("5D;99999F;500F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(l, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("90", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end


function GGGakmGGG500()
filsst30 = gg.multiChoice({
"ᵃᵏᵐ ᵛ¹" .. SSDI10,
"ᵃᵏᵐ ˣ ˢⁿᶦᵖᵉʳ ᵈᵃᵐᵃᵍᵉ" .. SSDI11,
},nil,
"gigain")
if filsst30 == nil then GGWEAPONGG() else
if filsst30[1] == true then akmammo() end
if filsst30[2] == true then akmbust() end
if filsst30[3] == true then GGWEAPONGG() end end end

function akmammo()
if SSDI10 == off then
      SSDI10 = on
gg.searchNumber("30D;15F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI10 == on then
      SSDI10 = off
gg.searchNumber("30D;15F;200F;150D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("150", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end


function akmbust()
if SSDI11 == off then
      SSDI11 = on
gg.searchNumber("30D;15F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("15", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI11 == on then
      SSDI11 = off
gg.searchNumber("100D;99999F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function GGGPistolGGG600()
filsst17 = gg.multiChoice({
"ᵖᶦˢᵗᵒˡ ᵛ¹" .. SSDI51,
"ᵖᶦˢᵗᵒˡ ˣ ˢⁿᶦᵖᵉʳ ᵈᵃᵐᵃᵍᵉ" .. SSDI52,
},nil,
"gigain")
if filsst17 == nil then GGWEAPONGG() else
if filsst17[1] == true then pistolammo() end
if filsst17[2] == true then pistolbust() end
if filsst17[3] == true then GGWEAPONGG() end end end

function pistolammo()
if SSDI51 == off then
      SSDI51 = on
gg.searchNumber("10D;1097859072D;1137180672D;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("60", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI51 == on then
      SSDI51 = off
gg.searchNumber("10D;1097859072D;1137180672D;60D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("60", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end


function pistolbust()
if SSDI52 == off then
      SSDI52 = on
gg.searchNumber("10D;1097859072D;1137180672D", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1097859072", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2000000000", gg.TYPE_FLOAT)
gg.clearResults()
else if SSDI52 == on then
      SSDI52 = off
gg.searchNumber("10D;2000000000D;1137180672D", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2000000000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1097859072", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function GGGrpgGGG700() 
end

function GGGcrossGGG800()
filsst17 = gg.multiChoice({
"ᶜʳᵒˢˢᵇᵒʷ ᵛ¹" .. SSDI54,
},nil,
"gigain")
if filsst17 == nil then GGWEAPONGG() else
if filsst17[1] == true then crossammo() end
if filsst17[2] == true then GGWEAPONGG() end end end

function crossammo()
if SSDI54 == off then
      SSDI54 = on
gg.searchNumber(" 1D;4D;80F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if SSDI54 == on then
      SSDI54 = off
gg.searchNumber("1D;4D;80F;0D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("257", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function vipandpre()
choice3=gg.choice({"ᵛᶦᵖ","ᵖʳᵉᵐᶦᵘᵐ",})
if choice3 == 1 then vip() end
if choice3 == 2 then prem() end
end

function vip()
  choice2 = gg.choice({
    "ᴷᵃᵗᵃⁿᵃ ᵃᶦᵐ",
    "ᵍᵘⁿ ˢᶦᶻᵉ",
    "ᶜᵃᵐᵉʳᵃ ᵖˡᵃʸᵉʳ",
    "ᵍˡᶦᵗᶜʰ ᵃˡˡ ʷᵉᵃᵖᵒⁿ",
    "ᵃˡˡ ʷᵉᵃᵖᵒⁿ ʰᵃᶜᵏ",
    "ᵃᶦʳʳᵒᶜᵏᵉᵗ",
    "𒌧𒂝",
    "ᶜʳᵃˢʰ ᶜʰᵃᵗ",
    "ᵃⁿᵗᶦᶜʳᵃˢʰ ᶜʰᵃᵗ"
  }, nil, "ᵛᶦᵖ")
  if choice2 == 1 then
    katana()
  end
  if choice2 == 2 then
    a450()
  end
  if choice2 == 3 then
    a200()
  end
  if choice2 == 4 then
    a()
  end
  if choice2 == 5 then
    aa()
  end
  if choice2 == 6 then
    aaa()
  end
  if choice2 == 7 then
    aaaa()
  end
  if choice2 == 8 then
    aaaaa()
  end
  if choice2 == 9 then
    aaaaaa()
  end
  if choice2 == nil then
  else
  end
end

function katana() 
gun=gg.multiChoice({"ᵃᶜᵗᶦᵛᵃᵗᵉᵈ","ᵈᵉᵃᶜᵗᶦᵛᵃᵗᵉᵈ"},nil,'ᵏᵃᵗᵃⁿᵃ')
if gun == nil then else
if gun[1] == true then katanaon() end
if gun[2] == true then katanaoff() end
end
end

function katanaon()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("99999", gg.TYPE_FLOAT)
gg.clearResults()
end

function katanaoff()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("99999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_FLOAT)
gg.clearResults()
end

function a450()
  fov = gg.prompt({
    "ʸᵒᵘʳ ᵍᵘⁿ ˢᶦᶻᵉ",
    "ᵉᵈᶦᵗ ᵗᵒ"
  }, {"8", nil}, {"number", "number"})
  if fov == nil then
  else
  gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber(fov[1], gg.TYPE_FLOAT)
    gg.getResults(100000)
    gg.editAll(fov[2], gg.TYPE_FLOAT)
    gg.toast(" ")
    gg.clearResults()
  end
end

function a200()
choice3=gg.choice({"ᵗᵃˡˡ","ˢʰᵒʳᵗ","ᵘⁿᵈᵉʳ","ˢᵘᵖᵉʳ ˢᵖᵉᵉᵈ ʲᵘᵐᵖ","ˢᵏʸ","ʷᵃˡˡ",})
if choice3 == 1 then gg500() end
if choice3 == 2 then gg700() end
if choice3 == 3 then gg900() end
if choice3 == 4 then gg1200() end
if choice3 == 5 then gg1400() end
if choice3 == 6 then gg1600() end
end

function gg500() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon1() end
if gun[2] == true then cameraoff1() end
end
end

function cameraon1()
gg.searchNumber("0.72000002861", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "1"
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
end

function cameraoff1()
gg.searchNumber("1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.72000002861"
		v.freeze = false
	end
end
gg.addListItems(t)
t = nil
end

function gg700() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon2() end
if gun[2] == true then cameraoff2() end
end
end

function cameraon2()
gg.searchNumber("0.72000002861", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.1"
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
end

function cameraoff2()
gg.searchNumber("0.1", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.72000002861"
		v.freeze = false
	end
end
gg.addListItems(t)
t = nil
end

function gg900() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon3() end
if gun[2] == true then cameraoff3() end
end
end

function cameraon3()
gg.searchNumber("0.72000002861", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "-5"
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
end

function cameraoff3()
gg.searchNumber("-5", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.72000002861"
		v.freeze = false
	end
end
gg.addListItems(t)
t = nil
end

function gg1200() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon4() end
if gun[2] == true then cameraoff4() end
end
end

function cameraon4()
gg.copyText("0.72000002861")
gg.clearResults()
gg.searchNumber("0.72000002861", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("1", gg.TYPE_FLOAT)
    gg.sleep(1)
    gg.setValues(revert)
    gg.editAll("4", gg.TYPE_FLOAT)
    gg.sleep(1)
end
end

function cameraoff4()
gg.toast("ᑎOT YᗴT") 
end

function gg1400() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon5() end
if gun[2] == true then cameraoff5() end
end
end

function cameraon5()
gg.searchNumber("0.72000002861", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "460"
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
end

function cameraoff5()
gg.searchNumber("460", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.72000002861"
		v.freeze = false
	end
end
gg.addListItems(t)
t = nil
end

function gg1600() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ"},nil,'ᶜᵃᵐ')
if gun == nil then else
if gun[1] == true then cameraon6() end
if gun[2] == true then cameraoff6() end
end
end

function cameraon6()
gg.searchNumber("0.56999999285", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "-6"
		v.freeze = true
	end
end
gg.addListItems(t)
t = nil
end

function cameraoff6()
gg.searchNumber("-6", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
local t = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(t) do
	if v.flags == gg.TYPE_FLOAT then
		v.value = "0.56999999285"
		v.freeze = false
	end
end
gg.addListItems(t)
t = nil
end

function a()
if SSDI12 == off then
      SSDI12 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("999", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI12 == on then
      SSDI12 = off
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("30", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function aa()
gg.clearResults()
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("3", gg.TYPE_DWORD)
    gg.sleep(50)
    gg.setValues(revert)
    gg.editAll("4", gg.TYPE_DWORD)
    gg.sleep(50)
    gg.setValues(revert)
    gg.editAll("8", gg.TYPE_DWORD)
    gg.sleep(50)
    gg.setValues(revert)
    gg.editAll("1", gg.TYPE_DWORD)
    gg.sleep(50)
end
end

function aaa()
if SSDI14 == off then
      SSDI14 = on
gg.searchNumber("3D;0.02F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("0.02", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15.0", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI14 == on then
      SSDI14 = off
gg.searchNumber("3D;5.0F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("5.0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.02", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function aaaa()
if SSDI15 == off then
      SSDI15 = on
gg.searchNumber("0.3", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2.4", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI15 == on then
      SSDI15 = off
	  gg.searchNumber("2.4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0.3", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function aaaaa()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
gg.copyText("<quad size=-9911111999999 width=991111199999>")
gg.searchNumber(":<color=red", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":drynessmeter", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber(";<color=red", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";drynessmeter", gg.TYPE_WORD)
gg.clearResults()
gg.alert("Paste the copied text into the chat. Everyone will crash, but you won't. Your chat will disappear. Then, when you leave the server, click the function again to disable it.")
end

function aaaaaa()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";<color=red", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";drynessmeter", gg.TYPE_WORD)
gg.clearResults()
end

function prem()
  choice2 = gg.choice({
    "ʰᵃⁿᵈˢ ʷᵉᵃᵖᵒⁿ",
    "ʷᵃˡˡʰᵃᶜᵏ ᵖʳᵒᵖ",
    "ˢᵘᵖᵉʳ ˢᵖᵉᵉᵈ ᶜᵃʳ",
    "ˢˡᶦᵈᵉ ᶜᵃʳ",
    "ᶜʰᵃᵐ",
    "ᵃᶦᵐᵇᵒᵗ ʳᵒᶜᵏᵉᵗ"
  }, nil, "ᵖʳᵉᵐᶦᵘᵐ")
  if choice2 == 1 then
    arrowandrpg()
  end
  if choice2 == 2 then
    aa2()
  end
  if choice2 == 3 then
    aaa2()
  end
  if choice2 == 4 then
    aaaa2()
  end
  if choice2 == 5 then
    aaaaa2()
  end
  if choice2 == 6 then
    aaaaaa2()
  end
  if choice2 == nil then
  else
  end
end

function arrowandrpg()
choice3=gg.choice({"ᵃʳʳᵒʷ","ʳᵖᵍ","ˢʰᵒᵗᵍᵘⁿ",})
if choice3 == 1 then gg400() end
if choice3 == 2 then gg600() end
if choice3 == 3 then gg800() end
end

function gg400() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ","ʰᵃⁿᵈ ˣ ᵃʳʳᵒʷ ˣ ᶠᵃˢᵗ"},nil,'ʰᵃⁿᵈ')
if gun == nil then else
if gun[1] == true then handon2() end
if gun[2] == true then handoff2() end
if gun[3] == true then handfast2() end
end
end

function handoff2() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;4D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("4", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function handon2() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
end

function handfast2() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function gg600() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ","ʰᵃⁿᵈ ˣ ʳᵖᵍ ˣ ᶠᵃˢᵗ"},nil,'ʰᵃⁿᵈ')
if gun == nil then else
if gun[1] == true then handon3() end
if gun[2] == true then handoff3() end
if gun[3] == true then handfast3() end
end
end

function handoff3()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;4.20389539e-45F;2F;15F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("4.20389539e-45", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2.80259693e-45", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function handon3() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2.80259693e-45F;2F;15F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2.80259693e-45", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4.20389539e-45", gg.TYPE_FLOAT)
end

function handfast3()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2.80259693e-45F;2F;15F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2.80259693e-45", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4.20389539e-45", gg.TYPE_FLOAT)
gg.clearResults()
gg.searchNumber("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function gg800() 
gun=gg.multiChoice({"ᵒⁿ","ᵒᶠᶠ","ʰᵃⁿᵈ ˣ ˢʰᵒᵗᵍᵘⁿ ˣ ᶠᵃˢᵗ"},nil,'ʰᵃⁿᵈ')
if gun == nil then else
if gun[1] == true then handon4() end
if gun[2] == true then handoff4() end
if gun[3] == true then handfast4() end
end
end

function handoff4() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;8D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("8", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function handon4() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_DWORD)
gg.clearResults()
end

function handfast4() 
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1D;2D;2F;15F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("2", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(300, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber("h 01 01 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.getResults(5000)
gg.editAll("h 01 00 00 00 A0 CF BD", gg.TYPE_BYTE)
gg.clearResults()
end

function aa2()
gg.searchNumber("-10X4", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("-10X8", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
revert = gg.getResults(999999, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.processResume()
gg.clearResults()
end

function aaa2()
if SSDI29 == off then
      SSDI29 = on
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("20000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI29 == on then
      SSDI29 = off
gg.searchNumber("20000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function aaaa2()
if SSDI30 == off then
      SSDI30 = on
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("2000000000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗩᑕTIᐯᗩTᗴᗪ")
else if SSDI30 == on then
      SSDI30 = off
gg.searchNumber("2000000000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("ᗪᗴᗩᑕTIᐯᗩTᗴᗪ")
      end
end
end

function aaaaa2()
filsst4 = gg.multiChoice({
    "ᖇᗩIᑎᗷOᗯ ᑕᕼᗩᗰՏ (V1)" .. SSDI39,
    "ᖇᗩIᑎᗷOᗯ ᑕᕼᗩᗰՏ (V2) + ᖴᗩՏT" .. SSDI40,
    "ᖇᗴᗪ" .. SSDI42,
    "ᘜᖇᗴᗴᑎ" .. SSDI43,
    "ᗷᒪᑌᗴ" .. SSDI44,
    "ᗷᒪᑌᗴ ᑎᗴOᑎ" .. SSDI45,
    "ᘜᖇᗴᗴᑎ ᑎᗴOᑎ" .. SSDI46,
    "ᘜᖇᗴᗴᑎ+ᐯIOᒪᗴT" .. SSDI47,
    "ᘜᖇᗴᗴᑎ+ᐯIOᒪᗴT ᑎᗴOᑎ" .. SSDI48,
    "ᘜᖇᗴᗴᑎ+ᐯIOᒪᗴT ᖴᗩՏT" .. SSDI49,
    "ᑭᗩᖇTIᗩᒪᒪY ᗷᒪᑌᗴ" .. SSDI50,
}, nil, "ᗯᕼᗩT ᑕOᒪOᖇ ᐯIՏᑌᗩᒪ YOᑌ ᗯᗩᑎT")

if filsst4 == nil then return end
    if filsst4[1] == true then RainbowChamsV1() end
    if filsst4[2] == true then RainbowChamsV2() end
    if filsst4[3] == true then RedChams() end
    if filsst4[4] == true then GreenChams() end
    if filsst4[5] == true then BlueChams() end
    if filsst4[6] == true then BlueNeon() end
    if filsst4[7] == true then GreenNeon() end
    if filsst4[9] == true then GreenViolet() end
    if filsst4[10] == true then GreenVioletNeon() end
    if filsst4[11] == true then GreenVioletFast() end
    if filsst4[12] == true then PartiallyBlue() end
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

function RainbowChamsV2()
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

function aaaaaa2()
gg.clearResults()
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000)

while true do
    gg.setValues(revert)
    gg.editAll("3", gg.TYPE_DWORD)
    gg.sleep(1200)
    gg.setValues(revert)
    gg.editAll("1", gg.TYPE_DWORD)
    gg.sleep(1200)
end
end



function best()
print('ᵍᵒᵒᵈᵇʸᵉ')
os.exit()
end

while true do
if gg.isVisible(true) then
Notch = 1
gg.setVisible(false)
end
if Notch == 1 then menu() end
end