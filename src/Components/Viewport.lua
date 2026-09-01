--!strict
local MiltechUI = require(script.Parent.Parent.MiltechUI)

local Viewport = {}
Viewport.__index = Viewport

function Viewport.new(window: any, position: UDim2, size: UDim2, title: string?)
	local self = setmetatable({}, Viewport)

	local container = Instance.new("Frame")
	container.Size = size
	container.Position = position
	container.BackgroundColor3 = Color3.fromRGB(12, 16, 20)
	container.BorderSizePixel = 0
	container.Parent = window.Container

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = MiltechUI.Theme.BorderDim
	stroke.Parent = container

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 18)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundTransparency = 1
	header.Text = title and string.upper(title) or "VIEWPORT"
	header.Font = MiltechUI.Theme.FontMain
	header.TextSize = 11
	header.TextColor3 = MiltechUI.Theme.TextMuted
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = container

	local vp = Instance.new("ViewportFrame")
	vp.Size = UDim2.new(1, -8, 1, -26)
	vp.Position = UDim2.new(0, 4, 0, 22)
	vp.BackgroundColor3 = Color3.fromRGB(6, 8, 10)
	vp.BorderSizePixel = 0
	vp.Parent = container

	local cam = Instance.new("Camera")
	cam.Parent = vp
	vp.CurrentCamera = cam

	self.Instance = container
	self.Viewport = vp
	self.Camera = cam
	self.Model = nil
	return self
end

function Viewport:SetModel(model: Model)
	-- clear existing
	for _, v in pairs(self.Viewport:GetChildren()) do
		if not v:IsA("Camera") then v:Destroy() end
	end

	if model then
		local clone = model:Clone()
		clone.Parent = self.Viewport
		self.Model = clone
		-- try a simple auto-focus
		local bounds = clone:GetExtentsSize()
		local lookAt = clone:GetModelCFrame().p
		local dist = math.max(bounds.X, bounds.Y, bounds.Z) * 2 + 6
		self.Camera.CFrame = CFrame.new(lookAt + Vector3.new(dist, dist, dist), lookAt)
	end
end

function Viewport:Clear()
	if self.Model then self.Model:Destroy() end
	self.Model = nil
end

return Viewport
