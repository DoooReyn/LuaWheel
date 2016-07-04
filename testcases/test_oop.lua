local addPath = ';./../?.lua'
package.path = package.path .. addPath
require('framework.preload')


print(string.rep('*', 50))
local Proto = Class()
Proto.test = 0

local p1 = New(Proto)
p1.test  = 1
p1:private('t', 11)             -- [note] t is a private variable

local p2 = Class('P2', p1)
p2.test = 2

print(p2.test, p2.t)            -- 2, 11
print(p2:typeOf('test'))        -- Public, 2
print(p2:typeOf('t'))           -- Private, 11


print(string.rep('*', 50))
p2:private('t', 22)
print(p2.t, p1.t)               -- 22, 11
print(p2:typeOf('test'))        -- Public, 2
print(p2:typeOf('t'))           -- Private, 22

print(string.rep('*', 50))
p2:private('test', 99)          -- fail
p2:inner('t', 99)               -- fail
print(p2.test, p1.t)            -- 2, 11

local p3 = New(p2)
p3.t = 99                       -- fail, equals to p2.t
print(p3.t, p2.t, p1.t)         -- 22, 22, 11


print(string.rep('*', 50))
print('Proto:')
table.print(Proto)
print(string.rep('*', 50))
print('P1:')
table.print(p1)
print(string.rep('*', 50))
print('P2:')
table.print(p2)
print(string.rep('*', 50))
print('P3:')
table.print(p3)


print(string.rep('*', 50))
print(Proto)
local p4 = New(Proto)
local p5 = New(p4)
print(p4:getInstance())
print(p5:getInstance())
Proto:destroyInstance()
print(p4:getInstance())
print(p5:getInstance())
