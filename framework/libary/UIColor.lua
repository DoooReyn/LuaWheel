local UIColor = {}

local Custom = {
    Auqa    = '00FFFF', --水绿色
    Black   = '000000', --黑色
    Blue    = '0000FF', --蓝色
    Fuchsia = 'FF00FF', --紫红色
    Gray    = '808080', --灰色
    Green   = '008000', --绿色
    Lime    = '00FF00', --浅绿色
    Maroon  = '800000', --褐色
    Navy    = '000080', --深蓝色
    Olive   = '808000', --橄榄色
    Purple  = '800080', --紫色
    Red     = 'FF0000', --红色
    Silver  = 'C0C0C0', --银色
    Teal    = '008080', --青色
    White   = 'FFFFFF', --白色
    Yellow  = 'FFFF00', --黄色
}

local function checkColorValue(v)
    v = type(v) == 'number' and v or 0
    v = math.max(v, 0)
    v = math.min(v, 255)
    return v
end

function UIColor.colorize(...)
    local t = {r = 0, g = 0, b = 0, a = 0}
    local r = {...}
    for i=1, math.min(#r, 4) do
        r[i] = checkColorValue(r[i])
    end
    t.r = r[1]
    t.g = r[2]
    t.b = r[3]
    t.a = r[4]
    return t
end

function UIColor.fromHex2RGB(hex)
    local r = string.sub(hex, 1, 2)
    local g = string.sub(hex, 3, 4)
    local b = string.sub(hex, 5, 6)
    return {r = r, g = g, b = b}
end

function UIColor.fromRGB2Hex(rgb)
    local format = string.format
    local r = format('%02x', rgb.r)
    local g = format('%02x', rgb.g)
    local b = format('%02x', rgb.b)
    return r .. g .. b
end

local function callable()
    local mt = {__call = function(_, k)
        local v = Custom[k]
        if v then
            return v
        end
        return nil
    end}
    setmetatable(UIColor, mt)

    return UIColor
end
callable()

return UIColor
