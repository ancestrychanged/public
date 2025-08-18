local warn = warn or function(...)
    local t = {}
    for i = 1, select('#', ...) do t[i] = tostring(select(i, ...)) end
    if io and io.stderr and io.stderr.write then
        io.stderr:write(table.concat(t, " "), "\n")
    else
        print(table.concat(t, " "))
    end
end

local function _safe_call(f)
    local ok = false
    ok = pcall(f)
    return ok
end

local function copy_to_clipboard_backend(text)
    -- exploits on roblo
    if getgenv then
        if type(rawget(getgenv(), "setclipboard")) == "function" then
            if _safe_call(function() setclipboard(text) end) then return true end
        end
    end

    -- garry's mod
    if type(rawget(_G, "SetClipboardText")) == "function" then
        if _safe_call(function() SetClipboardText(text) end) then return true end
    end

    -- fivem client (ox_lib present)
    if type(rawget(_G, "GetCurrentResourceName")) == "function" then
        local lib = rawget(_G, "lib")
        if type(lib) == "table" and type(lib.setClipboard) == "function" then
            if _safe_call(function() lib.setClipboard(text) end) then return true end
        end
    end

    -- world of warcraft: show a copy box
    if type(rawget(_G, "CreateFrame")) == "function" and rawget(_G, "UIParent") then
        local ok = _safe_call(function()
            local f = _G.InspectorCopyFrame
            if not f then
                f = CreateFrame("Frame", "InspectorCopyFrame", UIParent, "BackdropTemplate")
                f:SetSize(600, 300)
                f:SetPoint("CENTER")
                if f.SetBackdrop then
                    f:SetBackdrop({
                        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                        tile = true, tileSize = 16, edgeSize = 16,
                        insets = { left = 4, right = 4, top = 4, bottom = 4 }
                    })
                    f:SetBackdropColor(0, 0, 0, 0.9)
                end
                f:EnableMouse(true); f:SetMovable(true)
                f:RegisterForDrag("LeftButton")
                f:SetScript("OnDragStart", f.StartMoving)
                f:SetScript("OnDragStop", f.StopMovingOrSizing)

                local eb = CreateFrame("EditBox", nil, f, "InputBoxMultiLineTemplate")
                f.eb = eb
                eb:SetPoint("TOPLEFT", 10, -10)
                eb:SetPoint("BOTTOMRIGHT", -10, 40)
                eb:SetAutoFocus(true); eb:SetMultiLine(true)
                if _G.ChatFontNormal then eb:SetFontObject(ChatFontNormal) end

                local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
                btn:SetPoint("BOTTOMRIGHT", -10, 10); btn:SetSize(120, 22)
                btn:SetText("Close"); btn:SetScript("OnClick", function() f:Hide() end)

                local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                lbl:SetPoint("BOTTOMLEFT", 10, 15)
                lbl:SetText("Press Ctrl-C to copy")
            end
            f:Show(); f.eb:SetText(text); f.eb:HighlightText(); f.eb:SetFocus()
        end)
        if ok then return true end
    end

    -- plain Lua / LuaJIT on desktop
    local function _popen_write(cmd)
        if not io or not io.popen then return false end
        local p = io.popen(cmd, "w"); if not p then return false end
        p:write(text); p:close(); return true
    end

    if package and type(package.config) == "string" and package.config:sub(1,1) == "\\" then
        if _popen_write("clip") then return true end -- Windows
    else
        if _popen_write("pbcopy") then return true end -- macOS
        if _popen_write("xclip -selection clipboard") then return true end -- Linux
        if _popen_write("xsel -b") then return true end -- Linux alt
    end

    -- warcraft 3/roblox/locked sandboxes -> no clipboard, fall through
    return false
end

local inspector = {}

inspector.defaults = {
    maxdepth = math.huge, -- stop at this depth
    sortshit = true, -- sort keys for stable output (strings/numbers first)
    showmt = true, -- include metatable
    maxitems = nil, -- max items per table (nil = unlimited)
    maxstringlen = nil, -- truncate very long strings (nil = unlimited)
    indentationstep = 4 -- spaces per indent level
}

local function safetostring(x)
    local ok, s = pcall(tostring, x)
    return ok and s or "<tostring error>"
end

local function strwrap(s, maxLen)
    if maxLen and #s > maxLen then
        s = s:sub(1, maxLen) .. "...<truncated>"
    end
    
    return string.format("%q", s)
end

local function safetypeof(v)
    -- typeof() is better than type()
    -- though im executing this on normal lua sooo
    -- just a fllback
    local ok, tv = pcall(function() return typeof and typeof(v) end)
    return (ok and tv) or type(v)
end

local function identifier(str)
    return safetypeof(str) == "string" and str:match("^[_%a][_%w]*$") ~= nil
end

local function sortshit(keys)
    table.sort(keys, function(a, b)
        local ta, tb = safetypeof(a), safetypeof(b)
        if ta == tb and (ta == "string" or ta == "number") then
            return a < b
        end
        
        local rank = {string = 1, number = 2, boolean = 3, ["nil"] = 4, table = 5, ["function"] = 6, userdata = 7, thread = 8}
        return (rank[ta] or 99) < (rank[tb] or 99)
    end)
end

local function datatypeserialzieationfuckyou(v, opts)
    local t = safetypeof(v)
    if t == "string" then return strwrap(v, opts.maxstringlen)
    elseif t == "number" then return tostring(v)
    elseif t == "boolean" then return tostring(v)
    elseif t == "nil" then return "nil"
    elseif t == "function" then return "<function " .. safetostring(v) .. ">"
    elseif t == "userdata" then return "<userdata " .. safetostring(v) .. ">"
    elseif t == "thread" then return "<thread " .. safetostring(v) .. ">"
    else return "<" .. t .. " " .. safetostring(v) .. ">"
    end
end

local function _inspect(v, opts, seen, path, depth, indent)
    local t = safetypeof(v)
    if t ~= "table" then
        return datatypeserialzieationfuckyou(v, opts)
    end

    if seen[v] then
        return "<cycle -> " .. seen[v] .. ">"
    end

    if depth >= opts.maxdepth then
        return "<maxdepth table " .. safetostring(v) .. ">"
    end

    seen[v] = path

    local keys, count = {}, 0
    for i in pairs(v) do
        count = count + 1
        keys[#keys + 1] = i
    end

    if opts.sortshit then
        sortshit(keys)
    end

    local pieces = {}
    local nextINdentation = indent + opts.indentationstep
    local prefix = string.rep(" ", nextINdentation)
    local shown = 0
    local _tbl = v -- keep ref

    for _, k in ipairs(keys) do
        shown = shown + 1 -- shown += 1 is Luau only

        if not opts.maxitems or shown <= opts.maxitems then
            local representaition

            if identifier(k) then
                representaition = tostring(k) .. " = "
            else
                representaition = "[" .. _inspect(k, opts, seen, path .. "[key]", depth + 1, nextINdentation) .. "] = "
            end

            local _val = _inspect(_tbl[k], opts, seen, path .. "." .. safetostring(k), depth + 1, nextINdentation)
            pieces[#pieces + 1] = prefix .. representaition .. _val
        else
            pieces[#pieces + 1] = prefix .. "<" .. (count - (opts.maxitems or 0)) .. " more items omitted>"
            break
        end
    end


    if opts.showmt then
        local mt = getmetatable(v)
        if mt ~= nil then
            pieces[#pieces + 1] = prefix .. "<metatable> = " .. _inspect(mt, opts, seen, path .. "<metatable>", depth + 1, nextINdentation)
        end
    end

    seen[v] = nil

    if #pieces == 0 then
        return "{}"
    else
        return "{\n" .. table.concat(pieces, ",\n") .. "\n" .. string.rep(" ", indent) .. "}"
    end
end

function inspector.inspect(value, opts)
    opts = opts or {}

    for i, v in pairs(inspector.defaults) do
        if opts[i] == nil then opts[i] = v end
    end

    return _inspect(value, opts, {}, "<root>", 0, 0)
end

function inspector.copy(value, opts)
    local dump = inspector.inspect(value, opts)
    local ok = copy_to_clipboard_backend(dump)

    if ok then
        return true, dump
    else
        warn("[inspector inspect] clipboard unavailable; here is the dump:\n" .. dump)
        return false, dump
    end
end

-- example:

-- local t = {a = 1, b = {c = 2}, d = {1, 2, 3}}
-- local ok, text = inspector.copy(t)
-- print("copied to clipboard:", ok)

return inspector
