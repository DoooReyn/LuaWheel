local addPath = ';./../?.lua'
package.path = package.path .. addPath
require('framework.preload')


local arr = Array('number')
print(string.rep('=', 20))
arr:insert(2, 1)
arr:unshift(0)
arr:insertAt(1, 2)
arr:append(3,4,5,6,7,8,9,'10',11)
arr:shift()
arr:removeAt()
arr:print()                     -- 1,2,3,4,5,6,7,8,9
print(string.rep('=', 20))
arr:push(10)                    -- 1,2,3,4,5,6,7,8,9,10
arr:insert('w', 1)              -- fail
arr:push('n')                   -- fail
arr:pop()                       -- 1,2,3,4,5,6,7,8,9
arr:splice(1, 5)                -- 6,7,8,9
print(arr:front())              -- 6
print(arr:tail())               -- 9
arr:appendAt(2,11,12,13)        -- 6,11,12,13,7,8,9
arr:kick(3)
arr:print()                     -- 6,11,12,13
table.print(arr:slice(2,4))     -- 11,12,13. `slice` has no side effect !
local tmp, ret = arr + 14
print(tmp, ret)
print(arr + 19 + 15)
print(#arr)                     -- 6
arr:print()                     -- 6,11,12,13,14,19,15
arr = arr - 2
print(arr - 1 - 1)
arr:print()                     -- 6,11,12
arr = arr * 2
arr:print()                     -- 6,11,12,6,11,12
print(-arr)
arr:print()                     -- 12,11,6,12,11,6
print(arr:reverse()+17)
arr:print()                     -- 6,11,12,6,11,12,17
print(tostring(arr))            -- [6,11,12,6,11,12,17]
