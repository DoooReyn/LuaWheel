---------------------------------
-- Author: Reyn
-- Date: 2016-06-30
-- Comment: Some conventions as below:
--      arr : Array Table
--      map : Hash Table
--      tbl : Mixed Table
---------------------------------

local __TYPE__ = {
    MIXED = 'Mixed',
    ARRAY = 'Array',
    MAP   = 'HashMap'
}

unpack = unpack or table.unpack

function table.readonly(tbl)
    local new_tbl = {}
    local newindex = function(t, k, v)
        assert(false, "Error!Attempt to update a read-only table!!")
    end
    local mt = {__index = function(t, k)
        local v = rawget(t, k)
        if v then return v end
        local v = tbl[k]
        if v then return v end
        return nil
    end, __newindex = newindex}
    setmetatable(new_tbl, mt)
    return new_tbl
end

----------- types of table -------------
function table.types()
    return table.readonly(__TYPE__)
end

function table.typeof(tbl)
    local hasArr, hasMap = false, false
    for k,v in pairs(tbl) do
        if hasArr and hasMap then
            break
        end
        local isNum = isNumber(k)
        if isNum then hasArr = true end
        local isStr = isString(k)
        if isStr then hasMap = true end
    end

    if hasArr and hasMap then
        return __TYPE__.MIXED
    elseif hasArr then
        return __TYPE__.ARRAY
    elseif hasMap then
        return __TYPE__.MAP
    else -- empty
        return __TYPE__.ARRAY
    end
end

function table.isMixedTabl(tbl)
    return table.typeof(tbl) == __TYPE__.MIXED
end

function table.isArray(tbl)
    return table.typeof(tbl) == __TYPE__.ARRAY
end

function table.isHashMap(tbl)
    return table.typeof(tbl) == __TYPE__.MAP
end


function table.len(tbl)
    local count = 0
    for k, v in pairs(tbl) do
        count = count + 1
    end
    return count
end

function table.keys(map)
    local keys = {}
    for k, v in pairs(map) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(map)
    local values = {}
    for k, v in pairs(map) do
        values[#values + 1] = v
    end
    return values
end

function table.copy(tbl)
    local cp = {}
    for k,v in pairs(tbl) do
        cp[k] = isTable(v) and table.copy(v) or v
    end
    return cp
end

function table.print(tbl)
    local format = string.format
    for k,v in pairs(tbl) do
        print(format('[%s] => ', k), v)
    end
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        if not dest[k] then
            dest[k] = v
        end
    end
end

function table.mergeForce(dest, src)
    for k, v in pairs(src) do
        if dest[k] then
            dest[k] = v
        end
    end
end

function table.insertto(dest, src, begin)
    if not table.isArray(dest) or not table.isArray(src) then
        assert(false, "Error! `table.insertto` need an Array table.")
    end

    begin = isNumber(begin) and begin or 0

    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexOf(array, value, begin)
    if not table.isArray(array) then
        assert(false, "Error! `table.indexOf` need an Array table.")
    end

    begin = isNumber(begin) and begin or 0

    for i = begin, #array do
        if array[i] == value then
            return i
        end
    end

    return nil
end

function table.indexsOf(array, value)
    if not table.isArray(array) then
        assert(false, "Error! `table.indexOf` need an Array table.")
    end

    local indexs = {}
    for i=1, #array do
        if value == array[i] then
            indexs[#indexs + 1] = i
        end
    end

    return indexs
end

function table.firstIndexOf(array, value)
    local indexs = table.indexsOf(array, value)
    if #indexs > 0 then
        return indexs[1]
    end
    return nil
end

function table.lastIndexOf(array, value)
    local indexs = table.indexsOf(array, value)
    if #indexs > 0 then
        return indexs[#indexs]
    end
    return nil
end

function table.keyOf(map, value)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.keyOf` need an HashMap table.")
    end

    for k, v in pairs(map) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.keysOf(map, value)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.keysOf` need an HashMap table.")
    end

    local keys = {}
    for k, v in pairs(map) do
        if v == value then
            keys[#keys + 1] = k
        end
    end
    return keys
end

function table.valueOf(map, key)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.valueOf` need an HashMap table.")
    end

    for k,v in pairs(map) do
        if k == key then
            return v
        end
    end
    return nil
end

function table.removeByValue(array, value, removeall)
    if not table.isArray(array) then
        assert(false, "Error! `table.removeByValue` need an Array table.")
    end

    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end

function table.eachMap(map, each)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.eachMap` need an HashMap table.")
    end

    for k, v in pairs(map) do
        each(k, v)
    end
end

function table.mapEach(map, each)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.mapEach` need an HashMap table.")
    end

    for k,v in pairs(map) do
        map[k] = each(k, v)
    end
end

function table.filter(tbl, filter)
    for k, v in pairs(tbl) do
        if not filter(k, v) then
            tbl[k] = nil
        end
    end
end

function table.unique(tbl, saveAsArr)
    local check  = {}
    local unique = {}
    for k, v in pairs(tbl) do
        if not check[v] then
            if saveAsArr then
                unique[#unique+1] = v
            else
                unique[k] = v
            end
            check[v] = true
        end
    end
    return unique
end

function table.contain(tbl, value)
    local result, key = false, -1
    for k, v in pairs(tbl) do
        if v == value then
            result = true
            key = k
            break
        end
    end
    return ret,idx
end

function table.flipKey(map)
    if not table.isHashMap(map) then
        assert(false, "Error! `table.flipKey` need an HashMap table.")
    end

    local newTab = {}
    for k, v in pairs(map) do
        newTab[v] = k
    end
    return newTab
end

function table.reIndex(arr)
    if not table.isArray(arr) then
        assert(false, "Error! `table.reIndex` need an Array table.")
    end

    local index = {}
    local count = table.maxn(arr)
    for i,v in ipairs(arr) do
        index[count - i + 1] = v
    end
    return index
end

function table.intersection(t1, t2)
    local intersection = {}
    for k,v in pairs(t1) do
        if t2[k] then
            intersection[#intersection + 1] = k
        end
    end
    return intersection
end

function table.union(t1, t2)
    local union = table.keys(t1)
    for k,v in pairs(t1) do
        if nil == t2[k] then
            union[#union + 1] = k
        end
    end
    return union
end

function table.makeArray(tbl, pair)
    if pair == nil then pair = pairs end

    if pair == ipair then
        return table.reIndex(tbl)
    end

    local arr = {}
    for _,v in pair(tbl) do
        arr[#arr + 1] = v
    end
    return arr
end

function table.arrayEach(array, each)
    if not table.isArray(array) then
        assert(false, "Error! `table.arrayEach` need an Array table.")
    end

    for i=1, #array do
        array[i] = each(i, array[i])
    end
end

function table.eachArray(array, each)
    if not table.isArray(array) then
        assert(false, "Error! `table.eachArray` need an Array table.")
    end

    for i=1, #array do
        each(i, array[i])
    end
end

function table.enum(from, ...)
    local enum  = {}
    local array = {...}
    local from  = isNumber(from) and from or 1

    for i=1, #array do
        local key = array[i]
        enum[key] = from
        from = from + 1
    end

    return enum
end

function table.enumTab(tab, from)
    return table.enum(from, unpack(tab))
end

function table.arrayFilter(array, filter)
    if not table.isArray(array) then
        assert(false, "Error! `table.arrayFilter` need an Array table.")
    end

    local excludes = {}
    for i=1, #array do
        if filter(i, array[i]) then
            excludes[#excludes + 1] = i
        end
    end

    for i = #excludes, 1, -1 do
        table.remove(array, indexes[i])
    end
end

function table.weak(mt)
    mt = mt or "v"
    return setmetatable({}, {
        __mode = mt
    })
end

function table.arrayShift(array)
    if not table.isArray(array) then
        assert(false, "Error! `table.arrayShift` need an Array table.")
    end

    if #array == 0 then
        return false
    end

    local shift = array[1]
    table.remove(array, 1)
    return shift
end

function table.arrayUnshift(array, value)
    if not table.isArray(array) then
        assert(false, "Error! `table.arrayUnshift` need an Array table.")
    end
    table.insert(array, 1, value)
end

function table.keyAsValue(...)
    local arr = {...}
    local ret = {}
    for _,v in ipairs(arr) do
        ret[v] = v
    end
    return ret
end

function table.slice(array, from, to)
    if not table.isArray(array) then
        assert(false, "Error! `table.slice` need an Array table.")
    end

	local segment = {}
    from = from or 1
    from = math.max(from, 1)
    to   = to or #array
    to   = math.max(to, 1)
    to   = math.min(to, #array)
    to   = math.max(from, to)

	for i=from, to do
		segment[#segment + 1] = array[i]
	end
	return segment
end

function table.splice(array, from, cnt)
    if not table.isArray(array) then
        assert(false, "Error! `table.splice` need an Array table.")
    end

    local len = #array
    if len == 0 then
        return
    end

    from = isNumber(from) and from or len
    from = math.min(from, len)
    from = math.max(from, 1)

    cnt = isNumber(cnt) and cnt or 1
    cnt = math.min(cnt, len-from+1)
    cnt = math.max(cnt, 1)

    -- print('cnt, from : ', cnt, from)

    local cur = 0
    for i = from+cnt-1, 1, -1 do
        if cur == cnt then
            break
        end
        cur = cur + 1
        table.remove(array, i)
    end
end

function table.appendAt(dest, array, at)
    if not table.isArray(dest) and not table.isArray(array) then
        assert(false, "Error! `table.appendAt` need an Array table.")
    end

    local len = #dest
    if len == 0 then
        return
    end

    at = isNumber(at) and at or len
    at = math.min(at, len)
    at = math.max(at, 1)

    for i = 1, #array do
        table.insert(dest, at, array[i])
        at = at + 1
    end
end

function table.multiRemove(array, cnt)
    if not table.isArray(array) then
        assert(false, "Error! `table.multiShift` need an Array table.")
    end

    local len = #array
    if len == 0 then
        return
    end
    cnt = isNumber(cnt) and cnt or 1
    cnt = math.min(cnt, len)
    cnt = math.max(cnt, 1)

    local cur = 0
    for i = len, 1, -1 do
        if cur == cnt then
            break
        end
        cur = cur + 1
		table.remove(array, i)
	end
end

function table.reverse(array)
    if not table.isArray(array) then
        assert(false, "Error! `table.reverse` need an Array table.")
    end

    local len = #array
    local mid = len / 2
	for i,v in ipairs(array) do
        if i > mid then break end
        array[i], array[len-i+1] = array[len-i+1], array[i]
	end
end

function table.getFirstKey(tbl)
	local k, v = next(tbl)
	return k
end

function table.getFirstValue(tbl)
	local k, v = next(tbl)
	return v
end

function table.getLastKey(tbl)
	local k, v = next(tbl, table.len(tbl) - 1)
	return k
end

function table.getLastValue(tbl)
	local k, v = next(tbl, table.len(tbl) - 1)
	return v
end

local function randomOne(tbl)
    local keys = table.keys(tbl)
    local kId  = math.randomMax(#keys)
    local key  = keys[kId]
    return tbl[key]
end

local function randomMul(tbl, cnt)
    local keys = table.keys(tbl)
    cnt = isNumber(cnt) and cnt or 1
    cnt = math.min(cnt, #keys)

    local cur = 0
    local vals = {}
    while cur < cnt do
        local kId = math.randomMax(#keys)
        if not vals[kId] then
            vals[kId] = tbl[keys[kId]]
            cur = cur + 1
            table.remove(keys, kId)
        end
    end

    return table.values(vals)
end

function table.random(tbl, cnt)
    local len = table.len(tbl)
    if len == 0 then
        return nil
    end

    cnt = isNumber(cnt) and cnt or 1
    cnt = math.min(cnt, len)

    if cnt == 1 then
        return randomOne(tbl)
    end
    return randomMul(tbl, cnt)
end

function table.tostring (array)
    if not table.isArray(array) then
        assert(false, "Error! `table.tostring` need an Array table.")
    end
    return table.concat(array)
end
