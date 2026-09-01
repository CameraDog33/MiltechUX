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

local demoWindow = Window.new(UI, "Demo Console", UDim2.new(0, 420, 0, 320), UDim2.new(0.5, -210, 0.5, -160))
local nameInput = InputField.new(demoWindow, "player_name", UDim2.new(0, 0, 0, 36), UDim2.new(0, 400, 0, 28), 24)
local health = Status.new(demoWindow, "Integrity", UDim2.new(0, 0, 0, 72), UDim2.new(0, 400, 0, 16))
health:Update(0.76)

local function onConfirm()
	print("Action confirmed")
	health:Update(1)
end
local function onCancel()
	print("Action cancelled")
end

local demoBtn = Btn.new(demoWindow, "Open Modal", UDim2.new(0, 0, 0, 100), UDim2.new(0, 160, 0, 30), function()
	Dialog.new(UI, "Execute high-impact visual sequence?", onConfirm, onCancel)
end)

MiltechUI.Animations.SmoothUDim2(demoWindow.Instance, "Position", UDim2.new(0.5, -210, 0.5, -160), 0.45)

print("MiltechUI executor example initialized (raw HTTP loader).")
