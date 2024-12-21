local CharSelect = require"states.characterselect"

local triggerChoices = {
	storymode = {true, function(state)
		game.switchState(StoryMenuState())
	end},
	freeplay = {true, function(state)
		game.switchState(FreeplayState())
	end},
	credits = {true, function(state)
		game.switchState(CreditsState())
	end},
	options = {false, function(state)
		if state.buttons then state:remove(state.buttons) end
		state.optionsUI = state.optionsUI or Options(true, function()
			state.menuList.lock = false

			if Discord then
				Discord.changePresence({details = "In the Menus", state = "Main Menu"})
			end
			if state.buttons then state:add(state.buttons) end
		end)
		state.optionsUI.applySettings = bind(state, state.onSettingChange)
		state.optionsUI:setScrollFactor()
		state.optionsUI:screenCenter()
		state:add(state.optionsUI)
		return false
	end},
	donate = {true, function(state)
		game.switchState(CharSelect())
	end}
}

local function enterSelection(choice)
	local switch = triggerChoices[choice]
	state.selectedSomethin = true

	game.sound.play(paths.getSound('confirmMenu'))
	local flicker = Flicker(state.menuBg, switch[1] and 1.1 or 1, 0.15, true)
	local magenta = false
	flicker.onFlicker = function()
		magenta = not magenta
		state.menuBg:loadTexture(magenta and state.menuMagenta or state.menuYellow)
	end
	flicker.completionCallback = function()
		state.menuBg:loadTexture(state.menuYellow)
	end

	local selectedItem = state.menuList.members[state.menuList.curSelected]
	Flicker(selectedItem, 1, 0.05, not switch[1], false, function()
		state.selectedSomethin = not switch[2](state)
	end)
	for _, spr in ipairs(state.menuList.members) do
		if switch[1] and state.menuList.curSelected ~= spr.ID then
			Tween.tween(spr, {alpha = 0}, 0.4, {
				ease = "quadOut",
				onComplete = function()
					spr:destroy()
				end
			})
		end
	end
end


function postCreate()
	state.menuList.selectCallback = function(menuItem)
		enterSelection(state.menuItems[menuItem.ID])
	end
end