-- ╔══════════════════════════════════════════════════╗
-- ║          Eclipse v5 — GitHub Loader              ║
-- ║  Как использовать:                               ║
-- ║  1. Залей Eclipse-v5-improved.lua на GitHub      ║
-- ║     в любой репозиторий (публичный)              ║
-- ║  2. Открой файл на GitHub → нажми Raw            ║
-- ║  3. Скопируй URL из адресной строки              ║
-- ║  4. Вставь URL в RAW_URL ниже                    ║
-- ║  5. Этот Loader закинь в эксплоит и запускай     ║
-- ╚══════════════════════════════════════════════════╝

local RAW_URL = "https://github.com/slepoyvsevi/Xaxolov/blob/main/Eclipse-v5-improved.lua"

-- ── Загрузка ─────────────────────────────────────────────────────
local ok, err = pcall(function()
    local src = game:HttpGet(RAW_URL, true)
    assert(type(src) == "string" and #src > 100, "Пустой ответ от GitHub")
    local fn, compileErr = loadstring(src)
    assert(fn, "Ошибка компиляции: " .. tostring(compileErr))
    fn()
end)

if not ok then
    -- Показываем ошибку через StarterGui если есть
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = "Eclipse — Ошибка загрузки",
            Text     = tostring(err),
            Duration = 8,
        })
    end)
    warn("[Eclipse Loader] " .. tostring(err))
end
