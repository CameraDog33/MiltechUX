--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Tooltip = {}
Tooltip.__index = Tooltip

-- Attach a tooltip to an instance (hover shows text). parentInstance should be a GUI object.
function Tooltip.attach(parentInstance: Instance, text: string)
	local gui = parentInstance:FindFirstAncestorOfClass("ScreenGui") or parentInstance.Parent
	if not gui then return end

	local tip = Instance.new("TextLabel")
	tip.Name = "MiltechTooltip"
	tip.Size = UDim2.new(0, 200, 0, 28)
	tip.BackgroundColor3 = Color3.fromRGB(6, 8, 10)
	tip.BackgroundTransparency = 0
	tip.TextColor3 = MiltechUI.Theme.TextPrimary
	tip.Text = text
	tip.Font = MiltechUI.Theme.FontMain
	tip.TextSize = 12
	tip.Visible = false
	tip.ZIndex = 1000
	tip.Parent = gui

	local stroke = Instance.new("UIStroke")
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Thickness = 1
	stroke.Parent = tip

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.Parent = tip

	local function positionFor(input)
		local x = math.clamp(input.Position.X, 10, math.max(10, gui.AbsoluteSize.X - 210))
		local y = input.Position.Y - 36
		return UDim2.new(0, x, 0, y)
	end

	parentInstance.MouseEnter:Connect(function()
		local pos = parentInstance.AbsolutePosition and {Position = parentInstance.AbsolutePosition} or {Position = Vector2.new(0,0)}
		local p = positionFor(pos)
		tip.Position = p
		tip.Visible = true
		MiltechUI.Animations.Tween(tip, {BackgroundTransparency = 0}, 0.12)
	end)
	parentInstance.MouseLeave:Connect(function()
		MiltechUI.Animations.Tween(tip, {BackgroundTransparency = 1}, 0.12)
		delay(0.12, function() tip.Visible = false end)
	end)

	return tip
end

return Tooltip
