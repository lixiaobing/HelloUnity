
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

function class(classname, super)
    local superType = type(super)
    local cls

    --如果父类既不是函数也不是table则说明父类为空
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    --如果父类的类型是函数或者是C对象
    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        --如果父类是表则复制成员并且设置这个类的继承信息
        --如果是函数类型则设置构造方法并且设置ctor函数
        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        --设置类型的名称
        cls.__cname = classname
        cls.__ctype = 1

        --定义该类型的创建实例的函数为基类的构造函数后复制到子类实例
        --并且调用子数的ctor方法
        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

        function cls.New(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        --如果是继承自普通的lua表,则设置一下原型，并且构造实例后也会调用ctor方法
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end

        function cls.New(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end


function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function table.count(tab)
    local cnt = 0
    for _, _ in pairs(tab) do
        cnt = cnt + 1
    end
    return cnt
end

function table.foreach(t,callFunc)
    for k,v in pairs(t) do
        callFunc(k,v)
    end
end

function table.indexOf(list, target, from, useMaxN)
    local len = (useMaxN and #list) or table.maxn(list)
    if from == nil then
        from = 1
    end
    for i = from, len do
        if list[i] == target then
            return i
        end
    end
    return -1
end

local insert = table.insert
local format = string.format
local tostring = tostring
local type = type



function serialize(t)
    local mark={}
    local assign={}

    local tb_cache = {}
    local function tb(len)
        if tb_cache[len] then 
            return tb_cache[len]
        end
        local ret = ''
        while len > 1 do
            ret = ret .. '       '
            len = len - 1
        end
        if len >= 1 then
            ret = ret .. '├┄┄'
        end
        tb_cache[len] = ret
        return ret
    end

    local function table2str(t, parent, deep)
        if type(t) == "table" and t.__tostring then 
            return tostring(t)
        end

        deep = deep or 0
        mark[t] = parent
        local ret = {}
        table.foreach(t, function(f, v)
            local k = type(f)=="number" and "["..f.."]" or tostring(f)
            local t = type(v)
            if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
                insert(ret, format("%s=%q", k, tostring(v)))
            elseif t == "table" then
                local dotkey = parent..(type(f)=="number" and k or "."..k)
                if mark[v] then
                    insert(assign, dotkey.."="..mark[v])
                else
                    insert(ret, format("%s=%s", k, table2str(v, dotkey, deep + 1)))
                end
            elseif t == "string" then
                insert(ret, format("%s=%q", k, v))
            elseif t == "number" then
                if v == math.huge then
                    insert(ret, format("%s=%s", k, "math.huge"))
                elseif v == -math.huge then
                    insert(ret, format("%s=%s", k, "-math.huge"))
                else
                    insert(ret, format("%s=%s", k, tostring(v)))
                end
            else
                insert(ret, format("%s=%s", k, tostring(v)))
            end
        end)
        return "{\n" .. tb(deep + 2) .. table.concat(ret,",\n" .. tb(deep + 2)) .. '\n' .. tb(deep+1) .."}"
    end

    if type(t) == "table" then
        if t.__tostring then 
            return tostring(t)
        end
        local str = format("%s%s",  table2str(t,"_"), table.concat(assign," "))
        return "\n<<table>>" .. str
    else
        return tostring(t)
    end
end




local print_ = print
function print(...)
    local n = select('#', ...)

    local tb = {}

    table.insert(tb, '[' .. os.date() .. ']')
    for i = 1, n do
        local v = select(i, ...)
        local str = serialize(v)
        table.insert(tb, str)
    end

    local ret = table.concat(tb, '  ')

    print_(ret)

    return ret
end