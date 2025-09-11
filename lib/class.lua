--- Default function.
local dummy = function()
end

--- Simple copy of top level functions.
---@param from any
---@return any
local function copy(to, from)
  if not (type(from) == "table") then
    return from
  end

  for key, value in pairs(from) do
    if (type(value) == "function") then
      to[key] = value
    end
  end
  return to
end

---@param metadata table
return function(metadata)
  if not (metadata.__local) then
    if not (metadata.__name) then
      error("Metadata isn't local and [they doesn't have name].")
    elseif not (type(metadata.__name) == "string") then
      error("Metadata isn't local and [their name not a string].")
    elseif (#metadata.__name == 0) then
      error("Metadata isn't local and [their name is empty].")
    end
  end

  local class = {
    __name = metadata.__name,
    __constructor = metadata.__constructor or dummy,
    __parent = metadata.__parent
  }

  -- Post definitions.
  class.__index = class

  -- Describe some useful function.

  --- Checks the class type. It also handles parent class types.
  ---@param name string
  ---```lua
  --- if object:instanceof("ClassName") then
  ---   print("Object is %ClassName%!")
  --- end
  ---```
  class.instanceof = function(self, name)
    if not (type(name) == "string") then
      return false
    end

    -- Recursive check.
    local parent = self.__parent
    while (parent) do
      if (parent.__name == name) then
        return true
      end

      parent = parent.__parent
    end

    return (self.__name == name)
  end

  -- Metatable.
  local mt = {
    __call = function(self, ...)
      local object = {}

      -- Recursive constructor.
      local parent = self.__parent
      while (parent) do -- Until parent isn't nil.
        -- Copy functions into son's object.
        copy(object, parent)

        -- Going to the next parent.
        parent = parent.__parent
      end

      -- Set son's metatable. Overriding functions from self. 
      object = setmetatable(copy(object, self), self)

      -- Call the son`s constructor.
      object:__constructor(...)
      return object
    end
  }

  local public = setmetatable(class, mt)
  if not (metadata.__local) then
    _G[metadata.__name] = public
  else
    return public
  end
end
