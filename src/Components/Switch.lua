--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Switch = {}
Switch.__index = Switch

function Switch.new(window: any, position: UDim2, size: UDim2, initial: boolean?, callback: (boolean)->())
	local self = setmetatable({}, Switch)
	initial = initial == true

	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundTransparency = 1
	frame.Parent = window.Container

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, math.max(40, size.X.Offset), 0, math.max(18, size.Y.Offset))
	track.Position = UDim2.new(0, 0, 0, 0)
	track.BackgroundColor3 = Color3.fromRGB(28, 32, 36)
	track.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = track

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(initial and 1 or 0, initial and -18 or 2, 0, 1)
	knob.BackgroundColor3 = Color3.fromRGB(240,240,240)
	knob.Parent = track

	local kcorner = Instance.new("UICorner")
	kcorner.CornerRadius = UDim.new(0, 8)
	kcorner.Parent = knob

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Parent = track

	local function setState(on)
		local x = on and 1 or 0
		local knobX = on and UDim2.new(1, -18, 0, 1) or UDim2.new(0, 2, 0, 1)
		MiltechUI.Animations.Tween(knob, {Position = knobX}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		MiltechUI.Animations.Tween(track, {BackgroundColor3 = on and MiltechUI.Theme.Border or Color3.fromRGB(28,32,36)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			initial = not initial
			setState(initial)
			if callback then pcall(callback, initial) end
		end
	end)

	-- Expose API
	self.Instance = frame
	self.IsOn = function() return initial end
	self.Set = function(_, val) initial = val; setState(val) end
	return self
end

return Switch
