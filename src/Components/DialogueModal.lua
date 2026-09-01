--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)
local TweenService = game:GetService("TweenService")

local DialogModal = {}
DialogModal.__index = DialogModal

function DialogModal.new(core: any, message: string, onConfirm: () -> (), onCancel: () -> ())
	local self = setmetatable({}, DialogModal)
	
	-- Darken out the screen underneath
	local shade = Instance.new("TextButton")
	shade.Name = "Modal_Dimmer"
	shade.Size = UDim2.new(1, 0, 1, 0)
	shade.BackgroundColor3 = Color3.fromRGB(5, 7, 8)
	shade.BackgroundTransparency = 0.6
	shade.Text = ""
	shade.AutoButtonColor = false
	shade.Parent = core.ScreenGui
	
	-- Alert Panel Box
	local box = Instance.new("Frame")
	box.Name = "Alert_Box"
	box.Size = UDim2.new(0, 320, 0, 140)
	box.Position = UDim2.new(0.5, -160, 0.5, -70)
	box.BackgroundColor3 = MiltechUI.Theme.Background
	box.Parent = shade
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = MiltechUI.Theme.AccentB -- High-visibility Warning Orange
	stroke.Parent = box
	
	local msgLabel = Instance.new("TextLabel")
	msgLabel.Size = UDim2.new(1, -24, 0, 60)
	msgLabel.Position = UDim2.new(0, 12, 0, 15)
	msgLabel.BackgroundTransparency = 1
	msgLabel.Font = MiltechUI.Theme.FontMain
	msgLabel.Text = string.upper("!! NOTICE !!\n" .. message)
	msgLabel.TextColor3 = MiltechUI.Theme.TextPrimary
	msgLabel.TextSize = 12
	msgLabel.TextWrapped = true
	msgLabel.Parent = box
	
	-- Abstracting button framework wrapper logic inline natively
	local function createBtn(text: string, xOffset: number, color: Color3, callback: () -> ())
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 120, 0, 30)
		btn.Position = UDim2.new(0.5, xOffset, 1, -45)
		btn.BackgroundColor3 = Color3.fromRGB(20, 24, 28)
		btn.Font = MiltechUI.Theme.FontMain
		btn.Text = string.upper(text)
		btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		btn.TextSize = 11
		btn.Parent = box
		
		local bStroke = Instance.new("UIStroke")
		bStroke.Thickness = 1
		bStroke.Color = color
		bStroke.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			shade:Destroy()
			callback()
		end)
	end
	
	createBtn("PROCEED", -130, MiltechUI.Theme.AccentB, onConfirm)
	createBtn("ABORT", 10, MiltechUI.Theme.TextMuted, onCancel)
	
	return self
end

return DialogModal
