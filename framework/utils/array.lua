---------------------------------
-- Author: Reyn
-- Date: 2016-07-02
-- Comment: Array
---------------------------------

function Array(vtype)
    local new_array = {}
    local __array__ = {}
    local __methods__ = {}
    local __value_type__ = checkHashType(vtype)

    function __methods__:typeof()
        return string.format('Array<%s>', __value_type__)
    end
    function __methods__:insert(v, at)
        if not(type(v) == __value_type__ or __value_type__ == 'mixed') then
            return
        end
        local len = #__array__ + 1
        at = isNumber(at) and at or len
        at = math.min(at, len)
        table.insert(__array__, at, v)
    end
    function __methods__:insertAt(v, at)
        if not isNumber(at) then return end
        self:insert(v, at)
    end
    function __methods__:removeAt(at)
        at = isNumber(at) and at or #__array__
        table.remove(__array__, at)
    end
    function __methods__:pop()
        self:removeAt(__array__)
    end
    function __methods__:push(v)
        self:insert(v)
    end
    function __methods__:front()
        return __array__[1]
    end
    function __methods__:tail()
        return __array__[#__array__]
    end
    function __methods__:print()
        table.print(__array__)
    end
    function __methods__:shift()
        return self:removeAt(1)
    end
    function __methods__:unshift(v)
        return self:insert(v, 1)
    end
    function __methods__:append(...)
        local elements = {...}
        for i= 1, #elements do
            self:insert(elements[i])
        end
    end
    function __methods__:appendAt(at, ...)
        table.appendAt(__array__, {...}, at)
    end
    function __methods__:kick(cnt)
        if isNumber(cnt) and cnt >= 1 then
            table.multiRemove(__array__, cnt)
        end
    end
    function __methods__:slice(from, to)
        return table.slice(__array__, from, to)
    end
    function __methods__:splice(from, cnt)
        return table.splice(__array__, from, cnt)
    end
    function __methods__:reverse()
        table.reverse(__array__)
        return self
    end
    function __methods__:exist(val)
        if not (vtype == 'mixed' or vtype == type(val)) then
            return false
        end
        for i,v in ipairs(__array__) do
            if v == val then
                return true, i
            end
        end
        return false
    end

    local mt = {
        __index = function(t, k)
            if isNumber(k) then
                return __array__[k]
            end
            if __methods__[k] then
                return __methods__[k]
            end
        end,
        __newindex = function(t, k, v)
            if nil == __array__[k] then
                print(string.format('warning : [%s] index out of range.', tostring(k)))
                return
            end
            if nil == v then
                print(string.format('warning : can not set element to `nil` directly.'))
                return
            end
            if not(type(v) == __value_type__ or __value_type__ == 'mixed') then
                return
            end
            __array__[k] = v
        end,
        __len = function() return #__array__ end,
        __add = function(t, v)
            __methods__:push(v)
            return t
        end,
        __sub = function(t, v)
            __methods__:kick(v)
            return t
        end,
        __mul = function(t, v)
            if isNumber(v) and v >= 1 then
                local cp = table.copy(__array__)
                v = math.round(v)
                for i=1, v-1 do
                    __methods__:append(unpack(cp))
                end
            end
            return t
        end,
        __unm = __methods__.reverse,
        __tostring = function()
            return string.format('[%s]', table.concat(__array__, ','))
        end
    }
    setmetatable(new_array, mt)

    return new_array
end
