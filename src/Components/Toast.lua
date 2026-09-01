--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Toast = {}
Toast.__index = Toast

local stack = {}
local maxToasts = 4

function Toast.show(core: any, text: string, duration: number?)
	duration = duration or 3
	local screen = core and core.ScreenGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	local container = screen:FindFirstChild("Miltech_Toasts")
	if not container then
		container = Instance.new("Frame")
		container.Name = "Miltech_Toasts"
		container.Size = UDim2.new(0, 300, 0, maxToasts * 60)
		container.Position = UDim2.new(1, -310, 0, 20)
		container.BackgroundTransparency = 1
		container.Parent = screen
	end

	local t = Instance.new("Frame")
	t.Size = UDim2.new(1, 0, 0, 48)
	t.BackgroundColor3 = Color3.fromRGB(10, 14, 16)
	t.BorderSizePixel = 0
	t.AnchorPoint = Vector2.new(0,0)
	t.LayoutOrder = #stack + 1
	t.Parent = container

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1, -16, 1, 0)
	msg.Position = UDim2.new(0, 8, 0, 0)
	msg.BackgroundTransparency = 1
	msg.Text = text
	msg.Font = MiltechUI.Theme.FontMain
	msg.TextSize = 12
	msg.TextColor3 = MiltechUI.Theme.TextPrimary
	msg.TextWrapped = true
	msg.Parent = t

	local stroke = Instance.new("UIStroke")
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Thickness = 1
	stroke.Parent = t

	table.insert(stack, t)
	MiltechUI.Animations.Tween(t, {Position = UDim2.new(0,0,0, (#stack-1)*52)}, 0.18)

	delay(duration, function()
		MiltechUI.Animations.Tween(t, {BackgroundTransparency = 1}, 0.18)
		delay(0.18, function()
			pcall(function() t:Destroy() end)
			table.remove(stack, 1)
			-- reflow
			for i, v in ipairs(stack) do
				MiltechUI.Animations.Tween(v, {Position = UDim2.new(0,0,0,(i-1)*52)}, 0.12)
			end
		end)
	end)

	return t
end

return Toast
