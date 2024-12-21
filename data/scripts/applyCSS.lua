local keys = {"player1", "player2", "gfVersion"}
local name = "siblings"
local placeholders = {
	poyo = "pico",
	may = "bf"
}

function create()
	local char = placeholders[global.selectedCharacter]
	if char == PlayState.SONG.player1 then
		PlayState.SONG.player1 = global.selectedCharacter
	end
end