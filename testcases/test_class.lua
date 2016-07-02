local addPath = ';./../?.lua'
package.path = package.path .. addPath
require('framework.preload')


print(string.rep('#', 50))
print('Test Class new, construct and destruct')
print(string.rep('*', 50))

local function Sample()
    local ClassSample = Class('Sample')
    function ClassSample:construct(base)
        print('proto construct : ', base)
        self.base = base
    end
    function ClassSample:destruct()
        self.base = 0
        print('proto destruct : ', self.base)
    end
    return ClassSample
end

local S = Sample()
local Instance1 = S.new(100)
local Instance2 = S.new(100)
function Instance2:construct(base)
    self.base = base + 1
end
function Instance2:destruct()
    self.base = self.base - 99
end
Instance2:construct(888)
print(Instance1.base, Instance2.base)   -- 100, 889
Instance1:destruct()
Instance2:destruct()
print(Instance1.base, Instance2.base)   -- 0, 790


print(string.rep('#', 50))
print('Test global class register and unload')
print(string.rep('*', 50))
local Sample = LoadGlobalClass('Sample')
-- local Twice  = RegisterGlobalClass('Sample') -- would raise error
Sample.a = 0
local Sample = Class('Sample')
Sample.a = 1
print(GlobalClass('Sample').a, Sample.a) -- 0, 1
print(GlobalClass('Sample').a, Sample.a) -- 0, 1
UnloadGlobalClass('Sample')
print(GlobalClass('Sample'), Sample.a) -- 0, 1
