local foo = {}

function foo:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

return foo