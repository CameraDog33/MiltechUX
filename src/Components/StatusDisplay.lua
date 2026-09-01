--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)
local TweenService = game:GetService("TweenService")

local StatusDisplay = {}
StatusDisplay.__index = StatusDisplay

function StatusDisplay.new(window: any, labelText: string, position: UDim2, size: UDim2)
	local self = setmetatable({}, StatusDisplay)
	
	-- Container Label
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 14)
	textLabel.Position = position
	textLabel.BackgroundTransparency = 1
	textLabel.Text = string.upper(labelText)
	textLabel.Font = MiltechUI.Theme.FontMain
	textLabel.TextSize = 11
	textLabel.TextColor3 = MiltechUI.Theme.TextMuted
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = window.Container
	
	-- Track Bar Background
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 8)
	track.Position = UDim2.new(0, 0, 0, 16)
	track.BackgroundColor3 = Color3.fromRGB(15, 20, 22)
	track.BorderSizePixel = 0
	track.Parent = textLabel
	
	-- Fill Bar
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = MiltechUI.Theme.AccentA
	fill.BorderSizePixel = 0
	fill.Parent = track
	
	self.Fill = fill
	return self
end

-- Methods to dynamically update fill percentage
function StatusDisplay:Update(percentage: number)
	local clamped = math.clamp(percentage, 0, 1)
	local targetColor = MiltechUI.Theme.AccentA
	
	if clamped < 0.25 then
		targetColor = MiltechUI.Theme.AccentC -- Critical low Alert
	elseif clamped < 0.6 then
		targetColor = MiltechUI.Theme.AccentB -- Caution Warning
	end
	
	TweenService:Create(self.Fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Size = UDim2.new(clamped, 0, 1, 0),
		BackgroundColor3 = targetColor
	}):Play()
end

return StatusDisplay
