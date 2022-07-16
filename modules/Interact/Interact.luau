------------------------------------------------------------
-->     Created by: Jahames
-->     Version: 1.0
-->     Module: Interact
-->     Description: A library for creating interactive elements.
-->     Dependencies: ./Dependencies
-->     Pointers:
		--> All PascalCase Methods are Top Level Functions (Primary use)
		--> All camelCase Methods are Secondary Level Functions (Secondary or Utility use)
		--> All camelCase Methods with an '_' before their name are Utility Functions (Internal utility use)
------------------------------------------------------------

--> Dependencies
local Parent = script.Parent
local Dependencies = Parent:WaitForChild("Dependencies")
local Component = require(Dependencies:WaitForChild("Component"))
local EventStruct = require(Dependencies:WaitForChild("EventStruct"))

--> Main Module

local Interact = {}

Interact._components = {}

--> @Use: Utility functions

function Interact._warn(message: string, ...)
	warn(string.format("[Interact | Warning]: %s", string.format(message, ...)))
end

function Interact._assert(condition: any, message: string, level: number, ...)
	if (not condition) then
		error(string.format("[Interact | Assertion]: %s", string.format(message, ...)), level)
	end
end

function Interact._splitString(str: string, delimiter: string)
	local split = string.split(str, delimiter)
	local _temp = {}

	for _, val in split do
		if (val ~= "") then
			table.insert(_temp, val)
		end        
	end

	return table.unpack(_temp)
end

function Interact.event(inputEvent: string)
	local name, property = Interact._splitString(inputEvent, "/")

	Interact._assert(name, "Event name for Interact.event cannot be nil", 2)

	if (name == "GetPropertyChangedSignal") then
		Interact._assert(property, "Property name for Interact.event cannot be nil", 2)
		return EventStruct.new(name, property)
	end

	return EventStruct.new(name)
end

--> Created an item
function Interact.Create(class: any)
	local classType = class

	Interact._assert(classType, "Class type for Interact.create cannot be nil", 2)

	--> @Returns: Instance | Should automatically differ between instances, children, events and properties
	return function(props): Instance
		local created, instance = pcall(function()
			return Instance.new(class)
		end)

		Interact._assert(created, "Failed to create instance of class type '%s'", 2, class)

		for name, value in props do
			if (typeof(value) == "Instance") then
				--> Instance
				value.Name = name
				value.Parent = instance
			elseif (typeof(name) == "table") then
				--> Instance event binding
				local ty = name.__evType
				local args = name.__evArgs

				if (ty) then
					local event = string.match(ty, "<%w+>%(([%w%p]+)%)")

					if (not event) then
						--> Attempt to create an unknown event
						Interact._warn("Attempt to create an unknown event '%s'. Did you mean:\n[Interact.event(\"EventName\")] = function(self)\nend", ty)
						continue
					end

					local evName = args[1]
					local evProperty = args[2]
					local evSuccess, evConnection

					if (evName == "GetPropertyChangedSignal") then
						evSuccess, evConnection = pcall(function()
							return instance:GetPropertyChangedSignal(evProperty)
						end)
					else
						evSuccess, evConnection = pcall(function()
							return instance[evName]
						end)
					end

					if (not evSuccess) then
						--> Attempt to create an unknown event
						Interact._warn("Attempt to create an unknown event '%s'", ty)
						continue
					end

					evConnection:Connect(function(...)
						--> Just to return instance as the first argument
						value(instance, ...)
					end)
				end
			else
				--> Property
				local success = pcall(function()
					instance[name] = value
				end)

				if (not success) then
					Interact._warn("Failed to set property '%s' to '%s'", name, instance.Name)
				end
			end
		end

		return instance
	end
end

function Interact.Component(name: string, callback: ({any}) -> (Instance))
	Interact._assert(name, "Component name for Interact.component cannot be nil", 2)
	Interact._assert(callback, "Component callback for Interact.component cannot be nil", 2)

	Interact._components[name] = Component(name, callback)

	return Interact._components[name]
end

return Interact