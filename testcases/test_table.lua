local addPath = ';./../?.lua'
package.path = package.path .. addPath
require('framework.preload')

local x = false
print(isTrue(x))
print(isFalse(x))

local base = string
local plain = type(base) == 'table' and not getmetatable(base)
print(plain)


