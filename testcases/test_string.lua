local addPath = ';./../?.lua'
package.path = package.path .. addPath
require('framework.preload')

local chars, utf8chars, ascichars  = string.utf8chars('山东黄❤πßåsdalkdhåƒœŒ金asdj')
print(#chars, #utf8chars, #ascichars)				-- 23, 12, 11
local stringArray = string.toarray('时代的味道')
print(stringArray[3])								-- 的
stringArray[3] = 'De'
local arrayString = table.tostring(stringArray)
print(arrayString)									-- 时代De味道
print(#arrayString, #string.utf8chars(arrayString)) -- 14, 6

