local TaskMove = {} -- the table representing the class, which will double as the metatable for the instances

TaskMove.__index = TaskMove -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(TaskMove, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function TaskMove.new(init)
   local t = setmetatable({}, { __index = TaskMove })

   -- Your constructor stuff
  t.value = init
  return t
end

function TaskMove:getValue()
  return self.value
end

function TaskMove:activate(me, enemy)
  local distToOpponent = me["distanceToOpponent"]
  
	return (distToOpponent > 20)
  
end

function TaskMove:execute(me)
  return self:moveForward(me)
end

function TaskMove:forward(me)
	if me["facingRight"] then
		return "Right"
	end
	return "Left"
end

function TaskMove:moveForward(me)
   local result = {}
   result[self:forward(me)] = true
   return result
end

return TaskMove