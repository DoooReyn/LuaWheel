---------------------------------
-- Author: Reyn
-- Date: 2016-07-04
-- Comment: OOP in Lua
---------------------------------
function isClass(class)
    if not class.__isClass or not class.isInner then
        return false
    end
    local ret, retv = class:isInner('__isClass')
    return ret and retv == 1
end

function New(class)
    if not isClass(class) then
        assert(false, 'class must be a real class')
    end

    local instance = {}
    setmetatable(instance, {
        __index = function (t, k)
            local v = rawget(t, k)
            if nil ~= v then
                return v
            end
            return class[k]
        end,
        __newindex = function (t, k, v)
            if nil ~= class[k] then
                class[k] = v
                return
            end
            rawset(t, k, v)
        end
    })
    instance:initInstance(instance)

    return instance
end

function Class(cls_name, base_class)
    local prototype     = {}
    local __inner__     = {}
    local __private__   = {}
    local __subclass__  = {}
    local __instance__  = 0

    prototype.classname = cls_name or '__prototype__'

    -- inner members setting
    __inner__.super = base_class
    __inner__.__isClass = 1
    function __inner__:inner (k, v)
        if nil == rawget(prototype, k) and nil == __private__[k] and nil == __inner__[k] then
            __inner__[k] = v
        end
    end
    function __inner__:private (k, v)
        if nil == __inner__[k] and nil == rawget(prototype, k) then
            __private__[k] = v
        end
    end
    function __inner__:privateOf(k)
        local v = __private__[k]
        if v then return v end
        if base_class then
            return base_class:isPrivate(k)
        end
        return nil
    end

    function __inner__:isInner(k)
        local v = __inner__[k]
        local ret = nil ~= v
        if ret then
            return ret, v
        end

        if not base_class then
            return false, nil
        end

        return base_class:isInner(k)
    end
    function __inner__:isPrivate(k)
        local v = __private__[k]
        local ret = nil ~= v
        if ret then return ret, v end

        if not base_class then
            return false, nil
        end

        return base_class:isPrivate(k)
    end
    function __inner__:isPublic(k)
        local v = rawget(prototype, k)
        local ret = nil ~= v
        if ret then
            return ret, v
        end

        if not base_class then
            return false, nil
        end

        return base_class:isPublic(k)
    end
    function __inner__:typeOf(k)
        local ret, p = __inner__:isInner(k)
        if ret then
            return 'Inner', p
        end

        local ret, p = __inner__:isPrivate(k)
        if ret then
            return 'Private', p
        end

        local ret, p = __inner__:isPublic(k)
        return 'Public', p
    end

    function __inner__:addSubClass(class)
        __subclass__[#__subclass__+1] = class
    end
    function __inner__:subclass()
        return table.copy(__subclass__)
    end

    function __inner__:new(...)
        return New(prototype)
    end
    function __inner__:getInstance()
        if 0 ~= __instance__ then
            return __instance__
        end
        return New(prototype)
    end
    function __inner__:initInstance(instance)
        __instance__ = instance
    end
    function __inner__:destroyInstance()
        __instance__ = 0
    end

    -- set prototype metatable
    local function __index (t, k)
        local v = __inner__[k]
        if nil ~= v then return v end

        local v = __private__[k]
        if nil ~= v then return v end

        local v = rawget(t, k)
        if v then
            return v
        end

        if base_class then
            return base_class[k]
        end
    end
    local function __newindex (t, k, v)
        if nil ~= __inner__[k] or nil ~= __private__[k] then
            print('[warning] can not modify inner or private members directly.')
            return
        end
        rawset(t, k ,v)
    end
    local __metatable = {
        __index    = __index,
        __newindex = __newindex
    }
    setmetatable(prototype, __metatable)

    return prototype
end
