--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Window = {}
Window.__index = Window

function Window.new(core: any, title: string, size: UDim2, position: UDim2)
	local self = setmetatable({}, Window)
	
	-- Main Panel Background
	local mainPanel = Instance.new("Frame")
	mainPanel.Name = title .. "_Panel"
	mainPanel.Size = size
	mainPanel.Position = position
	mainPanel.BackgroundColor3 = MiltechUI.Theme.Background
	mainPanel.BackgroundTransparency = 0.15
	mainPanel.BorderSizePixel = 1
	mainPanel.BorderColor3 = MiltechUI.Theme.BorderDim
	mainPanel.Parent = core.ScreenGui
	
	-- Angular Tactical Border UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.Border
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = mainPanel
	
	-- Header Bar
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BackgroundColor3 = MiltechUI.Theme.BorderDim
	header.BackgroundTransparency = 0.4
	header.BorderSizePixel = 0
	header.Parent = mainPanel
	
	-- Header Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
	titleLabel.Position = UDim2.new(0, 8, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = string.upper("SYS // " .. title)
	titleLabel.TextColor3 = MiltechUI.Theme.TextPrimary
	titleLabel.Font = MiltechUI.Theme.FontMain
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	-- Corner Diagnostic String (Simulating systemic HUD data)
	local diagLabel = Instance.new("TextLabel")
	diagLabel.Size = UDim2.new(0.3, -8, 1, 0)
	diagLabel.Position = UDim2.new(0.7, 0, 0, 0)
	diagLabel.BackgroundTransparency = 1
	diagLabel.Text = "LOC_ERR // 0x00"
	diagLabel.TextColor3 = MiltechUI.Theme.TextMuted
	diagLabel.Font = MiltechUI.Theme.FontMain
	diagLabel.TextSize = 10
	diagLabel.TextXAlignment = Enum.TextXAlignment.Right
	diagLabel.Parent = header

	-- Content Container Frame for nesting items inside
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -16, 1, -41)
	container.Position = UDim2.new(0, 8, 0, 33)
	container.BackgroundTransparency = 1
	container.Parent = mainPanel

	self.Instance = mainPanel
	self.Container = container
	return self
end

return Window
