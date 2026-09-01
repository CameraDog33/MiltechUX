--!strict
local MiltechUI = {}
MiltechUI.__index = MiltechUI

-- Framework Global Theme Configuration
MiltechUI.Theme = {
	Background = Color3.fromRGB(10, 14, 16),
	Border = Color3.fromRGB(0, 163, 255),
	BorderDim = Color3.fromRGB(0, 60, 90),
	TextPrimary = Color3.fromRGB(240, 244, 248),
	TextMuted = Color3.fromRGB(110, 125, 135),
	AccentA = Color3.fromRGB(0, 255, 140),
	AccentB = Color3.fromRGB(255, 180, 0),
	AccentC = Color3.fromRGB(255, 0, 75),
	FontMain = Enum.Font.RobotoMono,
}

-- Core HUD Container Factory
function MiltechUI.new(player: Player)
	local self = setmetatable({}, MiltechUI)
	local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Miltech_HUD_System"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	self.ScreenGui = screenGui
	return self
end

--------------------------------------------------------------------------------
-- SUB-COMPONENTS BOUND DIRECTLY TO THE FRAMEWORK OBJECT
--------------------------------------------------------------------------------
MiltechUI.Window = {}
MiltechUI.Window.__index = MiltechUI.Window

function MiltechUI.Window.new(core: any, title: string, size: UDim2, position: UDim2)
	local self = setmetatable({}, MiltechUI.Window)
	
	local mainPanel = Instance.new("Frame")
	mainPanel.Name = title .. "_Panel"
	mainPanel.Size = size
	mainPanel.Position = position
	mainPanel.BackgroundColor3 = MiltechUI.Theme.Background
	mainPanel.BackgroundTransparency = 0.15
	mainPanel.BorderSizePixel = 1
	mainPanel.BorderColor3 = MiltechUI.Theme.BorderDim
	mainPanel.Parent = core.ScreenGui
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.Border
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = mainPanel
	
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BackgroundColor3 = MiltechUI.Theme.BorderDim
	header.BackgroundTransparency = 0.4
	header.Parent = mainPanel
	
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

-- 2. Button Component Integration
MiltechUI.Button = {}
MiltechUI.Button.__index = MiltechUI.Button

function MiltechUI.Button.new(window: any, text: string, position: UDim2, size: UDim2, callback: () -> ())
	local self = setmetatable({}, MiltechUI.Button)
	local TweenService = game:GetService("TweenService")
	
	local btn = Instance.new("TextButton")
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
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = MiltechUI.Theme.BorderDim}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.15), {Color = MiltechUI.Theme.Border}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 26, 30)}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.15), {Color = MiltechUI.Theme.BorderDim}):Play()
	end)
	btn.MouseButton1Click:Connect(callback)
	
	self.Instance = btn
	return self
end

-- 3. DataGrid Component Integration
MiltechUI.DataGrid = {}
MiltechUI.DataGrid.__index = MiltechUI.DataGrid

function MiltechUI.DataGrid.new(window: any, position: UDim2, size: UDim2)
	local self = setmetatable({}, MiltechUI.DataGrid)
	
	local container = Instance.new("ScrollingFrame")
	container.Position = position
	container.Size = size
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 2
	container.ScrollBarImageColor3 = MiltechUI.Theme.BorderDim
	container.Parent = window.Container
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 2)
	layout.Parent = container
	
	self.Container = container
	self.Rows = {}
	return self
end

function MiltechUI.DataGrid:AddRow(key: string, initialValue: string)
	local rowFrame = Instance.new("Frame")
	rowFrame.Size = UDim2.new(1, -4, 0, 20)
	rowFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 24)
	rowFrame.BackgroundTransparency = 0.4
	rowFrame.Parent = self.Container
	
	local keyLabel = Instance.new("TextLabel")
	keyLabel.Size = UDim2.new(0.4, 0, 1, 0)
	keyLabel.Position = UDim2.new(0, 6, 0, 0)
	keyLabel.BackgroundTransparency = 1
	keyLabel.Font = MiltechUI.Theme.FontMain
	keyLabel.Text = string.upper(key)
	keyLabel.TextColor3 = MiltechUI.Theme.TextMuted
	keyLabel.TextSize = 11
	keyLabel.TextXAlignment = Enum.TextXAlignment.Left
	keyLabel.Parent = rowFrame
	
	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0.6, -12, 1, 0)
	valLabel.Position = UDim2.new(0.4, 6, 0, 0)
	valLabel.BackgroundTransparency = 1
	valLabel.Font = MiltechUI.Theme.FontMain
	valLabel.Text = string.upper(initialValue)
	valLabel.TextColor3 = MiltechUI.Theme.TextPrimary
	valLabel.TextSize = 11
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.Parent = rowFrame
	
	self.Rows[key] = valLabel
	self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIListLayout.AbsoluteContentSize.Y)
end

function MiltechUI.DataGrid:UpdateRow(key: string, newValue: string)
	if self.Rows[key] then self.Rows[key].Text = string.upper(newValue) end
end

-- Return the entire combined library table directly
return MiltechUI
