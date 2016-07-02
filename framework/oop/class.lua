-----------------------------------------
-- Author: Reyn
-- Date: 2016-07-01
-- Comment: An implementation of `class`
-----------------------------------------

--[[
-- Info     :   _G_CLASSES_
-- Brief    :
--  Store global classes in `_G_CLASSES_`, a class
--  in `_G_CLASSES_` can not be overwrite.
]]--
local _G_CLASSES_ = {}
function CheckGlobalClass(class_name)
    if _G_CLASSES_[class_name] then
        assert(false, 'Can not register an existed class')
    end
end

--[[
-- Info     :   Class Factory
-- Brief    :
--  `constant_index_tab` : Store members that can not be modified.
--  `private_index_tab`  : Store members that can not be modified directly.
--  `metatable __index`  : `__index` should search these two tables above.
]]--
function Class(class_name, base_class)
    local new_class = {}
    if type(base_class) ~= 'table' then
        base_class = nil
    end

    -- constant_index_tab
    local constant_index_tab = {classname = class_name}
    if base_class then
        constant_index_tab.super = base_class
    end
    constant_index_tab.constantOf = function(t, k)
        local v = constant_index_tab[k]
        if v then return v end

        if base_class then
            v = base_class:constantOf(k)
            if v then return v end
        end
        return nil
    end
    constant_index_tab.constantMap = function(t, k ,v)
        -- if exists, it will not overwrite
        if not constant_index_tab[k] then
            constant_index_tab[k] = v
        end
    end
    constant_index_tab.publicOf = function(t, k)
        v = rawget(t, k)
        if v then return v end

        if base_class then
            v = base_class:publicOf(k)
            if v then return v end
        end

        return nil
    end
    constant_index_tab.instanceOf = function(t, instance)
        return class_name == instance
    end

    -- private_index_tab
    local private_index_tab = {}
    constant_index_tab.privateTab = function()
        return copy(private_index_tab)
    end
    constant_index_tab.privateMap = function(t, k, v)
        -- if exists, it will overwrite
        if v == nil then return end
        private_index_tab[k] = v
    end
    constant_index_tab.privateOf = function(t, k)
        local v = private_index_tab[k]
        if v then return v end

        if base_class then
            v = base_class:privateOf(k)
            if v then return v end
        end

        return nil
    end

    -- metatable
    setmetatable(new_class, {
        __index = function(t, k)
            -- search in constant_index_tab
            local v = constant_index_tab[k]
            if v then return v end

            -- search in private_index_tab
            local v = private_index_tab[k]
            if v then return v end

            -- search in new_class
            v = rawget(t, k)
            if v then return v end

            -- search in base_class
            if not base_class then return nil end
            v = base_class[k]
            if v then return v end
        end
    })

    new_class.construct = function(instance, ...)
        print(string.format('[%s] construct done.', class_name))
    end
    new_class.destruct = function(instance)
        print(string.format('[%s] destruct done.', class_name))
    end
    new_class.new = function(...)
        local instance = {}
        setmetatable(instance, {__index = new_class})
        instance:construct(...)
        return instance
    end

    return new_class
end

--[[
-- Info     : Register an class to `_G_CLASSES_`
-- Brief    : If class exists, it will raise error.
]]--
function LoadGlobalClass(class_name, base_class)
    CheckGlobalClass(class_name)

    local new_class = Class(class_name, base_class)
    _G_CLASSES_[class_name] = new_class
    return new_class
end

function GlobalClass(class_name)
    return _G_CLASSES_[class_name]
end
--[[
-- Info     : Unload an class from `_G_CLASSES_`
-- Brief    : Not recommended
]]
function UnloadGlobalClass(class_name, base_class)
    if _G_CLASSES_[class_name] then
        _G_CLASSES_[class_name] = nil
    end
end
