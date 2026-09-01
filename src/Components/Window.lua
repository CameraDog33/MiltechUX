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

		-- Make window draggable, dockable, and snap to grid
		local UserInputService = game:GetService("UserInputService")
		local dragging = false
		local dragInput = nil
		local dragStart = nil
		local startPos = nil
		local gridSize = 8 -- pixels
		local dockThreshold = 24 -- pixels to edge to auto-dock
	
		local function toUDim2(x, y)
			return UDim2.new(0, math.clamp(math.floor(x + 0.5), 0, mainPanel.Parent.AbsoluteSize.X - mainPanel.AbsoluteSize.X), 0, math.clamp(math.floor(y + 0.5), 0, mainPanel.Parent.AbsoluteSize.Y - mainPanel.AbsoluteSize.Y))
		end
	
		local function snapToGrid(val)
			return math.floor((val + gridSize / 2) / gridSize) * gridSize
		end
	
		local function bringToFront()
			local p = mainPanel.Parent
			pcall(function()
				mainPanel.Parent = nil
				mainPanel.Parent = p
			end)
		end
	
		header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragInput = input
				dragStart = Vector2.new(input.Position.X, input.Position.Y)
				startPos = Vector2.new(mainPanel.AbsolutePosition.X, mainPanel.AbsolutePosition.Y)
				bringToFront()
			end
		end)
	
		local dragConnection
		local function onInputChanged(input)
			if input == dragInput and dragging then
				local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
				local newX = startPos.X + delta.X
				local newY = startPos.Y + delta.Y
				-- clamp
				newX = math.clamp(newX, 0, mainPanel.Parent.AbsoluteSize.X - mainPanel.AbsoluteSize.X)
				newY = math.clamp(newY, 0, mainPanel.Parent.AbsoluteSize.Y - mainPanel.AbsoluteSize.Y)
				-- live snap to grid
				local snapX = snapToGrid(newX)
				local snapY = snapToGrid(newY)
				mainPanel.Position = toUDim2(snapX, snapY)
			end
		end
	
		header.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if dragConnection then dragConnection:Disconnect(); dragConnection = nil end
				dragConnection = UserInputService.InputChanged:Connect(function(i)
					onInputChanged(i)
				end)
			end
		end)
	
		UserInputService.InputEnded:Connect(function(input)
			if input == dragInput then
				dragging = false
				dragInput = nil
				if dragConnection then dragConnection:Disconnect(); dragConnection = nil end
				-- on release, perform edge docking
				local absPos = mainPanel.AbsolutePosition
				local absSize = mainPanel.AbsoluteSize
				local parentSize = mainPanel.Parent.AbsoluteSize
				local finalX = absPos.X
				local finalY = absPos.Y
				-- left
				if finalX <= dockThreshold then finalX = 8 end
				-- right
				if (parentSize.X - (finalX + absSize.X)) <= dockThreshold then finalX = parentSize.X - absSize.X - 8 end
				-- top
				if finalY <= dockThreshold then finalY = 8 end
				-- bottom
				if (parentSize.Y - (finalY + absSize.Y)) <= dockThreshold then finalY = parentSize.Y - absSize.Y - 8 end
				-- snap to grid for final
				finalX = snapToGrid(finalX)
				finalY = snapToGrid(finalY)
				mainPanel.Position = toUDim2(finalX, finalY)
			end
		end)
	
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
