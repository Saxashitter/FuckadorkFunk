local keys = {"player1", "player2", "gfVersion"}
local name = "siblings"
local placeholders = {
	poyo = "pico",
	may = "bf"
}

function create()
	local char = placeholders[global.selectedCharacter]
	for _,k in pairs(keys) do
		if PlayState.SONG[k] == name then
			PlayState.SONG[k] = char
		end
	end
end