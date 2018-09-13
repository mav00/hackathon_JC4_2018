local fobo = {}

fobo.__index = fobo -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(fobo, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function fobo.new(init)
   local t = setmetatable({}, { __index = fobo })

   -- Your constructor stuff
  t.value = init
  return t
end

function fobo:foo()
    print("Hello World! " .. self.value)
end

return fobo