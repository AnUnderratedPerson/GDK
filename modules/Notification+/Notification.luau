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

--> Main Module

local Notification = {}
Notification.__index = Notification

function Notification.new(options)
    local settings = options or {}
    local self = setmetatable({}, Notification)

    self.Padding = settings.Padding or 0
    self.BaseListInstance = settings.BaseListInstance or nil
    self.InstanceComponent = settings.Instance or nil

    self._assert(self.BaseListInstance, "BaseListInstance cannot be nil. You must provide an instance notifications will be parented to.", 2)
    self._assert(self.InstanceComponent, "InstanceComponent cannot be nil. There is no main notification instance supplied.", 2)
    self._assertInstanceComponent(self, self.InstanceComponent)

    return self
end

--> @Use: Utility functions

function Notification._assertInstanceComponent(self, InstanceComponent: Instance)
    local Instances = {
        BaseFrame = InstanceComponent:FindFirstChild("BaseBackgroundInstance", true),
        BaseContent = InstanceComponent:FindFirstChild("BaseContentTextInstance", true),
        BaseHeader = InstanceComponent:FindFirstChild("BaseHeaderInstance", true),
        BaseFooter = InstanceComponent:FindFirstChild("BaseFooterInstance", true),
    }

    self._assert(Instances.BaseFrame, "BaseFrame cannot be nil", 2)
    self._assert(Instances.BaseContent, "BaseContentText cannot be nil", 2)
    self._assert(Instances.BaseContent:IsA("TextLabel"), "BaseContentText must be a TextLabel", 2)
    self._assert(Instances.BaseFrame.AnchorPoint == Vector2.new(0.5, 0.5), "BaseFrame AnchorPoint must be 0.5, 0.5 for better accuracy at padding", 2)

    return Instances
end

function Notification._warn(message: string, ...)
	warn(string.format("[Notification | Warning]: %s", string.format(message, ...)))
end

function Notification._assert(condition: any, message: string, level: number, ...)
	if (not condition) then
		error(string.format("[Notification | Assertion]: %s", string.format(message, ...)), level)
	end
end

function Notification:CreateNotification(options)
    --> Creates a regular notification with a header, content, and footer.
    local settings = options or {
        Header = "INFORMATION",
        Content = "Placeholder content.",
        Footer = "None Provided...",
        Timeout = 10,
    }

    local BaseListInstance = self.BaseListInstance
    local NewNotificationFrame = self.InstanceComponent:Clone()
    local NewNotificationFrameInstances = self._assertInstanceComponent(self, NewNotificationFrame)
    local BaseHeader = NewNotificationFrameInstances.BaseHeader
    local BaseContent = NewNotificationFrameInstances.BaseContent
    local BaseFooter = NewNotificationFrameInstances.BaseFooter
    
    if (BaseHeader) then
        BaseHeader.Text = settings.Header        
    end

    BaseContent.Text = settings.Content

    if (BaseFooter) then
        BaseFooter.Text = settings.Footer
    end

    --> Padding working out is coming soon.
    --> Same with tweening the object and etc

    NewNotificationFrame.Parent = BaseListInstance

    task.delay(settings.Timeout, function()
        NewNotificationFrame:Destroy()
    end)
end

function Notification:CreateLiveNotification()
    --> Creates a live notification that constantly gets displayed and updated until it is manually destroyed.
    --> Coming soon
end

return Notification