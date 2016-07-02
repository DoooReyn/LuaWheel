--------------------------------------------
-- Author: Reyn
-- Date: 2016-07-01
-- Comment: An implementation of Singleton
--------------------------------------------

local function G_MAKE_INSTANCE()
    local _G_INSTANCE_PROTOTYPE = LoadGlobalClass('Instance')

    -- store instances in `_G_INSTANCE_LIST`
    local _G_INSTANCE_LIST = {}
    _G_INSTANCE_PROTOTYPE:constantMap('_G_INSTANCE_LIST', _G_INSTANCE_LIST)

    -- get instance from `_G_INSTANCE_LIST`
    _G_INSTANCE_PROTOTYPE:constantMap('getInstance', function (self, class_name, base_class)
        if not _G_INSTANCE_LIST[class_name] then
            _G_INSTANCE_LIST[class_name] = LoadGlobalClass(class_name, base_class)
        end
        return _G_INSTANCE_LIST[class_name]
    end)

    -- destroy instance with `instance name`
    _G_INSTANCE_PROTOTYPE:constantMap('destroyInstance', function(self, class_name)
        if _G_INSTANCE_LIST[class_name] then
            _G_INSTANCE_LIST[class_name] = nil
            return true
        end
        return false
    end)
    return _G_INSTANCE_PROTOTYPE
end

local G_INSTANCE = G_MAKE_INSTANCE()

function GlobalInstances(show)
    local instance_list = G_INSTANCE:constantOf('_G_INSTANCE_LIST')
    if show then
        for k,v in pairs(instance_list) do
            print(k, v)
        end
    end
    return copy(instance_list)
end

function GetInstance(class_name, base_class)
    return G_INSTANCE:getInstance(class_name, base_class)
end

function DestroyInstance(class_name)
    return G_INSTANCE:destroyInstance(class_name)
end
