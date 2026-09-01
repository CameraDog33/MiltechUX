--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Tabs = {}
Tabs.__index = Tabs

function Tabs.new(window: any, position: UDim2, size: UDim2, tabs: {string})
	local self = setmetatable({}, Tabs)

	local container = Instance.new("Frame")
	container.Size = size
	container.Position = position
	container.BackgroundTransparency = 1
	container.Parent = window.Container

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 28)
	header.BackgroundTransparency = 1
	header.Parent = container

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -32)
	content.Position = UDim2.new(0, 0, 0, 32)
	content.BackgroundTransparency = 1
	content.Parent = container

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Parent = header

	local pages = {}
	local current = nil

	for i, name in ipairs(tabs) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 140, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = name
		btn.Font = MiltechUI.Theme.FontMain
		btn.TextSize = 13
		btn.TextColor3 = MiltechUI.Theme.TextMuted
		btn.Parent = header

		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = content

		pages[name] = page

		btn.MouseButton1Click:Connect(function()
			if current == name then return end
			if current then pages[current].Visible = false end
			pages[name].Visible = true
			current = name
			-- header color feedback
			for _, child in ipairs(header:GetChildren()) do
				if child:IsA("TextButton") then child.TextColor3 = MiltechUI.Theme.TextMuted end
			end
			btn.TextColor3 = MiltechUI.Theme.TextPrimary
		end)
	end

	-- open first
	if #tabs > 0 then header:GetChildren()[1].MouseButton1Click:Wait() end

	self.Instance = container
	self.Pages = pages
	return self
end

return Tabs
