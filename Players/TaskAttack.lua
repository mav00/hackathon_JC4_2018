local TaskAttack = {} -- the table representing the class, which will double as the metatable for the instances

TaskAttack.__index = TaskAttack -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(TaskAttack, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function TaskAttack.new(init)
   local t = setmetatable({}, { __index = TaskAttack })

   -- Your constructor stuff
  t.value = init
  return t
end

function TaskAttack:getValue()
  return self.value
end

function TaskAttack:activate(me, enemy)
	if me["attacking"] == true then
		return true
  elseif self.value > 40 then
    self.value = self.value + 1
    return true
  elseif self.value > 44 then
    self.value = 0
    return true
  else
    self.value = self.value + 1
    return false
	end
  
end

function TaskAttack:execute(me)
  local result = {}
	if me["attacking"] == false then
		result["Y"] = true
    result[self:forward(me)] = true
	end
  return result
end

function TaskAttack:forward(me)
	if me["facingRight"] then
		return "Right"
	end
	return "Left"
end

return TaskAttack