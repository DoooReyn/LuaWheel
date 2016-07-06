---------------------------------
-- Author: Reyn
-- Date: 2016-07-01
-- Comment: String
---------------------------------

function string.utf8chars(input)
    local len  = string.len(input)
    local left = len
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local crx  = 0
    local chars = {}
    local utf8chars = {}
    local ascichars = {}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        crx = crx + i
        local char = string.sub(input, crx-i+1, crx)
        chars[#chars+1] = char
        if i == 1 then
        	ascichars[#ascichars+1] = char
        else
        	utf8chars[#utf8chars+1] = char 
        end
    end

    return chars, utf8chars, ascichars
end

function string.toarray(input)
	local chars = string.utf8chars(input)
	return chars
end

function string.upperFirst (s)
  return (s:gsub ("(%w)([%w]*)", function (l, ls) return l:upper () .. ls:lower() end))
end