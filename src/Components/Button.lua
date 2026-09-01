--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)
local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

function Button.new(window: any, text: string, position: UDim2, size: UDim2, callback: () -> ())
	local self = setmetatable({}, Button)
	
	local btn = Instance.new("TextButton")
	btn.Name = text .. "_Btn"
	btn.Size = size
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(20, 26, 30)
	btn.AutoButtonColor = false
	btn.Font = MiltechUI.Theme.FontMain
	btn.Text = "  > " .. string.upper(text)
	btn.TextColor3 = MiltechUI.Theme.TextPrimary
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = window.Container
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Parent = btn
	
	-- Interactive Micro-Animations
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = MiltechUI.Theme.BorderDim}):Play()
		TweenService:Create(stroke, tweenInfo, {Color = MiltechUI.Theme.Border}):Play()
	end)
	
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(20, 26, 30)}):Play()
		TweenService:Create(stroke, tweenInfo, {Color = MiltechUI.Theme.BorderDim}):Play()
	end)
	
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = MiltechUI.Theme.Border}):Play()
		btn.TextColor3 = MiltechUI.Theme.Background
	end)
	
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = MiltechUI.Theme.BorderDim}):Play()
		btn.TextColor3 = MiltechUI.Theme.TextPrimary
		callback() -- Execute logic
	end)
	
	self.Instance = btn
	return self
end

return Button
