local addPath = ';/Users/kdcq001/GitHub/LuaWheel/?.lua'
package.path = package.path .. addPath
require('framework.preload')

local fake = {insert = 0}

local mt = {
    __index = function(t,k)
        print('__index:', k)
        if fake[k] then
            return fake[k]
        end
    end,
    __newindex = function(t, k, v)
        print('__newindex :', k,v)
    end
}

local t = table
t = setmetatable(t, mt)
print(getmetatable(t).__index)
-- print(t.insert)
-- t.insert = 0
-- print(t.insert)
