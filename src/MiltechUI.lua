--!strict
local MiltechUI = {}
MiltechUI.__index = MiltechUI

-- Framework Theme Configuration (Modern Miltech)
MiltechUI.Theme = {
	Background = Color3.fromRGB(10, 14, 16),      -- Deep tactical obsidian
	Border = Color3.fromRGB(0, 163, 255),         -- Holographic tactical blue
	BorderDim = Color3.fromRGB(0, 60, 90),        -- Unfocused/Background border
	TextPrimary = Color3.fromRGB(240, 244, 248),  -- Crisp data white
	TextMuted = Color3.fromRGB(110, 125, 135),    -- Sub-text/Coordinates
	AccentA = Color3.fromRGB(0, 255, 140),        -- Status: Nominal/Safe (Green)
	AccentB = Color3.fromRGB(255, 180, 0),          -- Status: Warning/Caution (Orange)
	AccentC = Color3.fromRGB(255, 0, 75),          -- Status: Critical/Alert (Red)
	FontMain = Enum.Font.RobotoMono,              -- Fixed-width data font
	FontBold = Enum.Font.SourceSansBold,
}

-- Initialize Player GUI Container
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

return MiltechUI
