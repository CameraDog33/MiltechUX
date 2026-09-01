MiltechUI — Lightweight visual UX framework
=========================================

Overview
--------
MiltechUI is a small, theme-driven UI framework for Roblox focused on punchy visual style and consistent micro-animations. It exposes a core MiltechUI module plus many component modules (Window, Button, InputField, StatusDisplay, Viewport, Switch, Slider, Dropdown, Tooltip, Toast, Tabs, DialogueModal, etc.). Use it in Studio as ModuleScripts or load it at runtime from raw GitHub via HttpGet/loadstring (executor-friendly example provided).

Quick start — LocalScript (recommended for development)
------------------------------------------------------
Place MiltechUI.lua and the Components folder under ReplicatedStorage or under a ModuleScripts folder. Example LocalScript:

local MiltechUI = require(game.ReplicatedStorage.MiltechUI)
local Window = require(game.ReplicatedStorage.Components.Window)
local Button = require(game.ReplicatedStorage.Components.Button)

local player = game.Players.LocalPlayer
local UI = MiltechUI.new(player)
local window = Window.new(UI, "Demo", UDim2.new(0,420,0,320), UDim2.new(0.5,-210,0.5,-160))
local btn = Button.new(window, "Do Thing", UDim2.new(0,8,0,40), UDim2.new(0,180,0,28), function() print("clicked") end)

Executor / raw-HTTP loader
--------------------------
An executor-friendly example is included at src/ExecutorExample.lua. Core pattern:

local raw = game:HttpGet("https://raw.githubusercontent.com/CameraDog33/MiltechUX/refs/heads/main/src/MiltechUI.lua")
local MiltechUI = loadstring(raw)()

-- fetch components similarly and patch top-level require to accept MiltechUI

Core API (high level)
---------------------
- MiltechUI.new(player) -> core instance (contains ScreenGui, Sounds, Animations)
- core.Sounds:SetSound(key, "rbxassetid://...")
- MiltechUI.Animations.Tween(instance, props, time, style, direction)
- MiltechUI.Animations.SmoothUDim2(instance, propName, targetUDim2, duration)

Common components (constructor signature)
----------------------------------------
- Window.new(core, title, size:UDim2, position:UDim2)
- Button.new(window, text, position:UDim2, size:UDim2, callback)
- inputField.new(window, placeholder, position, size, maxChars)
- StatusDisplay.new(window, labelText, position, size) -> :Update(percentage)
- Viewport.new(window, position, size, title?) -> :SetModel(model), :Clear()
- Switch.new(window, position, size, initialBool, callback(state))
- Slider.new(window, position, size, min, max, initial, callback(value))
- Dropdown.new(window, label, position, size, itemsTable, callback(selected))
- Tooltip.attach(guiObject, "text")
- Toast.show(core, "message", duration)
- Tabs.new(window, position, size, {"Tab A","Tab B"})
- DialogueModal.new(core, message, onConfirm, onCancel)

Theming & customization
-----------------------
- MiltechUI.Theme table holds colors and FontMain. Edit the Theme before creating UI instances to customize look globally.
- Sounds: replace placeholder rbxassetid:// values via UI.Sounds:SetSound(key, id)

Testing & notes
---------------
- Executor raw-HTTP loading requires outbound HTTP from the executor environment.
- The example files contain explicit fallbacks and helpful warnings when LocalPlayer or HttpGet are unavailable.
- Sizes and spacing use UDim2 offsets; tweak component positioning in the example to suit target layouts.

Contributing
------------
- Add components under src/Components. Follow existing style: use MiltechUI.Theme, MiltechUI.Animations, and return a module table with :new and any public methods.
- Keep changes small and focused; update README with any API changes.

License
-------
MIT

