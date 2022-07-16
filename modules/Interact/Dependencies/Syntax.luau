local Interact = ...
local Button = Interact.Component("newComponent", function(props)
    return Interact.Create("TextButton") {
        Name = props.Name,
        BackgroundColor3 = props.Color,

        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(0, 0, 0, 0),
        
        InnerFrame = Interact.Create("TextLabel") {
            Name = "InnerFrame",
            BackgroundColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0, 0, 0, 0),
            Text = "Hello World",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 20
        }
    }
end)

Button:CreateComponent({
    Name = "Test",
    Color = Color3.new(1, 0, 0)
})