--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)
local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(window: any, position: UDim2, size: UDim2, min: number?, max: number?, initial: number?, callback: (number)->())
	min = min or 0
	max = max or 1
	initial = math.clamp(initial or min, min, max)

	local self = setmetatable({}, Slider)

	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundTransparency = 1
	frame.Parent = window.Container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 14)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = ""
	label.Font = MiltechUI.Theme.FontMain
	label.TextSize = 11
	label.TextColor3 = MiltechUI.Theme.TextMuted
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 8)
	track.Position = UDim2.new(0, 0, 0, 20)
	track.BackgroundColor3 = Color3.fromRGB(18, 22, 26)
	track.BorderSizePixel = 0
	track.Parent = frame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = MiltechUI.Theme.AccentA
	fill.BorderSizePixel = 0
	fill.Parent = track

	local knob = Instance.new("ImageButton")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new((initial - min) / (max - min), -7, 0, -3)
	knob.BackgroundTransparency = 1
	knob.Image = "rbxassetid://0" -- empty default
	knob.Parent = track

	local dragging = false

	local function setValueFromX(x)
		local abs = x - track.AbsolutePosition.X
		local pct = math.clamp(abs / track.AbsoluteSize.X, 0, 1)
		local value = min + pct * (max - min)
		MiltechUI.Animations.Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		MiltechUI.Animations.Tween(knob, {Position = UDim2.new(pct, -7, 0, -3)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		if callback then pcall(callback, value) end
		return value
	end

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			setValueFromX(input.Position.X)
		end
	end)

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			setValueFromX(input.Position.X)
		end
	end)

	self.Instance = frame
	self.Set = function(_, v)
		local pct = math.clamp((v - min) / (max - min), 0, 1)
		MiltechUI.Animations.Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		MiltechUI.Animations.Tween(knob, {Position = UDim2.new(pct, -7, 0, -3)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end

	return self
end

return Slider
