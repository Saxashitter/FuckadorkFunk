local CharSelect = State:extend"CharSelect"

CharSelect.characters = {}
CharSelect.curSel = 1

local function approach(from, to, speed)
	if from > to then
		return math.max(from-speed, to)
	end

	return math.min(from+speed, to)
end

local function charDef(self, id, dispname, bgtext)
	local sprite = Sprite()
	sprite:loadTexture(paths.getImage('css/'..id))
	sprite:setScrollFactor(0, 0)
	sprite:updateHitbox()
	sprite.x = 1280-16-sprite.width
	sprite.y = 16
	self:add(sprite)

	local char = {
		id = id,
		dispname = dispname,
		bgtext = bgtext,
		sprite = sprite
	}

	table.insert(self.characters, char)
	sprite.alpha = self.curSel == #self.characters and 1 or 0
end

local function changeSel(self, i)
	self.curSel = math.max(1, math.min(self.curSel+i, #self.characters))
end

function CharSelect:enter()
	self.menuBg = Sprite()
	self.menuBg:loadTexture(paths.getImage('menus/menuBG'))
	self.menuBg:setScrollFactor(0, 0)
	self.menuBg:updateHitbox()
	self.menuBg:screenCenter()

	self.characterText = Text(16, 16, "Character", paths.getFont("vcr.ttf", 64))
	self.characterText.antialiasing = false
	self.characterText.outline.width = 5
	self.characterText:setScrollFactor()

	self:add(self.menuBg)

	charDef(self, "poyo", "Poyo", "POWERHOUSE ")
	charDef(self, "may", "May", "KNOW-IT-ALL ")

	self:add(self.characterText)
	self.characterText.text = self.characters[self.curSel].dispname

	if love.system.getDevice() == "Mobile" then
		self.buttons = VirtualPadGroup()
		local w = 134

		local left = VirtualPad("left", 0, game.height - w)
		local right = VirtualPad("right", w, game.height - w)
		local enter = VirtualPad("return", game.width - w, right.y)
		local back = VirtualPad("escape", enter.x - w, right.y)
	
		enter.color = Color.LIME
		back.color = Color.RED

		self.buttons:add(left)
		self.buttons:add(right)

		self.buttons:add(enter)
		self.buttons:add(back)

		self:add(self.buttons)
	end
end

function CharSelect:update(dt)
	CharSelect.super.update(self, dt)

	local speed = 0.1
	for i,char in pairs(self.characters) do
		if i == self.curSel then
			char.sprite.alpha = approach(char.sprite.alpha, 1, 0.1)
		else
			char.sprite.alpha = approach(char.sprite.alpha, 0, 0.1)
		end
	end

	if controls:pressed("ui_right") then
		changeSel(self, 1)
	end
	if controls:pressed("ui_left") then
		changeSel(self, -1)
	end

	if controls:pressed("accept") then
		global.selectedCharacter = self.characters[self.curSel].id
		print(global.selectedCharacter)
		game.switchState(MainMenuState())
	end
end

return CharSelect