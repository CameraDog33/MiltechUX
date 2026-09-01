--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(window: any, labelText: string, position: UDim2, size: UDim2, items: {string}, callback: (string)->())
	local self = setmetatable({}, Dropdown)

	local container = Instance.new("Frame")
	container.Size = size
	container.Position = position
	container.BackgroundTransparency = 1
	container.Parent = window.Container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 14)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(labelText)
	label.Font = MiltechUI.Theme.FontMain
	label.TextSize = 11
	label.TextColor3 = MiltechUI.Theme.TextMuted
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 26)
	button.Position = UDim2.new(0, 0, 0, 18)
	button.BackgroundColor3 = Color3.fromRGB(18, 22, 26)
	button.Text = "Select..."
	button.Font = MiltechUI.Theme.FontMain
	button.TextSize = 12
	button.TextColor3 = MiltechUI.Theme.TextPrimary
	button.AutoButtonColor = false
	button.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Parent = button

	local menu = Instance.new("Frame")
	menu.Size = UDim2.new(1, 0, 0, 0)
	menu.Position = UDim2.new(0, 0, 0, 44)
	menu.BackgroundColor3 = Color3.fromRGB(12, 16, 20)
	menu.Visible = false
	menu.ClipsDescendants = true
	menu.Parent = container

	local layout = Instance.new("UIListLayout")
	layout.Parent = menu
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local function showMenu()
		menu.Visible = true
		MiltechUI.Animations.Tween(menu, {Size = UDim2.new(1, 0, 0, math.min(#items * 26, 200))}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		MiltechUI.Animations.Tween(button, {BackgroundColor3 = MiltechUI.Theme.BorderDim}, 0.12)
	end
	local function hideMenu()
		MiltechUI.Animations.Tween(menu, {Size = UDim2.new(1, 0, 0, 0)}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		delay(0.12, function() menu.Visible = false end)
		MiltechUI.Animations.Tween(button, {BackgroundColor3 = Color3.fromRGB(18,22,26)}, 0.12)
	end

	for i, v in ipairs(items) do
		local it = Instance.new("TextButton")
		it.Size = UDim2.new(1, 0, 0, 26)
		it.BackgroundTransparency = 1
		it.Text = v
		it.Font = MiltechUI.Theme.FontMain
		it.TextSize = 12
		it.TextColor3 = MiltechUI.Theme.TextPrimary
		it.TextXAlignment = Enum.TextXAlignment.Left
		it.Parent = menu
		it.MouseButton1Click:Connect(function()
			button.Text = v
			hideMenu()
			if callback then pcall(callback, v) end
		end)
	end

	button.MouseButton1Click:Connect(function()
		if menu.Visible then hideMenu() else showMenu() end
	end)

	self.Instance = container
	return self
end

return Dropdown
