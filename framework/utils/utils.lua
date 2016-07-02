---------------------------------
-- Author: Reyn
-- Date: 2016-07-01
-- Comment: Common Utils
---------------------------------

local base_data_type = table.keyAsValue(
    'boolean', 'number', 'string',
    'function', 'table', 'thread',
    'nil')
DATA_TYPE = table.readonly(base_data_type)

function checkType(v, type)
    return v == DATA_TYPE[type]
end

function checkHashType(tp)
    if not (tp == 'mixed' or DATA_TYPE[tp]) then
        tp = 'mixed'
    end
    return tp
end

function isBoolean(v)
    return checkType(DATA_TYPE['boolean'], type(v))
end

function isNumber(v)
    return checkType(DATA_TYPE['number'], type(v))
end

function isString(v)
    return checkType(DATA_TYPE['string'], type(v))
end

function isFunction(v)
    return checkType(DATA_TYPE['function'], type(v))
end

function isTable(v)
    return checkType(DATA_TYPE['table'], type(v))
end

function isUserData(v)
    return checkType(DATA_TYPE['userdata'], type(v))
end

function isNil(v)
    return checkType(DATA_TYPE['nil'], type(v))
end

function isThread()
    return checkType(DATA_TYPE['thread'], type(v))
end

function AddPackagePath(path)
    package.path = string.format('%s;%s/?.lua', package.path, path)
    print(package.path)
end

function CurrentPath()
    local obj = io.popen('pwd')
    path = obj:read('*all'):sub(1,-2)
    obj:close()
    return path
end

function AddCurrentPathToPackagePath(path)
    AddPackagePath(CurrentPath())
end

function DEBUG_CALL(fn, ...)
    if isDebugEnv() then
        return fn(...)
    end
end

function copy(tab)
    if type(tab) ~= 'table' then
        return tab
    end

    local cp = {}
    for k,v in pairs(tab) do
        if type(v) == 'table' then
            cp[k] = copy(v)
        else
            cp[k] = v
        end
    end
    return cp
end
