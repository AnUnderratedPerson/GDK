--TODO: Module loader for this repo and stuff. Make a plugin maybe too

local args = {"GetProperty"}
local result = "<event0x1>("

for i, arg in ipairs(args) do
    if (i == #args) then
        result = string.format("%s%s)", result, arg)
    else
        result = string.format("%s%s.", result, arg)        
    end
end

print(result)