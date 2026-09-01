-- ExecutorExample.lua (Raw HTTP+loadstring executor loader)
-- Loads MiltechUI and components directly from the GitHub repo using HttpGet + loadstring
-- Usage (example):
-- local rawSource = game:HttpGet("https://raw.githubusercontent.com/CameraDog33/MiltechUX/refs/heads/main/src/MiltechUI.lua")
-- local MiltechUI = loadstring(rawSource)()

local HttpServiceGet = function(url)
	-- prefer game:HttpGet but fall back to syn/http_request if available
	if type(game.HttpGet) == "function" then
		return game:HttpGet(url)
	elseif type(http_request) == "function" then
		local ok, res = pcall(function() return http_request({Url = url}).Body end)
		if ok then return res end
	end
	error("No HttpGet available in this executor environment")
end

local baseRaw = "https://raw.githubusercontent.com/CameraDog33/MiltechUX/refs/heads/main/src/"

-- Fetch and load the core MiltechUI module
local miltechRaw = HttpServiceGet(baseRaw .. "MiltechUI.lua")
local MiltechUI = assert(loadstring(miltechRaw), "Failed to compile MiltechUI source")()

-- Helper to fetch a component, patch its top-level require of MiltechUI, and execute it
local function fetchComponent(path)
	local raw = HttpServiceGet(baseRaw .. path .. ".lua")
	-- Replace common require pattern so the component can accept MiltechUI via vararg
	raw = raw:gsub("local%s+MiltechUI%s*=%s*require%([^%)]+%)", "local MiltechUI = ...")
	local fn = assert(loadstring(raw), "Failed to compile component: " .. path)
	local ok, comp = pcall(fn, MiltechUI)
	if not ok then error("Component execution error (" .. path .. "): " .. tostring(comp)) end
	return comp
end

local Window = fetchComponent("Components/Window")
local Btn = fetchComponent("Components/Button")
local InputField = fetchComponent("Components/inputField")
local Status = fetchComponent("Components/StatusDisplay")
local Dialog = fetchComponent("Components/DialogueModal")
local Viewport = fetchComponent("Components/Viewport")
local Switch = fetchComponent("Components/Switch")
local Slider = fetchComponent("Components/Slider")
local Dropdown = fetchComponent("Components/Dropdown")
local Tooltip = fetchComponent("Components/Tooltip")
local Toast = fetchComponent("Components/Toast")
local Tabs = fetchComponent("Components/Tabs")

-- Resolve LocalPlayer (poll briefly)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local attempts = 0
while not player and attempts < 50 do
	wait(0.1)
	player = Players.LocalPlayer
	attempts = attempts + 1
end

-- Executor-specific fallbacks
if not player then
	if type(getgenv) == "function" and getgenv().LocalPlayer then
		player = getgenv().LocalPlayer
	elseif shared and shared.LocalPlayer then
		player = shared.LocalPlayer
	end
end

if not player then
	error("ExecutorExample: Could not resolve LocalPlayer. Ensure this runs in a client executor with LocalPlayer available.")
end

-- Initialize UI
local UI = MiltechUI.new(player)
UI.Sounds:SetSound("Click", "rbxassetid://12345678")
UI.Sounds:SetSound("Hover", "rbxassetid://23456789")

local demoWindow = Window.new(UI, "Demo Console", UDim2.new(0, 640, 0, 420), UDim2.new(0.5, -320, 0.5, -210))

-- Left column controls
local nameInput = InputField.new(demoWindow, "player_name", UDim2.new(0, 8, 0, 36), UDim2.new(0, 300, 0, 28), 24)
local health = Status.new(demoWindow, "Integrity", UDim2.new(0, 8, 0, 72), UDim2.new(0, 300, 0, 16))
health:Update(0.76)

local demoBtn = Btn.new(demoWindow, "Open Modal", UDim2.new(0, 8, 0, 110), UDim2.new(0, 180, 0, 32), function()
	Dialog.new(UI, "Execute high-impact visual sequence?", function() health:Update(1); Toast.show(UI, "Confirmed", 2) end, function() Toast.show(UI, "Cancelled", 2) end)
	Toast.show(UI, "Modal opened", 2)
end)
Tooltip.attach(demoBtn.Instance, "Open a confirmation modal")

-- Right column: viewport + controls
local vp = Viewport.new(demoWindow, UDim2.new(0, 320, 0, 20), UDim2.new(0, 300, 0, 220), "Preview")

-- Build tiny sample model for the viewport (simple holo-cube)
local sampleModel = Instance.new("Model")
local part = Instance.new("Part")
part.Size = Vector3.new(2,2,2)
part.Anchored = true
part.Color = Color3.fromRGB(70,200,255)
part.Material = Enum.Material.Neon
part.Position = Vector3.new(0,0,0)
part.Parent = sampleModel

vp:SetModel(sampleModel)

-- Switch demo
local switch = Switch.new(demoWindow, UDim2.new(0, 8, 0, 150), UDim2.new(0, 40, 0, 18), false, function(state)
	print("Switch state:", state)
	Toast.show(UI, state and "Switch: ON" or "Switch: OFF", 1.6)
end)

-- Slider demo (min 0, max 100)
local slider = Slider.new(demoWindow, UDim2.new(0, 8, 0, 186), UDim2.new(0, 300, 0, 32), 0, 100, 42, function(value)
	print("Slider value:", math.floor(value))
end)

-- Dropdown demo
local dropdown = Dropdown.new(demoWindow, "Mode", UDim2.new(0, 8, 0, 230), UDim2.new(0, 300, 0, 28), {"Alpha","Beta","Gamma"}, function(selection)
	print("Dropdown selected:", selection)
	Toast.show(UI, "Selected: " .. selection, 2)
end)

-- Tabs demo (below viewport)
local tabs = Tabs.new(demoWindow, UDim2.new(0, 320, 0, 250), UDim2.new(0, 300, 0, 140), {"Info","Controls"})
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -12, 1, -12)
infoLabel.Position = UDim2.new(0, 6, 0, 6)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Preview pane and basic controls. Use the switch and slider to interact."
infoLabel.Font = MiltechUI.Theme.FontMain
infoLabel.TextColor3 = MiltechUI.Theme.TextMuted
infoLabel.TextWrapped = true
infoLabel.Parent = tabs.Pages["Info"]

-- Entrance
MiltechUI.Animations.SmoothUDim2(demoWindow.Instance, "Position", UDim2.new(0.5, -320, 0.5, -210), 0.45)

print("MiltechUI executor example updated with Viewport, Switch, Slider, Dropdown, Tabs, Tooltip, and Toast demos.")
