local bump = require"libs.bump"
local blocks = {}
local world
local player

-- MESSY CODE, PURELY PLACEHOLDERS UNTIL WE GET THE ASSETS NEEDED

local function make_player(x, y)
	local width = 32
	local height = 32
	player = {
		x = x,
		y = y,
		width = width,
		height = height,
		momx = 0,
		momy = 0,
		sprite = Graphic(x, y, width, height, Color.RED)
	}
	state:add(player.sprite)
end

local function make_block(x, y, w, h)
	local block = {
		x = x,
		y = y,
		width = w,
		height = h,
		sprite = Graphic(x, y, w, h, Color.WHITE)
	}

	blocks[#blocks+1] = block
	state:add(block.sprite)
	world:add(block,
		block.x,
		block.y,
		block.width,
		block.height
	)
end

local function load_map()
	make_block(24, 1, 32, 32)
end

function create()
	blocks = {}
	world = bump.newWorld()

	game.camera.zoom = 1
	load_map()
	make_player(0, 0)

	local player = player
	local block = blocks[1]

	

	return Script.Event_Cancel
end

function update()
	
end