local Component = {}
Component.__index = Component

function Component.new(name: string, callback: ({}) -> (Instance))
    local self = setmetatable({}, Component)
    
    self.Name = name
    self.ObjectName = string.format("<component0x1>(%s)", name)
    self.BaseContructor = callback

    return self
end

function Component:CreateComponent(props)
    return self.BaseContructor(props)
end

return Component