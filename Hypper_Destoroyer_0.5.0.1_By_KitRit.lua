off = " Off"
on = " On"
S1 = off  
S2 = off  
S3 = off  
S4 = off  
S5 = off  
S6 = off  
S7 = off  
S8 = off  
S9 = off  
S10 = off  
S11 = off  
S12 = off  
S13 = off  
S14 = off  
S15 = off  
S16 = off  
S17 = off  
S18 = off  
S19 = off  
S20 = off  
S21 = off  
S22 = off  
S23 = off  
S24 = off  
S25 = off  
S26 = off  
S27 = off  
S28 = off  
S29 = off  
S30 = off  
S31 = off  
S32 = off  
S33 = off  
S34 = off  
S35 = off  
S36 = off  
S37 = off  
S38 = off  
S39 = off  
S40 = off  
S41 = off  
S42 = off  
S43 = off  
S44 = off  
S45 = off  
S46 = off  
S47 = off  
S48 = off  
S49 = off  
S50 = off  
S51 = off  
S52 = off  
S53 = off  
S54 = off  
S55 = off  
S56 = off  
S57 = off  
S58 = off  
S59 = off  
S60 = off  
S61 = off  
S62 = off  
S63 = off  
S64 = off  
S65 = off  
S66 = off  
S67 = off  
S68 = off  
S69 = off  
S70 = off  
S71 = off  
S72 = off  
S73 = off  
S74 = off  
S75 = off  
S76 = off  
S77 = off  
S78 = off  
S79 = off  
S80 = off  
S81 = off  
S82 = off  
S83 = off  
S84 = off  
S85 = off  
S86 = off  
S87 = off  
S88 = off  
S89 = off  
S90 = off  
S91 = off  
S92 = off  
S93 = off  
S94 = off  
S95 = off  
S96 = off  
S97 = off  
S98 = off  
S99 = off  
S100 = off
S101 = off
S102 = off
S103 = off
S104 = off
S105 = off
S106 = off
S107 = off
S108 = off
S109 = off
S110 = off
S111 = off
S112 = off
S113 = off
S114 = off
S115 = off
S116 = off
S117 = off
S118 = off
S119 = off
S120 = off
S121 = off
S122 = off
S123 = off
S124 = off
S125 = off
S126 = off
S127 = off
S128 = off
S129 = off
S130 = off
S131 = off
S132 = off
S133 = off
S134 = off
S135 = off
S136 = off
S137 = off
S138 = off
S139 = off
S140 = off
S141 = off
S142 = off
S143 = off
S144 = off
S145 = off
S146 = off
S147 = off
S148 = off
S149 = off
S150 = off
S151 = off
S152 = off
S153 = off
S154 = off
S155 = off
S156 = off
S157 = off
S158 = off
S159 = off
S160 = off
S161 = off
S162 = off
S163 = off
S164 = off
S165 = off
S166 = off
S167 = off
S168 = off
S169 = off
S170 = off
S171 = off
S172 = off
S173 = off
S174 = off
S175 = off
S176 = off
S177 = off
S178 = off
S179 = off
S180 = off
S181 = off
S182 = off
S183 = off
S184 = off
S185 = off
S186 = off
S187 = off
S188 = off
S189 = off
S190 = off
S191 = off
S192 = off
S193 = off
S194 = off
S195 = off
S196 = off
S197 = off
S198 = off
S199 = off
S200 = off


-- Система хука
local gg = gg

local lib = "libil2cpp.so"
local info = gg.getTargetInfo()
local title = info.label
local ON = "> ＯＮ =\t" local OFF = ""

local bases, index, status = {}, 0, 0
local ranges = gg.getRangesList(lib)
if #ranges == 0 then status = 2 goto SPLIT end

for _, r in ipairs(ranges) do
    if r.state == "Xa" then
        index = index + 1
        bases[index] = r.start
        status = 1
    end
end

::SPLIT::
if status == 2 then
    local found, sizes, count = false, {}, 0
    ranges = gg.getRangesList()
    for _, r in ipairs(ranges) do
        if r.state == "Xa" and r.name:match("split_config") then found = true end
    end
    if not found then print("No split lib."); gg.setVisible(true); os.exit() end
    for _, r in ipairs(ranges) do
        if r.state == "Xa" then
            count = count + 1
            sizes[count] = r["end"] - r.start
        end
    end
    if count > 0 then
        local max = math.max(table.unpack(sizes))
        for _, r in ipairs(ranges) do
            if r.state == "Xa" and (r["end"] - r.start) == max then
                index = index + 1
                bases[index] = r.start
                status = 1
            end
        end
    end
end

if status ~= 1 then print("Lib not found."); gg.setVisible(true); os.exit() end

local orig = {}

function reset(off)
    if orig[off] then
        gg.setValues(orig[off])
        gg.sleep(1000)
    else
        gg.alert("ERR")
    end
end

function setHex(offset, hex)
    local base = bases[index]
    if not orig[offset] then
        local backup, patch, total = {}, {}, 0
        for h in string.gmatch(hex, "%S%S") do
            local addr = base + offset + total
            table.insert(backup, {address = addr, flags = gg.TYPE_BYTE})
            table.insert(patch, {address = addr, flags = gg.TYPE_BYTE, value = h .. "r"})
            total = total + 1
        end
        orig[offset] = gg.getValues(backup)
        gg.setValues(patch)
    else
        local patch, total = {}, 0
        for h in string.gmatch(hex, "%S%S") do
            table.insert(patch, {address = base + offset + total, flags = gg.TYPE_BYTE, value = h .. "r"})
            total = total + 1
        end
        gg.setValues(patch)
    end
end

function setValue(offset, flags, value)
    local base = bases[index]
    local addr = base + offset
    if not orig[offset] then
        orig[offset] = gg.getValues({{address = addr, flags = flags}})
    end
    gg.setValues({{address = addr, flags = flags, value = value}})
    -- setValue(0x2C98678, 4, "~A8 RET") -- Void Disable
end


local edit, end_hook, aaaa, a, b
local xg = {}

local edi, ed = "0x", "-0x"

function ISAOffset()
    local xHEX = string.format("%X", aaaa)
    if #xHEX > 8 then xHEX = xHEX:sub(#xHEX - 7) end
    edit = "~A8 B [PC,#" .. edi .. xHEX .. "]"
end

function ISAOffsetNeg()
    local xHEX = string.format("%X", b - a)
    if #xHEX > 8 then xHEX = xHEX:sub(#xHEX - 7) end
    edit = "~A8 B [PC,#" .. ed .. xHEX .. "]"
end

function gets(g)
    gg.loadResults(end_hook)
    xg[g] = gg.getResults(gg.getResultsCount())
    gg.clearResults()
end

function endhook(cc, g)
    local eh = {}
    eh[1] = {address = bases[index] + cc, flags = gg.TYPE_DWORD, value = xg[g][1].value, freeze = true}
    gg.addListItems(eh)
    gg.clearList()
end

function call_void(cc, ref, g)
    local p = {}
    p[1] = {address = bases[index] + cc, flags = gg.TYPE_DWORD}
    gg.addListItems(p)
    gg.loadResults(p)
    end_hook = gg.getResults(1)
    gets(g)
    a = bases[index] + ref
    b = bases[index] + cc
    aaaa = a - b
    if tonumber(aaaa) < 0 then ISAOffsetNeg() else ISAOffset() end
    p[1] = {address = bases[index] + cc, flags = gg.TYPE_DWORD, value = edit, freeze = true}
    gg.addListItems(p)
    gg.clearList()
end

-- система стринг эдитора [авто]
-- if editString('Старое название', 'Новое название') then — включение
-- if endString('Старое название', 'Новое название') then — выключение
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

-- Система отката и патча оффсетов. (Если функции будут использоваться в других приложениях = будет ошибка.)
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

-- ===== БЛОК: проверка ключа (вставить В НАЧАЛО) =====
local paste_keys_url = "https://pastebin.com/raw/3bTrDiMh"

local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

-- Получаем список ключей с Pastebin
local ok, resp = pcall(gg.makeRequest, paste_keys_url)
if not ok or not resp or not resp.content then
    gg.alert("Ошибка: не удалось звгрузить ключ. Выдайте скрипту доступ к интернету.")
    os.exit()
end

local valid_keys = {}
for line in resp.content:gmatch("[^\r\n]+") do
    line = trim(line)
    if line ~= "" then valid_keys[line] = true end
end

if next(valid_keys) == nil then
    gg.alert("Ошибка: в Pastebin нет ключей. Доступ закрыт.")
    os.exit()
end

-- Просим ключ НЕЗАМЕДЛИТЕЛЬНО при старте (всегда показывать панель ввода)
local input = gg.prompt({"Приветствуем вас в Hypper Destroyer 3.0, By KitRit. Для того чтобы получить доступ к скрипту введите команду /key в @hahol_robot , затем скопируйте и введите ключ:"}, {""}, {"text"})
if not input then
    gg.toast("Отменено пользователем")
    os.exit()
end

local entered = trim(tostring(input[1] or ""))

if entered == "" then
    gg.alert("Ключ пустой.")
    os.exit()
end

if not valid_keys[entered] then
    gg.alert("Неверный ключ. Попробуйте заново запросить у бота.")
    os.exit()
end

-- Ключ верный — ставим флаг и позволяем остальному коду загружаться
_G.__KEY_OK = true
gg.toast("Ключ принят.")
-- ===== Конец блока проверки ключа =====

function Main()
    while true do
        if gg.isVisible(true) then
            Sanbox = 1
            gg.setVisible(false)
			Main()
        end
        
        if Sanbox == 1 then
            Sanbox = 0
            S0nbox = gg.multiChoice({
                "➤ Option: Main",
                "➤ Option: Account", 
                "➤ Option: Server",
                "➤ Option: Visual",
                "➤ Option: Weapons",
				"➤ Option: Other",
				"➤ Info Script",
                "Exit"
            }, nil, 
            "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
            
            -- Добавляем проверку на nil и пустой выбор
            if S0nbox == nil then
                gg.toast("Menu closed")
                return
            end
            
            -- Проверяем каждый элемент массива
            for i = 1, 8 do
                if S0nbox[i] then
                    if i == 1 then 
                        Giga()
                    elseif i == 2 then 
                        Account()
                    elseif i == 3 then 
                        Server()
                    elseif i == 4 then 
                        Visual()
                    elseif i == 5 then
                        Weapon()
                    elseif i == 6 then
					    Other()
                    elseif i == 7 then
					    Info()
                    elseif i == 8 then
                        gg.toast("Hypper Sandbox")
                        os.exit()
                    end
                    break -- выходим после первого найденного выбора
                end
            end
        end
    end
end

function Giga()
filsst3 = gg.multiChoice({
    "➤ Anti kick",
    "➤ God mode",
    "➤ Crash Text",
    "➤ Destroy Server",
    "➤ Ownership props" .. S45,
    "➤ Delete All props" .. S46,
    "➤ Unfreeze All props" .. S47,
    "➤ Explode All Vehicles" .. S48,
	"➤ Tornado v3" .. S1,
	"➤ Multimine" .. S30,
    "➤ Invisible V2" .. S31,
	"➤ Infinity Props" .. S49,
	"➤ Infinity Vehicle" .. S50,
"Back"
}, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")

if filsst3 == nil then return end
    if filsst3[1] == true then kick() end
    if filsst3[2] == true then god() end
    if filsst3[3] == true then text() end
    if filsst3[4] == true then crash() end
    if filsst3[5] == true then ownProps() end
    if filsst3[6] == true then deleteProps() end
    if filsst3[7] == true then unfreezeProps() end
    if filsst3[8] == true then explodeVehicles() end
	if filsst3[9] == true then Tornado() end
	if filsst3[10] == true then Multimine() end
    if filsst3[11] == true then invisibleV2() end
	if filsst3[12] == true then InfinityProps() end
	if filsst3[13] == true then InfinityVehicles() end
    if filsst3[14] == true then Main() end 
	end
	
	function invisibleV2()
    if S31 == off then
        S31 = on
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x1638DDC, patchData, "invisible") then
            gg.toast("Activated!")
        end
    else
        S31 = off
        if endOffset("invisible") then
            gg.toast("Deactivated!")
        end
    end
end
	
	function Multimine() 
	    if S30 == off then
        S30 = on
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x37D1EC, patchData, "multimine") then
            gg.toast("Activated!")
        end
    else
        S30 = off
        if endOffset("multimine") then
            gg.toast("Deactivated!")
        end
    end
end


	function Tornado()
	S1 = on
	gg.alert('Чтобы управлять пропами (торнадо) включите владение пропами, затем анфризните их. Выберите на любое оружие режим рпг, тогда пропы полетят за ракетой.')
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
	
function InfinityProps()
    if S49 == off then
        S49 = on
        local patchData = {
            {offset = 4, value = '5280F460h', flags = gg.TYPE_DWORD},
            {offset = 4, value = '72A00C80h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x395ACC, patchData, "infP") then
            gg.toast("Activated!")
        end
    else
        S49 = off
        if endOffset("infP") then
            gg.toast("Deactivated!")
        end
    end
end

function InfinityVehicles()
    if S50 == off then
        S50 = on
        local patchData = {
            {offset = 4, value = '5280F460h', flags = gg.TYPE_DWORD},
            {offset = 4, value = '72A00C80h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x395F40, patchData, "infV") then
            gg.toast("Activated!")
        end
    else
        S50 = off
        if endOffset("infV") then
            gg.toast("Deactivated")
        end
    end
end

function ownProps()
    if S45 == off then
        S45 = on
       call_void(0x3A6C70, 0x3A7268, 1)
    end
end

function deleteProps()
    if S46 == off then
        S46 = on
       call_void(0x3A6C70, 0x3A71FC, 1)
    else
        S46 = off
        endhook(0x3A6C70, 1)
    end
end

function unfreezeProps()
gg.alert("Перезайди на сервер и вруби OwnProps")
    if S47 == off then
        S47 = on
       call_void(0x3A6E3C, 0x3A69B0, 1)
    else
        S47 = off
        endhook(0x3A6E3C, 1)
    end
end

function explodeVehicles()
    if S48 == off then
        S48 = on
       call_void(0x3C7A60, 0x3C6B18, 1)
    else
        S48 = off
        endhook(0x3C7A60, 1)
    end
end

	function crash()
	local menu2 = gg.alert('Какой тип функции хотите запустить?', 'Free', 'Premium')
if menu == 0 then -- User can cancel alert window by pressing "back" button
elseif menu2 == 1 then
gg.alert("Так как это премиум функция вот описание бесплатной: в бесплатной версии реализован аналог destroy all с ручным, а не автоматическим запуском. Несмотря на отличающийся алгоритм работы, его функциональность и эффективность практически не уступают оригиналу.")
gg.alert("В поле Имя объекта спавнера введите: Kitriter. В поле Дистанции установите: 1.123. Время на выполнение: 10 секунд.")
gg.sleep(10000)
gg.searchNumber("h 77 BE 8F 3F 00 00 00 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("h 77 BE 8F 3F 00 00 00 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("h FF FF FF FF FF FF FF FF", gg.TYPE_BYTE)
gg.clearResults()
gg.searchNumber(";Kitriter", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";Aircraft", gg.TYPE_WORD)
gg.clearResults()
elseif menu2 == 2 then
gg.alert('Чтобы купить функцию напишите мне в телеграмм.')
end
end

	
	function text()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, "60", "60", nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
gg.searchNumber(";<color=red", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(";KitRit-top", gg.TYPE_WORD)
gg.clearResults()
gg.alert("вставь скопированный текст в чат. Всех крашнет а тебя нет. У тебя чат станет чуть хуже выглядеть.")
gg.copyText("<quad size=-99999999 width=991111199999>")
gg.alert("Нужно также поставить два пробела, чтобы текст выглядел вот так: <quad size=-99999999 width=991111199999>")
      gg.toast("Activated")
end



	function god()
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x184352c, patchData, "godmod") then
            gg.toast("Activated!")
    end
end
	
	function kick()
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x2af5ad0, patchData, "antikick") then
            gg.toast("Activated!")
        end
    end



function Account()
    local S0nbox = gg.multiChoice({
        "➤ Clothes: ",
        "➤ Speed Hack", 
        "➤ Colors (150+)",
        "➤ Infinity Nick",
        "➤ Allow </>",
        "➤ No Ads" .. S6,
        "➤ No Password" .. S2,
        "➤ PlayFab (antiban)" .. S3,
        "➤ No Adventure" .. S4,
		"➤ Avatar Menu",
		"➤ String editor",
        "Back"
    }, nil, 
    "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox ~= nil then
        if S0nbox[1] then 
            clothesMenu()
        end
        
        if S0nbox[2] then 
            speedHack()
        end
        
        if S0nbox[3] then 
            colors()
        end
        
        if S0nbox[4] then 
            infNick()
        end
        
        if S0nbox[5] then 
            colorText()
        end
        
        if S0nbox[6] then
            noAds()
        end
        
        if S0nbox[7] then
            moPass()
        end
        
        if S0nbox[8] then 
            playFab()
        end
        
        if S0nbox[9] then 
            noAdvent()
        end
        
        if S0nbox[10] then 
            avaMenu()
        end
        
        if S0nbox[11] then 
            stringEditor()
        end
        
        if S0nbox[12] then
            Main()  -- Возврат в главное меню
        end
    else
        gg.toast("Menu closed")
        return
    end
end

function stringEditor()
end

function avaMenu()
end


function noAdvent()
if S4 == off then
S4 = on
gg.alert('вруби перед заходом на сервер с адвенчуром, зайди и теперь ты можешь сохранить карту.')
 gg.searchNumber(";GameMode", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";sosisand", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		
		 else
        S4 = off
		 gg.searchNumber(";sosisand", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";GameMode", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Deactivated!")
		end
		end

function playFab()
S3 = on
 gg.searchNumber(";PlayFab", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Sosihue", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end

function noPass()
if S2 == off then
S2 = on
 gg.searchNumber(";Password", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";sinpizdi", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		
		 else
        S2 = off
		 gg.searchNumber(";sinpizdi", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Password", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Deactivated!")
		end
		end
		
function noAds()
S6 = on
    local info = gg.getTargetInfo()
    local is64 = info.x64
    local pType = is64 and gg.TYPE_QWORD or gg.TYPE_DWORD
    local pOffset = is64 and 0x18 or 0xC
    local ranges = gg.getRangesList("libil2cpp.so")
    local VOID = is64 and "h C0 03 5F D6" or "h 1E FF 2F E1"

    local function FindMethod(method, flag)
        gg.clearResults()
        gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP)
        local startAddr = ranges[1].start
        local endAddr = ranges[#ranges]['end']
        gg.searchNumber(':'..method, gg.TYPE_BYTE, false, gg.TYPE_DWORD, startAddr, endAddr)
        
        if gg.getResultsCount() == 0 then
            gg.toast(method..' not found')
            return
        end
        
        gg.refineNumber(tostring(gg.getResults(1)[1].value), gg.TYPE_BYTE)
        local t = gg.getResults(gg.getResultsCount())
        gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP)
        gg.loadResults(t)
        gg.searchPointer(0)
        
        t = gg.getResults(gg.getResultsCount())
        for i,v in ipairs(t) do 
            v.address = v.address - pOffset 
            v.flags = pType 
        end
        t = gg.getValues(t)
        
        local results = {}
        for i,v in ipairs(t) do results[i] = {address = v.value, flags = flag} end
        gg.loadResults(results)
    end

    FindMethod("ShowInterstitial", gg.TYPE_DWORD)
    gg.getResults(gg.getResultsCount())
    gg.editAll(VOID, gg.TYPE_DWORD)
    gg.clearResults()
    gg.toast("Activated!")
end

function colorText()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("257698037761Q;60D:20", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    
    local results = gg.getResults(10000, nil, nil, nil, "60", "60")
    gg.editAll("0", gg.TYPE_DWORD)
    gg.clearResults()
    gg.toast("Activated!")
end

function infNick()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    
    gg.searchNumber(5357803930, gg.TYPE_QWORD)
    
    local initialResults = gg.getResults(250000)
    if #initialResults == 0 then
        gg.toast("Not found!")
        return false
    end
    
    local offsets = {
        FirstOffset = {},
        SecondOffset = {},
        FinalResults = {}
    }
    
    for i = 1, #initialResults do
        offsets.FirstOffset[i] = {
            address = initialResults[i].address - 16,
            flags = gg.TYPE_QWORD
        }
        offsets.SecondOffset[i] = {
            address = initialResults[i].address - 28,
            flags = gg.TYPE_QWORD
        }
    end
    
    offsets.FirstOffset = gg.getValues(offsets.FirstOffset)
    offsets.SecondOffset = gg.getValues(offsets.SecondOffset)
    
    local finalCount = 1
    for i = 1, #offsets.FirstOffset do
        if offsets.FirstOffset[i].value == 1061208257 and 
           offsets.SecondOffset[i].value == 4561810862086072489 then
            offsets.FinalResults[finalCount] = {
                address = offsets.FirstOffset[i].address - 68,
                flags = gg.TYPE_DWORD
            }
            finalCount = finalCount + 1
        end
    end
    
    gg.loadResults(offsets.FinalResults)
    local revert = gg.getResults(100000)
    gg.editAll(1999999, gg.TYPE_DWORD)
    gg.clearResults()
    gg.toast("Activated!")
end

function speedHack()
    local S0nbox = gg.multiChoice({
        "➤ Speed X2" .. S39,
        "➤ Speed X3" .. S40,
        "➤ Speed X4" .. S41,
        "➤ Speed X5" .. S42,
        "➤ Speed X10" .. S43,
        "Back"
    }, nil, 
    "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox ~= nil then
        if S0nbox[1] then 
            spdx2()
        end
        
        if S0nbox[2] then 
            spdx3()
        end
        
        if S0nbox[3] then 
            spdx4()
        end
        
        if S0nbox[4] then 
            spdx5()
        end
        
        if S0nbox[5] then 
            spdx10()
        end
        
        if S0nbox[6] then
            Account()  -- Возврат в главное меню
        end
    else
        gg.toast("Menu closed")
        return
    end
end


function spdx2()
    if S39 == off then
        S39 = on
        gg.searchNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        speedhack2_revert = gg.getResults(5000)
        gg.editAll("4515609228886409216", gg.TYPE_QWORD)
        gg.clearResults()
        gg.toast("2 Activated!")
    else
        S39 = off
        if speedhack2_revert then gg.setValues(speedhack2_revert) end
        gg.toast("2 Deactivated!")
    end
end

function spdx3()
    if S40 == off then
        S40 = on
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("4515609228873826304;4392630932057270955", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        speedhack3_revert = gg.getResults(1000)
        gg.editAll("4515609228892700672", gg.TYPE_QWORD)
        gg.clearResults()
        gg.toast("3 Activated!")
    else
        S40 = off
        if speedhack3_revert then gg.setValues(speedhack3_revert) end
        gg.toast("3 Deactivated!")
    end
end

function spdx4()
    if S41 == off then
        S41 = on
        gg.searchNumber("h0000803FABAAAA3E8FC2F53C", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        speedhack4_revert = gg.getResults(99999)
        gg.editAll("h00008040ABAAAA3E8FC2F53C", gg.TYPE_BYTE)
        gg.clearResults()
        gg.toast("4 Activated!")
    else
        S41 = off
        if speedhack4_revert then gg.setValues(speedhack4_revert) end
        gg.toast("4 Deactivated!")
    end
end

function spdx5()
    if S42 == off then
        S42 = on
        gg.searchNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        speedhack5_revert = gg.getResults(5000)
        gg.editAll("4515609228892700672", gg.TYPE_QWORD)
        gg.clearResults()
        gg.toast("5 Activated!")
    else
        S42 = off
        if speedhack5_revert then gg.setValues(speedhack5_revert) end
        gg.toast("5 Deactivated!")
    end
end

function spdx10()
    if S43 == off then
        S43 = on
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("4515609228873826304;4392630932057270955", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("4515609228873826304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        speedhack10_revert = gg.getResults(1000)
        gg.editAll("4515609228892700672", gg.TYPE_QWORD)
        gg.clearResults()
        gg.toast("10 Activated!")
    else
        S43 = off
        if speedhack10_revert then gg.setValues(speedhack10_revert) end
        gg.toast("10 Deactivated!")
    end
end

function clothesMenu()
    local S0nbox = gg.multiChoice({
        "➤ Corpse Skin ",
        "➤ Swat Skin", 
        "➤ Butcher Skin",
        "➤ Santa Hat",
        "➤ Wizard Hat" ,
        "➤ Dread Hat",
        "➤ Backflip Anim",
        "➤ Flair Anim",
        "Back"
    }, nil, 
    "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    if S0nbox ~= nil then
        if S0nbox[1] then 
            Corpse1()
        end
        
        if S0nbox[2] then 
            Swat1()
        end
        
        if S0nbox[3] then 
            Butcher1()
        end
        
        if S0nbox[4] then 
            Santa1()
        end
        
        if S0nbox[5] then 
            Wizard1()
        end
        
        if S0nbox[6] then
            Dread1()
        end
        
        if S0nbox[7] then
            Backflip1()
        end
        
        if S0nbox[8] then 
            Flair1()
        end
        
        if S0nbox[9] then
            Main()  -- Возврат в главное меню
        end
    else
        gg.toast("Menu closed")
        return
    end
end
function Flair1()
 gg.searchNumber(";Twerk", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Flair", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end
		
		function Backflip1()
 gg.searchNumber(";AirSquat", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Backflip", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end
		
function Dread1()
 gg.searchNumber(";Pilot", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Dread", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end

function Wizard1()
 gg.searchNumber(";Police", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Wizard", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end

function Santa1()
 gg.searchNumber(";Debug", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Santa", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end
		
function Butcher1()
 gg.searchNumber(";Soldier", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Butcher", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end

function Swat1()
 gg.searchNumber(";Jean", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll(";Swat", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
		end
		
function Corpse1()
        gg.setVisible(false)
        if editString('Hero', 'Corpse') then
            gg.clearResults()
            gg.toast("Activated!")
			end
			end



function colors()
    local colorMenu = gg.multiChoice({
        "╭ Красный",
        "│ Темно-красный", 
        "│ Алый",
        "│ Светло-красный",
        "│ Малиновый",
        "│ Кармин",
        "│ Бордовый",
        "│ Вишневый",
        "│ Гранатовый",
        "│ Рубиновый",
        "│ Оранжевый",
        "│ Темно-оранжевый",
        "│ Коралловый",
        "│ Персиковый",
        "│ Абрикосовый",
        "│ Мандариновый",
        "│ Тыквенный",
        "│ Медный",
        "│ Рыжий",
        "│ Киноварь",
        "│ Желтый",
        "│ Золотой",
        "│ Лимонный",
        "│ Светло-желтый",
        "│ Горчичный",
        "│ Янтарный",
        "│ Пшеничный",
        "│ Кукурузный",
        "│ Рапсовый",
        "│ Песочный",
        "│ Зеленый",
        "│ Темно-зеленый",
        "│ Светло-зеленый",
        "│ Лаймовый",
        "│ Оливковый",
        "│ Изумрудный",
        "│ Мятный",
        "│ Шартрез",
        "│ Лаймово-зеленый",
        "│ Весенний",
        "│ Салатовый",
        "│ Папоротниковый",
        "│ Хакки",
        "│ Охотничий",
        "│ Киви",
        "│ Авокадо",
        "│ Малахитовый",
        "│ Нефритовый",
        "│ Изумрудный",
        "│ Синий",
        "│ Темно-синий",
        "│ Светло-синий",
        "│ Голубой",
        "│ Лазурный",
        "│ Аквамарин",
        "│ Бирюзовый",
        "│ Сапфировый",
        "│ Кобальтовый",
        "│ Ультрамарин",
        "│ Индиго",
        "│ Джинсовый",
        "│ Стальной",
        "│ Небесно-голубой",
        "│ Морской волны",
        "│ Циановый",
        "│ Электрик",
        "│ Берлинская лазурь",
        "│ Полуночный",
        "│ Фиолетовый",
        "│ Темно-фиолетовый",
        "│ Светло-фиолетовый",
        "│ Лавандовый",
        "│ Сиреневый",
        "│ Аметистовый",
        "│ Пурпурный",
        "│ Орхидея",
        "│ Лиловый",
        "│ Фуксия",
        "│ Ежевичный",
        "│ Виноградный",
        "│ Баклажановый",
        "│ Черничный",
        "│ Сливовый",
        "│ Коричневый",
        "│ Темно-коричневый",
        "│ Светло-коричневый",
        "│ Бежевый",
        "│ Терракотовый",
        "│ Шоколадный",
        "│ Кофейный",
        "│ Ореховый",
        "│ Карамельный",
        "│ Медовый",
        "│ Коричный",
        "│ Рыжевато-коричневый",
        "│ Бронзовый",
        "│ Медно-коричневый",
        "│ Красновато-коричневый",
        "│ Серо-коричневый",
        "│ Розовый",
        "│ Темно-розовый",
        "│ Светло-розовый",
        "│ Розово-лавандовый",
        "│ Кораллово-розовый",
        "│ Лососевый",
        "│ Фламинго",
        "│ Розово-персиковый",
        "│ Розово-золотой",
        "│ Розово-лиловый",
        "│ Розово-фиолетовый",
        "│ Пудрово-розовый",
        "│ Барби",
        "│ Серый",
        "│ Темно-серый",
        "│ Светло-серый",
        "│ Серебряный",
        "│ Дымчатый",
        "│ Пепельный",
        "│ Стальной",
        "│ Графитовый",
        "│ Угольный",
        "│ Асфальтовый",
        "│ Антрацитовый",
        "│ Чугунный",
        "│ Мышиный",
        "│ Дымчато-серый",
        "│ Белый",
        "│ Снежно-белый",
        "│ Жемчужный",
        "│ Кремовый",
        "│ Слоновая кость",
        "│ Алебастровый",
        "│ Ванильный",
        "│ Кокосовый",
        "│ Молочный",
        "│ Фарфоровый",
        "│ Античный белый",
        "│ Черный",
        "│ Глубокий черный",
        "│ Угольно-черный",
        "│ Ночной",
        "│ Смоляной",
        "│ Маренго",
        "│ Оникс",
        "│ Гагачий",
        "│ Изумрудно-зеленый",
        "│ Изумрудно-синий",
        "│ Изумрудно-бирюзовый",
        "│ Бирюзово-зеленый",
        "│ Бирюзово-синий",
        "│ Аквамариновый",
        "│ Морской зеленый",
        "│ Океанской синий",
        "│ Небесно-голубой",
        "│ Лазурно-голубой",
        "│ Королевский синий",
        "│ Ультрамариновый",
        "│ Сапфирово-синий",
        "│ Кобальтово-синий",
        "│ Васильковый",
        "│ Гиацинтовый",
        "│ Фиалковый",
        "│ Лавандово-синий",
        "│ Сиренево-голубой",
        "│ Глициниевый",
        "│ Орхидейно-фиолетовый",
        "│ Аметистово-фиолетовый",
        "│ Пурпурно-фиолетовый",
        "│ Фиолетово-красный",
        "│ Малиново-красный",
        "│ Рубиново-красный",
        "│ Кораллово-красный",
        "│ Томатный",
        "│ Огненно-красный",
        "│ Кирпичный",
        "│ Терракотово-красный",
        "│ Киноварно-красный",
        "│ Алый",
        "│ Карминово-красный",
        "│ Бордово-красный",
        "│ Вишнево-красный",
        "│ Гранатово-красный",
        "│ Розово-красный",
        "│ Лососево-розовый",
        "│ Кораллово-розовый",
        "│ Персиково-розовый",
        "│ Розово-бежевый",
        "│ Песочно-бежевый",
        "│ Карамельно-бежевый",
        "│ Кремово-бежевый",
        "│ Орехово-бежевый",
        "│ Тауп",
        "│ Хаки",
        "│ Оливково-зеленый",
        "│ Оливково-серый",
        "│ Оливково-коричневый",
        "│ Золотисто-оливковый",
        "│ Лаймово-зеленый",
        "│ Яблочно-зеленый",
        "│ Изумрудно-зеленый",
        "│ Мятно-зеленый",
        "│ Шартрезно-зеленый",
        "│ Весенне-зеленый",
        "│ Салатово-зеленый",
        "│ Папоротниково-зеленый",
        "│ Хвойно-зеленый",
        "│ Лесной зеленый",
        "│ Болотный",
        "│ Камуфляжный",
        "│ Защитный",
        "│ Пыльный зеленый",
        "│ Опаловый",
        "│ Нефритово-зеленый",
        "│ Малахитово-зеленый",
        "│ Бирюзово-зеленый",
        "│ Аквамариново-зеленый",
        "│ Морской волны зеленый",
        "│ Голубовато-зеленый",
        "│ Сине-зеленый",
        "│ Зелено-синий",
        "│ Темно-бирюзовый",
        "│ Средне-бирюзовый",
        "│ Светло-бирюзовый",
        "│ Бирюзово-голубой",
        "│ Аквамариново-голубой",
        "│ Голубой лед",
        "│ Полярный голубой",
        "│ Небесный голубой",
        "│ Лазурный голубой",
        "╰ Back"
    }, nil, "Выберите цвет для копирования")
    
    if colorMenu then
        if colorMenu[1] then gg.copyText("#FF0000") gg.toast("Красный скопирован") end
        if colorMenu[2] then gg.copyText("#8B0000") gg.toast("Темно-красный скопирован") end
        if colorMenu[3] then gg.copyText("#DC143C") gg.toast("Алый скопирован") end
        if colorMenu[4] then gg.copyText("#FF6B6B") gg.toast("Светло-красный скопирован") end
        if colorMenu[5] then gg.copyText("#DC143C") gg.toast("Малиновый скопирован") end
        if colorMenu[6] then gg.copyText("#960018") gg.toast("Кармин скопирован") end
        if colorMenu[7] then gg.copyText("#800000") gg.toast("Бордовый скопирован") end
        if colorMenu[8] then gg.copyText("#DE3163") gg.toast("Вишневый скопирован") end
        if colorMenu[9] then gg.copyText("#733635") gg.toast("Гранатовый скопирован") end
        if colorMenu[10] then gg.copyText("#E0115F") gg.toast("Рубиновый скопирован") end
        if colorMenu[11] then gg.copyText("#FFA500") gg.toast("Оранжевый скопирован") end
        if colorMenu[12] then gg.copyText("#FF8C00") gg.toast("Темно-оранжевый скопирован") end
        if colorMenu[13] then gg.copyText("#FF7F50") gg.toast("Коралловый скопирован") end
        if colorMenu[14] then gg.copyText("#FFDAB9") gg.toast("Персиковый скопирован") end
        if colorMenu[15] then gg.copyText("#FBCEB1") gg.toast("Абрикосовый скопирован") end
        if colorMenu[16] then gg.copyText("#F28500") gg.toast("Мандариновый скопирован") end
        if colorMenu[17] then gg.copyText("#FF7518") gg.toast("Тыквенный скопирован") end
        if colorMenu[18] then gg.copyText("#B87333") gg.toast("Медный скопирован") end
        if colorMenu[19] then gg.copyText("#FF7F00") gg.toast("Рыжий скопирован") end
        if colorMenu[20] then gg.copyText("#E34234") gg.toast("Киноварь скопирована") end
        if colorMenu[21] then gg.copyText("#FFFF00") gg.toast("Желтый скопирован") end
        if colorMenu[22] then gg.copyText("#FFD700") gg.toast("Золотой скопирован") end
        if colorMenu[23] then gg.copyText("#FFFACD") gg.toast("Лимонный скопирован") end
        if colorMenu[24] then gg.copyText("#FFFFE0") gg.toast("Светло-желтый скопирован") end
        if colorMenu[25] then gg.copyText("#FFDB58") gg.toast("Горчичный скопирован") end
        if colorMenu[26] then gg.copyText("#FFBF00") gg.toast("Янтарный скопирован") end
        if colorMenu[27] then gg.copyText("#F5DEB3") gg.toast("Пшеничный скопирован") end
        if colorMenu[28] then gg.copyText("#FBEC5D") gg.toast("Кукурузный скопирован") end
        if colorMenu[29] then gg.copyText("#F0E68C") gg.toast("Рапсовый скопирован") end
        if colorMenu[30] then gg.copyText("#F4A460") gg.toast("Песочный скопирован") end
        if colorMenu[31] then gg.copyText("#00FF00") gg.toast("Зеленый скопирован") end
        if colorMenu[32] then gg.copyText("#006400") gg.toast("Темно-зеленый скопирован") end
        if colorMenu[33] then gg.copyText("#90EE90") gg.toast("Светло-зеленый скопирован") end
        if colorMenu[34] then gg.copyText("#32CD32") gg.toast("Лаймовый скопирован") end
        if colorMenu[35] then gg.copyText("#808000") gg.toast("Оливковый скопирован") end
        if colorMenu[36] then gg.copyText("#50C878") gg.toast("Изумрудный скопирован") end
        if colorMenu[37] then gg.copyText("#98FF98") gg.toast("Мятный скопирован") end
        if colorMenu[38] then gg.copyText("#7FFF00") gg.toast("Шартрез скопирован") end
        if colorMenu[39] then gg.copyText("#32CD32") gg.toast("Лаймово-зеленый скопирован") end
        if colorMenu[40] then gg.copyText("#00FF7F") gg.toast("Весенний скопирован") end
        if colorMenu[41] then gg.copyText("#7FFF00") gg.toast("Салатовый скопирован") end
        if colorMenu[42] then gg.copyText("#4F7942") gg.toast("Папоротниковый скопирован") end
        if colorMenu[43] then gg.copyText("#DFFF00") gg.toast("Хакки скопирован") end
        if colorMenu[44] then gg.copyText("#3D7044") gg.toast("Охотничий скопирован") end
        if colorMenu[45] then gg.copyText("#8EE53F") gg.toast("Киви скопирован") end
        if colorMenu[46] then gg.copyText("#568203") gg.toast("Авокадо скопирован") end
        if colorMenu[47] then gg.copyText("#0BDA51") gg.toast("Малахитовый скопирован") end
        if colorMenu[48] then gg.copyText("#00A86B") gg.toast("Нефритовый скопирован") end
        if colorMenu[49] then gg.copyText("#009975") gg.toast("Изумрудный скопирован") end
        if colorMenu[50] then gg.copyText("#0000FF") gg.toast("Синий скопирован") end
        if colorMenu[51] then gg.copyText("#000080") gg.toast("Темно-синий скопирован") end
        if colorMenu[52] then gg.copyText("#ADD8E6") gg.toast("Светло-синий скопирован") end
        if colorMenu[53] then gg.copyText("#87CEEB") gg.toast("Голубой скопирован") end
        if colorMenu[54] then gg.copyText("#007BA7") gg.toast("Лазурный скопирован") end
        if colorMenu[55] then gg.copyText("#7FFFD4") gg.toast("Аквамарин скопирован") end
        if colorMenu[56] then gg.copyText("#40E0D0") gg.toast("Бирюзовый скопирован") end
        if colorMenu[57] then gg.copyText("#082567") gg.toast("Сапфировый скопирован") end
        if colorMenu[58] then gg.copyText("#0047AB") gg.toast("Кобальтовый скопирован") end
        if colorMenu[59] then gg.copyText("#3F00FF") gg.toast("Ультрамарин скопирован") end
        if colorMenu[60] then gg.copyText("#4B0082") gg.toast("Индиго скопирован") end
        if colorMenu[61] then gg.copyText("#1560BD") gg.toast("Джинсовый скопирован") end
        if colorMenu[62] then gg.copyText("#4682B4") gg.toast("Стальной скопирован") end
        if colorMenu[63] then gg.copyText("#87CEFA") gg.toast("Небесно-голубой скопирован") end
        if colorMenu[64] then gg.copyText("#00FFFF") gg.toast("Морской волны скопирован") end
        if colorMenu[65] then gg.copyText("#00FFFF") gg.toast("Циановый скопирован") end
        if colorMenu[66] then gg.copyText("#7DF9FF") gg.toast("Электрик скопирован") end
        if colorMenu[67] then gg.copyText("#003153") gg.toast("Берлинская лазурь скопирована") end
        if colorMenu[68] then gg.copyText("#191970") gg.toast("Полуночный скопирован") end
        if colorMenu[69] then gg.copyText("#800080") gg.toast("Фиолетовый скопирован") end
        if colorMenu[70] then gg.copyText("#9400D3") gg.toast("Темно-фиолетовый скопирован") end
        if colorMenu[71] then gg.copyText("#C8A2C8") gg.toast("Светло-фиолетовый скопирован") end
        if colorMenu[72] then gg.copyText("#E6E6FA") gg.toast("Лавандовый скопирован") end
        if colorMenu[73] then gg.copyText("#C8A2C8") gg.toast("Сиреневый скопирован") end
        if colorMenu[74] then gg.copyText("#9966CC") gg.toast("Аметистовый скопирован") end
        if colorMenu[75] then gg.copyText("#CC8899") gg.toast("Пурпурный скопирован") end
        if colorMenu[76] then gg.copyText("#DA70D6") gg.toast("Орхидея скопирована") end
        if colorMenu[77] then gg.copyText("#B57EDC") gg.toast("Лиловый скопирован") end
        if colorMenu[78] then gg.copyText("#FF00FF") gg.toast("Фуксия скопирована") end
        if colorMenu[79] then gg.copyText("#614051") gg.toast("Ежевичный скопирован") end
        if colorMenu[80] then gg.copyText("#6F2DA8") gg.toast("Виноградный скопирован") end
        if colorMenu[81] then gg.copyText("#614051") gg.toast("Баклажановый скопирован") end
        if colorMenu[82] then gg.copyText("#082567") gg.toast("Черничный скопирован") end
        if colorMenu[83] then gg.copyText("#660066") gg.toast("Сливовый скопирован") end
        if colorMenu[84] then gg.copyText("#A52A2A") gg.toast("Коричневый скопирован") end
        if colorMenu[85] then gg.copyText("#654321") gg.toast("Темно-коричневый скопирован") end
        if colorMenu[86] then gg.copyText("#D2B48C") gg.toast("Светло-коричневый скопирован") end
        if colorMenu[87] then gg.copyText("#F5F5DC") gg.toast("Бежевый скопирован") end
        if colorMenu[88] then gg.copyText("#E2725B") gg.toast("Терракотовый скопирован") end
        if colorMenu[89] then gg.copyText("#7B3F00") gg.toast("Шоколадный скопирован") end
        if colorMenu[90] then gg.copyText("#6F4E37") gg.toast("Кофейный скопирован") end
        if colorMenu[91] then gg.copyText("#755C48") gg.toast("Ореховый скопирован") end
        if colorMenu[92] then gg.copyText("#AF6E4D") gg.toast("Карамельный скопирован") end
        if colorMenu[93] then gg.copyText("#D2B48C") gg.toast("Медовый скопирован") end
        if colorMenu[94] then gg.copyText("#7B3F00") gg.toast("Коричный скопирован") end
        if colorMenu[95] then gg.copyText("#A52A2A") gg.toast("Рыжевато-коричневый скопирован") end
        if colorMenu[96] then gg.copyText("#CD7F32") gg.toast("Бронзовый скопирован") end
        if colorMenu[97] then gg.copyText("#D2691E") gg.toast("Медно-коричневый скопирован") end
        if colorMenu[98] then gg.copyText("#A52A2A") gg.toast("Красновато-коричневый скопирован") end
        if colorMenu[99] then gg.copyText("#483C32") gg.toast("Серо-коричневый скопирован") end
        if colorMenu[100] then gg.copyText("#FFC0CB") gg.toast("Розовый скопирован") end
        if colorMenu[101] then Account() end
    else
        gg.toast("Menu Closed")
        return
    end
end




function Server()
    local S0nbox = gg.multiChoice({
        "➤ Server Create:",
		"➤ Player:",
        "➤ Events:", 
        "➤ Protect:",
        "➤ Creator Mode",
        "Back"
    }, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox == nil then
        gg.toast("Menu closed")
        return
    end

    if S0nbox[1] then SCreate() end
    if S0nbox[2] then Player() end
    if S0nbox[3] then Events() end
    if S0nbox[4] then Protection() end
    if S0nbox[5] then CBuild() end
    if S0nbox[6] then Main() end  -- Возврат в главное меню
end

function SCreate()
filsst3 = gg.multiChoice({
    "➤ Player Set" .. S89,
    "➤ Props Set" .. S90,
    "➤ Vehicles Set" .. S91,
"Back"
}, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")

if filsst3 == nil then return end
    if filsst3[1] == true then Player() end
    if filsst3[2] == true then Props() end
    if filsst3[3] == true then Vehicles() end
    if filsst3[4] == true then Server() end
end

function Vehicles()
S91 = on
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
S90 = on
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
S89 = on
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

local input = gg.prompt({"Select value :[0;10]"}, {0}, {"number"})

if input == nil then
    gg.alert("Отмена")
    os.exit()
end

local selectedValue = input[1]
gg.editAll(selectedValue, gg.TYPE_DWORD)
gg.clearResults()

gg.alert("лимит игроков: " .. selectedValue)
end

function CBuild()
    local GR = gg.prompt(
        {"<Напишите значение для Крейтор мода (советую 11.5 и 25.5)>"},
        {nil},
        {"number"}
    )
    
    if GR == nil then
        gg.alert("Отмена...")
        return
    end

    gg.searchNumber("45", gg.TYPE_FLOAT)
    local results = gg.getResults(100000)
    
    if #results == 0 then
        gg.alert("не найдено!")
        gg.clearResults()
        return
    end
    
    gg.editAll(GR[1], gg.TYPE_FLOAT)
    gg.clearResults()
    gg.toast("Заменено на: " .. GR[1])
end


function Protection()
    local S0nbox = gg.multiChoice({
        "➤ Anti Rocket" ..	S82,
        "➤ Anti Bowl" .. S83, 
        "➤ Anti Crash LG" .. S84,
        "➤ Anti Crash Chat" .. S85,
        "➤ Anti All" .. S86,
        "➤ Anti PvP" .. S87,
		"➤ Anti Mine" .. S88,
        "Back"
    }, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox == nil then
        gg.toast("Menu closed")
        return
    end
    
    if S0nbox[1] then antiRocket() end
    if S0nbox[2] then antiBowl() end
    if S0nbox[3] then antiLG() end
    if S0nbox[4] then antiChat() end
    if S0nbox[5] then antiAll() end
    if S0nbox[6] then antiPvP() end
	if S0nbox[7] then antiMine() end
    if S0nbox[8] then Server() end  -- Возврат в главное меню
end

function antiPvP()
gg.searchNumber(";TakeDamage", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100)
gg.editAll(";", gg.TYPE_WORD)
gg.clearResults()
end
	
-- Anti Crash LC
function antiLG()
    if S84 == off then
        S84 = on
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x3CF9A8, patchData, "anticrashlc") then
            gg.toast("Activated!")
        end
    else
        S84 = off
        if endOffset("anticrashlc") then
            gg.toast("Deactivated!")
        end
    end
end

-- Anti All Tecno/Stop All Players
function antiAll()
    if S86 == off then
        S86 = on
        local patchData = {
            {offset = 0, value = 'D2800000h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x163CD18, patchData, "antitencostop") then
            gg.toast("Activated!")
        end
    else
        S86 = off
        if endOffset("antitencostop") then
            gg.toast("Deactivated!")
        end
    end
end

-- Anti Rocket
function antiRocket()
    if S82 == off then
        S82 = on
        local patchData = {
            {offset = 0, value = 'D2800000h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x3A14F8, patchData, "antirocket") then
            gg.toast("Activated!")
        end
    else
        S82 = off
        if endOffset("antirocket") then
            gg.toast("Deactivated!")
        end
    end
end

-- Anti Arrow
function antiBowl()
    if S83 == off then
        S833 = on
        local patchData = {
            {offset = 0, value = 'D2800000h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x3A1638, patchData, "antiarrow") then
            gg.toast("Activated!")
        end
    else
        S83 = off
        if endOffset("antiarrow") then
            gg.toast("Deactivated!")
        end
    end
end


function antiChat()
    if S86 == off then
        S86 = on
        gg.searchNumber(";<color=red", gg.TYPE_WORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        anticrashchat_revert = gg.getResults(99999)
        gg.editAll(";Kitrittopk", gg.TYPE_WORD)
        gg.clearResults()
        gg.toast("Activated!")
    else
        S86 = off
        if anticrashchat_revert then gg.setValues(anticrashchat_revert) end
        gg.toast("Deactivated!")
    end
end

function antiMine()
    if S88 == off then
        S88 = on
        gg.searchNumber(":Mine", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        antimine_revert = gg.getResults(99999)
        gg.editAll(":Dest", gg.TYPE_BYTE)
        gg.clearResults()
        gg.toast("Activated!")
    else
        S88 = off
        if antimine_revert then gg.setValues(antimine_revert) end
        gg.toast("Deactivated!")
    end
end

function Events()
    local S0nbox = gg.multiChoice({
        "➤ Slide Cars" .. S70,
        "➤ All Car NaN" .. S71, 
        "➤ Car Speed Bust" .. S72,
        "➤ Car Fly" .. S73,
        "➤ Zero Gravity Props" .. S74,
        "➤ Helicopter NaN" .. S75,
        "➤ Spawn Editor" .. S76,
        "➤ NaN Spawn" .. S77,
        "Back"
    }, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox == nil then
        gg.toast("Menu closed")
        return
    end
    
    if S0nbox[1] then slidecars() end
    if S0nbox[2] then carNaN() end
    if S0nbox[3] then carSpeed() end
    if S0nbox[4] then carFly() end
    if S0nbox[5] then zeroProps() end
    if S0nbox[6] then helicopterNaN() end
    if S0nbox[7] then spawnEdit() end
    if S0nbox[8] then SpawnNaN() end
    if S0nbox[9] then Server() end  -- Возврат в главное меню
end

function spawnNaN()
end

function spawnEdit()
SD = gg.prompt({
    "<Твоя гравитация","<Начо менять"}, {"-0.53",nil}, {"number","number"})
if SD == nil then gg.alert("<Nothing.........") else
    gg.searchNumber(SD[1], gg.TYPE_FLOAT)
gg.getResults(100000)
gg.editAll(SD[2], gg.TYPE_FLOAT)
gg.clearResults()
end
end

function helicopterNaN()
if S75 == off then
      S75 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("300F;1 133 903 872D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 133 903 872D", gg.TYPE_DWORD)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S75 == on then
      S75 = off
      gg.toast("Прост выйди с верта, заспауни другой")
      end
end
end

function zeroProps()
if S74 == off then
      S74 = on
gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("3 239 900 611;4 776 067 405 843 781 386;", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_QWORD)
gg.clearResults()
      gg.toast("Activated")
else if S74 == on then
      S74 = off
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

function carFly()
if S73 == off then
      S73 = on
gg["setRanges"](gg["REGION_ANONYMOUS"])
           gg["searchNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["refineNumber"]('h9D74CDCC4C3D0000003F', gg["TYPE_BYTE"])
           gg["getResults"](500000)
           gg["editAll"]('h9D74000020C10000003F', gg["TYPE_BYTE"])
           gg["processResume"]()
           gg["clearResults"]()
      gg.toast("Activated")
else if S73 == on then
      S73 = off
      gg.toast("просто с тачки вылези")
      end
end
end

function carSpeed()
if S72 == off then
      S72 = on
gg.searchNumber("1000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15000", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if S72 == on then
      S72 = off
      gg.toast("Not Deactivated")
      end
end
end

function carNaN()
    if S72 == off then
        S72 = on
gg.clearResults()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1 137 180 672D;400F", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1 137 180 672", gg.TYPE_DWORD)
revert2 = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
        gg.toast("Activated!")
    else
        S72 = off
        if revert2 then gg.setValues(revert2) end
        gg.toast("Deactivated!")
    end
end

function slidecars()
    if S70 == off then
        S70 = on
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("h9D74CDCC4C3D0000003F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        slidecars_revert = gg.getResults(99999)
        gg.editAll("h9D74000000BF0000003F", gg.TYPE_BYTE)
        gg.clearResults()
        gg.toast("Ｓｌｉｄｅ Ｃａｒｓ Activated!")
    else
        S70 = off
        if slidecars_revert then gg.setValues(slidecars_revert) end
        gg.toast("Ｓｌｉｄｅ Ｃａｒｓ Deactivated!")
    end
end


function Player()
    local S0nbox = gg.multiChoice({
        "➤ NaN HP",
        "➤ Fly" .. S34, 
        "➤ Jump Fly" .. S35,
        "➤ Noclip" .. S60,
        "➤ No Collision Prop" .. S61,
        "➤ Player Gravity" .. S62,
        "➤ Double Jump" .. S63,
        "➤ Air Walk" .. S64,
        "➤ Invisible" .. S65,
        "➤ Slide Jump" .. S66,
        "➤ Slide Floor" .. S67,
        "➤ Inf Animation" .. S68,
        "Back"
    }, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
    
    -- Добавляем проверку на nil
    if S0nbox == nil then
        gg.toast("Menu closed")
        return
    end
    
    if S0nbox[1] then nanHP() end
    if S0nbox[2] then Fly() end
    if S0nbox[3] then jumpFly() end
    if S0nbox[4] then noclip() end
    if S0nbox[5] then noclipProp() end
    if S0nbox[6] then gravitymenu() end
    if S0nbox[7] then doubleJump() end
    if S0nbox[8] then airWalk() end
    if S0nbox[9] then inviz() end
    if S0nbox[10] then slideJump() end
    if S0nbox[11] then slideFloor() end
    if S0nbox[12] then infAnim() end
    if S0nbox[13] then Server() end  -- Возврат в главное меню
end

function gravitymenu()
GR = gg.prompt({
    "<Твоя гравитация","<Начо менять"}, {"-9.81000041962",nil}, {"number","number"})
if GR == nil then gg.alert("<Nothing.........") else
    gg.searchNumber(GR[1], gg.TYPE_FLOAT)
gg.getResults(100000)
gg.editAll(GR[2], gg.TYPE_FLOAT)
gg.clearResults()
end
end

function infAnim()
    if S68 == off then
        S68 = on
        local gg = gg
        local info = gg.getTargetInfo()
        local LibTable = {}
        v = gg.getTargetInfo()
        L = v.label
        V = v.versionName
        
        function isProcess64Bit()
            local regions = gg.getRangesList()
            local lastAddress = regions[#regions]["end"]
            return (lastAddress >> 32) ~= 0
        end
        
        local ISA = isProcess64Bit()
        
        function ISAOffsets()
            if (ISA == false) then
                edi = "+0x"
                ed = "-0x"
            elseif (ISA == true) then
                edi = "0x"
                ed = "-0x"
            end
        end
        
        ISAOffsets()
        
        function ISAOffsetss()
            if (ISA == false) then
                edit = "~A B " .. edits
            elseif (ISA == true) then
                edit = "~A8 B     [PC,#" .. edits .. "]"
            end
        end
        
        liby = 1
        libf = 0
        libzz = "libil2cpp.so"
        libx = gg.getRangesList("libil2cpp.so")
        
        for i, v in ipairs(libx) do
            if (libx[i].state == "Xa") then
                libz = "libil2cpp.so[" .. liby .. "].start"
                xand = gg.getRangesList("libil2cpp.so")[liby].start
                libf = 1
                break
            end
            liby = liby + 1
        end
        
        if (libf == 0) then
            liby = 1
            libzz = "libUE4.so"
            libx = gg.getRangesList("libUE4.so")
            for i, v in ipairs(libx) do
                if (libx[i].state == "Xa") then
                    libz = "libUE4.so[" .. liby .. "].start"
                    xand = gg.getRangesList("libUE4.so")[liby].start
                    libf = 1
                    break
                end
                liby = liby + 1
            end
        end
        
        lib = xand
        local sf = string.format
        
        function tohex(Data)
            if (type(Data) == "number") then
                return sf("0x%08X", Data)
            end
            return Data:gsub(".", function(a)
                return string.format("%02X", (string.byte(a)))
            end):gsub(" ", "")
        end
        
        function __()
            xHEX = string.format("%X", aaaa)
            if (#xHEX > 8) then
                act = (#xHEX - 8) + 1
                xHEX = string.sub(xHEX, act)
            end
            edits = edi .. xHEX
            ISAOffsetss()
        end
        
        function _()
            aaa = b - a
            xHEX = string.format("%X", aaa)
            if (#xHEX > 8) then
                act = (#xHEX - 8) + 1
                xHEX = string.sub(xHEX, act)
            end
            edits = ed .. xHEX
            ISAOffsetss()
        end
        
        function hook_void(cc, bb)
            LibStart = lib
            local m = {}
            m[1] = {address=(LibStart + bb),flags=gg.TYPE_DWORD}
            gg.addListItems(m)
            a = m[1].address
            gg.clearList()
            local p = {}
            p[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD}
            gg.addListItems(p)
            gg.loadResults(p)
            endhook = gg.getResults(1)
            local n = {}
            n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD}
            gg.addListItems(n)
            b = n[1].address
            gg.clearResults()
            gg.clearList()
            aaaa = a - b
            if (tonumber(aaaa) < 0) then
                _()
            end
            if (tonumber(aaaa) > 0) then
                __()
            end
            local n = {}
            n[1] = {address=(LibStart + cc),flags=gg.TYPE_DWORD,value=edit,freeze=true}
            gg.addListItems(n)
            gg.clearList()
        end

        infanimations_original = gg.getValues({{address = lib + 0x39E7B8, flags = gg.TYPE_DWORD}})
        hook_void(0x39E7B8, 0x39E12C)
        gg.toast("Activated!")
    else
        S68 = off
        if infanimations_original then gg.setValues(infanimations_original) end
        gg.toast("Deactivated!")
    end
end

function slideFloor()
    if S67 == off then
        S67 = on
        local gg = gg
        local info = gg.getTargetInfo()
        local is64 = info.x64
        local pType = is64 and gg.TYPE_QWORD or gg.TYPE_DWORD
        local pOffset = is64 and 0x18 or 0xC
        local ranges = gg.getRangesList("libil2cpp.so")
        local VOID = is64 and "h C0 03 5F D6" or "h 1E FF 2F E1"

        local function FindMethod(method, flag)
            gg.clearResults()
            gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER | gg.REGION_C_HEAP)
            local startAddr = ranges[1].start
            local endAddr = ranges[#ranges]['end']
            gg.searchNumber(':'..method, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, startAddr, endAddr)
            
            if gg.getResultsCount() == 0 then
                return
            end
            
            gg.refineNumber(tostring(gg.getResults(1)[1].value), gg.TYPE_BYTE)
            local t = gg.getResults(gg.getResultsCount())
            gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
            gg.loadResults(t)
            gg.searchPointer(0)
            
            t = gg.getResults(gg.getResultsCount())
            for i,v in ipairs(t) do 
                v.address = v.address - pOffset 
                v.flags = pType 
            end
            t = gg.getValues(t)
            
            local results = {}
            for i,v in ipairs(t) do results[i] = {address = v.value, flags = flag} end
            gg.loadResults(results)
        end

        FindMethod("get_velocity", gg.TYPE_DWORD)
        slidefloor_revert = gg.getResults(gg.getResultsCount())
        gg.editAll(VOID, gg.TYPE_DWORD)
        gg.clearResults()
        gg.toast("Activated!")
    else
        S67 = off
        if slidefloor_revert then gg.setValues(slidefloor_revert) end
        gg.toast("Deactivated!")
    end
end

function slideJump()
if S66 == off then
        S66 = on
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("h803FCDCC4C3E0000A040", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        slidejump_revert = gg.getResults(99999)
        gg.editAll("h803F4054094B0000A040", gg.TYPE_BYTE)
        gg.clearResults()
        gg.toast("Activated!")
    else
        S66 = off
        if slidejump_revert then gg.setValues(slidejump_revert) end
        gg.toast("Deactivated!")
    end
end

function inviz()
    if S65 == off then
        S65 = on
        local patchData = {
            {offset = 0, value = 'D2800020h', flags = gg.TYPE_DWORD},
            {offset = 4, value = 'D65F03C0h', flags = gg.TYPE_DWORD}
        }
        if editOffset(0x1638DDC, patchData, "invisible") then
            gg.toast("Activated!")
        end
    else
        S65 = off
        if endOffset("invisible") then
            gg.toast("Deactivated!")
        end
    end
end

function airWalk()
S64 = on
gg.searchNumber("-9.81", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(50000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
end

function doubleJump()
    local _={
        ["8392591"] = gg,
        ["4728163"] = gg.REGION_ANONYMOUS,
        ["1856342"] = gg.TYPE_BYTE,
        ["6937254"] = gg.SIGN_EQUAL,
        ["3274891"] = "h C3 F5 1C C1 00 00 00 00 CD CC 8C 3F 00 00 80 3F CD CC 4C 3E",
        ["5489126"] = "h C3 F5 1C C1 00 00 00 00 66 66 06 40 00 00 80 3F CD CC 4C 3E"
    }
    
    if S63 == off then
        S63 = on
        _["8392591"].setRanges(_["4728163"])
        _["8392591"].searchNumber(_["3274891"], _["1856342"], false, _["6937254"], 0, -1, 0)
        revert1 = _["8392591"].getResults(99999)
        _["8392591"].editAll(_["5489126"], _["1856342"])
        _["8392591"].clearResults()
        gg.toast("Ａｃｔｉｖａｔｅｄ!")
    else
        S63 = off
        _["8392591"].setRanges(_["4728163"])
        _["8392591"].searchNumber(_["5489126"], _["1856342"], false, _["6937254"], 0, -1, 0)
        revert1 = _["8392591"].getResults(99999)
        _["8392591"].editAll(_["3274891"], _["1856342"])
        _["8392591"].clearResults()
        gg.toast("Ｄｅａｃｔｉｖａｔｅｄ!")
    end
end

function noclipProp()
    if S61 == off then
        S61 = on
        gg.searchNumber("-10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
        gg.refineNumber("-10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
        nocollision_revert = gg.getResults(99999)
        gg.editAll("10", gg.TYPE_FLOAT)
        gg.clearResults()
        gg.toast("Activated!")
    else
        S61 = off
        if nocollision_revert then gg.setValues(nocollision_revert) end
        gg.toast("Deactivated!")
    end
end

function Noclip()
S60 = on
gg.searchNumberSmart(40.0)  
gg.editAllSmart(150.0)    
gg.clearResults()
      gg.toast("Activated")
      end
	  
	  
function jumpFly()
S35 = on
gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("hCDCC8C3F0000803FCDCC4C3E0000A040", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert1 = gg.getResults(99999)
    gg.editAll("hA66FA56A0000803FCDCC4C3E0000A040", gg.TYPE_BYTE)
    gg.clearResults()
    end


function Fly()
    if S34 == off then
        S34 = on
gg.processPause()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.clearResults()
  gg.searchNumber("281 479 271 678 208", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert98 = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("16 777 472", gg.TYPE_QWORD)
  gg.clearResults()
  gg.searchNumber("3 239 900 611", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
  revert99 = gg.getResults(4000, nil, nil, nil, nil, nil, nil, nil, nil)
  gg.editAll("0", gg.TYPE_QWORD)
  gg.processResume()
  gg.clearResults()
        gg.toast("Activated!")
    else
        S34 = off
        if fly_revert then gg.setValues(revert98) end
        if fly_revert2 then gg.setValues(revert99) end
        gg.toast("Deactivated!")
    end
end

function nanHP()
        gg.clearResults()
        gg.alert("Выстрели арбалетом")
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber("h00008C420000A042", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        nanhp_revert = gg.getResults(50000)
        gg.editAll("h0000A0C00000A042", gg.TYPE_BYTE)
        gg.clearResults()
        gg.searchNumber("h0000A04200008040", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        nanhp_revert2 = gg.getResults(10000)
        gg.editAll("hFFFFFFFF00008040", gg.TYPE_BYTE)
        gg.toast("Activated!")
end


function Visual()
filsst4 = gg.multiChoice({
    "➤ FOV" .. S92,
    "➤ Convulsions" .. S93,
    "➤ Free Camera" .. S94,
    "➤ Rainbow Chams (V1)" .. S95,
    "➤ Rainbow Chams (V2)" .. S96,
    "➤ Giga Chams (top)" .. S97,
    "➤ Red" .. S98,
    "➤ Green" .. S99,
    "➤ Blue" .. S100,
    "➤ Blue Neon" .. S101,
    "➤ Green Neon" .. S102,
    "➤ Green+Violet" .. S103,
    "➤ Green+Violet Neon" .. S104,
    "➤ Green+Violet Fast" .. S105,
    "➤ Partially Blue" .. S106,
    "➤ Чамсы ссди" .. S107,
    "➤ Дефолт Чамси" .. S108,
    "Back"
}, nil, "Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")

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
if S108 == off then
      S108 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('1073741897', gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741899',gg.TYPE_DWORD)
      gg.toast("Activated")
else if S108 == on then
      S108 = off
      gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber('1073741899', gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741897',gg.TYPE_DWORD)
      gg.toast("Deactivated")
      end
end
end


function Chamsssdi()
if S107 == off then
      S107 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741897", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S107 == on then
      S107 = off
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
if S106 == off then
      S106 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.refineNumber("1073741897", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741899", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S106 == on then
      S106 = off
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
if S105 == off then
      S105 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741903', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S105 == on then
      S105 = off
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
if S104 == off then
      S104 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741903", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S104 == on then
      S104 = off
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
if S103 == off then
      S103 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741902", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S103 == on then
      S103 = off
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
if S102 == off then
      S102 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.refineNumber("1073741896", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741899", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S102 == on then
      S102 = off
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
if S101 == off then
      S101 = on
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
else if S101 == on then
      S101 = off
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
if S100 == off then
      S100 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.refineNumber("1073741894", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741900", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S100 == on then
      S100 = off
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
if S99 == off then
      S99 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.refineNumber("1073741893", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll('1073741904', gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S99 == on then
      S99 = off
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
if S98 == off then
      S98 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.refineNumber("1073741895", gg.TYPE_DWORD)
gg.getResults(5000)
gg.editAll("1073741900", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S98 == on then
      S98 = off
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
if S97 == off then
      S97 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1;3;4;257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if S97 == on then
      gg.toast("Not Deactivated")
      end
end
end

function RainbowChamsV2()
if S96 == off then
      S96 = on
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
else if S96 == on then
      S96 = off
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
if S95 == off then
      S95 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1073741898", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1073741901", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S95 == on then
      S95 = off
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
S94 = on
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
if S93 == off then
      S93 = on
gg.searchNumber("1.57079637051", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(5000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("15000", gg.TYPE_FLOAT)
gg.toast("Activated")
      gg.toast("Activated")
else if S93 == on then
      S93 = off
      gg.toast("Not Deactivated")
      end
end
end

function FOV()
S92 = on
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

function Weapon()
filst11 = gg.choice({
"➤ Gun Mode",
"➤ Give Gun",
"➤ Smg",
"➤ Shotgun",
"Back"
},nil,
"Hypper Sandbox 0.5.0.1\nHypper Destroyer 3\nBy KitRit")
if filst11 == nil then Main() else
if filst11 == 1 then gunammo() end
if filst11 == 2 then gungive() end
if filst11 == 3 then smg() end
if filst11 == 4 then shotgun() end
if filst11 == 5 then Main() end end end


function gunammo()
filsst12 = gg.multiChoice({
"➤ Multigun (2 mode)" .. S109,
"➤ All Gun Infinity Ammo" .. S110,
"➤ All Gun Rapidfire" .. S111,
"➤ All Gun RPG" .. S128,
"➤ SMG Crossbowl" .. S112,
"➤ SMG ShotGun" .. S113,
"➤ Give NaN Pistol" .. S114,
"Back"
},nil,
"gigain")
if filsst12 == nil then Weapon() else
if filsst12[1] == true then Multigun() end
if filsst12[2] == true then infall() end
if filsst12[3] == true then rapidall() end
if filsst12[4] == true then gunrpgs() end
if filsst12[5] == true then smgCross() end
if filsst12[6] == true then smgshot() end
if filsst12[7] == true then nanpisun() end
if filsst12[8] == true then Weapon() end end end

function gunrpgs()
    gg.setRanges(gg.REGION_ANONYMOUS)

    if S128 == off then
	S128 = on
        -- ВКЛЮЧАЕМ ВСЁ (первые состояния)
        gg.searchNumber("h 07 00 00 00 E3 84 68 4A E3 84 68 4A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 E3 84 68 4A E3 84 68 4A", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 01 00 00 00 3D 21 99 45 37 21 99 45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 3D 21 99 45 37 21 99 45", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 01 00 00 00 E5 9F 7D 75 E3 9F 7D 75", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 E5 9F 7D 75 E3 9F 7D 75", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 01 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 05 00 00 00 75 60 DF 72 70 60 DF 72", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 75 60 DF 72 70 60 DF 72", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 04 00 00 00 B5 6E 07 49 B4 6E 07 49", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 B5 6E 07 49 B4 6E 07 49", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 08 00 00 00 30 DE 06 50 36 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 30 DE 06 50 36 DE 06 50", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 02 00 00 00 33 A0 16 5C 33 A0 16 5C", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 33 A0 16 5C 33 A0 16 5C", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 02 00 00 00 0C 73 D5 41 0C 73 D5 41", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 03 00 00 00 0C 73 D5 41 0C 73 D5 41", gg.TYPE_BYTE)
        gg.clearResults()

        gg.toast("✅ Все оружия включены")

    else
        -- ВЫКЛЮЧАЕМ ВСЁ (вторые состояния)
        gg.searchNumber("h 03 00 00 00 E3 84 68 4A E3 84 68 4A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 07 00 00 00 E3 84 68 4A E3 84 68 4A", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 3D 21 99 45 37 21 99 45", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 01 00 00 00 3D 21 99 45 37 21 99 45", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 E5 9F 7D 75 E3 9F 7D 75", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 01 00 00 00 E5 9F 7D 75 E3 9F 7D 75", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 01 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 75 60 DF 72 70 60 DF 72", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 05 00 00 00 75 60 DF 72 70 60 DF 72", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 B5 6E 07 49 B4 6E 07 49", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 04 00 00 00 B5 6E 07 49 B4 6E 07 49", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 30 DE 06 50 36 DE 06 50", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 08 00 00 00 30 DE 06 50 36 DE 06 50", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 33 A0 16 5C 33 A0 16 5C", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 02 00 00 00 33 A0 16 5C 33 A0 16 5C", gg.TYPE_BYTE)
        gg.clearResults()

        gg.searchNumber("h 03 00 00 00 0C 73 D5 41 0C 73 D5 41", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        revert1 = gg.getResults(99999)
        gg.editAll("h 02 00 00 00 0C 73 D5 41 0C 73 D5 41", gg.TYPE_BYTE)
        gg.clearResults()

        gg.toast("❌ Все оружия выключены")
    end
end


function Multigun()
	local menu2 = gg.alert('Какой тип мультигана вы хотите запустить?', 'Default', 'Speed+')
if menu == 0 then -- User can cancel alert window by pressing "back" button
elseif menu2 == 1 then
      S109 = on
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
elseif menu2 == 2 then
      S109 = on
gg.clearResults()
gg.searchNumber("30D;10F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
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
end

function infall()
S110 = on
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
SSDI111 = on
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

function smgCross()
if S112 == off then
      S112 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("4", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S112 == on then
      S112 = off
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
if S113 == off then
      S113 = on
  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30D;10F;200F;1D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(1000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("8", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S113 == on then
      S113 = off
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
if S114 == off then
      S114 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("10D;1097859072D;1137180672D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1097859072", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S114 == on then
      S114 = off
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
"➤ RPG Give" .. S115,
"➤ SMG Give" .. S116,
"➤ AKM Give" .. S117,
"➤ Bat Give" .. S118,
"➤ Sniper Give" .. S119,
"➤ Pistol Give" .. S120,
"➤ PhysicsGun Give" .. S121,
"➤ ToolBaton Give" .. S122,
"Back"
},nil,
"gigain")
if filsst13 == nil then Weapon() else
if filsst13[1] == true then giveRPG() end
if filsst13[2] == true then giveSMG() end
if filsst13[3] == true then giveAKM() end
if filsst13[4] == true then giveBat() end
if filsst13[5] == true then giveSniper() end
if filsst13[6] == true then givePistol() end
if filsst13[7] == true then givePhysicsGun() end
if filsst13[8] == true then giveToolBaton() end
if filsst13[9] == true then Weapon() end end end

function giveToolBaton()
      S122 = on
        gg.setVisible(false)
        if editString('Camera', 'ToolBaton') then
            gg.clearResults()
            gg.toast("Activated!")
			end
			end
			
function givePhysicsGun()
      S121 = on
        gg.setVisible(false)
        if editString('Camera', 'PhysicsGun') then
            gg.clearResults()
      gg.toast("Activated")
end
end

function givePistol()
if S120 == off then
      S120 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Pistol", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S120 == on then
      S120 = off
      gg.searchNumber(":Pistol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveSniper()
if S119 == off then
      S119 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Sniper", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S119 == on then
      S119 = off
      gg.searchNumber(":Sniper", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveBat()
if S118 == off then
      S118 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Bat", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S118 == on then
      S118 = off
      gg.searchNumber(":Bat", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveRPG()
if S115 == off then
      S115 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":RPG", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S115 == on then
      S115 = off
      gg.searchNumber(":RPG", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveSMG()
if S116 == off then
      S116 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Smg", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S116 == on then
      S116 = off
      gg.searchNumber(":Pistol", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Camera", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function giveAKM()
if S117 == off then
      S117 = on
gg.searchNumber(":Camera", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":Akm", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S117 == on then
      S117 = off
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
"➤ SMG Ammo+Speed" .. S123,
"➤ SMG Bust" .. S124,
"➤ SMG RPG" .. S125,
"Back"
},nil,
"gigain")
if filsst14 == nil then Weapon() else
if filsst14[1] == true then smgammo() end
if filsst14[2] == true then smgbust() end
if filsst14[3] == true then smgrpgg() end
if filsst14[4] == true then Weapon() end end end

function smgammo()
if S123 == off then
      S123 = on
	  gg.alert("После того как уберешь смг из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;10F;200F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if S123 == on then
      S123 = off
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
if S124 == off then
      S124 = on
	  gg.alert("После того как уберешь смг из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("30D;10F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("10", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if S123 == on then
      S123 = off
gg.searchNumber("30D;100F;200F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("10", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function smgrpgg()
    if S125 == off then
        S125 = on
        gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("h 01 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert1 = gg.getResults(99999)
    gg.editAll("h 03 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE)
    gg.clearResults()
    elseif S125 == on then
        S125 = off
        gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("h 03 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert1 = gg.getResults(99999)
    gg.editAll("h 01 00 00 00 80 36 07 3F 9E 36 07 3F", gg.TYPE_BYTE)
    gg.clearResults()
    end
end


function shotgun()
filsst15 = gg.multiChoice({
"➤ ShotGun Ammo+Speed" .. S126,
"➤ ShotGun Bust" .. S127,
"➤ ShotGun RPG" .. S128,
"Back"
},nil,
"gigain")
if filsst15 == nil then gun() else
if filsst15[1] == true then shotammo() end
if filsst15[2] == true then shotbust() end
if filsst15[3] == true then shotrpg() end
if filsst15[4] == true then Weapon() end end end

function shotammo()
if S126 == off then
      S126 = on
	  gg.alert("После того как уберешь двобовик из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;20F;400F;257D", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("0", gg.TYPE_DWORD)
gg.clearResults()
else if S126 == on then
      S126 = off
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
if S127 == off then
      S127 = on
	  gg.alert("После того как уберешь дробовик из рук и возьмешь заново - тебя крашнет")
gg.searchNumber("6D;20F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("20", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("100", gg.TYPE_FLOAT)
gg.clearResults()
else if S127 == on then
      S127 = off
gg.searchNumber("30D;100F;400F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("100", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(10000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("20", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Deactivated")
      end
end
end

function Other()
filsst31 = gg.multiChoice({
    "NaN Mine" .. S129,
    "FPS Boost" .. S130,
    "Telo Svinini" .. S131,
    "Xray" .. S132,
    "Fun Lug" .. S133,
    "Gun no Animation" .. S134,
    "1.228 - NaN" .. S135,
    "1.454 - Infinity" .. S136,
    "Crash RPG" .. S137,
    "Monitor (wall_12 = Monitor)" .. S138,
    "Not Spawnpoint (Adventure)" .. S139,
    "All Password Panel - 0000" .. S140,
    "Nextbot Allow" .. S141,
	"Crash FPS" .. S142,
    "Back"
}, nil, "gigain")
if filsst31 == nil then return end
    if filsst31[1] == true then nanMine() end
    if filsst31[2] == true then fpsBoost() end
    if filsst31[3] == true then teloSvinini() end
    if filsst31[4] == true then xray() end
    if filsst31[5] == true then funLug() end
    if filsst31[6] == true then gunNoAnim() end
    if filsst31[7] == true then PIZDAAANaN() end
    if filsst31[8] == true then HYESOSInfinity() end
    if filsst31[9] == true then crashRPG() end
    if filsst31[10] == true then monitorWall() end
    if filsst31[11] == true then notSpawnpointAdventure() end
    if filsst31[12] == true then allPassword0000() end
    if filsst31[13] == true then nextbotAllow() end
    if filsst31[14] == true then noPvPMode() end
    if filsst31[15] == true then crashFps() end
    if filsst31[16] == true then back() end
end

function crashFps()
 S142 = on
-- мне лень щас добавлять це в скрипт, такчоуш будет такой секреткой. краш фпс
gg.searchNumber('0x1C', gg.TYPE_FLOAT)
gg.getResults(500000)
gg.editAll('99999999', gg.TYPE_FLOAT)
end

function nextbotAllow()
if S141 == off then
      S141 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Nextbot", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";abcdefg", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if S141 == on then
      S141 = off
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
if S140 == off then
      S140 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(";Password", gg.TYPE_WORD)
gg.getResults(1000)
gg.editAll(";qwertyui", gg.TYPE_WORD)
gg.clearResults()
      gg.toast("Activated")
else if S140 == on then
      S140 = off
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
if S139 == off then
      S139 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":SpawnPoint", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":abcdefghij", gg.TYPE_BYTE)
gg.clearResults()
      gg.toast("Activated")
else if S139 == on then
      S139 = off
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
if S138 == off then
      S138 = on
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber(":wall_12", gg.TYPE_BYTE)
gg.getResults(1000)
gg.editAll(":Monitor", gg.TYPE_BYTE)
gg.clearResults()


      gg.toast("Activated")
else if S138 == on then
      S138 = off
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
if S137 == off then
      S137 = on
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
else if S137 == on then
      S137 = off
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

function HYESOSInfinity()
if S136 == off then
      S136 = on
	  gg.alert("впиши 1.454 в моторе, репульсоре, триггере и тд, затем вруби и поставь. Будет Infinity")
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1069161644", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("2139095040", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S136 == on then
      S136 = off
      gg.toast("После перезахода офнется")
      end
end
end

function PIZDAAANaN()
if S135 == off then
      S135 = on
	  gg.alert("впиши 1.228 в моторе, репульсоре, триггере и тд, затем вруби и поставь. Будет NaN")
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1067265819", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_DWORD)
gg.clearResults()
      gg.toast("Activated")
else if S135 == on then
      S135 = off
      gg.toast("После перезахода офнется")
      end
end
end

function gunNoAnim()
if S134 == off then
      S134 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("30", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(2500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("150.7", gg.TYPE_FLOAT)
gg.clearResults()
      gg.toast("Activated")
else if S134 == on then
      S134 = off
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
if S133 == off then
      S133 = on
	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE)
gg.toast("Делай респ")
gg.clearResults()
      gg.toast("Activated")
else if S133 == on then
      S133 = off
	  	  gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("hCDCCCC3D00000000FFFFFFFF", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(500, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("hCDCCCC3D00007A44FFFFFFFF", gg.TYPE_BYTE)
      gg.toast("Deactivated")
      end
end
end

function xray()
if S132 == off then
      S132 = on
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
else if S132 == on then
      S132 = off
      gg.toast("Not Deactivated")
      end
end
end

function teloSvinini()
if S131 == off then
      S131 = on
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
else if S131 == on then
      S131 = off
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
if S130 == off then
      S130 = on
	  gg.searchNumber(":4 515 609 228 873 826 304", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100000, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(":4 515 609 228 871 570 691", gg.TYPE_QWORD)
gg.processResume()
gg.clearResults()
      gg.toast("Activated")
else if S130 == on then
      S130 = off
      gg.toast("После перезахода офается само")
      end
end
end

function nanMine()
if S129 == off then
      S129 = on
gg.searchNumber('1 060 528 047', gg.TYPE_DWORD)
gg.getResults(50000)
gg.editAll('-1', gg.TYPE_DWORD)
gg.clearResults()
gg.freeze = true
      gg.toast("Activated")
else if S129 == on then
      S129 = off
      gg.toast("Not Deactivated")
      end
end
end

function Info()
gg.alert("топ хуйпер скрипт бай китрит")
end

function Qack()
    Weapon()
end
        
function back()
    Main()
end

while true do
        if gg.isVisible(true) then
            Sanbox = 1
            gg.setVisible(false)
        end
        if Sanbox == 1 then Main() end
		end