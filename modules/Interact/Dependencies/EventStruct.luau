local InstanceEventStruct = {}

function InstanceEventStruct.new(...)
    local args = {...}
    local result = "<event0x1>("

    for i, arg in ipairs(args) do
        if (i == #args) then
            result = string.format("%s%s)", result, arg)
        else
            result = string.format("%s%s/", result, arg)        
        end
    end

    return {
        __evArgs = args,
        __evType = result
    }
end

return InstanceEventStruct