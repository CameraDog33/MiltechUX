--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)
local TweenService = game:GetService("TweenService")

local InputField = {}
InputField.__index = InputField

function InputField.new(window: any, placeholder: string, position: UDim2, size: UDim2, maxChars: number)
	local self = setmetatable({}, InputField)
	maxChars = maxChars or 32
	
	local box = Instance.new("TextBox")
	box.Name = "Input_" .. placeholder
	box.Size = size
	box.Position = position
	box.BackgroundColor3 = Color3.fromRGB(14, 20, 24)
	box.ClearTextOnFocus = false
	box.Font = MiltechUI.Theme.FontMain
	box.Text = ""
	box.PlaceholderText = string.upper("// ENTER_" .. placeholder .. "...")
	box.PlaceholderColor3 = MiltechUI.Theme.TextMuted
	box.TextColor3 = MiltechUI.Theme.TextPrimary
	box.TextSize = 12
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Parent = window.Container
	
	-- Padding boundary
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Parent = box
	
	-- Visual feedback loops
	box.Focused:Connect(function()
		MiltechUI.Animations.Tween(stroke, {Color = MiltechUI.Theme.Border}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end)

	box.FocusLost:Connect(function()
		MiltechUI.Animations.Tween(stroke, {Color = MiltechUI.Theme.BorderDim}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end)
	
	-- Enforce character limits strictly
	box:GetPropertyChangedSignal("Text"):Connect(function()
		if #box.Text > maxChars then
			box.Text = string.sub(box.Text, 1, maxChars)
		end
	end)
	
	self.Instance = box
	return self
end

function InputField:GetText(): string
	return self.Instance.Text
end

return InputField
