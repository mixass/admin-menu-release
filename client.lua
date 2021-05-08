--[[
    discord.gg/x74z8GvrtJ
    MIXAS AntiCheat
    credit : hoax
]]
RegisterNetEvent("m-x-s-is-best")
AddEventHandler("m-x-s-is-best", function()
oTableHahaha = {}
do
    function oTableHahaha.insert(t, k, v)
    if not rawget(t._values, k) then -- new key 
        t._keys[#t._keys + 1] = k
    end
    if v == nil then -- delete key too.
        oTableHahaha.remove(t, k)
    else -- update/store value
        t._values[k] = v 
    end
    end

    local function find(t, value)
    for i,v in ipairs(t) do
        if v == value then
        return i
        end
    end
    end  

    function oTableHahaha.remove(t, k)
    local v = t._values[k]
    if v ~= nil then
        table.remove(t._keys, find(t._keys, k))
        t._values[k] = nil
    end
    return v
    end

    function oTableHahaha.index(t, k)
        return rawget(t._values, k)
    end

    function oTableHahaha.pairs(t)
    local i = 0
    return function()
        i = i + 1
        local key = t._keys[i]
        if key ~= nil then
        return key, t._values[key]
        end
    end
    end

    function oTableHahaha.new(init)
    init = init or {}
    local t = {_keys={}, _values={}}
    local n = #init
    if n % 2 ~= 0 then
        error"in oTableHahaha initialization: key is missing value"
    end
    for i=1,n/2 do
        local k = init[i * 2 - 1]
        local v = init[i * 2]
        if t._values[k] ~= nil then
        error("duplicate key:"..k)
        end
        t._keys[#t._keys + 1]  = k
        t._values[k] = v
    end
    return setmetatable(t,
        {__newindex=oTableHahaha.insert,
        __len=function(t) return #t._keys end,
        __pairs=oTableHahaha.pairs,
        __index=t._values
        })
    end
end

--==================================================================================================================================================--
--[[ NativeUI\Wrapper\Utility ]]
--==================================================================================================================================================--
do
    function table.Contains(table, val)
        for index, value in pairs(table) do if value == val then return true end end
        return false
    end

    function table.ContainsKey(table, key)
        return table[key] ~= nil
    end

    function table.Count(table)
        local count = 0
        if table ~= nil then
            for _ in pairs(table) do count = count + 1 end
        end
        return count
    end

    function string.IsNullOrEmpty(str) return str == nil or str == '' end

    function GetResolution()
        local W, H = 1920, 1080
        if GetActiveScreenResolution ~= nil then
            W, H = GetActiveScreenResolution()
        elseif GetScreenActiveResolution ~= nil then
            W, H = GetScreenActiveResolution()
        else
            W, H = N_0x873c9f3104101dd3()
        end
        if (W / H) > 3.5 then W, H = GetScreenResolution() end
        if W < 1920 then W = 1920 end
        if H < 1080 then H = 1080 end
        return W, H
    end

    function FormatXWYH(Value, Value2)
        local W, H = GetScreenResolution()
        local AW, AH = GetResolution()
        local XW = Value * (1 / W - ((1 / W) - (1 / AW)))
        local YH = Value2 * (1 / H - ((1 / H) - (1 / AH)))
        return XW, YH
    end

    function ReverseFormatXWYH(Value, Value2)
        local W, H = GetScreenResolution()
        local AW, AH = GetResolution()
        local XW = Value / (1 / W - (1 * (1 / W) - (1 / AW)))
        local YH = Value2 / (1 / H - ((1 / H) - (1 / AH)))
        return XW, YH
    end

    function ConvertToPixel(x, y)
        local AW, AH = GetResolution()
        return math.round(x * AW), math.round(y * AH)
    end

    function math.round(num, numDecimalPlaces) return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num)) end
    
    function math.trim(value) if value then return (string.gsub(value, "^%s*(.-)%s*$", "%1")) else return nil end end

    function ToBool(input)
        if input == "true" or tonumber(input) == 1 or input == true then
            return true
        else
            return false
        end
    end

    function string.split(inputstr, sep)
        if sep == nil then sep = "%s" end
        local t = {}
        local i = 1
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
            t[i] = str
            i = i + 1
        end
        return t
    end

    function string.starts(String, Start) return string.sub(String, 1, string.len(Start)) == Start end

    function IsMouseInBounds(X, Y, Width, Height, DrawOffset)
        local W, H = GetResolution()
        local MX, MY = math.round(GetControlNormal(0, 239) * W), math.round(GetControlNormal(0, 240) * H)
        MX, MY = FormatXWYH(MX, MY)
        X, Y = FormatXWYH(X, Y)
        if DrawOffset then
            X = X + DrawOffset.X
            Y = Y + DrawOffset.Y
        end
        Width, Height = FormatXWYH(Width, Height)
        return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
    end

    function TableDump(o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                s = s .. '[' .. k .. '] = ' .. TableDump(v) .. ','
            end
            return s .. '} '
        else
            return print(tostring(o))
        end
    end

    function Controller()
        return not GetLastInputMethod(2) -- IsInputDisabled() --N_0xA571D46727E2B718
    end

    function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
        Text = tostring(Text)
        X, Y = FormatXWYH(X, Y)
        SetTextFont(Font or 0)
        SetTextScale(1.0, Scale or 0)
        SetTextColour(R or 255, G or 255, B or 255, A or 255)

        if DropShadow then SetTextDropShadow() end
        if Outline then SetTextOutline() end

        if Alignment ~= nil then
            if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
                SetTextCentre(true)
            elseif Alignment == 2 or Alignment == "Right" then
                SetTextRightJustify(true)
                SetTextWrap(0, X)
            end
        end

        if tonumber(WordWrap) then
            if tonumber(WordWrap) ~= 0 then
                WordWrap, _ = FormatXWYH(WordWrap, 0)
                SetTextWrap(WordWrap, X - WordWrap)
            end
        end

        if BeginTextCommandDisplayText ~= nil then
            BeginTextCommandDisplayText("STRING")
        else
            SetTextEntry("STRING")
        end
        AddLongString(Text)

        if EndTextCommandDisplayText ~= nil then
            EndTextCommandDisplayText(X, Y)
        else
            DrawText(X, Y)
        end
    end

    function DrawRectangle(X, Y, Width, Height, R, G, B, A)
        X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
        X, Y = FormatXWYH(X, Y)
        Width, Height = FormatXWYH(Width, Height)
        DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255,
                    tonumber(A) or 255)
    end

    function DrawTexture(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
        if not HasStreamedTextureDictLoaded(tostring(TxtDictionary) or "") then
            RequestStreamedTextureDict(tostring(TxtDictionary) or "", true)
        end
        X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
        X, Y = FormatXWYH(X, Y)
        Width, Height = FormatXWYH(Width, Height)
        DrawSprite(tostring(TxtDictionary) or "", tostring(TxtName) or "", X + Width * 0.5, Y + Height * 0.5, Width, Height,
                    tonumber(Heading) or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
    end

    function PrintTable(node)
        -- to make output beautiful
        local function tab(amt)
            local str = ""
            for i = 1, amt do str = str .. "\t" end
            return str
        end

        local cache, stack, output = {}, {}, {}
        local depth = 1
        local output_str = "{\n"

        while true do
            local size = 0
            for k, v in pairs(node) do size = size + 1 end

            local cur_index = 1
            for k, v in pairs(node) do
                if (cache[node] == nil) or (cur_index >= cache[node]) then

                    if (string.find(output_str, "}", output_str:len())) then
                        output_str = output_str .. ",\n"
                    elseif not (string.find(output_str, "\n", output_str:len())) then
                        output_str = output_str .. "\n"
                    end

                    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                    table.insert(output, output_str)
                    output_str = ""

                    local key
                    if (type(k) == "number" or type(k) == "boolean") then
                        key = "[" .. tostring(k) .. "]"
                    else
                        key = "['" .. tostring(k) .. "']"
                    end

                    if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. tab(depth) .. key .. " = " .. tostring(v)
                    elseif (type(v) == "table") then
                        output_str = output_str .. tab(depth) .. key .. " = {\n"
                        table.insert(stack, node)
                        table.insert(stack, v)
                        cache[node] = cur_index + 1
                        break
                    else
                        output_str = output_str .. tab(depth) .. key .. " = '" .. tostring(v) .. "'"
                    end

                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
                    else
                        output_str = output_str .. ","
                    end
                else
                    -- close the table
                    if (cur_index == size) then output_str = output_str .. "\n" .. tab(depth - 1) .. "}" end
                end

                cur_index = cur_index + 1
            end

            if (size == 0) then output_str = output_str .. "\n" .. tab(depth - 1) .. "}" end

            if (#stack > 0) then
                node = stack[#stack]
                stack[#stack] = nil
                depth = cache[node] == nil and depth + 1 or depth - 1
            else
                break
            end
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = table.concat(output)

        print(output_str)
    end

    --[[ Rainbow Color Generator ]]
    --function GenerateRainbow(frequency)
   --     local result = {}
    --    local curtime = GetGameTimer() / 1000
    --    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    --    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
     --   result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)
     --   return result
    --end
end

--==================================================================================================================================================--
--[[ NativeUI\UIElements\UIVisual ]]
--==================================================================================================================================================--
UIVisual = setmetatable({}, UIVisual)
UIVisual.__index = UIVisual
do
    function UIVisual:Popup(array)
        ClearPrints()
        if (array.colors == nil) then
            SetNotificationBackgroundColor(140)
        else
            SetNotificationBackgroundColor(array.colors)
        end
        SetNotificationTextEntry("STRING")
        if (array.message == nil) then
            error("Missing arguments, message")
        else
            AddTextComponentString(tostring(array.message))
        end
        DrawNotification(false, true)
        if (array.sound ~= nil) then
            if (array.sound.audio_name ~= nil) then
                if (array.sound.audio_ref ~= nil) then
                    PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
                else
                    error("Missing arguments, audio_ref")
                end
            else
                error("Missing arguments, audio_name")
            end
        end
    end

    function UIVisual:PopupChar(array)
        if (array.colors == nil) then
            SetNotificationBackgroundColor(140)
        else
            SetNotificationBackgroundColor(array.colors)
        end
        SetNotificationTextEntry("STRING")
        if (array.message == nil) then
            error("Missing arguments, message")
        else
            AddTextComponentString(tostring(array.message))
        end
        if (array.request_stream_texture_dics ~= nil) then RequestStreamedTextureDict(array.request_stream_texture_dics) end
        if (array.picture ~= nil) then
            if (array.iconTypes == 1) or (array.iconTypes == 2) or (array.iconTypes == 3) or (array.iconTypes == 7) or
                (array.iconTypes == 8) or (array.iconTypes == 9) then
                SetNotificationMessage(tostring(array.picture), tostring(array.picture), true, array.iconTypes, array.sender, array.title)
            else
                SetNotificationMessage(tostring(array.picture), tostring(array.picture), true, 4, array.sender, array.title)
            end
        else
            if (array.iconTypes == 1) or (array.iconTypes == 2) or (array.iconTypes == 3) or (array.iconTypes == 7) or
                (array.iconTypes == 8) or (array.iconTypes == 9) then
                SetNotificationMessage('CHAR_ALL_PLAYERS_CONF', 'CHAR_ALL_PLAYERS_CONF', true, array.iconTypes, array.sender, array.title)
            else
                SetNotificationMessage('CHAR_ALL_PLAYERS_CONF', 'CHAR_ALL_PLAYERS_CONF', true, 4, array.sender, array.title)
            end
        end
        if (array.sound ~= nil) then
            if (array.sound.audio_name ~= nil) then
                if (array.sound.audio_ref ~= nil) then
                    PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
                else
                    error("Missing arguments, audio_ref")
                end
            else
                error("Missing arguments, audio_name")
            end
        end
        DrawNotification(false, true)
    end

    function UIVisual:Text(array)
        ClearPrints()
        SetTextEntry_2("STRING")
        if (array.message ~= nil) then
            AddTextComponentString(tostring(array.message))
        else
            error("Missing arguments, message")
        end
        if (array.time_display ~= nil) then
            DrawSubtitleTimed(tonumber(array.time_display), 1)
        else
            DrawSubtitleTimed(6000, 1)
        end
        if (array.sound ~= nil) then
            if (array.sound.audio_name ~= nil) then
                if (array.sound.audio_ref ~= nil) then
                    PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
                else
                    error("Missing arguments, audio_ref")
                end
            else
                error("Missing arguments, audio_name")
            end
        end
    end

    function UIVisual:FloatingHelpText(array)
        BeginTextCommandDisplayHelp("STRING")
        if (array.message ~= nil) then
            AddTextComponentScaleform(array.message)
        else
            error("Missing arguments, message")
        end
        EndTextCommandDisplayHelp(0, 0, 1, -1)
        if (array.sound ~= nil) then
            if (array.sound.audio_name ~= nil) then
                if (array.sound.audio_ref ~= nil) then
                    PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
                else
                    error("Missing arguments, audio_ref")
                end
            else
                error("Missing arguments, audio_name")
            end
        end
    end

    function UIVisual:ShowFreemodeMessage(array)
        if (array.sound ~= nil) then
            if (array.sound.audio_name ~= nil) then
                if (array.sound.audio_ref ~= nil) then
                    PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
                else
                    error("Missing arguments, audio_ref")
                end
            else
                error("Missing arguments, audio_name")
            end
        end
        if (array.request_scaleform ~= nil) then
            local scaleform = Pyta.Request.Scaleform({movie = array.request_scaleform.movie})
            if (array.request_scaleform.scale ~= nil) then
                PushScaleformMovieFunction(scaleform, array.request_scaleform.scale)
            else
                PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
            end
        else
            local scaleform = Pyta.Request.Scaleform({movie = 'MP_BIG_MESSAGE_FREEMODE'})
            if (array.request_scaleform.scale ~= nil) then
                PushScaleformMovieFunction(scaleform, array.request_scaleform.scale)
            else
                PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
            end
        end
        if (array.title ~= nil) then
            PushScaleformMovieFunctionParameterString(array.title)
        else
            ConsoleLog({message = 'Missing arguments { title = "Nice title" } '})
        end
        if (array.message ~= nil) then
            PushScaleformMovieFunctionParameterString(array.message)
        else
            ConsoleLog({message = 'Missing arguments { message = "Yeah display message right now" } '})
        end
        if (array.shake_gameplay ~= nil) then ShakeGameplayCam(array.shake_gameplay, 1.0) end
        if (array.screen_effect_in ~= nil) then StartScreenEffect(array.screen_effect_in, 0, 0) end
        PopScaleformMovieFunctionVoid()
        while array.time > 0 do
            Citizen.Wait(1)
            array.time = array.time - 1.0
            StopScreenEffect(scaleform, 255, 255, 255, 255)
        end
        if (array.screen_effect_in ~= nil) then StopScreenEffect(array.screen_effect_in) end
        if (array.screen_effect_out ~= nil) then StartScreenEffect(array.screen_effect_out, 0, 0) end
        SetScaleformMovieAsNoLongerNeeded(scaleform)
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIElements\UIResRectangle ]]
--==================================================================================================================================================--
UIResRectangle = setmetatable({}, UIResRectangle)
UIResRectangle.__index = UIResRectangle
UIResRectangle.__call = function() return "Rectangle" end
do
    function UIResRectangle.New(X, Y, Width, Height, R, G, B, A)
        local _UIResRectangle = {
            X = tonumber(X) or 0,
            Y = tonumber(Y) or 0,
            Width = tonumber(Width) or 0,
            Height = tonumber(Height) or 0,
            _Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255}
        }
        return setmetatable(_UIResRectangle, UIResRectangle)
    end

    function UIResRectangle:Position(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.X = tonumber(X)
            self.Y = tonumber(Y)
        else
            return {X = self.X, Y = self.Y}
        end
    end

    function UIResRectangle:Size(Width, Height)
        if tonumber(Width) and tonumber(Height) then
            self.Width = tonumber(Width)
            self.Height = tonumber(Height)
        else
            return {Width = self.Width, Height = self.Height}
        end
    end

    function UIResRectangle:Colour(R, G, B, A)
        if tonumber(R) or tonumber(G) or tonumber(B) or tonumber(A) then
            self._Colour.R = tonumber(R) or 255
            self._Colour.B = tonumber(B) or 255
            self._Colour.G = tonumber(G) or 255
            self._Colour.A = tonumber(A) or 255
        else
            return self._Colour
        end
    end

    function UIResRectangle:Draw()
        local Position = self:Position()
        local Size = self:Size()
        Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
        Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
        DrawRect(Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height, self._Colour.R, self._Colour.G,
                    self._Colour.B, self._Colour.A)
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIElements\UIResText ]]
--==================================================================================================================================================--
UIResText = setmetatable({}, UIResText)
UIResText.__index = UIResText
UIResText.__call = function() return "Text" end
do
    function GetCharacterCount(str)
        local characters = 0
        for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            local a = c:byte(1, -1)
            if a ~= nil then characters = characters + 1 end
        end
        return characters
    end

    function GetByteCount(str)
        local bytes = 0
        for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            local a, b, c, d = c:byte(1, -1)
            if a ~= nil then bytes = bytes + 1 end
            if b ~= nil then bytes = bytes + 1 end
            if c ~= nil then bytes = bytes + 1 end
            if d ~= nil then bytes = bytes + 1 end
        end
        return bytes
    end

    function AddLongStringForAscii(str)
        local maxByteLengthPerString = 99
        for i = 1, GetCharacterCount(str), maxByteLengthPerString do
            AddTextComponentString(string.sub(str, i, i + maxByteLengthPerString))
        end
    end

    function AddLongStringForUtf8(str)
        local maxByteLengthPerString = 99
        local bytecount = GetByteCount(str)
        local charcount = GetCharacterCount(str)
        if bytecount < maxByteLengthPerString then
            AddTextComponentString(str)
            return
        end
        local startIndex = 0
        for i = 0, charcount, 1 do
            local length = i - startIndex
            if GetByteCount(string.sub(str, startIndex, length)) > maxByteLengthPerString then
                AddTextComponentString(string.sub(str, startIndex, length - 1))
                i = i - 1
                startIndex = startIndex + (length - 1)
            end
        end
        AddTextComponentString(string.sub(str, startIndex, charcount - startIndex))
    end

    function AddLongString(str)
        local bytecount = GetByteCount(str)
        if bytecount == GetCharacterCount(str) then
            AddLongStringForAscii(str)
        else
            AddLongStringForUtf8(str)
        end
    end

    function MeasureStringWidthNoConvert(str, font, scale)
        SetTextEntryForWidth("STRING")
        AddLongString(str)
        SetTextFont(font or 0)
        SetTextScale(1.0, scale or 0)
        if EndTextCommandGetWidth ~= nil then
            return EndTextCommandGetWidth(true)
        else
            return GetTextScreenWidth(true)
        end
    end

    function MeasureStringWidth(str, font, scale)
        local W, H = GetResolution()
        return MeasureStringWidthNoConvert(str, font, scale) * W
    end

    function UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap, LongText)
        local _UIResText = {
            _Text = tostring(Text) or "",
            X = tonumber(X) or 0,
            Y = tonumber(Y) or 0,
            Scale = tonumber(Scale) or 0,
            _Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255},
            Font = tonumber(Font) or 0,
            Alignment = Alignment or nil,
            DropShadow = DropShadow or nil,
            Outline = Outline or nil,
            WordWrap = tonumber(WordWrap) or 0,
            LongText = ToBool(LongText) or false
        }
        return setmetatable(_UIResText, UIResText)
    end

    function UIResText:Position(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.X = tonumber(X)
            self.Y = tonumber(Y)
        else
            return {X = self.X, Y = self.Y}
        end
    end

    function UIResText:Colour(R, G, B, A)
        if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
            self._Colour.R = tonumber(R)
            self._Colour.B = tonumber(B)
            self._Colour.G = tonumber(G)
            self._Colour.A = tonumber(A)
        else
            return self._Colour
        end
    end

    function UIResText:Text(Text)
        if tostring(Text) and Text ~= nil then
            self._Text = tostring(Text)
        else
            return self._Text
        end
    end

    function UIResText:Draw()
        local Position = self:Position()
        Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)

        SetTextFont(self.Font)
        SetTextScale(1.0, self.Scale)
        SetTextColour(self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)

        if self.DropShadow then SetTextDropShadow() end
        if self.Outline then SetTextOutline() end

        if self.Alignment ~= nil then
            if self.Alignment == 1 or self.Alignment == "Center" or self.Alignment == "Centre" then
                SetTextCentre(true)
            elseif self.Alignment == 2 or self.Alignment == "Right" then
                SetTextRightJustify(true)
                SetTextWrap(0, Position.X)
            end
        end

        if tonumber(self.WordWrap) then
            if tonumber(self.WordWrap) ~= 0 then
                SetTextWrap(Position.X, Position.X + (tonumber(self.WordWrap) / Resolution.Width))
            end
        end

        if BeginTextCommandDisplayText ~= nil then
            BeginTextCommandDisplayText(self.LongText and "CELL_EMAIL_BCON" or "STRING");
        else
            SetTextEntry(self.LongText and "CELL_EMAIL_BCON" or "STRING");
        end
        AddLongString(self._Text)

        if EndTextCommandDisplayText ~= nil then
            EndTextCommandDisplayText(Position.X, Position.Y)
        else
            DrawText(Position.X, Position.Y)
        end
    end
end


--==================================================================================================================================================--
--[[ NativeUI\UIElements\Sprite ]]
--==================================================================================================================================================--
Sprite = setmetatable({}, Sprite)
Sprite.__index = Sprite
Sprite.__call = function() return "Sprite" end
do
    function Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
        local _Sprite = {
            TxtDictionary = tostring(TxtDictionary),
            TxtName = tostring(TxtName),
            X = tonumber(X) or 0,
            Y = tonumber(Y) or 0,
            Width = tonumber(Width) or 0,
            Height = tonumber(Height) or 0,
            Heading = tonumber(Heading) or 0,
            _Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255}
        }
        return setmetatable(_Sprite, Sprite)
    end

    function Sprite:Position(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.X = tonumber(X)
            self.Y = tonumber(Y)
        else
            return {X = self.X, Y = self.Y}
        end
    end

    function Sprite:Size(Width, Height)
        if tonumber(Width) and tonumber(Width) then
            self.Width = tonumber(Width)
            self.Height = tonumber(Height)
        else
            return {Width = self.Width, Height = self.Height}
        end
    end

    function Sprite:Colour(R, G, B, A)
        if tonumber(R) or tonumber(G) or tonumber(B) or tonumber(A) then
            self._Colour.R = tonumber(R) or 255
            self._Colour.B = tonumber(B) or 255
            self._Colour.G = tonumber(G) or 255
            self._Colour.A = tonumber(A) or 255
        else
            return self._Colour
        end
    end

    function Sprite:Draw()
        if not HasStreamedTextureDictLoaded(self.TxtDictionary) then RequestStreamedTextureDict(self.TxtDictionary, true) end
        local Position = self:Position()
        local Size = self:Size()
        Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
        Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
        DrawSprite(self.TxtDictionary, self.TxtName, Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height,
                    self.Heading, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\elements\Badge ]]
--==================================================================================================================================================--
BadgeStyle = {
    None = 0,
    BronzeMedal = 1,
    GoldMedal = 2,
    SilverMedal = 3,
    Alert = 4,
    Crown = 5,
    Ammo = 6,
    Armour = 7,
    Barber = 8,
    Clothes = 9,
    Franklin = 10,
    Bike = 11,
    Car = 12,
    Gun = 13,
    Heart = 14,
    Makeup = 15,
    Mask = 16,
    Michael = 17,
    Star = 18,
    Tattoo = 19,
    Trevor = 20,
    Lock = 21,
    Tick = 22,
    Sale = 23,
    ArrowLeft = 24,
    ArrowRight = 25,
    Audio1 = 26,
    Audio2 = 27,
    Audio3 = 28,
    AudioInactive = 29,
    AudioMute = 30,
    Info = 31,
    MenuArrow = 32,
    GTAV = 33
}
BadgeTexture = {
    [0] = function() return "" end,
    [1] = function() return "mp_medal_bronze" end,
    [2] = function() return "mp_medal_gold" end,
    [3] = function() return "mp_medal_silver" end,
    [4] = function() return "mp_alerttriangle" end,
    [5] = function() return "mp_hostcrown" end,
    [6] = function(Selected)
        if Selected then
            return "shop_ammo_icon_b"
        else
            return "shop_ammo_icon_a"
        end
    end,
    [7] = function(Selected)
        if Selected then
            return "shop_armour_icon_b"
        else
            return "shop_armour_icon_a"
        end
    end,
    [8] = function(Selected)
        if Selected then
            return "shop_barber_icon_b"
        else
            return "shop_barber_icon_a"
        end
    end,
    [9] = function(Selected)
        if Selected then
            return "shop_clothing_icon_b"
        else
            return "shop_clothing_icon_a"
        end
    end,
    [10] = function(Selected)
        if Selected then
            return "shop_franklin_icon_b"
        else
            return "shop_franklin_icon_a"
        end
    end,
    [11] = function(Selected)
        if Selected then
            return "shop_garage_bike_icon_b"
        else
            return "shop_garage_bike_icon_a"
        end
    end,
    [12] = function(Selected)
        if Selected then
            return "shop_garage_icon_b"
        else
            return "shop_garage_icon_a"
        end
    end,
    [13] = function(Selected)
        if Selected then
            return "shop_gunclub_icon_b"
        else
            return "shop_gunclub_icon_a"
        end
    end,
    [14] = function(Selected)
        if Selected then
            return "shop_health_icon_b"
        else
            return "shop_health_icon_a"
        end
    end,
    [15] = function(Selected)
        if Selected then
            return "shop_makeup_icon_b"
        else
            return "shop_makeup_icon_a"
        end
    end,
    [16] = function(Selected)
        if Selected then
            return "shop_mask_icon_b"
        else
            return "shop_mask_icon_a"
        end
    end,
    [17] = function(Selected)
        if Selected then
            return "shop_michael_icon_b"
        else
            return "shop_michael_icon_a"
        end
    end,
    [18] = function() return "shop_new_star" end,
    [19] = function(Selected)
        if Selected then
            return "shop_tattoos_icon_b"
        else
            return "shop_tattoos_icon_a"
        end
    end,
    [20] = function(Selected)
        if Selected then
            return "shop_trevor_icon_b"
        else
            return "shop_trevor_icon_a"
        end
    end,
    [21] = function() return "shop_lock" end,
    [22] = function() return "shop_tick_icon" end,
    [23] = function() return "saleicon" end,
    [24] = function() return "arrowleft" end,
    [25] = function() return "arrowright" end,
    [26] = function() return "leaderboard_audio_1" end,
    [27] = function() return "leaderboard_audio_2" end,
    [28] = function() return "leaderboard_audio_3" end,
    [29] = function() return "leaderboard_audio_inactive" end,
    [30] = function() return "leaderboard_audio_mute" end,
    [31] = function() return "info_icon_32" end,
    [32] = function() return "menuarrow_32" end,
    [33] = function() return "mpgroundlogo_bikers" end
}
BadgeDictionary = {
    [0] = function(Selected)
        if Selected then
            return "commonmenu"
        else
            return "commonmenu"
        end
    end,
    [31] = function(Selected)
        if Selected then
            return "shared"
        else
            return "shared"
        end
    end,
    [32] = function(Selected)
        if Selected then
            return "shared"
        else
            return "shared"
        end
    end,
    [33] = function(Selected)
        if Selected then
            return "3dtextures"
        else
            return "3dtextures"
        end
    end
}
BadgeColour = {
    [5] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [21] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [22] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end
}
do
    function GetBadgeTexture(Badge, Selected)
        if BadgeTexture[Badge] then
            return BadgeTexture[Badge](Selected)
        else
            return ""
        end
    end

    function GetBadgeDictionary(Badge, Selected)
        if BadgeDictionary[Badge] then
            return BadgeDictionary[Badge](Selected)
        else
            return "commonmenu"
        end
    end

    function GetBadgeColour(Badge, Selected)
        if BadgeColour[Badge] then
            return BadgeColour[Badge](Selected)
        else
            return 255, 255, 255, 255
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\elements\StringMeasurer ]]
--==================================================================================================================================================--
CharacterMap = {
    [' '] = 6,
    ['!'] = 6,
    ['"'] = 6,
    ['#'] = 11,
    ['$'] = 10,
    ['%'] = 17,
    ['&'] = 13,
    ['\\'] = 4,
    ['('] = 6,
    [')'] = 6,
    ['*'] = 7,
    ['+'] = 10,
    [','] = 4,
    ['-'] = 6,
    ['.'] = 4,
    ['/'] = 7,
    ['0'] = 12,
    ['1'] = 7,
    ['2'] = 11,
    ['3'] = 11,
    ['4'] = 11,
    ['5'] = 11,
    ['6'] = 12,
    ['7'] = 10,
    ['8'] = 11,
    ['9'] = 11,
    [':'] = 5,
    [';'] = 4,
    ['<'] = 9,
    ['='] = 9,
    ['>'] = 9,
    ['?'] = 10,
    ['@'] = 15,
    ['A'] = 12,
    ['B'] = 13,
    ['C'] = 14,
    ['D'] = 14,
    ['E'] = 12,
    ['F'] = 12,
    ['G'] = 15,
    ['H'] = 14,
    ['I'] = 5,
    ['J'] = 11,
    ['K'] = 13,
    ['L'] = 11,
    ['M'] = 16,
    ['N'] = 14,
    ['O'] = 16,
    ['P'] = 12,
    ['Q'] = 15,
    ['R'] = 13,
    ['S'] = 12,
    ['T'] = 11,
    ['U'] = 13,
    ['V'] = 12,
    ['W'] = 18,
    ['X'] = 11,
    ['Y'] = 11,
    ['Z'] = 12,
    ['['] = 6,
    [']'] = 6,
    ['^'] = 9,
    ['_'] = 18,
    ['`'] = 8,
    ['a'] = 11,
    ['b'] = 12,
    ['c'] = 11,
    ['d'] = 12,
    ['e'] = 12,
    ['f'] = 5,
    ['g'] = 13,
    ['h'] = 11,
    ['i'] = 4,
    ['j'] = 4,
    ['k'] = 10,
    ['l'] = 4,
    ['m'] = 18,
    ['n'] = 11,
    ['o'] = 12,
    ['p'] = 12,
    ['q'] = 12,
    ['r'] = 7,
    ['s'] = 9,
    ['t'] = 5,
    ['u'] = 11,
    ['v'] = 10,
    ['w'] = 14,
    ['x'] = 9,
    ['y'] = 10,
    ['z'] = 9,
    ['{'] = 6,
    ['|'] = 3,
    ['}'] = 6
}
function MeasureString(str)
    local output = 0
    for i = 1, GetCharacterCount(str), 1 do
        if CharacterMap[string.sub(str, i, i)] then output = output + CharacterMap[string.sub(str, i, i)] + 1 end
    end
    return output
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuItem ]]
--==================================================================================================================================================--
UIMenuItem = setmetatable({}, UIMenuItem)
UIMenuItem.__index = UIMenuItem
UIMenuItem.__call = function() return "UIMenuItem", "UIMenuItem" end
do
    function UIMenuItem.New(Text, Description)
        local _UIMenuItem = {
            Rectangle = UIResRectangle.New(0, 0, 431, 38, 255, 255, 255, 20),
            Text = UIResText.New(tostring(Text) or "", 8, 0, 0.33, 245, 245, 245, 255, 0),
            _Text = {
                Padding = {X = 8},
                Colour = {Selected = {R = 25, G = 25, B = 25, A = 255}, Hovered = {R = 245, G = 245, B = 245, A = 255}}
            },
            _Description = tostring(Description) or "",
            SelectedSprite = Sprite.New("commonmenu", "gradient_nav", 0, 0, 431, 38, nil, 200, 200, 200, 150),
            LeftBadge = {Sprite = Sprite.New("commonmenu", "", 0, 0, 35, 35), Badge = 0},
            RightBadge = {Sprite = Sprite.New("commonmenu", "", 0, 0, 35, 35), Badge = 0},
            Label = {
                Text = UIResText.New("", 0, 0, 0.33, 245, 245, 245, 255, 0, "Right"),
                MainColour = {R = 255, G = 255, B = 255, A = 255},
                HighlightColour = {R = 0, G = 0, B = 0, A = 255}
            },
            _Selected = false,
            _Hovered = false,
            _Enabled = true,
            _Offset = {X = 0, Y = 0},
            _LabelOffset = {X = 0, Y = 0},
            _LeftBadgeOffset = {X = 0, Y = 0},
            _RightBadgeOffset = {X = 0, Y = 0},
            ParentMenu = nil,
            Panels = {},
            Activated = function(menu, item) end,
            ActivatedPanel = function(menu, item, panel, panelvalue) end
        }
        return setmetatable(_UIMenuItem, UIMenuItem)
    end

    function UIMenuItem:SetParentMenu(Menu)
        if Menu ~= nil and Menu() == "UIMenu" then
            self.ParentMenu = Menu
        else
            return self.ParentMenu
        end
    end

    function UIMenuItem:Selected(bool)
        if bool ~= nil then
            self._Selected = ToBool(bool)
        else
            return self._Selected
        end
    end

    function UIMenuItem:Hovered(bool)
        if bool ~= nil then
            self._Hovered = ToBool(bool)
        else
            return self._Hovered
        end
    end

    function UIMenuItem:Enabled(bool)
        if bool ~= nil then
            self._Enabled = ToBool(bool)
        else
            return self._Enabled
        end
    end

    function UIMenuItem:Description(str)
        if tostring(str) and str ~= nil then
            self._Description = tostring(str)
        else
            return self._Description
        end
    end

    function UIMenuItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self._Offset.X = tonumber(X) end
            if tonumber(Y) then self._Offset.Y = tonumber(Y) end
        else
            return self._Offset
        end
    end

    function UIMenuItem:LeftBadgeOffset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self._LeftBadgeOffset.X = tonumber(X) end
            if tonumber(Y) then self._LeftBadgeOffset.Y = tonumber(Y) end
        else
            return self._LeftBadgeOffset
        end
    end

    function UIMenuItem:RightBadgeOffset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self._RightBadgeOffset.X = tonumber(X) end
            if tonumber(Y) then self._RightBadgeOffset.Y = tonumber(Y) end
        else
            return self._RightBadgeOffset
        end
    end

    function UIMenuItem:Position(Y)
        if tonumber(Y) then
            self.Rectangle:Position(self._Offset.X, Y + 144 + self._Offset.Y)
            self.SelectedSprite:Position(0 + self._Offset.X, Y + 144 + self._Offset.Y)
            self.Text:Position(self._Text.Padding.X + self._Offset.X, Y + 149 + self._Offset.Y)
            self.LeftBadge.Sprite:Position(0 + self._Offset.X + self._LeftBadgeOffset.X, Y + 146 + self._Offset.Y + self._LeftBadgeOffset.Y)
            self.RightBadge.Sprite:Position(385 + self._Offset.X + self._RightBadgeOffset.X,
                                            Y + 146 + self._Offset.Y + self._RightBadgeOffset.Y)
            self.Label.Text:Position(415 + self._Offset.X + self._LabelOffset.X, Y + 148 + self._Offset.Y + self._LabelOffset.Y)
        end
    end

    function UIMenuItem:RightLabel(Text, MainColour, HighlightColour)
        if MainColour ~= nil then
            local labelMainColour = MainColour
        else
            local labelMainColour = {R = 255, G = 255, B = 255, A = 255}
        end
        if HighlightColour ~= nil then
            local labelHighlightColour = HighlightColour
        else
            local labelHighlightColour = {R = 0, G = 0, B = 0, A = 255}
        end
        if tostring(Text) and Text ~= nil then
            if type(labelMainColour) == "table" then self.Label.MainColour = labelMainColour end
            if type(labelHighlightColour) == "table" then self.Label.HighlightColour = labelHighlightColour end
            self.Label.Text:Text(tostring(Text))
        else
            self.Label.MainColour = {R = 0, G = 0, B = 0, A = 0}
            self.Label.HighlightColour = {R = 0, G = 0, B = 0, A = 0}
            return self.Label.Text:Text()
        end
    end

    function UIMenuItem:SetLeftBadge(Badge) if tonumber(Badge) then self.LeftBadge.Badge = tonumber(Badge) end end

    function UIMenuItem:SetRightBadge(Badge) if tonumber(Badge) then self.RightBadge.Badge = tonumber(Badge) end end

    function UIMenuItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Text:Text(tostring(Text))
        else
            return self.Text:Text()
        end
    end

    function UIMenuItem:SetTextSelectedColor(R, G, B, A)
        if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
            self._Text.Colour.Selected.R = R
            self._Text.Colour.Selected.G = G
            self._Text.Colour.Selected.B = B
            self._Text.Colour.Selected.A = A
        else
            return {
                R = self._Text.Colour.Selected.R,
                G = self._Text.Colour.Selected.G,
                B = self._Text.Colour.Selected.B,
                A = self._Text.Colour.Selected.A
            }
        end
    end

    function UIMenuItem:SetTextHoveredColor(R, G, B, A)
        if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
            self._Text.Colour.Hovered.R = R
            self._Text.Colour.Hovered.G = G
            self._Text.Colour.Hovered.B = B
            self._Text.Colour.Hovered.A = A
        else
            return {
                R = self._Text.Colour.Hovered.R,
                G = self._Text.Colour.Hovered.G,
                B = self._Text.Colour.Hovered.B,
                A = self._Text.Colour.Hovered.A
            }
        end
    end

    function UIMenuItem:AddPanel(Panel)
        if Panel() == "UIMenuPanel" then
            table.insert(self.Panels, Panel)
            Panel:SetParentItem(self)
        end
    end

    function UIMenuItem:RemovePanelAt(Index)
        if tonumber(Index) then if self.Panels[Index] then table.remove(self.Panels, tonumber(Index)) end end
    end

    function UIMenuItem:FindPanelIndex(Panel)
        if Panel() == "UIMenuPanel" then for Index = 1, #self.Panels do if self.Panels[Index] == Panel then return Index end end end
        return nil
    end

    function UIMenuItem:FindPanelItem()
        for Index = #self.Items, 1, -1 do if self.Items[Index].Panel then return Index end end
        return nil
    end

    function UIMenuItem:Draw()
        self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, self.Rectangle.Height)
        self.SelectedSprite:Size(431 + self.ParentMenu.WidthOffset, self.SelectedSprite.Height)

        if self._Hovered and not self._Selected then self.Rectangle:Draw() end

        if self._Selected then self.SelectedSprite:Draw() end

        if self._Enabled then
            if self._Selected then
                self.Text:Colour(self._Text.Colour.Selected.R, self._Text.Colour.Selected.G, self._Text.Colour.Selected.B,
                                    self._Text.Colour.Selected.A)
                self.Label.Text:Colour(self.Label.HighlightColour.R, self.Label.HighlightColour.G, self.Label.HighlightColour.B,
                                        self.Label.HighlightColour.A)
            else
                self.Text:Colour(self._Text.Colour.Hovered.R, self._Text.Colour.Hovered.G, self._Text.Colour.Hovered.B,
                                    self._Text.Colour.Hovered.A)
                self.Label.Text:Colour(self.Label.MainColour.R, self.Label.MainColour.G, self.Label.MainColour.B, self.Label.MainColour.A)
            end
        else
            self.Text:Colour(163, 159, 148, 255)
            self.Label.Text:Colour(163, 159, 148, 255)
        end

        if self.LeftBadge.Badge == BadgeStyle.None then
            self.Text:Position(self._Text.Padding.X + self._Offset.X, self.Text.Y)
        else
            self.Text:Position(35 + self._Offset.X + self._LeftBadgeOffset.X, self.Text.Y)
            self.LeftBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.LeftBadge.Badge, self._Selected)
            self.LeftBadge.Sprite.TxtName = GetBadgeTexture(self.LeftBadge.Badge, self._Selected)
            self.LeftBadge.Sprite:Colour(GetBadgeColour(self.LeftBadge.Badge, self._Selected))
            self.LeftBadge.Sprite:Draw()
        end

        if self.RightBadge.Badge ~= BadgeStyle.None then
            self.RightBadge.Sprite:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset + self._RightBadgeOffset.X,
                                            self.RightBadge.Sprite.Y)
            self.RightBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.RightBadge.Badge, self._Selected)
            self.RightBadge.Sprite.TxtName = GetBadgeTexture(self.RightBadge.Badge, self._Selected)
            self.RightBadge.Sprite:Colour(GetBadgeColour(self.RightBadge.Badge, self._Selected))
            self.RightBadge.Sprite:Draw()
        end

        if self.Label.Text:Text() ~= "" and string.len(self.Label.Text:Text()) > 0 then
            if self.RightBadge.Badge ~= BadgeStyle.None then
                self.Label.Text:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset + self._RightBadgeOffset.X, self.Label.Text.Y)
                self.Label.Text:Draw()
            else
                self.Label.Text:Position(415 + self._Offset.X + self.ParentMenu.WidthOffset + self._LabelOffset.X, self.Label.Text.Y)
                self.Label.Text:Draw()
            end
        end

        self.Text:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuCheckboxItem ]]
--==================================================================================================================================================--
UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
UIMenuCheckboxItem.__call = function() return "UIMenuItem", "UIMenuCheckboxItem" end
do
    function UIMenuCheckboxItem.New(Text, Check, Description, CheckboxStyle)
        if CheckboxStyle ~= nil then
            CheckboxStyle = tonumber(CheckboxStyle)
        else
            CheckboxStyle = 1
        end
        local _UIMenuCheckboxItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            CheckboxStyle = CheckboxStyle,
            CheckedSprite = Sprite.New("commonmenu", "shop_box_blank", 410, 95, 50, 50),
            Checked = ToBool(Check),
            CheckboxEvent = function(menu, item, checked) end
        }
        return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
    end

    function UIMenuCheckboxItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuCheckboxItem:Position(Y)
        if tonumber(Y) then
            self.Base:Position(Y)
            self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 138 + self.Base._Offset.Y)
        end
    end

    function UIMenuCheckboxItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuCheckboxItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuCheckboxItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuCheckboxItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuCheckboxItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuCheckboxItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuCheckboxItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuCheckboxItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuCheckboxItem:RightLabel() error("This item does not support a right label") end

    function UIMenuCheckboxItem:Draw()
        self.Base:Draw()
        self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.CheckedSprite.Y)
        if self.CheckboxStyle == nil or self.CheckboxStyle == tonumber(1) then
            if self.Base:Selected() then
                if self.Checked then
                    self.CheckedSprite.TxtName = "shop_box_tickb"
                else
                    self.CheckedSprite.TxtName = "shop_box_blankb"
                end
            else
                if self.Checked then
                    self.CheckedSprite.TxtName = "shop_box_tick"
                else
                    self.CheckedSprite.TxtName = "shop_box_blank"
                end
            end
        elseif self.CheckboxStyle == tonumber(2) then
            if self.Base:Selected() then
                if self.Checked then
                    self.CheckedSprite.TxtName = "shop_box_crossb"
                else
                    self.CheckedSprite.TxtName = "shop_box_blankb"
                end
            else
                if self.Checked then
                    self.CheckedSprite.TxtName = "shop_box_cross"
                else
                    self.CheckedSprite.TxtName = "shop_box_blank"
                end
            end
        end
        self.CheckedSprite:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuListItem ]]
--==================================================================================================================================================--
UIMenuListItem = setmetatable({}, UIMenuListItem)
UIMenuListItem.__index = UIMenuListItem
UIMenuListItem.__call = function() return "UIMenuItem", "UIMenuListItem" end
do
    function UIMenuListItem.New(Text, Items, Index, Description)
        if type(Items) ~= "table" then Items = {} end
        if Index == 0 then Index = 1 end
        local _UIMenuListItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Items = Items,
            LeftArrow = Sprite.New("commonmenu", "arrowleft", 110, 105, 30, 30),
            RightArrow = Sprite.New("commonmenu", "arrowright", 280, 105, 30, 30),
            ItemText = UIResText.New("", 290, 104, 0.35, 255, 255, 255, 255, 0, "Right"),
            _Index = tonumber(Index) or 1,
            Panels = {},
            OnListChanged = function(menu, item, newindex) end,
            OnListSelected = function(menu, item, newindex) end
        }
        return setmetatable(_UIMenuListItem, UIMenuListItem)
    end

    function UIMenuListItem:SetParentMenu(Menu)
        if Menu ~= nil and Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuListItem:Position(Y)
        if tonumber(Y) then
            self.LeftArrow:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
            self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
            self.ItemText:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
            self.Base:Position(Y)
        end
    end

    function UIMenuListItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuListItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuListItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuListItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuListItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuListItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuListItem:Index(Index)
        if tonumber(Index) then
            if tonumber(Index) > #self.Items then
                self._Index = 1
            elseif tonumber(Index) < 1 then
                self._Index = #self.Items
            else
                self._Index = tonumber(Index)
            end
        else
            return self._Index
        end
    end

    function UIMenuListItem:ItemToIndex(Item)
        for i = 1, #self.Items do
            if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
                return i
            elseif type(self.Items[i]) == "table" and (type(Item) == type(self.Items[i].Name) or type(Item) == type(self.Items[i].Value)) and
                (Item == self.Items[i].Name or Item == self.Items[i].Value) then
                return i
            end
        end
    end

    function UIMenuListItem:IndexToItem(Index)
        if tonumber(Index) then
            if tonumber(Index) == 0 then Index = 1 end
            if self.Items[tonumber(Index)] then return self.Items[tonumber(Index)] end
        end
    end

    function UIMenuListItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuListItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuListItem:RightLabel() error("This item does not support a right label") end

    function UIMenuListItem:AddPanel(Panel)
        if Panel() == "UIMenuPanel" then
            table.insert(self.Panels, Panel)
            Panel:SetParentItem(self)
        end
    end

    function UIMenuListItem:RemovePanelAt(Index)
        if tonumber(Index) then if self.Panels[Index] then table.remove(self.Panels, tonumber(Index)) end end
    end

    function UIMenuListItem:FindPanelIndex(Panel)
        if Panel() == "UIMenuPanel" then for Index = 1, #self.Panels do if self.Panels[Index] == Panel then return Index end end end
        return nil
    end

    function UIMenuListItem:FindPanelItem()
        for Index = #self.Items, 1, -1 do if self.Items[Index].Panel then return Index end end
        return nil
    end

    function UIMenuListItem:Draw()
        self.Base:Draw()

        if self:Enabled() then
            if self:Selected() then
                self.ItemText:Colour(0, 0, 0, 255)
                self.LeftArrow:Colour(0, 0, 0, 255)
                self.RightArrow:Colour(0, 0, 0, 255)
            else
                self.ItemText:Colour(245, 245, 245, 255)
                self.LeftArrow:Colour(245, 245, 245, 255)
                self.RightArrow:Colour(245, 245, 245, 255)
            end
        else
            self.ItemText:Colour(163, 159, 148, 255)
            self.LeftArrow:Colour(163, 159, 148, 255)
            self.RightArrow:Colour(163, 159, 148, 255)
        end

        local Text = (type(self.Items[self._Index]) == "table") and tostring(self.Items[self._Index].Name) or
                            tostring(self.Items[self._Index])
        local Offset = MeasureStringWidth(Text, 0, 0.35)

        self.ItemText:Text(Text)
        self.LeftArrow:Position(378 - Offset + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.LeftArrow.Y)

        self.LeftArrow:Draw()
        self.RightArrow:Draw()
        self.ItemText:Position(403 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.ItemText.Y)

        self.ItemText:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuColouredItem ]]
--==================================================================================================================================================--
UIMenuColouredItem = setmetatable({}, UIMenuColouredItem)
UIMenuColouredItem.__index = UIMenuColouredItem
UIMenuColouredItem.__call = function() return "UIMenuItem", "UIMenuColouredItem" end
do
    function UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
        if type(Colour) ~= "table" then Colour = {R = 0, G = 0, B = 0, A = 255} end
        if type(HighlightColour) ~= "table" then Colour = {R = 255, G = 255, B = 255, A = 255} end
        local _UIMenuColouredItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Rectangle = UIResRectangle.New(0, 0, 431, 38, MainColour.R, MainColour.G, MainColour.B, MainColour.A),
            MainColour = MainColour,
            HighlightColour = HighlightColour,
            ParentMenu = nil,
            Activated = function(menu, item) end
        }
        _UIMenuColouredItem.Base.SelectedSprite:Colour(HighlightColour.R, HighlightColour.G, HighlightColour.B, HighlightColour.A)
        return setmetatable(_UIMenuColouredItem, UIMenuColouredItem)
    end

    function UIMenuColouredItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
            self.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuColouredItem:Position(Y)
        if tonumber(Y) then
            self.Base:Position(Y)
            self.Rectangle:Position(self.Base._Offset.X, Y + 144 + self.Base._Offset.Y)
        end
    end

    function UIMenuColouredItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuColouredItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuColouredItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuColouredItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuColouredItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuColouredItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuColouredItem:SetTextSelectedColor(R, G, B, A)
        if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
            self.Base._Text.Colour.Selected.R = R
            self.Base._Text.Colour.Selected.G = G
            self.Base._Text.Colour.Selected.B = B
            self.Base._Text.Colour.Selected.A = A
        else
            return {
                R = self.Base._Text.Colour.Selected.R,
                G = self.Base._Text.Colour.Selected.G,
                B = self.Base._Text.Colour.Selected.B,
                A = self.Base._Text.Colour.Selected.A
            }
        end
    end

    function UIMenuColouredItem:SetTextHoveredColor(R, G, B, A)
        if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
            self.Base._Text.Colour.Hovered.R = R
            self.Base._Text.Colour.Hovered.G = G
            self.Base._Text.Colour.Hovered.B = B
            self.Base._Text.Colour.Hovered.A = A
        else
            return {
                R = self.Base._Text.Colour.Hovered.R,
                G = self.Base._Text.Colour.Hovered.G,
                B = self.Base._Text.Colour.Hovered.B,
                A = self.Base._Text.Colour.Hovered.A
            }
        end
    end

    function UIMenuColouredItem:RightLabel(Text, MainColour, HighlightColour)
        if tostring(Text) and Text ~= nil then
            if type(MainColour) == "table" then self.Base.Label.MainColour = MainColour end
            if type(HighlightColour) == "table" then self.Base.Label.HighlightColour = HighlightColour end
            self.Base.Label.Text:Text(tostring(Text))
        else
            self.Label.MainColour = {R = 0, G = 0, B = 0, A = 0}
            self.Label.HighlightColour = {R = 0, G = 0, B = 0, A = 0}
            return self.Base.Label.Text:Text()
        end
    end

    function UIMenuColouredItem:SetLeftBadge(Badge) if tonumber(Badge) then self.Base.LeftBadge.Badge = tonumber(Badge) end end

    function UIMenuColouredItem:SetRightBadge(Badge) if tonumber(Badge) then self.Base.RightBadge.Badge = tonumber(Badge) end end

    function UIMenuColouredItem:Draw()
        self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, self.Rectangle.Height)
        self.Rectangle:Draw()
        self.Base:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuProgressItem ]]
--==================================================================================================================================================--
UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)
UIMenuProgressItem.__index = UIMenuProgressItem
UIMenuProgressItem.__call = function() return "UIMenuItem", "UIMenuProgressItem" end
do
    function UIMenuProgressItem.New(Text, Items, Index, Description, Counter)
        if type(Items) ~= "table" then Items = {} end
        if Index == 0 then Index = 1 end
        local _UIMenuProgressItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Data = {Items = Items, Counter = ToBool(Counter), Max = 407.5, Index = tonumber(Index) or 1},
            Audio = {Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil},
            Background = UIResRectangle.New(0, 0, 415, 20, 0, 0, 0, 255),
            Bar = UIResRectangle.New(0, 0, 407.5, 12.5),
            OnProgressChanged = function(menu, item, newindex) end,
            OnProgressSelected = function(menu, item, newindex) end
        }

        _UIMenuProgressItem.Base.Rectangle.Height = 60
        _UIMenuProgressItem.Base.SelectedSprite.Height = 60

        if _UIMenuProgressItem.Data.Counter then
            _UIMenuProgressItem.Base:RightLabel(_UIMenuProgressItem.Data.Index .. "/" .. #_UIMenuProgressItem.Data.Items)
        else
            _UIMenuProgressItem.Base:RightLabel((type(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]) == "table") and
                                                    tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index].Name) or
                                                    tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]))
        end

        _UIMenuProgressItem.Bar.Width = _UIMenuProgressItem.Data.Index / #_UIMenuProgressItem.Data.Items * _UIMenuProgressItem.Data.Max

        return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
    end

    function UIMenuProgressItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuProgressItem:Position(Y)
        if tonumber(Y) then
            self.Base:Position(Y)
            self.Data.Max = 407.5 + self.Base.ParentMenu.WidthOffset
            self.Background:Size(415 + self.Base.ParentMenu.WidthOffset, 20)
            self.Background:Position(8 + self.Base._Offset.X, 177 + Y + self.Base._Offset.Y)
            self.Bar:Position(11.75 + self.Base._Offset.X, 180.75 + Y + self.Base._Offset.Y)
        end
    end

    function UIMenuProgressItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuProgressItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuProgressItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuProgressItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuProgressItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuProgressItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuProgressItem:Index(Index)
        if tonumber(Index) then
            if tonumber(Index) > #self.Data.Items then
                self.Data.Index = 1
            elseif tonumber(Index) < 1 then
                self.Data.Index = #self.Data.Items
            else
                self.Data.Index = tonumber(Index)
            end

            if self.Data.Counter then
                self.Base:RightLabel(self.Data.Index .. "/" .. #self.Data.Items)
            else
                self.Base:RightLabel(
                    (type(self.Data.Items[self.Data.Index]) == "table") and tostring(self.Data.Items[self.Data.Index].Name) or
                        tostring(self.Data.Items[self.Data.Index]))
            end

            self.Bar.Width = self.Data.Index / #self.Data.Items * self.Data.Max
        else
            return self.Data.Index
        end
    end

    function UIMenuProgressItem:ItemToIndex(Item)
        for i = 1, #self.Data.Items do
            if type(Item) == type(self.Data.Items[i]) and Item == self.Data.Items[i] then
                return i
            elseif type(self.Data.Items[i]) == "table" and
                (type(Item) == type(self.Data.Items[i].Name) or type(Item) == type(self.Data.Items[i].Value)) and
                (Item == self.Data.Items[i].Name or Item == self.Data.Items[i].Value) then
                return i
            end
        end
    end

    function UIMenuProgressItem:IndexToItem(Index)
        if tonumber(Index) then
            if tonumber(Index) == 0 then Index = 1 end
            if self.Data.Items[tonumber(Index)] then return self.Data.Items[tonumber(Index)] end
        end
    end

    function UIMenuProgressItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuProgressItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuProgressItem:RightLabel() error("This item does not support a right label") end

    function UIMenuProgressItem:CalculateProgress(CursorX)
        local Progress = CursorX - self.Bar.X
        self:Index(math.round(#self.Data.Items *
                                    (((Progress >= 0 and Progress <= self.Data.Max) and Progress or ((Progress < 0) and 0 or self.Data.Max)) /
                                        self.Data.Max)))
    end

    function UIMenuProgressItem:Draw()
        self.Base:Draw()

        if self.Base._Selected then
            self.Background:Colour(table.unpack(Colours.Black))
            self.Bar:Colour(table.unpack(Colours.White))
        else
            self.Background:Colour(table.unpack(Colours.White))
            self.Bar:Colour(table.unpack(Colours.Black))
        end

        self.Background:Draw()
        self.Bar:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuSeparatorItem ]]
--==================================================================================================================================================--
UIMenuSeparatorItem = setmetatable({}, UIMenuSeparatorItem)
UIMenuSeparatorItem.__index = UIMenuSeparatorItem
UIMenuSeparatorItem.__call = function() return "UIMenuItem", "UIMenuSeparatorItem" end
do
    function UIMenuSeparatorItem.New()
        local _UIMenuSeparatorItem = {Base = UIMenuItem.New(Text or "N/A", Description or "")}

        _UIMenuSeparatorItem.Base.Label.Text.Alignment = "Center"
        return setmetatable(_UIMenuSeparatorItem, UIMenuSeparatorItem)
    end

    function UIMenuSeparatorItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuSeparatorItem:Position(Y) if tonumber(Y) then self.Base:Position(Y) end end

    function UIMenuSeparatorItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuSeparatorItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuSeparatorItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuSeparatorItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuSeparatorItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuSeparatorItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuSeparatorItem:Draw()
        self.Base:Draw()

        if self.Base._Selected then
        else
        end

    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuSliderHeritageItem ]]
--==================================================================================================================================================--
UIMenuSliderHeritageItem = setmetatable({}, UIMenuSliderHeritageItem)
UIMenuSliderHeritageItem.__index = UIMenuSliderHeritageItem
UIMenuSliderHeritageItem.__call = function() return "UIMenuItem", "UIMenuSliderHeritageItem" end
do
    function UIMenuSliderHeritageItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
        if type(Items) ~= "table" then Items = {} end
        if Index == 0 then Index = 1 end

        if type(SliderColors) ~= "table" or SliderColors == nil then
            _SliderColors = {R = 57, G = 119, B = 200, A = 255}
        else
            _SliderColors = SliderColors
        end

        if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
            _BackgroundSliderColors = {R = 4, G = 32, B = 57, A = 255}
        else
            _BackgroundSliderColors = BackgroundSliderColors
        end

        local _UIMenuSliderHeritageItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Items = Items,
            LeftArrow = Sprite.New("mpleaderboard", "leaderboard_female_icon", 0, 0, 40, 40, 0, 255, 255, 255, 255),
            RightArrow = Sprite.New("mpleaderboard", "leaderboard_male_icon", 0, 0, 40, 40, 0, 255, 255, 255, 255),
            Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B,
                                            _BackgroundSliderColors.A),
            Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
            Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
            _Index = tonumber(Index) or 1,
            Audio = {Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil},
            OnSliderChanged = function(menu, item, newindex) end,
            OnSliderSelected = function(menu, item, newindex) end
        }
        return setmetatable(_UIMenuSliderHeritageItem, UIMenuSliderHeritageItem)
    end

    function UIMenuSliderHeritageItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuSliderHeritageItem:Position(Y)
        if tonumber(Y) then
            self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
            self.LeftArrow:Position(217 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 143.5 + Y + self.Base._Offset.Y)
            self.RightArrow:Position(395 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 143.5 + Y + self.Base._Offset.Y)
            self.Base:Position(Y)
        end
    end

    function UIMenuSliderHeritageItem:Selected(bool)
        if bool ~= nil then
            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuSliderHeritageItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuSliderHeritageItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuSliderHeritageItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuSliderHeritageItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuSliderHeritageItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuSliderHeritageItem:Index(Index)
        if tonumber(Index) then
            if tonumber(Index) > #self.Items then
                self._Index = 1
            elseif tonumber(Index) < 1 then
                self._Index = #self.Items
            else
                self._Index = tonumber(Index)
            end
        else
            return self._Index
        end
    end

    function UIMenuSliderHeritageItem:ItemToIndex(Item)
        for i = 1, #self.Items do if type(Item) == type(self.Items[i]) and Item == self.Items[i] then return i end end
    end

    function UIMenuSliderHeritageItem:IndexToItem(Index)
        if tonumber(Index) then
            if tonumber(Index) == 0 then Index = 1 end
            if self.Items[tonumber(Index)] then return self.Items[tonumber(Index)] end
        end
    end

    function UIMenuSliderHeritageItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuSliderHeritageItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuSliderHeritageItem:RightLabel() error("This item does not support a right label") end

    function UIMenuSliderHeritageItem:Draw()
        self.Base:Draw()
        if self:Enabled() then
            if self:Selected() then
                self.LeftArrow:Colour(0, 0, 0, 255)
                self.RightArrow:Colour(0, 0, 0, 255)
            else
                self.LeftArrow:Colour(255, 255, 255, 255)
                self.RightArrow:Colour(255, 255, 255, 255)
            end
        else
            self.LeftArrow:Colour(255, 255, 255, 255)
            self.RightArrow:Colour(255, 255, 255, 255)
        end
        local Offset = ((self.Background.Width - self.Slider.Width) / (#self.Items - 1)) * (self._Index - 1)
        self.Slider:Position(250 + self.Base._Offset.X + Offset + self.Base.ParentMenu.WidthOffset, self.Slider.Y)
        self.LeftArrow:Draw()
        self.RightArrow:Draw()
        self.Background:Draw()
        self.Slider:Draw()
        self.Divider:Draw()
        self.Divider:Colour(255, 255, 255, 255)
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuSliderItem ]]
--==================================================================================================================================================--
UIMenuSliderItem = setmetatable({}, UIMenuSliderItem)
UIMenuSliderItem.__index = UIMenuSliderItem
UIMenuSliderItem.__call = function() return "UIMenuItem", "UIMenuSliderItem" end
do
    function UIMenuSliderItem.New(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
        if type(Items) ~= "table" then Items = {} end
        if Index == 0 then Index = 1 end
        if type(SliderColors) ~= "table" or SliderColors == nil then
            _SliderColors = {R = 57, G = 119, B = 200, A = 255}
        else
            _SliderColors = SliderColors
        end
        if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
            _BackgroundSliderColors = {R = 4, G = 32, B = 57, A = 255}
        else
            _BackgroundSliderColors = BackgroundSliderColors
        end
        local _UIMenuSliderItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Items = Items,
            ShowDivider = ToBool(Divider),
            LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 105, 25, 25),
            RightArrow = Sprite.New("commonmenu", "arrowright", 0, 105, 25, 25),
            Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B,
                                            _BackgroundSliderColors.A),
            Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
            Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
            _Index = tonumber(Index) or 1,
            OnSliderChanged = function(menu, item, newindex) end,
            OnSliderSelected = function(menu, item, newindex) end
        }
        return setmetatable(_UIMenuSliderItem, UIMenuSliderItem)
    end

    function UIMenuSliderItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuSliderItem:Position(Y)
        if tonumber(Y) then
            self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
            self.LeftArrow:Position(225 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
            self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
            self.Base:Position(Y)
        end
    end

    function UIMenuSliderItem:Selected(bool)
        if bool ~= nil then

            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuSliderItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuSliderItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuSliderItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuSliderItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuSliderItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuSliderItem:Index(Index)
        if tonumber(Index) then
            if tonumber(Index) > #self.Items then
                self._Index = 1
            elseif tonumber(Index) < 1 then
                self._Index = #self.Items
            else
                self._Index = tonumber(Index)
            end
        else
            return self._Index
        end
    end

    function UIMenuSliderItem:ItemToIndex(Item)
        for i = 1, #self.Items do if type(Item) == type(self.Items[i]) and Item == self.Items[i] then return i end end
    end

    function UIMenuSliderItem:IndexToItem(Index)
        if tonumber(Index) then
            if tonumber(Index) == 0 then Index = 1 end
            if self.Items[tonumber(Index)] then return self.Items[tonumber(Index)] end
        end
    end

    function UIMenuSliderItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuSliderItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuSliderItem:RightLabel() error("This item does not support a right label") end

    function UIMenuSliderItem:Draw()
        self.Base:Draw()

        if self:Enabled() then
            if self:Selected() then
                self.LeftArrow:Colour(0, 0, 0, 255)
                self.RightArrow:Colour(0, 0, 0, 255)
            else
                self.LeftArrow:Colour(245, 245, 245, 255)
                self.RightArrow:Colour(245, 245, 245, 255)
            end
        else
            self.LeftArrow:Colour(163, 159, 148, 255)
            self.RightArrow:Colour(163, 159, 148, 255)
        end

        local Offset = ((self.Background.Width - self.Slider.Width) / (#self.Items - 1)) * (self._Index - 1)

        self.Slider:Position(250 + self.Base._Offset.X + Offset + self.Base.ParentMenu.WidthOffset, self.Slider.Y)

        if self:Selected() then
            self.LeftArrow:Draw()
            self.RightArrow:Draw()
        end

        self.Background:Draw()
        self.Slider:Draw()
        if self.ShowDivider then self.Divider:Draw() end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\items\UIMenuSliderProgressItem ]]
--==================================================================================================================================================--
UIMenuSliderProgressItem = setmetatable({}, UIMenuSliderProgressItem)
UIMenuSliderProgressItem.__index = UIMenuSliderProgressItem
UIMenuSliderProgressItem.__call = function() return "UIMenuItem", "UIMenuSliderProgressItem" end
do
    function UIMenuSliderProgressItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
        if type(Items) ~= "table" then Items = {} end
        if Index == 0 then Index = 1 end
        if type(SliderColors) ~= "table" or SliderColors == nil then
            _SliderColors = {R = 57, G = 119, B = 200, A = 255}
        else
            _SliderColors = SliderColors
        end
        if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
            _BackgroundSliderColors = {R = 4, G = 32, B = 57, A = 255}
        else
            _BackgroundSliderColors = BackgroundSliderColors
        end
        local _UIMenuSliderProgressItem = {
            Base = UIMenuItem.New(Text or "", Description or ""),
            Items = Items,
            LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 105, 25, 25),
            RightArrow = Sprite.New("commonmenu", "arrowright", 0, 105, 25, 25),
            Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B,
                                            _BackgroundSliderColors.A),
            Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
            Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
            _Index = tonumber(Index) or 1,
            OnSliderChanged = function(menu, item, newindex) end,
            OnSliderSelected = function(menu, item, newindex) end
        }

        local Offset = ((_UIMenuSliderProgressItem.Background.Width) / (#_UIMenuSliderProgressItem.Items - 1)) *
                            (_UIMenuSliderProgressItem._Index - 1)
        _UIMenuSliderProgressItem.Slider.Width = Offset

        return setmetatable(_UIMenuSliderProgressItem, UIMenuSliderProgressItem)
    end

    function UIMenuSliderProgressItem:SetParentMenu(Menu)
        if Menu() == "UIMenu" then
            self.Base.ParentMenu = Menu
        else
            return self.Base.ParentMenu
        end
    end

    function UIMenuSliderProgressItem:Position(Y)
        if tonumber(Y) then
            self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
            self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
            self.LeftArrow:Position(225 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
            self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
            self.Base:Position(Y)
        end
    end

    function UIMenuSliderProgressItem:Selected(bool)
        if bool ~= nil then

            self.Base._Selected = ToBool(bool)
        else
            return self.Base._Selected
        end
    end

    function UIMenuSliderProgressItem:Hovered(bool)
        if bool ~= nil then
            self.Base._Hovered = ToBool(bool)
        else
            return self.Base._Hovered
        end
    end

    function UIMenuSliderProgressItem:Enabled(bool)
        if bool ~= nil then
            self.Base._Enabled = ToBool(bool)
        else
            return self.Base._Enabled
        end
    end

    function UIMenuSliderProgressItem:Description(str)
        if tostring(str) and str ~= nil then
            self.Base._Description = tostring(str)
        else
            return self.Base._Description
        end
    end

    function UIMenuSliderProgressItem:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self.Base._Offset.X = tonumber(X) end
            if tonumber(Y) then self.Base._Offset.Y = tonumber(Y) end
        else
            return self.Base._Offset
        end
    end

    function UIMenuSliderProgressItem:Text(Text)
        if tostring(Text) and Text ~= nil then
            self.Base.Text:Text(tostring(Text))
        else
            return self.Base.Text:Text()
        end
    end

    function UIMenuSliderProgressItem:Index(Index)
        if tonumber(Index) then
            if tonumber(Index) > #self.Items then
                self._Index = #self.Items
            elseif tonumber(Index) < 1 then
                self._Index = 1
            else
                self._Index = tonumber(Index)
            end
        else
            local Offset = ((self.Background.Width) / (#self.Items - 1)) * (self._Index - 1)
            self.Slider.Width = Offset
            return self._Index
        end
    end

    function UIMenuSliderProgressItem:ItemToIndex(Item)
        for i = 1, #self.Items do if type(Item) == type(self.Items[i]) and Item == self.Items[i] then return i end end
    end

    function UIMenuSliderProgressItem:IndexToItem(Index)
        if tonumber(Index) then
            if tonumber(Index) == 0 then Index = 1 end
            if self.Items[tonumber(Index)] then return self.Items[tonumber(Index)] end
        end
    end

    function UIMenuSliderProgressItem:SetLeftBadge() error("This item does not support badges") end

    function UIMenuSliderProgressItem:SetRightBadge() error("This item does not support badges") end

    function UIMenuSliderProgressItem:RightLabel() error("This item does not support a right label") end

    function UIMenuSliderProgressItem:Draw()
        self.Base:Draw()

        if self:Enabled() then
            if self:Selected() then
                self.LeftArrow:Colour(0, 0, 0, 255)
                self.RightArrow:Colour(0, 0, 0, 255)
            else
                self.LeftArrow:Colour(245, 245, 245, 255)
                self.RightArrow:Colour(245, 245, 245, 255)
            end
        else
            self.LeftArrow:Colour(163, 159, 148, 255)
            self.RightArrow:Colour(163, 159, 148, 255)
        end

        if self:Selected() then
            self.LeftArrow:Draw()
            self.RightArrow:Draw()
        end

        self.Background:Draw()
        self.Slider:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuColourPanel ]]
--==================================================================================================================================================--
UIMenuColourPanel = setmetatable({}, UIMenuColourPanel)
UIMenuColourPanel.__index = UIMenuColourPanel
UIMenuColourPanel.__call = function() return "UIMenuPanel", "UIMenuColourPanel" end
do
    function UIMenuColourPanel.New(Title, Colours)
        local _UIMenuColourPanel = {
            Data = {
                Pagination = {Min = 1, Max = 8, Total = 8},
                Index = 1000,
                Items = Colours,
                Title = Title or "Title",
                Enabled = true,
                Value = 1
            },
            Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 112),
            Bar = {},
            EnableArrow = true,
            LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 0, 30, 30),
            RightArrow = Sprite.New("commonmenu", "arrowright", 0, 0, 30, 30),
            SelectedRectangle = UIResRectangle.New(0, 0, 44.5, 8),
            Text = UIResText.New(Title .. " [1 / " .. #Colours .. "]" or "Title" .. " [1 / " .. #Colours .. "]", 0, 0, 0.35, 255, 255, 255,
                                    255, 0, "Centre"),
            ParentItem = nil
        }

        for Index = 1, #Colours do
            if Index < 10 then
                table.insert(_UIMenuColourPanel.Bar, UIResRectangle.New(0, 0, 44.5, 44.5, table.unpack(Colours[Index])))
            else
                break
            end
        end

        if #_UIMenuColourPanel.Data.Items ~= 0 then
            _UIMenuColourPanel.Data.Index = 1000 - (1000 % #_UIMenuColourPanel.Data.Items)
            _UIMenuColourPanel.Data.Pagination.Max = _UIMenuColourPanel.Data.Pagination.Total + 1
            _UIMenuColourPanel.Data.Pagination.Min = 0
        end
        return setmetatable(_UIMenuColourPanel, UIMenuColourPanel)
    end

    function UIMenuColourPanel:SetParentItem(Item)
        -- required
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuColourPanel:Enabled(Enabled)
        if type(Enabled) == "boolean" then
            self.Data.Enabled = Enabled
        else
            return self.Data.Enabled
        end
    end

    function UIMenuColourPanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            for Index = 1, #self.Bar do
                self.Bar[Index]:Position(15 + (44.5 * (Index - 1)) + ParentOffsetX + (ParentOffsetWidth / 2), 55 + Y)
            end
            self.SelectedRectangle:Position(15 + (44.5 * ((self:CurrentSelection() - self.Data.Pagination.Min) - 1)) + ParentOffsetX +
                                                (ParentOffsetWidth / 2), 47 + Y)
            if self.EnableArrow ~= false then
                self.LeftArrow:Position(7.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
                self.RightArrow:Position(393.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
            end
            self.Text:Position(215.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
        end
    end

    function UIMenuColourPanel:CurrentSelection(value, PreventUpdate)
        if tonumber(value) then
            if #self.Data.Items == 0 then self.Data.Index = 0 end

            self.Data.Index = 1000000 - (1000000 % #self.Data.Items) + tonumber(value)

            if self:CurrentSelection() > self.Data.Pagination.Max then
                self.Data.Pagination.Min = self:CurrentSelection() - (self.Data.Pagination.Total + 1)
                self.Data.Pagination.Max = self:CurrentSelection()
            elseif self:CurrentSelection() < self.Data.Pagination.Min then
                self.Data.Pagination.Min = self:CurrentSelection() - 1
                self.Data.Pagination.Max = self:CurrentSelection() + (self.Data.Pagination.Total + 1)
            end

            self:UpdateSelection(PreventUpdate)
        else
            if #self.Data.Items == 0 then
                return 1
            else
                if self.Data.Index % #self.Data.Items == 0 then
                    return 1
                else
                    return self.Data.Index % #self.Data.Items + 1
                end
            end
        end
    end

    function UIMenuColourPanel:UpdateParent(Colour)
        local _, ParentType = self.ParentItem()
        if ParentType == "UIMenuListItem" then
            local PanelItemIndex = self.ParentItem:FindPanelItem()
            local PanelIndex = self.ParentItem:FindPanelIndex(self)
            if PanelItemIndex then
                self.ParentItem.Items[PanelItemIndex].Value[PanelIndex] = Colour
                self.ParentItem:Index(PanelItemIndex)
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            else
                for Index = 1, #self.ParentItem.Items do
                    if type(self.ParentItem.Items[Index]) == "table" then
                        if not self.ParentItem.Items[Index].Panels then self.ParentItem.Items[Index].Panels = {} end
                        self.ParentItem.Items[Index].Panels[PanelIndex] = Colour
                    else
                        self.ParentItem.Items[Index] = {
                            Name = tostring(self.ParentItem.Items[Index]),
                            Value = self.ParentItem.Items[Index],
                            Panels = {[PanelIndex] = Colour}
                        }
                    end
                end
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            end
        elseif ParentType == "UIMenuItem" then
            self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Colour)
        end
    end

    function UIMenuColourPanel:UpdateSelection(PreventUpdate)
        local CurrentSelection = self:CurrentSelection()
        if not PreventUpdate then self:UpdateParent(CurrentSelection) end
        self.SelectedRectangle:Position(15 + (44.5 * ((CurrentSelection - self.Data.Pagination.Min) - 1)) + self.ParentItem:Offset().X,
                                        self.SelectedRectangle.Y)
        for Index = 1, 9 do self.Bar[Index]:Colour(table.unpack(self.Data.Items[self.Data.Pagination.Min + Index])) end
        self.Text:Text(self.Data.Title .. " [" .. CurrentSelection .. " / " .. #self.Data.Items .. "]")
    end

    function UIMenuColourPanel:Functions()
        local DrawOffset = {X = 0, Y = 0}
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then DrawOffset = self.ParentItem:SetParentMenu().DrawOffset end

        if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 174) then self:GoLeft() end
        if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 175) then self:GoRight() end

        if IsMouseInBounds(self.LeftArrow.X, self.LeftArrow.Y, self.LeftArrow.Width, self.LeftArrow.Height, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then self:GoLeft() end
        end
        if IsMouseInBounds(self.RightArrow.X, self.RightArrow.Y, self.RightArrow.Width, self.RightArrow.Height, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then self:GoRight() end
        end

        for Index = 1, #self.Bar do
            if IsMouseInBounds(self.Bar[Index].X, self.Bar[Index].Y, self.Bar[Index].Width, self.Bar[Index].Height, DrawOffset) then
                if IsDisabledControlJustPressed(0, 24) then self:CurrentSelection(self.Data.Pagination.Min + Index - 1) end
            end
        end
    end

    function UIMenuColourPanel:GoLeft()
        if #self.Data.Items > self.Data.Pagination.Total + 1 then
            if self:CurrentSelection() <= self.Data.Pagination.Min + 1 then
                if self:CurrentSelection() == 1 then
                    self.Data.Pagination.Min = #self.Data.Items - (self.Data.Pagination.Total + 1)
                    self.Data.Pagination.Max = #self.Data.Items
                    self.Data.Index = 1000 - (1000 % #self.Data.Items)
                    self.Data.Index = self.Data.Index + (#self.Data.Items - 1)
                    self:UpdateSelection()
                else
                    self.Data.Pagination.Min = self.Data.Pagination.Min - 1
                    self.Data.Pagination.Max = self.Data.Pagination.Max - 1
                    self.Data.Index = self.Data.Index - 1
                    self:UpdateSelection()
                end
            else
                self.Data.Index = self.Data.Index - 1
                self:UpdateSelection()
            end
        else
            self.Data.Index = self.Data.Index - 1
            self:UpdateSelection()
        end
    end

    function UIMenuColourPanel:GoRight()
        if #self.Data.Items > self.Data.Pagination.Total + 1 then
            if self:CurrentSelection() >= self.Data.Pagination.Max then
                if self:CurrentSelection() == #self.Data.Items then
                    self.Data.Pagination.Min = 0
                    self.Data.Pagination.Max = self.Data.Pagination.Total + 1
                    self.Data.Index = 1000 - (1000 % #self.Data.Items)
                    self:UpdateSelection()
                else
                    self.Data.Pagination.Max = self.Data.Pagination.Max + 1
                    self.Data.Pagination.Min = self.Data.Pagination.Max - (self.Data.Pagination.Total + 1)
                    self.Data.Index = self.Data.Index + 1
                    self:UpdateSelection()
                end
            else
                self.Data.Index = self.Data.Index + 1
                self:UpdateSelection()
            end
        else
            self.Data.Index = self.Data.Index + 1
            self:UpdateSelection()
        end
    end

    function UIMenuColourPanel:Draw()
        if self.Data.Enabled then
            self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 112)
            self.Background:Draw()
            if self.EnableArrow ~= false then
                self.LeftArrow:Draw()
                self.RightArrow:Draw()
            end
            self.Text:Draw()
            self.SelectedRectangle:Draw()
            for Index = 1, #self.Bar do self.Bar[Index]:Draw() end
            self:Functions()
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuGridPanel ]]
--==================================================================================================================================================--
UIMenuGridPanel = setmetatable({}, UIMenuGridPanel)
UIMenuGridPanel.__index = UIMenuGridPanel
UIMenuGridPanel.__call = function()
return "UIMenuPanel", "UIMenuGridPanel"
end
do
    function UIMenuGridPanel.New(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
        local _UIMenuGridPanel = {
            Data = {
                Enabled = true,
            },
            Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
            Grid = Sprite.New("pause_menu_pages_char_mom_dad", "nose_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
            Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
            Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
            ParentItem = nil,
            Text = {
                Top = UIResText.New(TopText or "Top", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Left = UIResText.New(LeftText or "Left", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Right = UIResText.New(RightText or "Right", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Bottom = UIResText.New(BottomText or "Bottom", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            },
            SetCirclePosition = { X = CirclePositionX or 0.5, Y = CirclePositionY or 0.5 }
        }
        return setmetatable(_UIMenuGridPanel, UIMenuGridPanel)
    end

    function UIMenuGridPanel:SetParentItem(Item)
        -- required
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuGridPanel:Enabled(Enabled)
        if type(Enabled) == "boolean" then
            self.Data.Enabled = Enabled
        else
            return self.Data.Enabled
        end
    end

    function UIMenuGridPanel:CirclePosition(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
            self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
        else
            return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
        end
    end

    function UIMenuGridPanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
            self.Text.Top:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 5 + Y)
            self.Text.Left:Position(ParentOffsetX + 57.75 + (ParentOffsetWidth / 2), 120 + Y)
            self.Text.Right:Position(ParentOffsetX + 373.25 + (ParentOffsetWidth / 2), 120 + Y)
            self.Text.Bottom:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 240 + Y)
            if not self.CircleLocked then
                self.CircleLocked = true
                self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
            end
        end
    end

    function UIMenuGridPanel:UpdateParent(X, Y)
        local _, ParentType = self.ParentItem()
        self.Data.Value = { X = X, Y = Y }
        if ParentType == "UIMenuListItem" then
            local PanelItemIndex = self.ParentItem:FindPanelItem()
            if PanelItemIndex then
                self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { X = X, Y = Y }
                self.ParentItem:Index(PanelItemIndex)
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            else
                local PanelIndex = self.ParentItem:FindPanelIndex(self)
                for Index = 1, #self.ParentItem.Items do
                    if type(self.ParentItem.Items[Index]) == "table" then
                        if not self.ParentItem.Items[Index].Panels then
                            self.ParentItem.Items[Index].Panels = {}
                        end
                        self.ParentItem.Items[Index].Panels[PanelIndex] = { X = X, Y = Y }
                    else
                        self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { X = X, Y = Y } } }
                    end
                end
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X, Y = Y })
            end
        elseif ParentType == "UIMenuItem" then
            self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X, Y = Y })
        end
    end

    function UIMenuGridPanel:Functions()
        local DrawOffset = { X = 0, Y = 0 }
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
            DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
        end
        if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then
                if not self.Pressed then
                    self.Pressed = true
                    Citizen.CreateThread(function()
                        self.Audio.Id = GetSoundId()
                        PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                            Citizen.Wait(0)
                            local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                            CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                            self.Circle:Position(((CursorX > (self.Grid.X + 10 + self.Grid.Width - 40)) and (self.Grid.X + 10 + self.Grid.Width - 40) or ((CursorX < (self.Grid.X + 20 - (self.Circle.Width / 2))) and (self.Grid.X + 20 - (self.Circle.Width / 2)) or CursorX)), ((CursorY > (self.Grid.Y + 10 + self.Grid.Height - 40)) and (self.Grid.Y + 10 + self.Grid.Height - 40) or ((CursorY < (self.Grid.Y + 20 - (self.Circle.Height / 2))) and (self.Grid.Y + 20 - (self.Circle.Height / 2)) or CursorY)))
                        end
                        StopSound(self.Audio.Id)
                        ReleaseSoundId(self.Audio.Id)
                        self.Pressed = false
                    end)
                    Citizen.CreateThread(function()
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                            Citizen.Wait(75)
                            local ResultX, ResultY = math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)

                            self:UpdateParent((((ResultX >= 0.0 and ResultX <= 1.0) and ResultX or ((ResultX <= 0) and 0.0) or 1.0) * 2) - 1, (((ResultY >= 0.0 and ResultY <= 1.0) and ResultY or ((ResultY <= 0) and 0.0) or 1.0) * 2) - 1)
                        end
                    end)
                end
            end
        end
    end

    function UIMenuGridPanel:Draw()
        if self.Data.Enabled then
            self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
            self.Background:Draw()
            self.Grid:Draw()
            self.Circle:Draw()
            self.Text.Top:Draw()
            self.Text.Left:Draw()
            self.Text.Right:Draw()
            self.Text.Bottom:Draw()
            self:Functions()
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuHorizontalOneLineGridPanel ]]
--==================================================================================================================================================--
UIMenuHorizontalOneLineGridPanel = setmetatable({}, UIMenuHorizontalOneLineGridPanel)
UIMenuHorizontalOneLineGridPanel.__index = UIMenuHorizontalOneLineGridPanel
UIMenuHorizontalOneLineGridPanel.__call = function()
return "UIMenuPanel", "UIMenuHorizontalOneLineGridPanel"
end
do
    function UIMenuHorizontalOneLineGridPanel.New(LeftText, RightText, CirclePositionX)
        local _UIMenuHorizontalOneLineGridPanel = {
            Data = {
                Enabled = true,
            },
            Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
            Grid = Sprite.New("NativeUI", "horizontal_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
            Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
            Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
            ParentItem = nil,
            Text = {
                Left = UIResText.New(LeftText or "Left", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Right = UIResText.New(RightText or "Right", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            },
            SetCirclePosition = { X = CirclePositionX or 0.5, Y = 0.5 }
        }
        return setmetatable(_UIMenuHorizontalOneLineGridPanel, UIMenuHorizontalOneLineGridPanel)
    end

    function UIMenuHorizontalOneLineGridPanel:SetParentItem(Item)
        -- required
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuHorizontalOneLineGridPanel:Enabled(Enabled)
        if type(Enabled) == "boolean" then
            self.Data.Enabled = Enabled
        else
            return self.Data.Enabled
        end
    end

    function UIMenuHorizontalOneLineGridPanel:CirclePosition(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
            self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
        else
            return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 10) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
        end
    end

    function UIMenuHorizontalOneLineGridPanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
            self.Text.Left:Position(ParentOffsetX + 57.75 + (ParentOffsetWidth / 2), 120 + Y)
            self.Text.Right:Position(ParentOffsetX + 373.25 + (ParentOffsetWidth / 2), 120 + Y)
            if not self.CircleLocked then
                self.CircleLocked = true
                self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
            end
        end
    end

    function UIMenuHorizontalOneLineGridPanel:UpdateParent(X)
        local _, ParentType = self.ParentItem()
        self.Data.Value = { X = X }
        if ParentType == "UIMenuListItem" then
            local PanelItemIndex = self.ParentItem:FindPanelItem()
            if PanelItemIndex then
                self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { X = X }
                self.ParentItem:Index(PanelItemIndex)
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            else
                local PanelIndex = self.ParentItem:FindPanelIndex(self)
                for Index = 1, #self.ParentItem.Items do
                    if type(self.ParentItem.Items[Index]) == "table" then
                        if not self.ParentItem.Items[Index].Panels then
                            self.ParentItem.Items[Index].Panels = {}
                        end
                        self.ParentItem.Items[Index].Panels[PanelIndex] = { X = X }
                    else
                        self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { X = X } } }
                    end
                end
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X })
            end
        elseif ParentType == "UIMenuItem" then
            self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X })
        end
    end

    function UIMenuHorizontalOneLineGridPanel:Functions()
        local DrawOffset = { X = 0, Y = 0}
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
            DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
        end
        if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then
                if not self.Pressed then
                    self.Pressed = true
                    Citizen.CreateThread(function()
                        self.Audio.Id = GetSoundId()
                        PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 10, self.Grid.Height - 10, DrawOffset) do
                            Citizen.Wait(0)
                            local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                            CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                            local moveCursorX = (CursorX > (self.Grid.X + 10 + self.Grid.Width - 40)) and (self.Grid.X + 10 + self.Grid.Width - 40) or ((CursorX < (self.Grid.X + 20 - (self.Circle.Width / 2))) and (self.Grid.X + 20 - (self.Circle.Width / 2)) or CursorX)
                            local moveCursorY = (CursorY > (self.Grid.Y + 10 + self.Grid.Height - 120)) and (self.Grid.Y + 10 + self.Grid.Height - 120) or ((CursorY < (self.Grid.Y + 100 - (self.Circle.Height / 2))) and (self.Grid.Y + 100 - (self.Circle.Height / 2)) or CursorY)
                            self.Circle:Position(moveCursorX, moveCursorY)
                        end
                        StopSound(self.Audio.Id)
                        ReleaseSoundId(self.Audio.Id)
                        self.Pressed = false
                    end)
                    Citizen.CreateThread(function()
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                            Citizen.Wait(75)
                            local ResultX = math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2)
                            self:UpdateParent((((ResultX >= 0.0 and ResultX <= 1.0) and ResultX or ((ResultX <= 0) and 0.0) or 1.0) * 2) - 1)
                        end
                    end)
                end
            end
        end
    end

    function UIMenuHorizontalOneLineGridPanel:Draw()
        if self.Data.Enabled then
            self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
            self.Background:Draw()
            self.Grid:Draw()
            self.Circle:Draw()
            self.Text.Left:Draw()
            self.Text.Right:Draw()
            self:Functions()
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuPercentagePanel ]]
--==================================================================================================================================================--
UIMenuPercentagePanel = setmetatable({}, UIMenuPercentagePanel)
UIMenuPercentagePanel.__index = UIMenuPercentagePanel
UIMenuPercentagePanel.__call = function()
return "UIMenuPanel", "UIMenuPercentagePanel"
end
do
    function UIMenuPercentagePanel.New(MinText, MaxText)
        local _UIMenuPercentagePanel = {
            Data = {
                Enabled = true,
            },
            Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 76),
            ActiveBar = UIResRectangle.New(0, 0, 413, 10, 245, 245, 245, 255),
            BackgroundBar = UIResRectangle.New(0, 0, 413, 10, 87, 87, 87, 255),
            Text = {
                Min = UIResText.New(MinText or "0%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Max = UIResText.New("100%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Title = UIResText.New(MaxText or "Opacity", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            },
            Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
            ParentItem = nil,
        }

        return setmetatable(_UIMenuPercentagePanel, UIMenuPercentagePanel)
    end

    function UIMenuPercentagePanel:SetParentItem(Item)
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuPercentagePanel:Enabled(Enabled)
        if type(Enabled) == "boolean" then
            self.Data.Enabled = Enabled
        else
            return self.Data.Enabled
        end
    end

    function UIMenuPercentagePanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            self.ActiveBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 9, 50 + Y)
            self.BackgroundBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 9, 50 + Y)
            self.Text.Min:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 25, 15 + Y)
            self.Text.Max:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 398, 15 + Y)
            self.Text.Title:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 215.5, 15 + Y)
        end
    end

    function UIMenuPercentagePanel:Percentage(Value)
        if tonumber(Value) then
            local Percent = ((Value < 0.0) and 0.0) or ((Value > 1.0) and 1.0 or Value)
            self.ActiveBar:Size(self.BackgroundBar.Width * Percent, self.ActiveBar.Height)
        else
            local DrawOffset = { X = 0, Y = 0}
            if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
                DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
            end

            local W, H = GetResolution()
            local Progress = (math.round((GetControlNormal(0, 239) - DrawOffset.X) * W)) - self.ActiveBar.X
            return math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)) / self.BackgroundBar.Width, 2)
        end
    end

    function UIMenuPercentagePanel:UpdateParent(Percentage)
        local _, ParentType = self.ParentItem()
        if ParentType == "UIMenuListItem" then
            local PanelItemIndex = self.ParentItem:FindPanelItem()
            if PanelItemIndex then
                self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = Percentage
                self.ParentItem:Index(PanelItemIndex)
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            else
                local PanelIndex = self.ParentItem:FindPanelIndex(self)
                for Index = 1, #self.ParentItem.Items do
                    if type(self.ParentItem.Items[Index]) == "table" then
                        if not self.ParentItem.Items[Index].Panels then
                            self.ParentItem.Items[Index].Panels = {}
                        end
                        self.ParentItem.Items[Index].Panels[PanelIndex] = Percentage
                    else
                        self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = Percentage } }
                    end
                end
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            end
        elseif ParentType == "UIMenuItem" then
            self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Percentage)
        end
    end

    function UIMenuPercentagePanel:Functions()
        local DrawOffset = { X = 0, Y = 0}
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
            DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
        end
        if IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then
                if not self.Pressed then
                    self.Pressed = true
                    Citizen.CreateThread(function()
                        self.Audio.Id = GetSoundId()
                        PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) do
                            Citizen.Wait(0)
                            local Progress, ProgressY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, 0)
                            Progress = Progress - self.ActiveBar.X
                            self.ActiveBar:Size(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)), self.ActiveBar.Height)
                        end
                        StopSound(self.Audio.Id)
                        ReleaseSoundId(self.Audio.Id)
                        self.Pressed = false
                    end)
                    Citizen.CreateThread(function()
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) do
                            Citizen.Wait(75)
                            local Progress, ProgressY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, 0)
                            Progress = Progress - self.ActiveBar.X
                            self:UpdateParent(math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)) / self.BackgroundBar.Width, 2))
                        end
                    end)
                end
            end
        end
    end

    function UIMenuPercentagePanel:Draw()
        if self.Data.Enabled then
            self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 76)
            self.Background:Draw()
            self.BackgroundBar:Draw()
            self.ActiveBar:Draw()
            self.Text.Min:Draw()
            self.Text.Max:Draw()
            self.Text.Title:Draw()
            self:Functions()
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuStatisticsPanel ]]
--==================================================================================================================================================--
UIMenuStatisticsPanel = setmetatable({}, UIMenuStatisticsPanel)
UIMenuStatisticsPanel.__index = UIMenuStatisticsPanel
UIMenuStatisticsPanel.__call = function() return "UIMenuPanel", "UIMenuStatisticsPanel" end
do
    function UIMenuStatisticsPanel.New()
        local _UIMenuStatisticsPanel = {
            Background = UIResRectangle.New(0, 0, 431, 47, 0, 0, 0, 170),
            Divider = true,
            ParentItem = nil,
            Items = {}
        }
        return setmetatable(_UIMenuStatisticsPanel, UIMenuStatisticsPanel)
    end

    function UIMenuStatisticsPanel:AddStatistics(Name)
        local Items = {
            Text = UIResText.New(Name or "", 0, 0, 0.35, 255, 255, 255, 255, 0, "Left"),
            BackgroundProgressBar = UIResRectangle.New(0, 0, 200, 10, 255, 255, 255, 100),
            ProgressBar = UIResRectangle.New(0, 0, 100, 10, 255, 255, 255, 255),
            Divider = {
                [1] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
                [2] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
                [3] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
                [4] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
                [5] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255)
            }
        }
        table.insert(self.Items, Items)
    end

    function UIMenuStatisticsPanel:SetParentItem(Item)
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuStatisticsPanel:SetPercentage(ItemID, Number)
        if ItemID ~= nil then
            if Number <= 0 then
                self.Items[ItemID].ProgressBar.Width = 0
            else
                if Number <= 100 then
                    self.Items[ItemID].ProgressBar.Width = Number * 2.0
                else
                    self.Items[ItemID].ProgressBar.Width = 100 * 2.0
                end
            end
        else
            error("Missing arguments, ItemID")
        end
    end

    function UIMenuStatisticsPanel:GetPercentage(ItemID)
        if ItemID ~= nil then
            return self.Items[ItemID].ProgressBar.Width * 2.0
        else
            error("Missing arguments, ItemID")
        end
    end

    function UIMenuStatisticsPanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            for i = 1, #self.Items do
                local OffsetItemCount = 40 * i
                self.Items[i].Text:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 13, Y - 34 + OffsetItemCount)
                self.Items[i].BackgroundProgressBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200, Y - 22 + OffsetItemCount)
                self.Items[i].ProgressBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200, Y - 22 + OffsetItemCount)
                if self.Divider ~= false then
                    for _ = 1, #self.Items[i].Divider, 1 do
                        local DividerOffsetWidth = _ * 40
                        self.Items[i].Divider[_]:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200 + DividerOffsetWidth,
                                                            Y - 22 + OffsetItemCount)
                        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 47 + OffsetItemCount - 39)
                    end
                end
            end
        end
    end

    function UIMenuStatisticsPanel:Draw()
        self.Background:Draw()
        for i = 1, #self.Items do
            self.Items[i].Text:Draw()
            self.Items[i].BackgroundProgressBar:Draw()
            self.Items[i].ProgressBar:Draw()
            for _ = 1, #self.Items[i].Divider do self.Items[i].Divider[_]:Draw() end
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\panels\UIMenuVerticalOneLineGridPanel ]]
--==================================================================================================================================================--
UIMenuVerticalOneLineGridPanel = setmetatable({}, UIMenuVerticalOneLineGridPanel)
UIMenuVerticalOneLineGridPanel.__index = UIMenuVerticalOneLineGridPanel
UIMenuVerticalOneLineGridPanel.__call = function()
return "UIMenuPanel", "UIMenuVerticalOneLineGridPanel"
end
do
    function UIMenuVerticalOneLineGridPanel.New(TopText, BottomText, CirclePositionY)
        local _UIMenuVerticalOneLineGridPanel = {
            Data = {
                Enabled = true,
            },
            Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
            Grid = Sprite.New("NativeUI", "vertical_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
            Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
            Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
            ParentItem = nil,
            Text = {
                Top = UIResText.New(TopText or "Top", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
                Bottom = UIResText.New(BottomText or "Bottom", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            },
            SetCirclePosition = { X = 0.5, Y = CirclePositionY or 0.5 }
        }
        return setmetatable(_UIMenuVerticalOneLineGridPanel, UIMenuVerticalOneLineGridPanel)
    end

    function UIMenuVerticalOneLineGridPanel:SetParentItem(Item)
        if Item() == "UIMenuItem" then
            self.ParentItem = Item
        else
            return self.ParentItem
        end
    end

    function UIMenuVerticalOneLineGridPanel:Enabled(Enabled)
        if type(Enabled) == "boolean" then
            self.Data.Enabled = Enabled
        else
            return self.Data.Enabled
        end
    end

    function UIMenuVerticalOneLineGridPanel:CirclePosition(X, Y)
        if tonumber(X) and tonumber(Y) then
            self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
            self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
        else
            return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
        end
    end

    function UIMenuVerticalOneLineGridPanel:Position(Y)
        if tonumber(Y) then
            local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
            self.Background:Position(ParentOffsetX, Y)
            self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
            self.Text.Top:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 5 + Y)
            self.Text.Bottom:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 240 + Y)
            if not self.CircleLocked then
                self.CircleLocked = true
                self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
            end
        end
    end

    function UIMenuVerticalOneLineGridPanel:UpdateParent(Y)
        local _, ParentType = self.ParentItem()
        self.Data.Value = { Y = Y }
        if ParentType == "UIMenuListItem" then
            local PanelItemIndex = self.ParentItem:FindPanelItem()
            if PanelItemIndex then
                self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { Y = Y }
                self.ParentItem:Index(PanelItemIndex)
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            else
                local PanelIndex = self.ParentItem:FindPanelIndex(self)
                for Index = 1, #self.ParentItem.Items do
                    if type(self.ParentItem.Items[Index]) == "table" then
                        if not self.ParentItem.Items[Index].Panels then
                            self.ParentItem.Items[Index].Panels = {}
                        end
                        self.ParentItem.Items[Index].Panels[PanelIndex] = { Y = Y }
                    else
                        self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { Y = Y } } }
                    end
                end
                self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
                self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { Y = Y })
            end
        elseif ParentType == "UIMenuItem" then
            self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { Y = Y })
        end
    end

    function UIMenuVerticalOneLineGridPanel:Functions()
        local DrawOffset = { X = 0, Y = 0}
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
            DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
        end

        if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then
                if not self.Pressed then
                    self.Pressed = true
                    Citizen.CreateThread(function()
                        self.Audio.Id = GetSoundId()
                        PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                            Citizen.Wait(0)
                            local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                            CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                            local moveCursorX = ((CursorX > (self.Grid.X + 10 + self.Grid.Width - 120)) and (self.Grid.X + 10 + self.Grid.Width - 120) or ((CursorX < (self.Grid.X + 100 - (self.Circle.Width / 2))) and (self.Grid.X + 100 - (self.Circle.Width / 2)) or CursorX))
                            local moveCursorY = ((CursorY > (self.Grid.Y + 10 + self.Grid.Height - 40)) and (self.Grid.Y + 10 + self.Grid.Height - 40) or ((CursorY < (self.Grid.Y + 20 - (self.Circle.Height / 2))) and (self.Grid.Y + 20 - (self.Circle.Height / 2)) or CursorY))
                            self.Circle:Position(moveCursorX, moveCursorY)
                        end
                        StopSound(self.Audio.Id)
                        ReleaseSoundId(self.Audio.Id)
                        self.Pressed = false
                    end)
                    Citizen.CreateThread(function()
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                            Citizen.Wait(75)
                            local ResultY = math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
                            self:UpdateParent((((ResultY >= 0.0 and ResultY <= 1.0) and ResultY or ((ResultY <= 0) and 0.0) or 1.0) * 2) - 1)
                        end
                    end)
                end
            end
        end
    end

    function UIMenuVerticalOneLineGridPanel:Draw()
        if self.Data.Enabled then
            self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
            self.Background:Draw()
            self.Grid:Draw()
            self.Circle:Draw()
            self.Text.Top:Draw()
            self.Text.Bottom:Draw()
            self:Functions()
        end
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\winows\UIMenuHeritageWindow ]]
--==================================================================================================================================================--
UIMenuHeritageWindow = setmetatable({}, UIMenuHeritageWindow)
UIMenuHeritageWindow.__index = UIMenuHeritageWindow
UIMenuHeritageWindow.__call = function() return "UIMenuWindow", "UIMenuHeritageWindow" end
do
    function UIMenuHeritageWindow.New(Mum, Dad)
        if not tonumber(Mum) then Mum = 0 end
        if not (Mum >= 0 and Mum <= 21) then Mum = 0 end
        if not tonumber(Dad) then Dad = 0 end
        if not (Dad >= 0 and Dad <= 23) then Dad = 0 end
        local _UIMenuHeritageWindow = {
            Background = Sprite.New("pause_menu_pages_char_mom_dad", "mumdadbg", 0, 0, 431, 228), -- Background is required, must be a sprite or a rectangle.
            MumSprite = Sprite.New("char_creator_portraits", ((Mum < 21) and "female_" .. Mum or "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1)), 0, 0, 228, 228),
            DadSprite = Sprite.New("char_creator_portraits", ((Dad < 21) and "male_" .. Dad or "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1)), 0, 0, 228, 228),
            Mum = Mum,
            Dad = Dad,
            _Offset = {X = 0, Y = 0},
            ParentMenu = nil
        }
        return setmetatable(_UIMenuHeritageWindow, UIMenuHeritageWindow)
    end

    function UIMenuHeritageWindow:SetParentMenu(Menu)
        -- required
        if Menu() == "UIMenu" then
            self.ParentMenu = Menu
        else
            return self.ParentMenu
        end
    end

    function UIMenuHeritageWindow:Offset(X, Y)
        if tonumber(X) or tonumber(Y) then
            if tonumber(X) then self._Offset.X = tonumber(X) end
            if tonumber(Y) then self._Offset.Y = tonumber(Y) end
        else
            return self._Offset
        end
    end

    function UIMenuHeritageWindow:Position(Y)
        if tonumber(Y) then
            self.Background:Position(self._Offset.X, 144 + Y + self._Offset.Y)
            self.MumSprite:Position(self._Offset.X + (self.ParentMenu.WidthOffset / 2) + 25, 144 + Y + self._Offset.Y)
            self.DadSprite:Position(self._Offset.X + (self.ParentMenu.WidthOffset / 2) + 195, 144 + Y + self._Offset.Y)
        end
    end

    function UIMenuHeritageWindow:Index(Mum, Dad)
        if not tonumber(Mum) then Mum = self.Mum end
        if not (Mum >= 0 and Mum <= 21) then Mum = self.Mum end
        if not tonumber(Dad) then Dad = self.Dad end
        if not (Dad >= 0 and Dad <= 23) then Dad = self.Dad end
        self.Mum = Mum
        self.Dad = Dad
        self.MumSprite.TxtName = ((self.Mum < 21) and "female_" .. self.Mum or "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1))
        self.DadSprite.TxtName = ((self.Dad < 21) and "male_" .. self.Dad or "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1))
    end

    function UIMenuHeritageWindow:Draw()
        self.Background:Size(431 + self.ParentMenu.WidthOffset, 228)
        self.Background:Draw()
        self.DadSprite:Draw()
        self.MumSprite:Draw()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu ]]
--==================================================================================================================================================--
UIMenu = setmetatable({}, UIMenu)
UIMenu.__index = UIMenu
UIMenu.__call = function() return "UIMenu" end
do
    function UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
        X, Y = tonumber(X) or 0, tonumber(Y) or 0
        if Title ~= nil then
            Title = tostring(Title) or ""
        else
            Title = ""
        end
        if Subtitle ~= nil then
            Subtitle = tostring(Subtitle) or ""
        else
            Subtitle = ""
        end
        if TxtDictionary ~= nil then
            TxtDictionary = tostring(TxtDictionary) or "commonmenu"
        else
            TxtDictionary = "commonmenu"
        end
        if TxtName ~= nil then
            TxtName = tostring(TxtName) or "interaction_bgd"
        else
            TxtName = "interaction_bgd"
        end
        if Heading ~= nil then
            Heading = tonumber(Heading) or 0
        else
            Heading = 0
        end
        if R ~= nil then
            R = tonumber(R) or 255
        else
            R = 255
        end
        if G ~= nil then
            G = tonumber(G) or 255
        else
            G = 255
        end
        if B ~= nil then
            B = tonumber(B) or 255
        else
            B = 255
        end
        if A ~= nil then
            A = tonumber(A) or 255
        else
            A = 255
        end

        local _UIMenu = {
            Logo = Sprite.New(TxtDictionary, TxtName, 0 + X, 0 + Y, 431, 107, Heading, R, G, B, A),
            Banner = nil,
            Title = UIResText.New(Title, 215 + X, 20 + Y, 1.15, 255, 255, 255, 255, 1, 1, 0),
            BetterSize = true,
            Subtitle = {ExtraY = 0},
            WidthOffset = 0,
            Position = {X = X, Y = Y},
            DrawOffset = {X = 0, Y = 0},
            Pagination = {Min = 0, Max = 10, Total = 9},
            PageCounter = {isCustom = false, PreText = ""},
            Extra = {},
            Description = {},
            Items = {},
            Windows = {},
            Children = {},
            Controls = {
                Back = {Enabled = true},
                Select = {Enabled = true},
                Left = {Enabled = true},
                Right = {Enabled = true},
                Up = {Enabled = true},
                Down = {Enabled = true}
            },
            ParentMenu = nil,
            ParentItem = nil,
            _Visible = false,
            ActiveItem = 1000,
            Dirty = false,
            ReDraw = true,
            InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS"),
            InstructionalButtons = {},
            OnIndexChange = function(menu, newindex) end,
            OnListChange = function(menu, list, newindex) end,
            OnSliderChange = function(menu, slider, newindex) end,
            OnProgressChange = function(menu, progress, newindex) end,
            OnCheckboxChange = function(menu, item, checked) end,
            OnListSelect = function(menu, list, index) end,
            OnSliderSelect = function(menu, slider, index) end,
            OnProgressSelect = function(menu, progress, index) end,
            OnItemSelect = function(menu, item, index) end,
            OnMenuChanged = function(menu, newmenu, forward) end,
            OnMenuClosed = function(menu) end,
            Settings = {
                InstructionalButtons = true,
                MultilineFormats = true,
                ScaleWithSafezone = true,
                ResetCursorOnOpen = true,
                MouseControlsEnabled = true,
                MouseEdgeEnabled = true,
                ControlDisablingEnabled = true,
                DrawOrder = nil,
                Audio = {
                    Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                    UpDown = "NAV_UP_DOWN",
                    LeftRight = "NAV_LEFT_RIGHT",
                    Select = "SELECT",
                    Back = "BACK",
                    Error = "ERROR"
                },
                EnabledControls = {
                    Controller = {
                        {0, 2}, -- Look Up and Down
                        {0, 1}, -- Look Left and Right
                        {0, 25}, -- Aim
                        {0, 24} -- Attack
                    },
                    Keyboard = {
                        {0, 201}, -- Select
                        {0, 195}, -- X axis
                        {0, 196}, -- Y axis
                        {0, 187}, -- Down
                        {0, 188}, -- Up
                        {0, 189}, -- Left
                        {0, 190}, -- Right
                        {0, 202}, -- Back
                        {0, 217}, -- Select
                        {0, 242}, -- Scroll down
                        {0, 241}, -- Scroll up
                        {0, 239}, -- Cursor X
                        {0, 240}, -- Cursor Y
                        {0, 31}, -- Move Up and Down
                        {0, 30}, -- Move Left and Right
                        {0, 21}, -- Sprint
                        {0, 22}, -- Jump
                        {0, 23}, -- Enter
                        {0, 75}, -- Exit Vehicle
                        {0, 71}, -- Accelerate Vehicle
                        {0, 72}, -- Vehicle Brake
                        {0, 59}, -- Move Vehicle Left and Right
                        {0, 89}, -- Fly Yaw Left
                        {0, 9}, -- Fly Left and Right
                        {0, 8}, -- Fly Up and Down
                        {0, 90}, -- Fly Yaw Right
                        {0, 76} -- Vehicle Handbrake
                    }
                }
            }
        }

        if Subtitle ~= "" and Subtitle ~= nil then
            _UIMenu.Subtitle.Rectangle = UIResRectangle.New(0 + _UIMenu.Position.X, 107 + _UIMenu.Position.Y, 431, 37, 0, 0, 0, 255)
            _UIMenu.Subtitle.Text = UIResText.New(Subtitle, 8 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0)
            _UIMenu.Subtitle.BackupText = Subtitle
            _UIMenu.Subtitle.Formatted = false
            if string.starts(Subtitle, "~") then _UIMenu.PageCounter.PreText = string.sub(Subtitle, 1, 3) end
            _UIMenu.PageCounter.Text = UIResText.New("", 425 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0, "Right")
            _UIMenu.Subtitle.ExtraY = 37
        end

        _UIMenu.ArrowSprite = Sprite.New("commonmenu", "shop_arrows_upanddown", 190 + _UIMenu.Position.X, 147 + 37 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 40, 40)
        _UIMenu.Extra.Up = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)
        _UIMenu.Extra.Down = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 18 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)

        _UIMenu.Description.Bar = UIResRectangle.New(_UIMenu.Position.X, 123, 431, 4, 0, 0, 0, 255)
        _UIMenu.Description.Rectangle = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 127, 431, 30)
        _UIMenu.Description.Badge = Sprite.New("shared", "info_icon_32", _UIMenu.Position.X + 5, 130, 31, 31)
        _UIMenu.Description.Text = UIResText.New("Description", _UIMenu.Position.X + 35, 125, 0.35)
        _UIMenu.Description.Text.LongText = 1

        _UIMenu.Background = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 144 + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 290, 25)

        if _UIMenu.BetterSize == true then
            _UIMenu.WidthOffset = math.floor(tonumber(69))
            _UIMenu.Logo:Size(431 + _UIMenu.WidthOffset, 107)
            _UIMenu.Title:Position(((_UIMenu.WidthOffset + 431) / 2) + _UIMenu.Position.X, 20 + _UIMenu.Position.Y)
            if _UIMenu.Subtitle.Rectangle ~= nil then
                _UIMenu.Subtitle.Rectangle:Size(431 + _UIMenu.WidthOffset + 100, 37)
                _UIMenu.PageCounter.Text:Position(425 + _UIMenu.Position.X + _UIMenu.WidthOffset, 110 + _UIMenu.Position.Y)
            end
            if _UIMenu.Banner ~= nil then _UIMenu.Banner:Size(431 + _UIMenu.WidthOffset, 107) end
        end

        Citizen.CreateThread(function()
            if not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) then
                _UIMenu.InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
                while not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) do Citizen.Wait(0) end
            end
        end)
        return setmetatable(_UIMenu, UIMenu)
    end

    function UIMenu:SetMenuWidthOffset(Offset)
        if tonumber(Offset) then
            self.WidthOffset = math.floor(tonumber(Offset) + tonumber(70))
            self.Logo:Size(431 + self.WidthOffset, 107)
            self.Title:Position(((self.WidthOffset + 431) / 2) + self.Position.X, 20 + self.Position.Y)
            if self.Subtitle.Rectangle ~= nil then
                self.Subtitle.Rectangle:Size(431 + self.WidthOffset + 100, 37)
                self.PageCounter.Text:Position(425 + self.Position.X + self.WidthOffset, 110 + self.Position.Y)
            end
            if self.Banner ~= nil then self.Banner:Size(431 + self.WidthOffset, 107) end
        end
    end

    function UIMenu:DisEnableControls(bool)
        if bool then
            EnableAllControlActions(2)
        else
            DisableAllControlActions(2)
        end
        if bool then
            return
        else
            if Controller() then
                for Index = 1, #self.Settings.EnabledControls.Controller do
                    EnableControlAction(self.Settings.EnabledControls.Controller[Index][1], self.Settings.EnabledControls.Controller[Index][2], true)
                end
            else
                for Index = 1, #self.Settings.EnabledControls.Keyboard do
                    EnableControlAction(self.Settings.EnabledControls.Keyboard[Index][1], self.Settings.EnabledControls.Keyboard[Index][2], true)
                end
            end
        end
    end

    function UIMenu:InstructionalButtons(bool) if bool ~= nil then self.Settings.InstrucitonalButtons = ToBool(bool) end end

    function UIMenu:SetBannerSprite(Sprite, IncludeChildren)
        if Sprite() == "Sprite" then
            self.Logo = Sprite
            self.Logo:Size(431 + self.WidthOffset, 107)
            self.Logo:Position(self.Position.X, self.Position.Y)
            self.Banner = nil
            if IncludeChildren then
                for Item, Menu in pairs(self.Children) do
                    Menu.Logo = Sprite
                    Menu.Logo:Size(431 + self.WidthOffset, 107)
                    Menu.Logo:Position(self.Position.X, self.Position.Y)
                    Menu.Banner = nil
                end
            end
        end
    end

    function UIMenu:SetBannerRectangle(Rectangle, IncludeChildren)
        if Rectangle() == "Rectangle" then
            self.Banner = Rectangle
            self.Banner:Size(431 + self.WidthOffset, 107)
            self.Banner:Position(self.Position.X, self.Position.Y)
            self.Logo = nil
            if IncludeChildren then
                for Item, Menu in pairs(self.Children) do
                    Menu.Banner = Rectangle
                    Menu.Banner:Size(431 + self.WidthOffset, 107)
                    Menu:Position(self.Position.X, self.Position.Y)
                    Menu.Logo = nil
                end
            end
        end
    end

    function UIMenu:CurrentSelection(value)
        if tonumber(value) then
            if #self.Items == 0 then self.ActiveItem = 0 end
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = 1000000 - (1000000 % #self.Items) + tonumber(value)
            if self:CurrentSelection() > self.Pagination.Max then
                self.Pagination.Min = self:CurrentSelection() - self.Pagination.Total
                self.Pagination.Max = self:CurrentSelection()
            elseif self:CurrentSelection() < self.Pagination.Min then
                self.Pagination.Min = self:CurrentSelection()
                self.Pagination.Max = self:CurrentSelection() + self.Pagination.Total
            end
        else
            if #self.Items == 0 then
                return 1
            else
                if self.ActiveItem % #self.Items == 0 then
                    return 1
                else
                    return self.ActiveItem % #self.Items + 1
                end
            end
        end
    end

    function UIMenu:CalculateWindowHeight()
        local Height = 0
        for i = 1, #self.Windows do Height = Height + self.Windows[i].Background:Size().Height end
        return Height
    end

    function UIMenu:CalculateItemHeightOffset(Item)
        if Item.Base then
            return Item.Base.Rectangle.Height
        else
            return Item.Rectangle.Height
        end
    end

    function UIMenu:CalculateItemHeight()
        local ItemOffset = 0 + self.Subtitle.ExtraY - 37
        for i = self.Pagination.Min + 1, self.Pagination.Max do
            local Item = self.Items[i]
            if Item ~= nil then ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item) end
        end

        return ItemOffset
    end

    function UIMenu:RecalculateDescriptionPosition()
        local WindowHeight = self:CalculateWindowHeight()
        self.Description.Bar:Position(self.Position.X, 149 + self.Position.Y + WindowHeight)
        self.Description.Rectangle:Position(self.Position.X, 149 + self.Position.Y + WindowHeight)
        self.Description.Badge:Position(self.Position.X + 4, 152 + self.Position.Y + WindowHeight)
        self.Description.Text:Position(self.Position.X + 38, 153 + self.Position.Y + WindowHeight)
        self.Description.Bar:Size(431 + self.WidthOffset, 4)
        self.Description.Rectangle:Size(431 + self.WidthOffset, 30)
        self.Description.Bar:Position(self.Position.X, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Bar:Position().Y)
        self.Description.Rectangle:Position(self.Position.X, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Rectangle:Position().Y)
        self.Description.Badge:Position(self.Position.X + 4, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Badge:Position().Y)
        self.Description.Text:Position(self.Position.X + 38, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Text:Position().Y)
    end

    function UIMenu:CaclulatePanelPosition(HasDescription)
        local Height = self:CalculateWindowHeight() + 149 + self.Position.Y
        if HasDescription then Height = Height + self.Description.Rectangle:Size().Height + 5 end
        return self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + Height
    end

    function UIMenu:AddWindow(Window)
        if Window() == "UIMenuWindow" then
            Window:SetParentMenu(self)
            Window:Offset(self.Position.X, self.Position.Y)
            table.insert(self.Windows, Window)
            self.ReDraw = true
            self:RecalculateDescriptionPosition()
        end
    end

    function UIMenu:RemoveWindowAt(Index)
        if tonumber(Index) then
            if self.Windows[Index] then
                table.remove(self.Windows, Index)
                self.ReDraw = true
                self:RecalculateDescriptionPosition()
            end
        end
    end

    function UIMenu:AddItem(Item)
        Items = Item
        if #Items == 0 then
            if Item() == "UIMenuItem" then
                local SelectedItem = self:CurrentSelection()
                Item:SetParentMenu(self)
                Item:Offset(self.Position.X, self.Position.Y)
                Item:Position((#self.Items * 25) - 37 + self.Subtitle.ExtraY)
                table.insert(self.Items, Item)
                self:RecalculateDescriptionPosition()
                self:CurrentSelection(SelectedItem)
            end
        end
        for i = 1, #Items, 1 do
            Item = Items[i]
            if Item() == "UIMenuItem" then
                local SelectedItem = self:CurrentSelection()
                Item:SetParentMenu(self)
                Item:Offset(self.Position.X, self.Position.Y)
                Item:Position((#self.Items * 25) - 37 + self.Subtitle.ExtraY)
                table.insert(self.Items, Item)
                self:RecalculateDescriptionPosition()
                self:CurrentSelection(SelectedItem)
            end
        end
    end

    function UIMenu:AddSpacerItem(Title, Description)
        local output = "~h~";
        local length = Title:len();
        local totalSize = 50 - length;

        for i=0, totalSize do
            output = output.." ";
        end
        output = output..Title;
        local spacerItem = nil;
        if string.IsNullOrEmpty(Description) then spacerItem = UIMenuItem.New(output, "")
        else spacerItem = UIMenuItem.New(output, Description) end
        spacerItem:Enabled(false)
        self:AddItem(spacerItem)
    end
    
    function UIMenu:GetItemAt(index) return self.Items[index] end

    function UIMenu:RemoveItemAt(Index)
        if tonumber(Index) then
            if self.Items[Index] then
                local SelectedItem = self:CurrentSelection()
                if #self.Items > self.Pagination.Total and self.Pagination.Max == #self.Items - 1 then
                    self.Pagination.Min = self.Pagination.Min - 1
                    self.Pagination.Max = self.Pagination.Max + 1
                end
                table.remove(self.Items, tonumber(Index))
                self:RecalculateDescriptionPosition()
                self:CurrentSelection(SelectedItem)
            end
        end
    end

    function UIMenu:RefreshIndex()
        if #self.Items == 0 then
            self.ActiveItem = 1000
            self.Pagination.Max = self.Pagination.Total + 1
            self.Pagination.Min = 0
            return
        end
        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = 1000 - (1000 % #self.Items)
        self.Pagination.Max = self.Pagination.Total + 1
        self.Pagination.Min = 0
        self.ReDraw = true
    end

    function UIMenu:Clear()
        self.Items = {}
        self.ReDraw = true
        self:RecalculateDescriptionPosition()
    end

    function UIMenu:MultilineFormat(str, offset)
        if offset == nil then offset = 0 end
        if tostring(str) then
            local PixelPerLine = 425 + self.WidthOffset - offset
            local AggregatePixels = 0
            local output = ""
            local words = string.split(tostring(str), " ")
            for i = 1, #words do
                local offset = MeasureStringWidth(words[i], 0, 0.30)
                AggregatePixels = AggregatePixels + offset
                if AggregatePixels > PixelPerLine then
                    output = output .. "\n" .. words[i] .. " "
                    AggregatePixels = offset + MeasureString(" ")
                else
                    output = output .. words[i] .. " "
                    AggregatePixels = AggregatePixels + MeasureString(" ")
                end
            end

            return output
        end
    end

    function UIMenu:DrawCalculations()
        local WindowHeight = self:CalculateWindowHeight()
        if self.Settings.MultilineFormats then
            if self.Subtitle.Rectangle and not self.Subtitle.Formatted then
                self.Subtitle.Formatted = true
                self.Subtitle.Text:Text(self:MultilineFormat(self.Subtitle.Text:Text()))
                local Linecount = #string.split(self.Subtitle.Text:Text(), "\n")
                self.Subtitle.ExtraY = ((Linecount == 1) and 37 or ((Linecount + 1) * 22))
                self.Subtitle.Rectangle:Size(431 + self.WidthOffset, self.Subtitle.ExtraY)
            end
        elseif self.Subtitle.Formatted then
            self.Subtitle.Formatted = false
            self.Subtitle.ExtraY = 37
            self.Subtitle.Rectangle:Size(431 + self.WidthOffset, self.Subtitle.ExtraY)
            self.Subtitle.Text:Text(self.Subtitle.BackupText)
        end

        self.Background:Size(431 + self.WidthOffset, self:CalculateItemHeight() + WindowHeight + ((self.Subtitle.ExtraY > 0) and 0 or 37))

        self.Extra.Up:Size(431 + self.WidthOffset, 18)
        self.Extra.Down:Size(431 + self.WidthOffset, 18)

        local offsetExtra = 4
        self.Extra.Up:Position(self.Position.X, 144 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
        self.Extra.Down:Position(self.Position.X, 144 + 18 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)

        if self.WidthOffset > 0 then
            self.ArrowSprite:Position(190 + self.Position.X + (self.WidthOffset / 2),
                                        141 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
        else
            self.ArrowSprite:Position(190 + self.Position.X + self.WidthOffset,
                                        141 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
        end

        self.ReDraw = false

        if #self.Items ~= 0 and self.Items[self:CurrentSelection()]:Description() ~= "" then
            self:RecalculateDescriptionPosition()
            local description = self.Items[self:CurrentSelection()]:Description()
            if self.Settings.MultilineFormats then
                self.Description.Text:Text(self:MultilineFormat(description, 35))
            else
                self.Description.Text:Text(description)
            end
            local Linecount = #string.split(self.Description.Text:Text(), "\n")
            self.Description.Rectangle:Size(431 + self.WidthOffset, ((Linecount == 1) and 37 or ((Linecount + 1) * 22)))
        end
    end

    function UIMenu:Visible(bool)
        if bool ~= nil then
            self._Visible = ToBool(bool)
            self.JustOpened = ToBool(bool)
            self.Dirty = ToBool(bool)
            self:UpdateScaleform()
            if self.ParentMenu ~= nil or ToBool(bool) == false then return end
            if self.Settings.ResetCursorOnOpen then
                if SetCursorSprite ~= nil then
                    SetCursorSprite(1)
                else
                    N_0x8db8cffd58b62552(1)
                end
                if SetCursorLocation ~= nil then
                    SetCursorLocation(0.5, 0.5)
                else
                    N_0xfc695459d4d0e219(0.5, 0.5)
                end
            end
        else
            return self._Visible
        end
    end

    function UIMenu:ProcessControl()
        if not self._Visible then return end
        if self.JustOpened then
            self.JustOpened = false
            return
        end
        if self.Controls.Back.Enabled and
            (IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(1, 177) or IsDisabledControlJustReleased(2, 177) or
                IsDisabledControlJustReleased(0, 199) or IsDisabledControlJustReleased(1, 199) or IsDisabledControlJustReleased(2, 199)) then
            self:GoBack()
        end
        if #self.Items == 0 then return end
        if not self.UpPressed then
            if self.Controls.Up.Enabled and
                (IsDisabledControlJustPressed(0, 172) or IsDisabledControlJustPressed(1, 172) or IsDisabledControlJustPressed(2, 172) or
                    IsDisabledControlJustPressed(0, 241) or IsDisabledControlJustPressed(1, 241) or IsDisabledControlJustPressed(2, 241) or
                    IsDisabledControlJustPressed(2, 241)) then
                Citizen.CreateThread(function()
                    self.UpPressed = true
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoUpOverflow()
                    else
                        self:GoUp()
                    end
                    self:UpdateScaleform()
                    Citizen.Wait(175)
                    while self.Controls.Up.Enabled and
                        (IsDisabledControlPressed(0, 172) or IsDisabledControlPressed(1, 172) or IsDisabledControlPressed(2, 172) or
                            IsDisabledControlPressed(0, 241) or IsDisabledControlPressed(1, 241) or IsDisabledControlPressed(2, 241) or
                            IsDisabledControlPressed(2, 241)) do
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoUpOverflow()
                        else
                            self:GoUp()
                        end
                        self:UpdateScaleform()
                        Citizen.Wait(125)
                    end
                    self.UpPressed = false
                end)
            end
        end
        if not self.DownPressed then
            if self.Controls.Down.Enabled and
                (IsDisabledControlJustPressed(0, 173) or IsDisabledControlJustPressed(1, 173) or IsDisabledControlJustPressed(2, 173) or
                    IsDisabledControlJustPressed(0, 242) or IsDisabledControlJustPressed(1, 242) or IsDisabledControlJustPressed(2, 242)) then
                Citizen.CreateThread(function()
                    self.DownPressed = true
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoDownOverflow()
                    else
                        self:GoDown()
                    end
                    self:UpdateScaleform()
                    Citizen.Wait(175)
                    while self.Controls.Down.Enabled and
                        (IsDisabledControlPressed(0, 173) or IsDisabledControlPressed(1, 173) or IsDisabledControlPressed(2, 173) or
                            IsDisabledControlPressed(0, 242) or IsDisabledControlPressed(1, 242) or IsDisabledControlPressed(2, 242)) do
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoDownOverflow()
                        else
                            self:GoDown()
                        end
                        self:UpdateScaleform()
                        Citizen.Wait(125)
                    end
                    self.DownPressed = false
                end)
            end
        end
        if not self.LeftPressed then
            if self.Controls.Left.Enabled and
                (IsDisabledControlJustPressed(0, 174) or IsDisabledControlJustPressed(1, 174) or IsDisabledControlJustPressed(2, 174)) then
                local type, subtype = self.Items[self:CurrentSelection()]()
                Citizen.CreateThread(function()
                    if (subtype == "UIMenuSliderHeritageItem") then
                        self.LeftPressed = true
                        self:GoLeft()
                        Citizen.Wait(40)
                        while self.Controls.Left.Enabled and
                            (IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174)) do
                            self:GoLeft()
                            Citizen.Wait(20)
                        end
                        self.LeftPressed = false
                    else
                        self.LeftPressed = true
                        self:GoLeft()
                        Citizen.Wait(175)
                        while self.Controls.Left.Enabled and
                            (IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174)) do
                            self:GoLeft()
                            Citizen.Wait(125)
                        end
                        self.LeftPressed = false
                    end
                end)
            end
        end
        if not self.RightPressed then
            if self.Controls.Right.Enabled and
                (IsDisabledControlJustPressed(0, 175) or IsDisabledControlJustPressed(1, 175) or IsDisabledControlJustPressed(2, 175)) then
                Citizen.CreateThread(function()
                    local type, subtype = self.Items[self:CurrentSelection()]()
                    if (subtype == "UIMenuSliderHeritageItem") then
                        self.RightPressed = true
                        self:GoRight()
                        Citizen.Wait(40)
                        while self.Controls.Right.Enabled and
                            (IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175)) do
                            self:GoRight()
                            Citizen.Wait(20)
                        end
                        self.RightPressed = false
                    else
                        self.RightPressed = true
                        self:GoRight()
                        Citizen.Wait(175)
                        while self.Controls.Right.Enabled and
                            (IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175)) do
                            self:GoRight()
                            Citizen.Wait(125)
                        end
                        self.RightPressed = false
                    end
                end)
            end
        end
        if self.Controls.Select.Enabled and
            (IsDisabledControlJustPressed(0, 201) or IsDisabledControlJustPressed(1, 201) or IsDisabledControlJustPressed(2, 201)) then
            self:SelectItem()
        end
    end

    function UIMenu:GoUpOverflow()
        if #self.Items <= self.Pagination.Total + 1 then return end
        if self:CurrentSelection() <= self.Pagination.Min + 1 then
            if self:CurrentSelection() == 1 then
                self.Pagination.Min = #self.Items - (self.Pagination.Total + 1)
                self.Pagination.Max = #self.Items
                self.Items[self:CurrentSelection()]:Selected(false)
                self.ActiveItem = 1000 - (1000 % #self.Items)
                self.ActiveItem = self.ActiveItem + (#self.Items - 1)
                self.Items[self:CurrentSelection()]:Selected(true)
            else
                self.Pagination.Min = self.Pagination.Min - 1
                self.Pagination.Max = self.Pagination.Max - 1
                self.Items[self:CurrentSelection()]:Selected(false)
                self.ActiveItem = self.ActiveItem - 1
                self.Items[self:CurrentSelection()]:Selected(true)
            end
        else
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = self.ActiveItem - 1
            self.Items[self:CurrentSelection()]:Selected(true)
        end
        PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
        self.OnIndexChange(self, self:CurrentSelection())
        self.ReDraw = true
    end

    function UIMenu:GoUp()
        if #self.Items > self.Pagination.Total + 1 then return end
        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = self.ActiveItem - 1
        self.Items[self:CurrentSelection()]:Selected(true)
        PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
        self.OnIndexChange(self, self:CurrentSelection())
        self.ReDraw = true
    end

    function UIMenu:GoDownOverflow()
        if #self.Items <= self.Pagination.Total + 1 then return end

        if self:CurrentSelection() >= self.Pagination.Max then
            if self:CurrentSelection() == #self.Items then
                self.Pagination.Min = 0
                self.Pagination.Max = self.Pagination.Total + 1
                self.Items[self:CurrentSelection()]:Selected(false)
                self.ActiveItem = 1000 - (1000 % #self.Items)
                self.Items[self:CurrentSelection()]:Selected(true)
            else
                self.Pagination.Max = self.Pagination.Max + 1
                self.Pagination.Min = self.Pagination.Max - (self.Pagination.Total + 1)
                self.Items[self:CurrentSelection()]:Selected(false)
                self.ActiveItem = self.ActiveItem + 1
                self.Items[self:CurrentSelection()]:Selected(true)
            end
        else
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = self.ActiveItem + 1
            self.Items[self:CurrentSelection()]:Selected(true)
        end
        PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
        self.OnIndexChange(self, self:CurrentSelection())
        self.ReDraw = true
    end

    function UIMenu:GoDown()
        if #self.Items > self.Pagination.Total + 1 then return end

        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = self.ActiveItem + 1
        self.Items[self:CurrentSelection()]:Selected(true)
        PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
        self.OnIndexChange(self, self:CurrentSelection())
        self.ReDraw = true
    end

    function UIMenu:GoLeft()
        local type, subtype = self.Items[self:CurrentSelection()]()
        if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuSliderItem" and subtype ~= "UIMenuProgressItem" and subtype ~=
            "UIMenuSliderHeritageItem" and subtype ~= "UIMenuSliderProgressItem" then return end

        if not self.Items[self:CurrentSelection()]:Enabled() then
            PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
            return
        end

        if subtype == "UIMenuListItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index - 1)
            self.OnListChange(self, Item, Item._Index)
            Item.OnListChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index - 1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderProgressItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index - 1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuProgressItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item.Data.Index - 1)
            self.OnProgressChange(self, Item, Item.Data.Index)
            Item.OnProgressChanged(self, Item, Item.Data.Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderHeritageItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index - 0.1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            if not Item.Pressed then
                Item.Pressed = true
                Citizen.CreateThread(function()
                    Item.Audio.Id = GetSoundId()
                    PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                    Citizen.Wait(100)
                    StopSound(Item.Audio.Id)
                    ReleaseSoundId(Item.Audio.Id)
                    Item.Pressed = false
                end)
            end

        end
    end

    function UIMenu:GoRight()
        local type, subtype = self.Items[self:CurrentSelection()]()
        if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuSliderItem" and subtype ~= "UIMenuProgressItem" and subtype ~=
            "UIMenuSliderHeritageItem" and subtype ~= "UIMenuSliderProgressItem" then return end
        if not self.Items[self:CurrentSelection()]:Enabled() then
            PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
            return
        end
        if subtype == "UIMenuListItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index + 1)
            self.OnListChange(self, Item, Item._Index)
            Item.OnListChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index + 1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderProgressItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index + 1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuProgressItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item.Data.Index + 1)
            self.OnProgressChange(self, Item, Item.Data.Index)
            Item.OnProgressChanged(self, Item, Item.Data.Index)
            PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
        elseif subtype == "UIMenuSliderHeritageItem" then
            local Item = self.Items[self:CurrentSelection()]
            Item:Index(Item._Index + 0.1)
            self.OnSliderChange(self, Item, Item:Index())
            Item.OnSliderChanged(self, Item, Item._Index)
            if not Item.Pressed then
                Item.Pressed = true
                Citizen.CreateThread(function()
                    Item.Audio.Id = GetSoundId()
                    PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                    Citizen.Wait(100)
                    StopSound(Item.Audio.Id)
                    ReleaseSoundId(Item.Audio.Id)
                    Item.Pressed = false
                end)
            end
        end
    end

    function UIMenu:SelectItem()
        if not self.Items[self:CurrentSelection()]:Enabled() then
            PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
            return
        end
        local Item = self.Items[self:CurrentSelection()]
        local type, subtype = Item()
        if subtype == "UIMenuCheckboxItem" then
            Item.Checked = not Item.Checked
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnCheckboxChange(self, Item, Item.Checked)
            Item.CheckboxEvent(self, Item, Item.Checked)
        elseif subtype == "UIMenuListItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnListSelect(self, Item, Item._Index)
            Item.OnListSelected(self, Item, Item._Index)
        elseif subtype == "UIMenuSliderItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnSliderSelect(self, Item, Item._Index)
            Item.OnSliderSelected(Item._Index)
        elseif subtype == "UIMenuSliderProgressItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnSliderSelect(self, Item, Item._Index)
            Item.OnSliderSelected(Item._Index)
        elseif subtype == "UIMenuProgressItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnProgressSelect(self, Item, Item.Data.Index)
            Item.OnProgressSelected(Item.Data.Index)
        elseif subtype == "UIMenuSliderHeritageItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnSliderSelect(self, Item, Item._Index)
            Item.OnSliderSelected(Item._Index)
        else
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            self.OnItemSelect(self, Item, self:CurrentSelection())
            Item.Activated(self, Item)
            if not self.Children[Item] then return end
            self:Visible(false)
            self.Children[Item]:Visible(true)
            self.OnMenuChanged(self, self.Children[self.Items[self:CurrentSelection()]], true)
        end
    end

    function UIMenu:GoBack()
        PlaySoundFrontend(-1, self.Settings.Audio.Back, self.Settings.Audio.Library, true)
        self:Visible(false)
        if self.ParentMenu ~= nil then
            self.ParentMenu:Visible(true)
            self.OnMenuChanged(self, self.ParentMenu, false)
            if self.Settings.ResetCursorOnOpen then
                if SetCursorLocation ~= nil then
                    SetCursorLocation(0.5, 0.5)
                else
                    N_0xfc695459d4d0e219(0.5, 0.5)
                end
            end
        end
        self.OnMenuClosed(self)
    end

    function UIMenu:BindMenuToItem(Menu, Item)
        if Menu() == "UIMenu" and Item() == "UIMenuItem" then
            Menu.ParentMenu = self
            Menu.ParentItem = Item
            self.Children[Item] = Menu
        end
    end

    function UIMenu:ReleaseMenuFromItem(Item)
        if Item() == "UIMenuItem" then
            if not self.Children[Item] then return false end
            self.Children[Item].ParentMenu = nil
            self.Children[Item].ParentItem = nil
            self.Children[Item] = nil
            return true
        end
    end

    function UIMenu:PageCounterName(String)
        self.PageCounter.isCustom = true
        self.PageCounter.PreText = String
        self.PageCounter.Text:Text(self.PageCounter.PreText)
        self.PageCounter.Text:Draw()
    end

    function UIMenu:Draw()
        if not self._Visible then return end
        HideHudComponentThisFrame(19)
        if self.Settings.ControlDisablingEnabled then self:DisEnableControls(false) end
        if self.Settings.InstructionalButtons then DrawScaleformMovieFullscreen(self.InstructionalScaleform, 255, 255, 255, 255, 0) end
        if self.Settings.ScaleWithSafezone then
            if N_0xB8A850F20A067EB6 ~= nil then
                N_0xB8A850F20A067EB6(76, 84)
            elseif SetScriptGfxAlign ~= nil then
                SetScriptGfxAlign(76, 84)
            elseif SetScreenDrawPosition ~= nil then
                SetScreenDrawPosition(76, 84)
            end

            if N_0xF5A2C681787E579D ~= nil then
                N_0xF5A2C681787E579D(0, 0, 0, 0)
            elseif ScreenDrawPositionRatio ~= nil then
                ScreenDrawPositionRatio(0, 0, 0, 0)
            elseif SetScriptGfxAlignParams ~= nil then
                SetScriptGfxAlignParams(0, 0, 0, 0)
            end

            if self.Settings.DrawOrder ~= nil then SetScriptGfxDrawOrder(tonumber(self.Settings.DrawOrder)) end
            if GetScriptGfxPosition ~= nil then
                self.DrawOffset.X, self.DrawOffset.Y = GetScriptGfxPosition(0, 0)
            else
                self.DrawOffset.X, self.DrawOffset.Y = N_0x6dd8f5aa635eb4b2(0, 0)
            end
        end
        if self.ReDraw then self:DrawCalculations() end
        if self.Logo then
            self.Logo:Draw()
        elseif self.Banner then
            self.Banner:Draw()
        end
        self.Title:Draw()
        if self.Subtitle.Rectangle then
            self.Subtitle.Rectangle:Draw()
            self.Subtitle.Text:Draw()
        end
        if #self.Items ~= 0 or #self.Windows ~= 0 then self.Background:Draw() end
        if #self.Windows ~= 0 then
            local WindowOffset = 0
            for index = 1, #self.Windows do
                if self.Windows[index - 1] then
                    WindowOffset = WindowOffset + self.Windows[index - 1].Background:Size().Height
                end
                local Window = self.Windows[index]
                Window:Position(WindowOffset + self.Subtitle.ExtraY - 37)
                Window:Draw()
            end
        end
        if #self.Items == 0 then
            if self.Settings.ScaleWithSafezone then
                if ResetScriptGfxAlign ~= nil then
                    ResetScriptGfxAlign()
                elseif ScreenDrawPositionEnd ~= nil then
                    ScreenDrawPositionEnd()
                else
                    N_0xe3a3db414a373dab()
                end
            end
            return
        end

        local CurrentSelection = self:CurrentSelection()
        self.Items[CurrentSelection]:Selected(true)

        if self.Items[CurrentSelection]:Description() ~= "" then
            self.Description.Bar:Draw()
            self.Description.Rectangle:Draw()
            self.Description.Badge:Draw()
            self.Description.Text:Draw()
        end

        if self.Items[CurrentSelection].Panels ~= nil then
            if #self.Items[CurrentSelection].Panels ~= 0 then
                local PanelOffset = self:CaclulatePanelPosition(self.Items[CurrentSelection]:Description() ~= "")
                for index = 1, #self.Items[CurrentSelection].Panels do
                    if self.Items[CurrentSelection].Panels[index - 1] then
                        PanelOffset = PanelOffset + self.Items[CurrentSelection].Panels[index - 1].Background:Size().Height + 5
                    end
                    self.Items[CurrentSelection].Panels[index]:Position(PanelOffset)
                    self.Items[CurrentSelection].Panels[index]:Draw()
                end
            end
        end

        local WindowHeight = self:CalculateWindowHeight()

        if #self.Items <= self.Pagination.Total + 1 then
            local ItemOffset = self.Subtitle.ExtraY - 37 + WindowHeight
            for index = 1, #self.Items do
                local Item = self.Items[index]
                Item:Position(ItemOffset)
                Item:Draw()
                ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
            end
        else
            local ItemOffset = self.Subtitle.ExtraY - 37 + WindowHeight
            for index = self.Pagination.Min + 1, self.Pagination.Max, 1 do
                if self.Items[index] then
                    local Item = self.Items[index]
                    Item:Position(ItemOffset)
                    Item:Draw()
                    ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
                end
            end

            self.Extra.Up:Draw()
            self.Extra.Down:Draw()
            self.ArrowSprite:Draw()

            if self.PageCounter.isCustom ~= true then
                if self.PageCounter.Text ~= nil then
                    local Caption = self.PageCounter.PreText .. CurrentSelection .. " / " .. #self.Items
                    self.PageCounter.Text:Text(Caption)
                    self.PageCounter.Text:Draw()
                end
            end
        end

        if self.PageCounter.isCustom ~= false then
            if self.PageCounter.Text ~= nil then
                self.PageCounter.Text:Text(self.PageCounter.PreText)
                self.PageCounter.Text:Draw()
            end
        end

        if self.Settings.ScaleWithSafezone then
            if ResetScriptGfxAlign ~= nil then
                ResetScriptGfxAlign()
            elseif ScreenDrawPositionEnd ~= nil then
                ScreenDrawPositionEnd()
            else
                N_0xe3a3db414a373dab()
            end
        end
    end

    function UIMenu:ProcessMouse()
        if not self._Visible or self.JustOpened or #self.Items == 0 or ToBool(Controller()) or not self.Settings.MouseControlsEnabled then
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 25, true)
            EnableControlAction(0, 24, true)
            if self.Dirty then for _, Item in pairs(self.Items) do if Item:Hovered() then Item:Hovered(false) end end end
            return
        end

        local WindowHeight = self:CalculateWindowHeight()
        local Limit = #self.Items
        local ItemOffset = 0

        ShowCursorThisFrame()

        if #self.Items > self.Pagination.Total + 1 then Limit = self.Pagination.Max end

        local W, H = GetResolution()

        if IsMouseInBounds(0, 0, 30, H) and self.Settings.MouseEdgeEnabled then
            SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 5)
            if SetCursorSprite ~= nil then
                SetCursorSprite(6)
            else
                N_0x8db8cffd58b62552(6)
            end
        elseif IsMouseInBounds(W - 30, 0, 30, H) and self.Settings.MouseEdgeEnabled then
            SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 5)
            if SetCursorSprite ~= nil then
                SetCursorSprite(7)
            else
                N_0x8db8cffd58b62552(7)
            end
        elseif self.Settings.MouseEdgeEnabled then
            if SetCursorSprite ~= nil then
                SetCursorSprite(1)
            else
                N_0x8db8cffd58b62552(1)
            end
        end

        for i = self.Pagination.Min + 1, Limit, 1 do
            local X, Y = self.Position.X, self.Position.Y + 144 - 37 + self.Subtitle.ExtraY + ItemOffset + WindowHeight
            local Item = self.Items[i]
            local Type, SubType = Item()
            local Width, Height = 431 + self.WidthOffset, self:CalculateItemHeightOffset(Item)

            if IsMouseInBounds(X, Y, Width, Height, self.DrawOffset) then
                Item:Hovered(true)
                if not self.Controls.MousePressed then
                    if IsDisabledControlJustPressed(0, 24) then
                        Citizen.CreateThread(function()
                            local _X, _Y, _Width, _Height = X, Y, Width, Height
                            self.Controls.MousePressed = true
                            if Item:Selected() and Item:Enabled() then
                                if SubType == "UIMenuListItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoLeft()
                                    elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                                Item.RightArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoRight()
                                    elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width,
                                                                Item.LeftArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                elseif SubType == "UIMenuSliderItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoLeft()
                                    elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                                Item.RightArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoRight()
                                    elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width,
                                                                Item.LeftArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                elseif SubType == "UIMenuSliderProgressItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoLeft()
                                    elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                                Item.RightArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoRight()
                                    elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width,
                                                                Item.LeftArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                elseif SubType == "UIMenuSliderHeritageItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoLeft()
                                    elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                                Item.RightArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height,
                                                        self.DrawOffset) then
                                        self:GoRight()
                                    elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width,
                                                                Item.LeftArrow.Height, self.DrawOffset) then
                                        self:SelectItem()
                                    end
                                elseif SubType == "UIMenuProgressItem" then
                                    if IsMouseInBounds(Item.Bar.X, Item.Bar.Y - 12, Item.Data.Max, Item.Bar.Height + 24, self.DrawOffset) then
                                        local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239), 0)
                                        Item:CalculateProgress(CursorX)
                                        self.OnProgressChange(self, Item, Item.Data.Index)
                                        Item.OnProgressChanged(self, Item, Item.Data.Index)
                                        if not Item.Pressed then
                                            Item.Pressed = true
                                            Citizen.CreateThread(function()
                                                Item.Audio.Id = GetSoundId()
                                                PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                                                Citizen.Wait(100)
                                                StopSound(Item.Audio.Id)
                                                ReleaseSoundId(Item.Audio.Id)
                                                Item.Pressed = false
                                            end)
                                        end
                                    else
                                        self:SelectItem()
                                    end
                                else
                                    self:SelectItem()
                                end
                            elseif not Item:Selected() then
                                self:CurrentSelection(i - 1)
                                PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                                self.OnIndexChange(self, self:CurrentSelection())
                                self.ReDraw = true
                                self:UpdateScaleform()
                            elseif not Item:Enabled() and Item:Selected() then
                                PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                            end
                            Citizen.Wait(175)
                            while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_X, _Y, _Width, _Height, self.DrawOffset) do
                                if Item:Selected() and Item:Enabled() then
                                    if SubType == "UIMenuListItem" then
                                        if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                            self.DrawOffset) then self:GoLeft() end
                                        if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                            Item.RightArrow.Height, self.DrawOffset) then
                                            self:GoRight()
                                        end
                                    elseif SubType == "UIMenuSliderItem" then
                                        if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                            self.DrawOffset) then self:GoLeft() end
                                        if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                            Item.RightArrow.Height, self.DrawOffset) then
                                            self:GoRight()
                                        end
                                    elseif SubType == "UIMenuSliderProgressItem" then
                                        if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                            self.DrawOffset) then self:GoLeft() end
                                        if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                            Item.RightArrow.Height, self.DrawOffset) then
                                            self:GoRight()
                                        end
                                    elseif SubType == "UIMenuSliderHeritageItem" then
                                        if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height,
                                                            self.DrawOffset) then self:GoLeft() end
                                        if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width,
                                                            Item.RightArrow.Height, self.DrawOffset) then
                                            self:GoRight()
                                        end
                                    elseif SubType == "UIMenuProgressItem" then
                                        if IsMouseInBounds(Item.Bar.X, Item.Bar.Y - 12, Item.Data.Max, Item.Bar.Height + 24, self.DrawOffset) then
                                            local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239), 0)
                                            Item:CalculateProgress(CursorX)
                                            self.OnProgressChange(self, Item, Item.Data.Index)
                                            Item.OnProgressChanged(self, Item, Item.Data.Index)
                                            if not Item.Pressed then
                                                Item.Pressed = true
                                                Citizen.CreateThread(function()
                                                    Item.Audio.Id = GetSoundId()
                                                    PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                                                    Citizen.Wait(100)
                                                    StopSound(Item.Audio.Id)
                                                    ReleaseSoundId(Item.Audio.Id)
                                                    Item.Pressed = false
                                                end)
                                            end
                                        else
                                            self:SelectItem()
                                        end
                                    end
                                elseif not Item:Selected() then
                                    self:CurrentSelection(i - 1)
                                    PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                                    self.OnIndexChange(self, self:CurrentSelection())
                                    self.ReDraw = true
                                    self:UpdateScaleform()
                                elseif not Item:Enabled() and Item:Selected() then
                                    PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                                end
                                Citizen.Wait(125)
                            end
                            self.Controls.MousePressed = false
                        end)
                    end
                end
            else
                Item:Hovered(false)
            end
            ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
        end

        local ExtraX, ExtraY = self.Position.X, 144 + self:CalculateItemHeight() + self.Position.Y + WindowHeight

        if #self.Items <= self.Pagination.Total + 1 then return end

        if IsMouseInBounds(ExtraX, ExtraY, 431 + self.WidthOffset, 18, self.DrawOffset) then
            self.Extra.Up:Colour(30, 30, 30, 255)
            if not self.Controls.MousePressed then
                if IsDisabledControlJustPressed(0, 24) then
                    Citizen.CreateThread(function()
                        local _ExtraX, _ExtraY = ExtraX, ExtraY
                        self.Controls.MousePressed = true
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoUpOverflow()
                        else
                            self:GoUp()
                        end
                        Citizen.Wait(175)
                        while IsDisabledControlPressed(0, 24) and
                            IsMouseInBounds(_ExtraX, _ExtraY, 431 + self.WidthOffset, 18, self.DrawOffset) do
                            if #self.Items > self.Pagination.Total + 1 then
                                self:GoUpOverflow()
                            else
                                self:GoUp()
                            end
                            Citizen.Wait(125)
                        end
                        self.Controls.MousePressed = false
                    end)
                end
            end
        else
            self.Extra.Up:Colour(0, 0, 0, 200)
        end

        if IsMouseInBounds(ExtraX, ExtraY + 18, 431 + self.WidthOffset, 18, self.DrawOffset) then
            self.Extra.Down:Colour(30, 30, 30, 255)
            if not self.Controls.MousePressed then
                if IsDisabledControlJustPressed(0, 24) then
                    Citizen.CreateThread(function()
                        local _ExtraX, _ExtraY = ExtraX, ExtraY
                        self.Controls.MousePressed = true
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoDownOverflow()
                        else
                            self:GoDown()
                        end
                        Citizen.Wait(175)
                        while IsDisabledControlPressed(0, 24) and
                            IsMouseInBounds(_ExtraX, _ExtraY + 18, 431 + self.WidthOffset, 18, self.DrawOffset) do
                            if #self.Items > self.Pagination.Total + 1 then
                                self:GoDownOverflow()
                            else
                                self:GoDown()
                            end
                            Citizen.Wait(125)
                        end
                        self.Controls.MousePressed = false
                    end)
                end
            end
        else
            self.Extra.Down:Colour(0, 0, 0, 200)
        end
    end

    function UIMenu:AddInstructionButton(button)
        if type(button) == "table" and #button == 2 then table.insert(self.InstructionalButtons, button) end
    end

    function UIMenu:RemoveInstructionButton(button)
        if type(button) == "table" then
            for i = 1, #self.InstructionalButtons do
                if button == self.InstructionalButtons[i] then
                    table.remove(self.InstructionalButtons, i)
                    break
                end
            end
        else
            if tonumber(button) then
                if self.InstructionalButtons[tonumber(button)] then table.remove(self.InstructionalButtons, tonumber(button)) end
            end
        end
    end

    function UIMenu:AddEnabledControl(Inputgroup, Control, Controller)
        if tonumber(Inputgroup) and tonumber(Control) then
            table.insert(self.Settings.EnabledControls[(Controller and "Controller" or "Keyboard")], {Inputgroup, Control})
        end
    end

    function UIMenu:RemoveEnabledControl(Inputgroup, Control, Controller)
        local Type = (Controller and "Controller" or "Keyboard")
        for Index = 1, #self.Settings.EnabledControls[Type] do
            if Inputgroup == self.Settings.EnabledControls[Type][Index][1] and Control == self.Settings.EnabledControls[Type][Index][2] then
                table.remove(self.Settings.EnabledControls[Type], Index)
                break
            end
        end
    end

    function UIMenu:UpdateScaleform()
        if not self._Visible or not self.Settings.InstructionalButtons then return end

        PushScaleformMovieFunction(self.InstructionalScaleform, "CLEAR_ALL")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(self.InstructionalScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterInt(0)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(self.InstructionalScaleform, "CREATE_CONTAINER")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(0)
        N_0xe83a3e3557a56640(N_0x0499d7b09fc9b407(2, 176, 0)) -- PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, 176, 0))
        PushScaleformMovieFunctionParameterString(GetLabelText("HUD_INPUT2"))
        PopScaleformMovieFunctionVoid()

        if self.Controls.Back.Enabled then
            PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(1)
            N_0xe83a3e3557a56640(N_0x0499d7b09fc9b407(2, 177, 0)) -- PushScaleformMovieMethodParameterButtonName(N_0x0499d7b09fc9b407(2, 177, 0))
            PushScaleformMovieFunctionParameterString(GetLabelText("HUD_INPUT3"))
            PopScaleformMovieFunctionVoid()
        end

        local count = 2

        for i = 1, #self.InstructionalButtons do
            if self.InstructionalButtons[i] then
                if #self.InstructionalButtons[i] == 2 then
                    PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
                    PushScaleformMovieFunctionParameterInt(count)
                    N_0xe83a3e3557a56640(self.InstructionalButtons[i][1]) -- PushScaleformMovieMethodParameterButtonName(self.InstructionalButtons[i][1])
                    PushScaleformMovieFunctionParameterString(self.InstructionalButtons[i][2])
                    PopScaleformMovieFunctionVoid()
                    count = count + 1
                end
            end
        end

        PushScaleformMovieFunction(self.InstructionalScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
    end
end

--==================================================================================================================================================--
--[[ NativeUI\UIMenu\MenuPool ]]
--==================================================================================================================================================--
MenuPool = setmetatable({}, MenuPool)
MenuPool.__index = MenuPool
do
    function MenuPool.New()
        local _MenuPool = {Menus = {}}
        return setmetatable(_MenuPool, MenuPool)
    end

    function MenuPool:AddSubMenu(Menu, Text, Description, BindMenu, KeepPosition, KeepBanner)
        if BindMenu ~= nil then BindMenu = ToBool(BindMenu); else BindMenu = true end;
        if KeepPosition ~= nil then KeepPosition = ToBool(KeepPosition); else KeepPosition = true end;
        if KeepBanner ~= nil then KeepBanner = ToBool(KeepBanner); else KeepBanner = true end;
        if Menu() == "UIMenu" then
            local Item = UIMenuItem.New(tostring(Text), Description or "")
            local SubMenu
            if KeepPosition then
                SubMenu = UIMenu.New(Menu.Title:Text(), Text, Menu.Position.X, Menu.Position.Y)
            else
                SubMenu = UIMenu.New(Menu.Title:Text(), Text)
            end
            if KeepBanner then
                if Menu.Logo ~= nil then
                    SubMenu.Logo = Menu.Logo
                else
                    SubMenu.Logo = nil
                    SubMenu.Banner = Menu.Banner
                end
            end
            self:Add(SubMenu)
            if BindMenu then
                Menu:AddItem(Item)
                Menu:BindMenuToItem(SubMenu, Item);
            end
            return {SubMenu = SubMenu, Item = Item}
        end
    end

    function MenuPool:Add(Menu) if Menu() == "UIMenu" then table.insert(self.Menus, Menu) end end

    function MenuPool:MouseEdgeEnabled(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.MouseEdgeEnabled = ToBool(bool) end end
    end

    function MenuPool:ControlDisablingEnabled(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.ControlDisablingEnabled = ToBool(bool) end end
    end

    function MenuPool:ResetCursorOnOpen(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.ResetCursorOnOpen = ToBool(bool) end end
    end

    function MenuPool:MultilineFormats(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.MultilineFormats = ToBool(bool) end end
    end

    function MenuPool:Audio(Attribute, Setting)
        if Attribute ~= nil and Setting ~= nil then
            for _, Menu in pairs(self.Menus) do if Menu.Settings.Audio[Attribute] then Menu.Settings.Audio[Attribute] = Setting end end
        end
    end

    function MenuPool:WidthOffset(offset)
        if tonumber(offset) then for _, Menu in pairs(self.Menus) do Menu:SetMenuWidthOffset(tonumber(offset)) end end
    end

    function MenuPool:CounterPreText(str) if str ~= nil then for _, Menu in pairs(self.Menus) do Menu.PageCounter.PreText = tostring(str) end end end

    function MenuPool:InstructionalButtonsEnabled(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.InstructionalButtons = ToBool(bool) end end
    end

    function MenuPool:MouseControlsEnabled(bool)
        if bool ~= nil then for _, Menu in pairs(self.Menus) do Menu.Settings.MouseControlsEnabled = ToBool(bool) end end
    end

    function MenuPool:RefreshIndex() for _, Menu in pairs(self.Menus) do Menu:RefreshIndex() end end

    function MenuPool:ProcessMenus()
        self:ProcessControl()
        self:ProcessMouse()
        self:Draw()
    end

    function MenuPool:ProcessControl() for _, Menu in pairs(self.Menus) do if Menu:Visible() then Menu:ProcessControl() end end end

    function MenuPool:ProcessMouse() for _, Menu in pairs(self.Menus) do if Menu:Visible() then Menu:ProcessMouse() end end end

    function MenuPool:Draw() for _, Menu in pairs(self.Menus) do if Menu:Visible() then Menu:Draw() end end end

    function MenuPool:IsAnyMenuOpen()
        local open = false
        for _, Menu in pairs(self.Menus) do
            if Menu:Visible() then
                open = true
                break
            end
        end
        return open
    end

    function MenuPool:CloseAllMenus()
        for _, Menu in pairs(self.Menus) do
            if Menu:Visible() then
                Menu:Visible(false)
                Menu.OnMenuClosed(Menu)
            end
        end
    end

    function MenuPool:SetBannerSprite(Sprite) if Sprite() == "Sprite" then for _, Menu in pairs(self.Menus) do Menu:SetBannerSprite(Sprite) end end end

    function MenuPool:SetBannerRectangle(Rectangle)
        if Rectangle() == "Rectangle" then for _, Menu in pairs(self.Menus) do Menu:SetBannerRectangle(Rectangle) end end
    end

    function MenuPool:TotalItemsPerPage(Value)
        if tonumber(Value) then for _, Menu in pairs(self.Menus) do Menu.Pagination.Total = Value - 1 end end
    end
end

NativeUI = {}
do
    function NativeUI.CreatePool() return MenuPool.New() end

    function NativeUI.CreateMenu(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
        return UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
    end

    function NativeUI.CreateItem(Text, Description) return UIMenuItem.New(Text, Description) end

    function NativeUI.CreateColouredItem(Text, Description, MainColour, HighlightColour)
        return UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
    end

    function NativeUI.CreateCheckboxItem(Text, Check, Description, CheckboxStyle)
        return UIMenuCheckboxItem.New(Text, Check, Description, CheckboxStyle)
    end

    function NativeUI.CreateListItem(Text, Items, Index, Description) return UIMenuListItem.New(Text, Items, Index, Description) end

    function NativeUI.CreateSliderItem(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
        return UIMenuSliderItem.New(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
    end

    function NativeUI.CreateSliderHeritageItem(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
        return UIMenuSliderHeritageItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    end

    function NativeUI.CreateSliderProgressItem(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
        return UIMenuSliderProgressItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    end

    function NativeUI.CreateProgressItem(Text, Items, Index, Description, Counter)
        return UIMenuProgressItem.New(Text, Items, Index, Description, Counter)
    end

    function NativeUI.CreateHeritageWindow(Mum, Dad) return UIMenuHeritageWindow.New(Mum, Dad) end

    function NativeUI.CreateGridPanel(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
        return UIMenuGridPanel.New(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
    end

    function NativeUI.CreateHorizontalGridPanel(LeftText, RightText, CirclePositionX)
        return UIMenuHorizontalOneLineGridPanel.New(LeftText, RightText, CirclePositionX)
    end

    function NativeUI.CreateVerticalGridPanel(TopText, BottomText, CirclePositionY)
        return UIMenuVerticalOneLineGridPanel.New(TopText, BottomText, CirclePositionY)
    end

    function NativeUI.CreateColourPanel(Title, Colours) return UIMenuColourPanel.New(Title, Colours) end

    function NativeUI.CreatePercentagePanel(MinText, MaxText) return UIMenuPercentagePanel.New(MinText, MaxText) end

    function NativeUI.CreateStatisticsPanel() return UIMenuStatisticsPanel.New() end

    function NativeUI.CreateSprite(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
        return Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
    end

    function NativeUI.CreateRectangle(X, Y, Width, Height, R, G, B, A) return UIResRectangle.New(X, Y, Width, Height, R, G, B, A) end

    function NativeUI.CreateText(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
        return UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
    end

    function NativeUI.CreateTimerBarProgress(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
        return UITimerBarProgressItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    end

    function NativeUI.CreateTimerBar(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
        return UITimerBarItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    end

    function NativeUI.CreateTimerBarProgressWithIcon(TxtDictionary, TxtName, IconDictionary, IconName, X, Y, Heading, R, G, B, A)
        return UITimerBarProgressWithIconItem.New(TxtDictionary, TxtName, IconDictionary, IconName, X, Y, Heading, R, G, B, A)
    end

    function NativeUI.TimerBarPool() return UITimerBarPool.New() end

    function NativeUI.ProgressBarPool() return UIProgressBarPool.New() end

    function NativeUI.CreateProgressBarItem(Text, X, Y, Heading, R, G, B, A) return UIProgressBarItem.New(Text, X, Y, Heading, R, G, B, A) end
end

--==================================================================================================================================================--
--[[ HoaX Menu Variables ]]
--==================================================================================================================================================--
FivemMenuxd = {}
FivemMenuxdPool = {}

local ShowMenu = true

local X, Y = ReverseFormatXWYH(0.00, 0.05)

FivemMenuxd = NativeUI.CreateMenu("MIXAS", "AntiCheat Menu", X, Y)

FivemMenuxdPool = NativeUI.CreatePool()
FivemMenuxdPool:Add(FivemMenuxd)

local _currentScenario = ""

local ShowCrosshair = false
local ShowRadar = true
local ShowExtendedRadar = false

local HasWaypoint = false
local HasCarTag = false
local carTagId = nil

local DriveToWpTaskActive = false;
local DriveWanderTaskActive = false;

local ShowEsp = false
local ShowHeadSprites = false
local ShowWantedLevel = false
local ShowEspInfo = false
local ShowEspOutline = false
local ShowEspLines = false

--================================================================================================================================================--
--[[ FiveMHahaha Functions ]]
--==================================================================================================================================================--
FiveMHahaha = {}
do
    FiveMHahaha.Notify = function(text, type)
        if type == nil then type = NotificationType.None end
        SetNotificationTextEntry("STRING")
        if type == NotificationType.Info then
            AddTextComponentString("~b~~h~Info~h~~s~: " .. text)
        elseif type == NotificationType.Error then
            AddTextComponentString("~r~~h~Error~h~~s~: " .. text)
        elseif type == NotificationType.Alert then
            AddTextComponentString("~y~~h~Alert~h~~s~: " .. text)
        elseif type == NotificationType.Success then
            AddTextComponentString("~g~~h~Success~h~~s~: " .. text)
        else
            AddTextComponentString(text)
        end
        DrawNotification(false, false)
    end

    FiveMHahaha.Subtitle = function(message, duration, drawImmediately)
        if duration == nil then duration = 2500 end;
        if drawImmediately == nil then drawImmediately = true; end;
        ClearPrints()
        SetTextEntry_2("STRING");
        for i = 1, message:len(), 99 do
            AddTextComponentString(string.sub(message, i, i + 99))
        end
        DrawSubtitleTimed(duration, drawImmediately);
    end

    FiveMHahaha.GetKeyboardInput = function(TextEntry, ExampleText, MaxStringLength)
        AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
        local blockinput = true
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end

        if UpdateOnscreenKeyboard() ~= 2 then
            local result = GetOnscreenKeyboardResult()
            Citizen.Wait(500)
            blockinput = false
            return result
        else
            Citizen.Wait(500)
            blockinput = false
            return nil
        end
    end

    FiveMHahaha.GetVehicleProperties = function(vehicle)
        local color1, color2 = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local extras = {}

        for id = 0, 12 do
            if DoesExtraExist(vehicle, id) then
                local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
                extras[tostring(id)] = state
            end
        end

        return {
            model = GetEntityModel(vehicle),

            plate = math.trim(GetVehicleNumberPlateText(vehicle)),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

            health = GetEntityMaxHealth(vehicle),
            dirtLevel = GetVehicleDirtLevel(vehicle),

            color1 = color1,
            color2 = color2,

            pearlescentColor = pearlescentColor,
            wheelColor = wheelColor,

            wheels = GetVehicleWheelType(vehicle),
            windowTint = GetVehicleWindowTint(vehicle),

            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1), IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },

            extras = extras,

            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),

            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),

            modTurbo = IsToggleModOn(vehicle, 18),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modXenon = IsToggleModOn(vehicle, 22),

            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),

            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modLivery = GetVehicleLivery(vehicle)
        }
    end

    FiveMHahaha.SetVehicleProperties = function(vehicle, props)
        SetVehicleModKit(vehicle, 0)

        if props.plate ~= nil then SetVehicleNumberPlateText(vehicle, props.plate) end

        if props.plateIndex ~= nil then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end

        if props.health ~= nil then SetEntityHealth(vehicle, props.health) end

        if props.dirtLevel ~= nil then SetVehicleDirtLevel(vehicle, props.dirtLevel) end

        if props.color1 ~= nil then
            local color1, color2 = GetVehicleColours(vehicle)
            SetVehicleColours(vehicle, props.color1, color2)
        end

        if props.color2 ~= nil then
            local color1, color2 = GetVehicleColours(vehicle)
            SetVehicleColours(vehicle, color1, props.color2)
        end

        if props.pearlescentColor ~= nil then
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
        end

        if props.wheelColor ~= nil then
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
        end

        if props.wheels ~= nil then SetVehicleWheelType(vehicle, props.wheels) end

        if props.windowTint ~= nil then SetVehicleWindowTint(vehicle, props.windowTint) end

        if props.neonEnabled ~= nil then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end

        if props.extras ~= nil then
            for id, enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end

        if props.neonColor ~= nil then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end

        if props.modSmokeEnabled ~= nil then ToggleVehicleMod(vehicle, 20, true) end

        if props.tyreSmokeColor ~= nil then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end

        if props.modSpoilers ~= nil then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end

        if props.modFrontBumper ~= nil then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end

        if props.modRearBumper ~= nil then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end

        if props.modSideSkirt ~= nil then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end

        if props.modExhaust ~= nil then SetVehicleMod(vehicle, 4, props.modExhaust, false) end

        if props.modFrame ~= nil then SetVehicleMod(vehicle, 5, props.modFrame, false) end

        if props.modGrille ~= nil then SetVehicleMod(vehicle, 6, props.modGrille, false) end

        if props.modHood ~= nil then SetVehicleMod(vehicle, 7, props.modHood, false) end

        if props.modFender ~= nil then SetVehicleMod(vehicle, 8, props.modFender, false) end

        if props.modRightFender ~= nil then SetVehicleMod(vehicle, 9, props.modRightFender, false) end

        if props.modRoof ~= nil then SetVehicleMod(vehicle, 10, props.modRoof, false) end

        if props.modEngine ~= nil then SetVehicleMod(vehicle, 11, props.modEngine, false) end

        if props.modBrakes ~= nil then SetVehicleMod(vehicle, 12, props.modBrakes, false) end

        if props.modTransmission ~= nil then SetVehicleMod(vehicle, 13, props.modTransmission, false) end

        if props.modHorns ~= nil then SetVehicleMod(vehicle, 14, props.modHorns, false) end

        if props.modSuspension ~= nil then SetVehicleMod(vehicle, 15, props.modSuspension, false) end

        if props.modArmor ~= nil then SetVehicleMod(vehicle, 16, props.modArmor, false) end

        if props.modTurbo ~= nil then ToggleVehicleMod(vehicle, 18, props.modTurbo) end

        if props.modXenon ~= nil then ToggleVehicleMod(vehicle, 22, props.modXenon) end

        if props.modFrontWheels ~= nil then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end

        if props.modBackWheels ~= nil then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end

        if props.modPlateHolder ~= nil then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end

        if props.modVanityPlate ~= nil then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end

        if props.modTrimA ~= nil then SetVehicleMod(vehicle, 27, props.modTrimA, false) end

        if props.modOrnaments ~= nil then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end

        if props.modDashboard ~= nil then SetVehicleMod(vehicle, 29, props.modDashboard, false) end

        if props.modDial ~= nil then SetVehicleMod(vehicle, 30, props.modDial, false) end

        if props.modDoorSpeaker ~= nil then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end

        if props.modSeats ~= nil then SetVehicleMod(vehicle, 32, props.modSeats, false) end

        if props.modSteeringWheel ~= nil then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end

        if props.modShifterLeavers ~= nil then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end

        if props.modAPlate ~= nil then SetVehicleMod(vehicle, 35, props.modAPlate, false) end

        if props.modSpeakers ~= nil then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end

        if props.modTrunk ~= nil then SetVehicleMod(vehicle, 37, props.modTrunk, false) end

        if props.modHydrolic ~= nil then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end

        if props.modEngineBlock ~= nil then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end

        if props.modAirFilter ~= nil then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end

        if props.modStruts ~= nil then SetVehicleMod(vehicle, 41, props.modStruts, false) end

        if props.modArchCover ~= nil then SetVehicleMod(vehicle, 42, props.modArchCover, false) end

        if props.modAerials ~= nil then SetVehicleMod(vehicle, 43, props.modAerials, false) end

        if props.modTrimB ~= nil then SetVehicleMod(vehicle, 44, props.modTrimB, false) end

        if props.modTank ~= nil then SetVehicleMod(vehicle, 45, props.modTank, false) end

        if props.modWindows ~= nil then SetVehicleMod(vehicle, 46, props.modWindows, false) end

        if props.modLivery ~= nil then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
    end

    FiveMHahaha.DeleteVehicle = function(vehicle)
        SetEntityAsMissionEntity(Object, 1, 1)
        DeleteEntity(Object)
        SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
        DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    end

    FiveMHahaha.DirtyVehicle = function(vehicle) SetVehicleDirtLevel(vehicle, 15.0) end

    FiveMHahaha.CleanVehicle = function(vehicle) SetVehicleDirtLevel(vehicle, 1.0) end

    FiveMHahaha.GetPlayers = function()
        local players    = {}
        for i=0, 255, 1 do
            local ped = GetPlayerPed(i)
            if DoesEntityExist(ped) then
                table.insert(players, i)
            end
        end
        return players
    end

    FiveMHahaha.GetClosestPlayer = function(coords)
        local players         = FiveMHahaha.GetPlayers()
        local closestDistance = -1
        local closestPlayer   = -1
        local usePlayerPed    = false
        local playerPed       = PlayerPedId()
        local playerId        = PlayerId()

        if coords == nil then
            usePlayerPed = true
            coords       = GetEntityCoords(playerPed)
        end

        for i=1, #players, 1 do
            local target = GetPlayerPed(players[i])

            if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
                local targetCoords = GetEntityCoords(target)
                local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

                if closestDistance == -1 or closestDistance > distance then
                    closestPlayer   = players[i]
                    closestDistance = distance
                end
            end
        end

        return closestPlayer, closestDistance
    end

    FiveMHahaha.GetWaypoint = function()
        local g_Waypoint = nil;
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
            local blipIterator = GetBlipInfoIdIterator(8)
            local blip = GetFirstBlipInfoId(8, blipIterator)
            g_Waypoint = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector());
        end
        print(g_Waypoint);
        return g_Waypoint;
    end

    FiveMHahaha.GetSafePlayerName = function(name)
        if string.IsNullOrEmpty(name) then return "" end;
        return name:gsub("%^", "\\^"):gsub("%~", "\\~"):gsub("%<", "«"):gsub("%>", "»");
    end

    FiveMHahaha.SetResourceLocked = function(resource, item)
        Citizen.CreateThread(function()
            if item ~= nil then local item_type, item_subtype = item(); end

            if GetResourceState(resource) == "started" then
                if item ~= nil then item:Enabled(true); end;
                if item_subtype == "UIMenuItem" then item:SetRightBadge(BadgeStyle.None); end;
            else
                if item ~= nil then item:Enabled(false); end;
                if item_subtype == "UIMenuItem" then item:SetRightBadge(BadgeStyle.Lock); end;
            end
        end)
    end

    FiveMHahaha.TriggerCustomEvent = function(server, event, ...)
        local payload = msgpack.pack({...})
        if server then
            TriggerServerEventInternal(event, payload, payload:len())
        else
            TriggerEventInternal(event, payload, payload:len())
        end
    end
end

--==================================================================================================================================================--
--[[ World Functions ]]
--==================================================================================================================================================--
NotificationType = {
    None = 0,
    Info = 1,
    Error = 2,
    Alert = 3,
    Success = 4
}
do
    function DrawText3D(x, y, z, text, r, g, b)
        SetDrawOrigin(x, y, z, 0)
        SetTextFont(0)
        SetTextProportional(0)
        SetTextScale(0.0, 0.20)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end

    function ShootPlayer(playerIdx)
        local head = GetPedBoneCoords(playerIdx, GetEntityBoneIndexByName(playerIdx, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        SetPedShootsAtCoord(GetPlayerPed(-1), head.x, head.y, head.z, true)
    end

    function SpectatePlayer(playerIdx)
        Spectating = not Spectating

        local playerPed = GetPlayerPed(-1)
        local targetPed = GetPlayerPed(playerIdx)

        if (Spectating) then
            local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))
            RequestCollisionAtCoord(targetx, targety, targetz)
            NetworkSetInSpectatorMode(true, targetPed)
            FiveMHahaha.Subtitle("Spectating " .. GetPlayerName(playerIdx))
        else
            local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))
            RequestCollisionAtCoord(targetx, targety, targetz)
            NetworkSetInSpectatorMode(false, targetPed)
            FiveMHahaha.Subtitle("Stopped Spectating " .. GetPlayerName(playerIdx))
        end
    end

end




--==================================================================================================================================================--
--[[ Vehicle Functions ]]
--==================================================================================================================================================--
VehicleMaxSpeeds = { 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220 }

do
    function ParkVehicle(vehicle)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed, false)
        local x, y, z = table.unpack(playerCoords)
        local node, outPos = GetNthClosestVehicleNode(x, y, z, 20, 0, 0, 0)
        local sx, sy, sz = table.unpack(outPos)
        if node then
            FiveMHahaha.Notify(NotificationType.Info,
                                "The player ped will find a suitable place to park the car and will then stop driving. Please wait.")
            ClearPedTasks(playerPed)
            TaskVehiclePark(playerPed, vehicle, sx, sy, sz, 0, 5, 20, false)
            SetVehicleHalt(vehicle, 5, 0, false)
            ClearPedTasks(playerPed)
            FiveMHahaha.Notify(NotificationType.Info, "The player ped has stopped driving and parked the vehicle.")
        end
    end

    function DriveToWaypoint(style)
        if style == nil then style = 0 end
        local WaypointCoords = nil

        if DoesBlipExist(GetFirstBlipInfoId(8)) then
            local blipIterator = GetBlipInfoIdIterator(8)
            local blip = GetFirstBlipInfoId(8, blipIterator)
            WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
        else
            FiveMHahaha.Notify("~r~No waypoint!", NotificationType.Error)
        end
        if WaypointCoords ~= nil then
            ClearPedTasks(GetPlayerPed(-1))
            DriveWanderTaskActive = false
            DriveToWpTaskActive = true

            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local vehicleEntity = GetEntityModel(vehicle)

            SetDriverAbility(GetPlayerPed(-1), 1)
            SetDriverAggressiveness(GetPlayerPed(-1), 0)

            if GetVehicleModelMaxSpeed ~= nil then
                TaskVehicleDriveToCoordLongrange(GetPlayerPed(-1), vehicle, WaypointCoords, GetVehicleModelMaxSpeed(vehicleEntity), style, 10)
            else
                TaskVehicleDriveToCoordLongrange(GetPlayerPed(-1), vehicle, WaypointCoords, Citizen.InvokeNative(0xF417C2502FFFED43, vehicleEntity), style, 10)
            end
            Citizen.CreateThread(function()
                while DriveToWpTaskActive and GetDistanceBetweenCoords(WaypointCoords, GetEntityCoords(vehicle), false) > 15 do
                    if GetDistanceBetweenCoords(WaypointCoords, GetEntityCoords(vehicle) , false) < 15 then
                        ParkVehicle(vehicle)
                    end
                    Wait(0)
                end
            end)
        else
            FiveMHahaha.Notify("~r~Waypoint missing!", NotificationType.Error)
        end
    end

    function DriveWander(style)
        if style == nil then style = 0 end

        ClearPedTasks(GetPlayerPed(-1))
        DriveWanderTaskActive = true
        DriveToWpTaskActive = false

        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
        local vehicleEntity = GetEntityModel(vehicle)

        SetDriverAbility(GetPlayerPed(-1), 1)
        SetDriverAggressiveness(GetPlayerPed(-1), 0)
        SetEntityMaxSpeed(vehicle, 16.5)

        if GetVehicleModelMaxSpeed ~= nil then
            TaskVehicleDriveWander(GetPlayerPed(-1), vehicle, GetVehicleModelMaxSpeed(vehicleEntity), style)
        else
            TaskVehicleDriveWander(GetPlayerPed(-1), vehicle, Citizen.InvokeNative(0xF417C2502FFFED43, vehicleEntity), style)
        end
    end

    function SpawnVehicleToPlayer(modelName, playerIdx)
        if modelName and IsModelValid(modelName) and IsModelAVehicle(modelName) then
            RequestModel(modelName)
            while not HasModelLoaded(modelName) do Citizen.Wait(0) end
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            local playerPed = GetPlayerPed(playerIdx)
            local SpawnedVehicle = CreateVehicle(model, GetEntityCoords(playerPed), GetEntityHeading(playerPed), true, true)
            local SpawnedVehicleIdx = NetworkGetNetworkIdFromEntity(SpawnedVehicle)
            SetNetworkIdCanMigrate(SpawnedVehicleIdx, true)
            SetEntityAsMissionEntity(SpawnedVehicle, true, false)
            SetVehicleHasBeenOwnedByPlayer(SpawnedVehicle, true)
            SetVehicleNeedsToBeHotwired(SpawnedVehicle, false)
            SetModelAsNoLongerNeeded(model)

            SetPedIntoVehicle(playerPed, SpawnedVehicle, -1)
            SetVehicleEngineOn(SpawnedVehicle, true, false, false)
            SetVehRadioStation(SpawnedVehicle, 'OFF')
            return SpawnedVehicle
        else
            FiveMHahaha.Notify("Invalid Vehicle Model!", NotificationType.Error)
            return nil
        end
    end

    function SpawnLegalVehicle(vehicalModelName, playerIdx, plateNumber)
        local SpawnedVehicle = SpawnVehicleToPlayer(vehicalModelName, playerIdx)
        if SpawnedVehicle ~= nil then
            if string.IsNullOrEmpty(plateNumber) then SetVehicleNumberPlateText(SpawnedVehicle, GetVehicleNumberPlateText(SpawnedVehicle))
            else SetVehicleNumberPlateText(SpawnedVehicle, plateNumber) end
            FiveMHahaha.Notify("Spawned Vehicle", NotificationType.Success)
            local SpawnedVehicleProperties = FiveMHahaha.GetVehicleProperties(SpawnedVehicle)
            local SpawnedVehicleModel = GetDisplayNameFromVehicleModel(SpawnedVehicleProperties.model)
            if SpawnedVehicleProperties then
                FiveMHahaha.TriggerCustomEvent(true, 'esx_vehicleshop:setVehicleOwnedPlayerId', GetPlayerServerId(playerIdx), SpawnedVehicleProperties, SpawnedVehicleModel, vehicalModelName, false)
                FiveMHahaha.Notify("~g~~h~You own this spawned vehicle!")
            end
        end
    end

    function MaxTuneVehicle(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleProps = FiveMHahaha.GetVehicleProperties(SpawnedVehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleWheelType(vehicle, 7)
        for index = 0, 38 do
            if index > 16 and index < 23 then
                ToggleVehicleMod(vehicle, index, true)
            elseif index == 14 then
                SetVehicleMod(vehicle, 14, 16, false)
            elseif index == 23 or index == 24 then
                SetVehicleMod(vehicle, index, 1, false)
            else
                SetVehicleMod(vehicle, index, GetNumVehicleMods(vehicle, index) - 1, false)
            end
        end
        SetVehicleWindowTint(vehicle, 1)
        SetVehicleTyresCanBurst(vehicle, false)
        SetVehicleNumberPlateTextIndex(vehicle, 5)
    end
end

--==================================================================================================================================================--
--[[ HoaX Menu Functions ]]
--==================================================================================================================================================--
do
    local color = {}
    Citizen.CreateThread(function()
        while ShowMenu do
            Citizen.Wait(0)
            --BURASINI DUZENLE
            FivemMenuxd.Logo:Colour(118, 238, 0, 255)
        end
    end)


    --[[ World Settings ]]
    Citizen.CreateThread(function()
        while ShowMenu do
            --[[ Display Minimap ]]
            DisplayRadar(ShowMenu and ShowRadar)
            
            --[[ Display Extended Minimap ]]
            if SetBigmapActive ~= nil then SetBigmapActive(ShowMenu and ShowExtendedRadar, false)
            else SetRadarBigmapEnabled(ShowMenu and ShowExtendedRadar, false) end

            --[[ Extend minimap on keypress ]]
            if IsDisabledControlJustPressed(0, 19) and IsDisabledControlPressed(0, 21) then
                ShowExtendedRadar = not ShowExtendedRadar
            end

            if Enable_SuperJump then SetSuperJumpThisFrame(PlayerId()) end

            if Enable_InfiniteStamina then RestorePlayerStamina(PlayerId(), 1.0) end

            if ShowCrosshair then ShowHudComponentThisFrame(14) end

            if Enable_VehicleGodMode and IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                SetEntityInvincible(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
            end

            if vehicleFastSpeed_isEnabled and IsPedInAnyVehicle(PlayerPedId(-1), true) then
                if IsControlPressed(0, 209) then
                    SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId(-1)), 100.0)
                elseif IsControlPressed(0, 210) then
                    SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId(-1)), 0.0)
                end
            end
            if nameabove then
                local ignorePlayerNameDistance = false
                local playerNamesDist = 130
                for id = 0, 128 do
                    if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
                        local ped = GetPlayerPed(id)
                        local blip = GetBlipFromEntity(ped)

                        local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                        local targetX, targetY, targetZ = table.unpack(GetEntityCoords(GetPlayerPed(id), true))

                        local distance = math.floor(GetDistanceBetweenCoords(playerX, playerY, playerZ, targetX, targetY, targetZ, true))

                        local playerServerIdx = GetPlayerServerId(id)
                        local playerName = FiveMHahaha.GetSafePlayerName(GetPlayerName(id))

                        if ignorePlayerNameDistance then
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(targetX, targetY, targetZ + 1.2, playerServerIdx .. "  |  " .. playerName, color.r, color.g, color.b)
                            else
                                DrawText3D(targetX, targetY, targetZ + 1.2, playerServerIdx .. "  |  " .. playerName, 255, 255, 255)
                            end
                        end
                        if distance < playerNamesDist then
                            if not ignorePlayerNameDistance then
                                if NetworkIsPlayerTalking(id) then
                                    DrawText3D(targetX, targetY, targetZ + 1.2, playerServerIdx .. "  |  " .. playerName, color.r, color.g, color.b)
                                else
                                    DrawText3D(targetX, targetY, targetZ + 1.2, playerServerIdx .. "  |  " .. playerName, 255, 255, 255)
                                end
                            end
                        end
                    end
                end
            end

            if ShowEsp then
                for i = 0, 128 do
                    if i ~= PlayerId() and GetPlayerServerId(i) ~= 0 then
                        local pPed = GetPlayerPed(i)
                        local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId()))
                        local x, y, z = table.unpack(GetEntityCoords(pPed))
                        local message = "Name: " .. FiveMHahaha.GetSafePlayerName(GetPlayerName(i)) .. "\nServer ID: " .. GetPlayerServerId(i) .."\n Healt : "..GetEntityHealth(pPed).."\n Armour : "..GetPedArmour(pPed).."\nPlayer ID: " .. i ..
                                            "\nDist: " .. math.round(GetDistanceBetweenCoords(cx, cy, cz, x, y, z, true), 1)
                        if IsPedInAnyVehicle(pPed) then
                            local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(pPed))))
                            message = message .. "\nVeh: " .. VehName
                        end
                        if ShowEspInfo and ShowEsp then DrawText3D(x, y, z + 1.0, message, 255, 255, 112) end
                        if ShowEspOutline and ShowEsp then
                            local PedCoords = GetOffsetFromEntityInWorldCoords(pPed)
                            LineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
                            LineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
                            LineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
                            LineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                            LineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                            LineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
                            LineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)

                            TLineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
                            TLineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                            TLineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                            TLineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                            TLineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                            TLineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
                            TLineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)

                            ConnectorOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
                            ConnectorOneEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
                            ConnectorTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                            ConnectorTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                            ConnectorThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
                            ConnectorThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
                            ConnectorFourBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                            ConnectorFourEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
                            DrawLine(LineOneBegin.x, LineOneBegin.y, LineOneBegin.z, LineOneEnd.x, LineOneEnd.y, LineOneEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(LineTwoBegin.x, LineTwoBegin.y, LineTwoBegin.z, LineTwoEnd.x, LineTwoEnd.y, LineTwoEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(LineThreeBegin.x, LineThreeBegin.y, LineThreeBegin.z, LineThreeEnd.x, LineThreeEnd.y, LineThreeEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(LineThreeEnd.x, LineThreeEnd.y, LineThreeEnd.z, LineFourBegin.x, LineFourBegin.y, LineFourBegin.z, color.r, color.g, color.b, 255)
                            DrawLine(TLineOneBegin.x, TLineOneBegin.y, TLineOneBegin.z, TLineOneEnd.x, TLineOneEnd.y, TLineOneEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(TLineTwoBegin.x, TLineTwoBegin.y, TLineTwoBegin.z, TLineTwoEnd.x, TLineTwoEnd.y, TLineTwoEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(TLineThreeBegin.x, TLineThreeBegin.y, TLineThreeBegin.z, TLineThreeEnd.x, TLineThreeEnd.y, TLineThreeEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(TLineThreeEnd.x, TLineThreeEnd.y, TLineThreeEnd.z, TLineFourBegin.x, TLineFourBegin.y, TLineFourBegin.z, color.r, color.g, color.b, 255)
                            DrawLine(ConnectorOneBegin.x, ConnectorOneBegin.y, ConnectorOneBegin.z, ConnectorOneEnd.x, ConnectorOneEnd.y, ConnectorOneEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(ConnectorTwoBegin.x, ConnectorTwoBegin.y, ConnectorTwoBegin.z, ConnectorTwoEnd.x, ConnectorTwoEnd.y, ConnectorTwoEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(ConnectorThreeBegin.x, ConnectorThreeBegin.y, ConnectorThreeBegin.z, ConnectorThreeEnd.x, ConnectorThreeEnd.y, ConnectorThreeEnd.z, color.r, color.g, color.b, 255)
                            DrawLine(ConnectorFourBegin.x, ConnectorFourBegin.y, ConnectorFourBegin.z, ConnectorFourEnd.x, ConnectorFourEnd.y, ConnectorFourEnd.z, color.r, color.g, color.b, 255)
                        end
                        if ShowEspLines and ShowEsp then DrawLine(cx, cy, cz, x, y, z, 255, 255, 112, 255) end
                    end
                end
            end



            Wait(0)
        end
    end)

    local function CustomRightBadge(item, badge, width, height, offsetX, offsetY)
        item:SetRightBadge(badge)
        item.RightBadge.Sprite.Width = width
        item.RightBadge.Sprite.Height = height
        item:RightBadgeOffset(offsetX, offsetY)
    end

    local function AddPlayerOptionsMenu(menu)
        local PlayerOptionsMenu = (FivemMenuxdPool:AddSubMenu(menu, "Player Options"))
        PlayerOptionsMenu.Item:RightLabel("→→")
        PlayerOptionsMenu = PlayerOptionsMenu.SubMenu


        local stopScenario = NativeUI.CreateItem("Clear Ped Task", "This will force a playing scenario to stop immediately, without waiting for it to finish it's 'stopping' animation.")
        PlayerOptionsMenu:AddItem(stopScenario)
        stopScenario.Activated = function(ParentMenu, SelectedItem) ClearPedTasksImmediately(PlayerPedId()) end

        local setHunger = NativeUI.CreateItem("~y~ESX: ~g~Hunger ( 100% )", "Set hunger level to 100%")
        setHunger.Activated = function(ParentMenu, SelectedItem) FiveMHahaha.TriggerCustomEvent(false, 'esx_status:set', "hunger", 1000000) end
        PlayerOptionsMenu:AddItem(setHunger)
        FiveMHahaha.SetResourceLocked('esx_status', setHunger)

        local setThirst = NativeUI.CreateItem("~y~ESX: ~g~Thirst ( 100% )", "Set thirst level to 100%")
        setThirst.Activated = function(ParentMenu, SelectedItem) FiveMHahaha.TriggerCustomEvent(false, 'esx_status:set', "thirst", 1000000) end
        PlayerOptionsMenu:AddItem(setThirst)
        FiveMHahaha.SetResourceLocked('esx_status', setThirst)

        local heal = NativeUI.CreateItem("Native: ~g~Heal ", " 100% health")
        heal.Activated = function(ParentMenu, SelectedItem) SetEntityHealth(PlayerPedId(), 200) end
        PlayerOptionsMenu:AddItem(heal)

        local armour = NativeUI.CreateItem("Native: ~b~Give Armour", "Give yourself to 100% armour")
        armour.Activated = function(ParentMenu, SelectedItem) CreatePickup(GetHashKey("PICKUP_ARMOUR_STANDARD"), GetEntityCoords(GetPlayerPed(-1))) end
        PlayerOptionsMenu:AddItem(armour)

        local suicide = NativeUI.CreateItem("~r~Commit Suicide", "Kill yourself by taking the pill. Or by using a pistol if you have one.")
        suicide.Activated = function(ParentMenu, SelectedItem) SetEntityHealth(PlayerPedId(), 0) end
        PlayerOptionsMenu:AddItem(suicide)
    end


    local function AddVehicleAutoPilot(menu)
        local vehicleAutoPilotMenu = (FivemMenuxdPool:AddSubMenu(menu, "Vehicle Auto Pilot", "Manage vehicle auto pilot options."))
        vehicleAutoPilotMenu.Item:RightLabel("→→")
        vehicleAutoPilotMenu = vehicleAutoPilotMenu.SubMenu

        local StyleFromIndex = {
            [1] = 431,
            [2] = 1074528293,
            [3] = 536871355,
            [4] = 1467,
        }

        local drivingStyles = { "Normal", "Rushed", "Avoid highways", "Drive in reverse" }
        local drivingStyle = NativeUI.CreateListItem("Driving Style", drivingStyles, 1, "Set the driving style that is used for the Drive to Waypoint and Drive Around Randomly functions.")
        drivingStyle.OnListSelected = function(menu, item, index)
            SetDriveTaskDrivingStyle(PlayerPedId(), StyleFromIndex[index]) end
        vehicleAutoPilotMenu:AddItem(drivingStyle)

        local startDrivingWaypoint = NativeUI.CreateItem("Drive To Waypoint", "Make your player ped drive your vehicle to your waypoint.")
        vehicleAutoPilotMenu:AddItem(startDrivingWaypoint)

        local startDrivingRandomly = NativeUI.CreateItem("Drive Around Randomly", "Make your player ped drive your vehicle randomly around the map.");
        vehicleAutoPilotMenu:AddItem(startDrivingRandomly)

        local stopDriving = NativeUI.CreateItem("Park Vehicle", "The player ped will find a suitable place to stop the vehicle. The task will be stopped once the vehicle has reached the suitable stop location.");
        vehicleAutoPilotMenu:AddItem(stopDriving)

        local forceStopDriving = NativeUI.CreateItem("Stop Driving", "This will stop the driving task immediately without finding a suitable place to stop.");
        vehicleAutoPilotMenu:AddItem(forceStopDriving)


        vehicleAutoPilotMenu.OnItemSelect = function(sender, item, index)
            local playerPed = GetPlayerPed(-1)
            local style = StyleFromIndex[drivingStyle:Index()]
            if (IsPedInAnyVehicle(playerPed, false) and item ~= stopDriving and item ~= forceStopDriving) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if (vehicle ~=nil and DoesEntityExist(vehicle) and IsVehicleDriveable(vehicle, false)) then
                    if (GetPedInVehicleSeat(vehicle, -1)) then
                        if (item == startDrivingWaypoint) then
                            if (DoesBlipExist(GetFirstBlipInfoId(8))) then
                                DriveToWaypoint(style)
                                FiveMHahaha.Notify("Your player ped is now driving the vehicle for you. You can cancel any time by pressing the Stop Driving button. The vehicle will stop when it has reached the destination.", NotificationType.Info)
                            else
                                FiveMHahaha.Notify("You need a waypoint before you can drive to it!", NotificationType.Error)
                            end
                        elseif (item == startDrivingRandomly) then
                            DriveWander(style)
                            FiveMHahaha.Notify("Your player ped is now driving the vehicle for you. You can cancel any time by pressing the Stop Driving button.", NotificationType.Info)
                        end
                    else
                        FiveMHahaha.Notify("You must be the driver of this vehicle!", NotificationType.Error)
                    end
                else
                    FiveMHahaha.Notify("Your vehicle is broken or it does not exist!", NotificationType.Error)
                end
            elseif (item ~= stopDriving and item ~= forceStopDriving) then
                FiveMHahaha.Notify("You need to be in a vehicle first!", NotificationType.Error)
            end
            if item == stopDriving then
                if (IsPedInAnyVehicle(playerPed, false)) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if (vehicle ~=nil and DoesEntityExist(vehicle) and IsVehicleDriveable(vehicle, false)) then
                        ParkVehicle(vehicle)
                    end
                else
                    ClearPedTasks(playerPed)
                    FiveMHahaha.Notify("Your ped is not in any vehicle.", NotificationType.Alert);
                end
            elseif item == forceStopDriving then
                DriveWanderTaskActive = false
                DriveToWpTaskActive = false
                SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 500.01);
                ClearPedTasks(playerPed);
                FiveMHahaha.Notify("Driving task cancelled.", NotificationType.Info);
            end
        end
    end

    local function AddVehicleOptionsMenu(menu)
        local VehicleOptionsMenu = (FivemMenuxdPool:AddSubMenu(menu, "Vehicle Options"))
        VehicleOptionsMenu.Item:RightLabel("→→")
        VehicleOptionsMenu = VehicleOptionsMenu.SubMenu

        AddVehicleAutoPilot(VehicleOptionsMenu)

        local vehicleMaxSpeed =  NativeUI.CreateListItem("Set Vehicle Speed", VehicleMaxSpeeds, 11)
        vehicleMaxSpeed.OnListSelected = function(menu, item, index)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                if index == 1 then SetEntityMaxSpeed(vehicle, 500.0);
                else SetEntityMaxSpeed(vehicle, tonumber(vehicleMaxSpeed:IndexToItem(index))/3.6); end;
            else FiveMHahaha.Notify("You must be in a ~r~vehicle ~w~to use this !", NotificationType.Error); end; end
        VehicleOptionsMenu:AddItem(vehicleMaxSpeed)

        local spawnLegalVehicle = NativeUI.CreateItem("Spawn Legal Vehicle", "Spawn a custom legal vehicle.")
        spawnLegalVehicle.Activated = function(ParentMenu, SelectedItem)
            local ModelName = FiveMHahaha.GetKeyboardInput("Enter Vehicle Spawn Name", "", 10)
            local PlateNumber = FiveMHahaha.GetKeyboardInput("Enter Vehicle Plate Number", "", 8)
            SpawnLegalVehicle(ModelName, PlayerId(), PlateNumber) end
        VehicleOptionsMenu:AddItem(spawnLegalVehicle)
        FiveMHahaha.SetResourceLocked('esx_vehicleshop', refuelVehicle)

        local repairVehicle = NativeUI.CreateItem("~b~Repair Vehicle", "Repair any visual and physical damage present on your vehicle.")
        repairVehicle:RightLabel("🔧")
        repairVehicle.Activated = function(ParentMenu, SelectedItem)
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleLights(vehicle, 0)
            SetVehicleBurnout(vehicle, false)
            N_0x1fd09e7390a74d54(vehicle, 0) end
        VehicleOptionsMenu:AddItem(repairVehicle)

        local maxTuneVehicle = NativeUI.CreateItem("Max Tune", "Max tune your vehicle.")
        maxTuneVehicle.Activated = function(ParentMenu, SelectedItem)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then MaxTuneVehicle(GetPlayerPed(-1));
            else FiveMHahaha.Notify("You must be in a ~r~vehicle ~w~to use this !", NotificationType.Error); end; end;
        VehicleOptionsMenu:AddItem(maxTuneVehicle)

        local deleteVehicle = NativeUI.CreateItem("Delete Vehicle", "Delete your vehicle.")
        deleteVehicle.Activated = function(ParentMenu, SelectedItem) FiveMHahaha.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1))) end
        VehicleOptionsMenu:AddItem(deleteVehicle)

        local cleanVehicle = NativeUI.CreateItem("Clean Vehicle", "Make your vehicle clean.")
        cleanVehicle.Activated = function(ParentMenu, SelectedItem) FiveMHahaha.CleanVehicle(GetVehiclePedIsIn(GetPlayerPed(-1))) end
        VehicleOptionsMenu:AddItem(cleanVehicle)

        local changeVehiclePlate = NativeUI.CreateItem("Set License Plate Text", "Enter a custom license plate for your vehicle.")
        changeVehiclePlate.Activated = function(ParentMenu, SelectedItem)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                local result = FiveMHahaha.GetKeyboardInput("Enter the plate license you want", "", 8)
                if result then SetVehicleNumberPlateText(playerVeh, result) end
            else
                FiveMHahaha.Notify("You must be in a ~r~vehicle ~w~to use this !", NotificationType.Error)
            end end
        VehicleOptionsMenu:AddItem(changeVehiclePlate)

    end


    local function AddWorldOptionsMenu(menu)
        local WorldOptionsMenu = (FivemMenuxdPool:AddSubMenu(menu, "Admin Options"))
        WorldOptionsMenu.Item:RightLabel("→→")
        WorldOptionsMenu = WorldOptionsMenu.SubMenu

        local ESPOptionsMenu = (FivemMenuxdPool:AddSubMenu(WorldOptionsMenu, "Extra-Sensory Perception (ESP)"))
        local ServerOptions = (FivemMenuxdPool:AddSubMenu(WorldOptionsMenu, "Server Options"))

        ESPOptionsMenu.Item:RightLabel("→→")
        ESPOptionsMenu = ESPOptionsMenu.SubMenu
        --[[ ESPOptionsMenu ]] do
            local esp = NativeUI.CreateCheckboxItem("ESP", ShowEsp, "Master Switch.")
            esp.CheckboxEvent = function(menu, item, enabled) ShowEsp = enabled end
            ESPOptionsMenu:AddItem(esp)

            local espInfo = NativeUI.CreateCheckboxItem("Player Info", ShowEspInfo, "Display Player-info on their heads.")
            espInfo.CheckboxEvent = function(menu, item, enabled) ShowEspInfo = enabled end
            ESPOptionsMenu:AddItem(espInfo)

            local espOutline = NativeUI.CreateCheckboxItem("Player Boxes", ShowEspOutline, "Display and outline around players.")
            espOutline.CheckboxEvent = function(menu, item, enabled) ShowEspOutline = enabled end
            ESPOptionsMenu:AddItem(espOutline)

            local espLines = NativeUI.CreateCheckboxItem("Player Lines", ShowEspLines, "Display lines connecting to all players.")
            espLines.CheckboxEvent = function(menu, item, enabled) ShowEspLines = enabled end
            ESPOptionsMenu:AddItem(espLines)
            
            
        local crosshair = NativeUI.CreateCheckboxItem("Enable Crosshair", ShowCrosshair, "Enable crosshair for giving leathal damage.")
        crosshair.CheckboxEvent = function(menu, item, enabled) ShowCrosshair = enabled end
        ESPOptionsMenu:AddItem(crosshair)

        end


        --
        ServerOptions.Item:RightLabel("→→")
        ServerOptions = ServerOptions.SubMenu
        do
            local deleteallpeds = NativeUI.CreateItem("Delete All Peds", 'Delete all peds', "Delete All Peds")
            deleteallpeds.CheckboxEvent = function(menu, item, enabled) ShowEsp = enabled end
            ServerOptions:AddItem(deleteallpeds)
            deleteallpeds.Activated = function(ParentMenu, SelectedItem)
            ExecuteCommand(ClientConfig.PedWipeCommand)
            print(ClientConfig.PedWipeCommand)
            end

            local deleteallcars = NativeUI.CreateItem("Delete All Cars", 'Delete all cars', "Delete All Cars")
            deleteallcars.CheckboxEvent = function(menu, item, enabled) ShowEsp = enabled end
            ServerOptions:AddItem(deleteallcars)
            deleteallcars.Activated = function(ParentMenu, SelectedItem)
                ExecuteCommand(ClientConfig.CarWipeCommand)
                print(ClientConfig.CarWipeCommand)
            end

            local deleteallentitys = NativeUI.CreateItem("Delete All Objects", 'Delete all Objects', "Delete All Objects")
            deleteallentitys.CheckboxEvent = function(menu, item, enabled) ShowEsp = enabled end
            ServerOptions:AddItem(deleteallentitys)
            deleteallentitys.Activated = function(ParentMenu, SelectedItem)
                ExecuteCommand(ClientConfig.EntityWipeCommand)
                print(ClientConfig.EntityWipeCommand)
            end
        end

    end


    AddPlayerOptionsMenu(FivemMenuxd)
    AddVehicleOptionsMenu(FivemMenuxd)
    AddWorldOptionsMenu(FivemMenuxd)
end

FivemMenuxdPool:MouseControlsEnabled(false)
FivemMenuxdPool:MouseEdgeEnabled(false)
FivemMenuxdPool:ControlDisablingEnabled(false)

FivemMenuxdPool:RefreshIndex()

Citizen.CreateThread(function()
    while ShowMenu do
        FivemMenuxdPool:ProcessMenus()
        if IsDisabledControlJustPressed(0, 121) then
            FivemMenuxdPool:RefreshIndex()
            if FivemMenuxdPool:IsAnyMenuOpen() then
                FivemMenuxdPool:CloseAllMenus()
            else
                FivemMenuxd:Visible(true)
            end
        end
        Citizen.Wait(0)
    end
end)
end)