-------------------
-- CONFIGURATION --
-------------------

-- The available built in colors are: 
-- "clear", "red", "green", "blue", "white", "black", "gray", "grey", "orange", "yellow", "green", "teal", "cyan", "purple" and "magenta"
-- You can create your own colors using the rgb(a) format by replacing "#" with "0x" eg. teal or #008080 would be written as 0x008080
-- The last two characters are for transparency eg. 80 = half transparency and FF = opaque 
-- A half transparent teal would be written as 0x00808080

local colors = {
	menuBackgroundColor = 0xFFFFFF80,
	menuTitleColor = "grey",
	menuSelectedColor = "green",
	menuUnselectedColor = "red",
	comboCounterActiveColour = "blue", -- Colour of the combo counter if the combo hasn't dropped
	inputHistoryA = "green", -- Colour of the letter A in the input history
	inputHistoryB = "blue", -- Colour of the letter B in the input history
	inputHistoryC = "red", -- Colour of the letter C in the input history
	inputHistoryS = "yellow" -- Colour of the letter S in the input history
}

-- Toggleable hud locations for input history

local hud = {
	scrollFromBottom = true, -- Toggles hud.scrolling the input history upwards or downwards
	xP1 = 13, -- X Position of the first frame of P1's input history.
	yP1 = 200, -- Y Position of the first frame of P1's input history. 207 and 70 are recommended for hud.scrolling from the bottom and top respectively.
	xP2 = 337, -- X Position of the first frame of P2's input history.
	yP2 = 200, -- Y Position of the first frame of P2's input history. 207 and 70 are recommended for hud.scrolling from the bottom and top respectively.
	offset = 3
}

-- These are the default values for the menu options and you can change them to what you desire
-- They will be replaced when the settings are saved to menu settings.txt

local options = {
	guardAction = 1,
	guardActionDelay = 0,
	airTech = true,
	airTechDirection = 1,
	airTechDelay = 0,
	mediumKickHotkey = 1,
	strongKickHotkey = 1,
	music = false,
	meterRefill = true,
	healthRefill = true,
	standGaugeRefill = true,
	guiStyle = 2,
	forceStand = 1,
	ips = true
}

-----------------------
-- END CONFIGURATION --
-----------------------

print("JoJo's Bizarre Adventure: Heritage for the Future Training Mode")
print("Credits to Maxie and the HFTF OCEANIA community for the current version with menu features.")
print("Credits to peon2 for programming, potatoboih for finding RAM values and Klofkac for the initial version.")
print("Special Thanks to Zarythe for graphical design and all the beta testers.")
print("Developed specifically for JoJo's Bizarre Adventure (Japan 990913, NO CD) (jojoban) though other versions should work.")
print("This script was designed for FBA-RR however the basic features should work for MAME-RR as well.")
print("Because of how knockdown is handled in JoJo, meaties may not behave as expected. Occasionally when the game is reset the script messes up, simply hit 'restart' in the lua script window to fix that")
--This script is not compressed or written efficiently as it is layed out to promote legibility.

print()
print("Commands List")
print()
print("Coin to open up the menu.")
print("Hold start control your opponent.")
print("Special functions are bound to Medium Kick and Heavy kick. The functions can be reassigned in the menu.")
print("Holding down replay button will make it loop.")
print("Pressing MK on the menu will restore p2 stand gauge")
print("Pressing HK on the menu will restore p1 stand gauge")

local optionType = {
	subMenu = 1,
	bool = 2,
	int = 3,
	list = 4,
	func = 5,
	info = 6,
	back = 7
}

local systemOptions = {
	{
		name = "Music:",
		key = "music",
		type = optionType.bool
	},
	{
		name = "Gui Style:",
		key = "guiStyle",
		type = optionType.list,
		list = {
			"None",
			"Simple",
			"Advanced",
			"P1 + P2"
		}
	},
	{
		name = "Heavy Kick Hotkey:",
		key = "mediumKickHotkey",
		type = optionType.list,
		list = {
			"Record"
		}
	},
	{
		name = "Strong Kick Hotkey:",
		key = "strongKickHotkey",
		type = optionType.list,
		list = {
			"Replay",
			"Input playback"
		}
	},
	{
		name = "Return",
		type = optionType.back
	}
}

local battleOptions = {
	{
		name = "Meter Refill:",
		key = "meterRefill",
		type = optionType.bool
	},
	{
		name = "Health Refill:",
		key = "healthRefill",
		type = optionType.bool
	},
	{
		name = "Stand Gauge Refill:",
		key = "standGaugeRefill",
		type = optionType.bool
	},
	{
		name = "IPS:",
		key = "ips",
		type = optionType.bool
	},
	{
		name = "Return",
		type = optionType.back
	},

}

local enemyOptions = {
	{
		name = "Guard Action",
		key = "guardAction",
		type = optionType.list,
		list = {
			"Default",
			"Push block",
			"Guard Cancel"
		}
	},
	{
		name = "Guard Action Delay:",
		key = "guardActionDelay",
		type = optionType.int,
		min = 0,
		max = 15
	},
	{
		name = "Air Tech:",
		key = "airTech",
		type = optionType.bool
	},
	{
		name = "Air Tech Direction:",
		key = "airTechDirection",
		type = optionType.list,
		list = {
			"Up/Neutral",
			"Down",
			"Toward",
			"Away"
		}
	},
	{
		name = "Air Tech Delay:",
		key = "airTechDelay",
		type = optionType.int,
		min = 0,
		max = 10
	},
	{
		name = "Force Stand:",
		key = "forceStand",
		type = optionType.list,
		list = {
			"Default",
			"On",
			"Off"
		}
	},
	{
		name = "Return",
		type = optionType.back
	}
}

local rootOptions = {
	{
		name = "Enemy Settings",
		type = optionType.subMenu,
		options = enemyOptions
	},
	{
		name = "Battle Settings",
		type = optionType.subMenu,
		options = battleOptions
	},
	{
		name = "System Settings",
		type = optionType.subMenu,
		options = systemOptions
	},
	{
		name = "Save Settings",
		type = optionType.func,
		func = function() writeSettings() end
	},
	{
		name = "About",
		type = optionType.info,
		infos = {
			"Credits to Maxie and the HFTF OCEANIA",
			"Community for the current release.",
			"Credits to peon2, potatoboih, Klofkac and",
			"Zarythe for the initial version.",
			"This script is still undergoing development.",
			"For bug reports and feature requests please",
			"DM Maxie#7777 on discord.",
			"Thank you!"
		}
	},
	{
		name = "Return",
		type = optionType.back
	}
}

local infoOptions = {
	{
		name = "Return",
		type = optionType.back
	}
}

local menu = {
	state = 0, --0 = closed, 1 = top menu, 2 = sub menu
	index = 1,
	previousIndex = 1,
	options = rootOptions,
	title = "Training Menu",
	info = ""
}

local parserDictionary = {
	u = 0x01,
	d = 0x02,
	l = 0x04,
	r = 0x08,
	a = 0x10,
	b = 0x20,
	c = 0x40,
	s = 0x80
}

local p1 = {
	health = 0, 
	previousHealth = 0,
	damage = 0,
	previousDamage = 0,
	comboDamage = 0,
	standHealth = 0,
	standGauge = 0,
	standGaugeMax = 0,
	combo = 0,
	previousCombo = 0,
	control = false,
	previousControl = false,
	directionLock = 0,
	directionLockFacing = 0,
	inputs = 0,
	previousInputs = 0,
	recording = false,
	loop = false,
	displayComboCounter = 0,
	comboCounterColor = "white",
	recorded = {},
	recordedFacing = 0,
	inputPlayback = nil,
	inputPlaybackFacing = 0,
	inputHistoryTable = {},
	playback = nil,
	playbackCount = 0,
	playbackFacing = 0,
	playbackFlipped = false,
	guarding = false,
	previousGuarding = false,
	animationState = 0,
	previosAnimationState = 0,
	riseFall = 0,
	previousRiseFall = 0,
	hitstun = false,
	previousHitstun = false,
	blockstun = 0,
	previousBlockstun = 0,
	blocking = false,
	stand = false,
	previousIps = 0,
	ips = 0,
	scaling = 0,
	previousScaling = 0,
	buttons = {},
	memory = nil
}

-- Shallow copy of p1 with new tables created
local p2 = {}
for k, v in pairs(p1) do
	if type(v) == "table" then
		p2[k] = {}
	else
		p2[k] = v
	end
end

-- Sets the table for use
for i = 1, 13, 1 do 
	p1.inputHistoryTable[i] = 0
	p2.inputHistoryTable[i] = 0
end

--Set individual memory values

p1.memory = {
	character = 0x203488C,
	health = 0x205BB28,
	standHealth = 0x205BB48,
	healthRefill = 0x20349CD,
	combo = 0x205BB38,
	meter = 0x205BB64,
	meterRefill = 0x2034863,
	standGaugeRefill = 0x203520D,
	standGaugeMax = 0x00000000,
	guarding = 0x00000000, --placeholder need to find this later
	facing = 0x2034899,
	animationState = 0x00000000, --placeholder need to find this later
	riseFall  = 0x00000000, --placeholder need to find this later
	hitstun = 0x00000000, --placeholder need to find this later
	blockstun = 0x00000000, --placeholder need to find this later
	stand = 0x00000000, --placeholder need to find this later
	ips = 0x2034E9E,
	scaling = 0x2034E9D,
	height = 0x00000000
}

p2.memory = {
	character = 0x2034CAC,
	health = 0x205BB29,
	standHealth = 0x205BB49,
	healthRefill = 0x2034DED,
	combo = 0x205BB39,
	meter = 0x205BB65,
	meterRefill = 0x2034887,
	standGaugeRefill = 0x203562D,
	standGaugeMax = 0x02035631,
	guarding = 0x02034E51,
	facing = 0x2034CB9,
	animationState = 0x02034D93,
	riseFall = 0x002034DA8,
	hitstun = 0x02034D91,
	blockstun = 0x02034D5A,
	stand = 0x02034E3F,
	ips = 0x00000000,
	scaling = 0x00000000,
	height = 0x02034D0D
}

p1.health = memory.readbyte(p1.memory.health)
p1.standHealth = memory.readbyte(p1.memory.standHealth)
p1.standGauge = p1.standHealth 
p2.health = memory.readbyte(p2.memory.health)
p2.standHealth = memory.readbyte(p2.memory.standHealth)
p2.standGauge = p2.standHealth

p1.name = "P1 "
p1.number = 1
p2.name = "P2 "
p2.number = 2

hud.scroll = hud.scrollFromBottom and 1 or -1

local buttons = {
	up = "Up",
	down = "Down",
	left = "Left",
	right = "Right"
}

if fba then
	buttons.a = "Weak Punch"
	buttons.b = "Medium Punch"
	buttons.c = "Strong Punch"
	buttons.s = "Weak Kick"
	buttons.mk = "Medium Kick"
	buttons.sk = "Strong Kick"
elseif mame then
	buttons.a = "Button 1"
	buttons.b = "Button 2"
	buttons.c = "Button 3"
	buttons.s = "Button 4"
	buttons.mk = "Button 5"
	buttons.sk = "Button 6"
else
	error("This script is only intended for FBA-rr and MAME-rr.", 0)
end

local inputDictionary = {
	[0x01] = "Up",
	[0x02] = "Down",
	[0x04] = "Left",
	[0x08] = "Right",
	[0x10] = buttons.a,
	[0x20] = buttons.b,
	[0x40] = buttons.c,
	[0x80] = buttons.s,
}

for k, v in pairs(buttons) do
	p1.buttons[k] = p1.name..v
	p2.buttons[k] = p2.name..v
end

if fba then
	p1.buttons.start = "P1 Start"
	p1.buttons.coin = "P1 Coin"
	p2.buttons.start = "P2 Start"
	p2.buttons.coin = "P2 Coin"
elseif mame then
	p1.buttons.start = "1 Player Start"
	p1.buttons.coin = "Coin 1"
	p2.buttons.start = "2 Players Start"
	p2.buttons.coin = "Coin 2"
end

local selectInputs = {
	p1.buttons.a,
	p1.buttons.s
}

local cancelInputs = {
	p1.buttons.b,
	p1.buttons.c,
	p1.buttons.mk,
	p1.buttons.sk
}

local input = {
	current = {},
	previous = {},
	held = {},
	overwrite = {}
}

local characters = {
	jotaro = 0x00,
	kakyoin = 0x01,
	avdol = 0x02,
	polnaref = 0x03,
	joseph = 0x04,
	iggy = 0x05,
	alessy = 0x06,
	chaca = 0x07,
	devo = 0x08,
	nDoul = 0x09,
	midler = 0x0A,
	dio = 0x0B,
	vanillaIce = 0x0C,
	death13 = 0x0D,
	shadowDio = 0x0E,
	youngJoseph = 0x0F,
	holHorse = 0x10,
	iced = 0x11,
	newKakyoin = 0x12,
	blackPolnareff = 0x13,
	petshop = 0x14,
	mariah = 0x15,
	hoingo = 0x16,
	rubberSoul = 0x17,
	khan = 0x18
}

local gcStartup = { --Default is 10, 10
	[characters.avdol] = {9, 9},
	[characters.iggy] = {11, 11},
	[characters.jotaro] = {8, 10},
	[characters.joseph] = {15, 10},
	[characters.petshop] = {12, 12},
	[characters.rubberSoul] = {5, 5},
	[characters.youngJoseph] = {13, 13}
}

--Initialise input held count time
function initButtons(player) 
	for _, v in pairs(player.buttons) do
		input.held[v] = 0
	end
end

initButtons(p1)
initButtons(p2)

-- Reads the inputs.txt file and turns it into an array of hex values containing p1 and p2 inputs
function readInputsFile()
	p1.inputPlayback = {}
	p1.inputPlaybackFacing = 1
	p2.inputPlayback = {}
	p2.inputPlaybackFacing = 0
	local f, err = io.open("inputs.txt", "r")
	if err then 
		print("Error reading inputs.txt")
		return 
	end
	local player = nil
	local inputCount = 1
	for line in f:lines() do
		if (line ~= "" and line:sub(1, 1) ~= "-") then
			if (line == "P1") then
				player = p1
				inputCount = 1
			elseif (line == "P2") then
				player = p2
				inputCount = 1
			elseif player then
				local inputs = parseInput(0, line)
				for _ = 1, inputs.wait, 1 do
					player.inputPlayback[inputCount] = inputs.hex
					inputCount = inputCount + 1
				end
			end
		end
	end
	f:close()
end

-- Converts the input text into a hex value and a wait time
function parseInput(shift, line)
	local _, _, number = line:find("(%d+)")
	local inputs = {
		hex = 0,
		wait = tonumber(number) or 1
	}
	for letter in line:lower():gmatch("%a") do
		local inputHex = parserDictionary[letter]
		if inputHex then
			inputs.hex = bit.bor(inputs.hex, bit.lshift(inputHex, shift))
		end
	end
	return inputs
end

-- Reads a file and returns the contents
function readFile(name)
	local f, err = io.open(name, "r")
	if err then
		return nil
	end
	local contents = f:read("*all")
	f:close()
	return contents
end

--Returns whether a key is pressed once
function pressed(key)
	return (not input.previous[key] and input.current[key])
end

--Checks a table of inputs for being pressed
function pressedTable(table)
	for i = 1, #table, 1 do
		if pressed(table[i]) then return true end
	end
	return false
end

--This is like when you hold down a key on a computer and it spams it after a certain amount of time
function repeating(key) 
	local value = input.held[key]
	if value == 0 then 
		return false 
	end
	if value == 1 or (value > 20 and value % 3 == 0) then
		return true
	end
	return false
end

--Input held for x frames
function held(key, x)
	return input.held[key] > x
end

--Turns a hex into both players inputs
function hexToInputTable(hex)
	local table = {}
	inputTableInsert(table, hex, "P1 ")
	inputTableInsert(table, bit.rshift(hex, 8), "P2 ")
	return table
end

--Turns a hex into a player input table
function hexToPlayerInput(hex, player)
	local table = {}
	inputTableInsert(table, hex, player)
	return table
end

--Used by hextoinputtable
function inputTableInsert(table, hex, player)
	for k, v in pairs(inputDictionary) do
		if bit.band(k, hex) == k then
			table[player..v] = true
		end
	end
end

--Swaps left and right in a hex for changing sides
function swapHexDirection(hex)
	return swapBits(hex, 2, 3)
end

--swaps two individual bits in a hex
function swapBits(hex, p1, p2)
	local bit1 = bit.band(bit.rshift(hex, p1), 1)
	local bit2 = bit.band(bit.rshift(hex, p2), 1)
	local x = bit.bxor(bit1, bit2)
	x = bit.bor(bit.lshift(x, p1), bit.lshift(x, p2))
	return bit.bxor(hex, x)
end

--Copies values from one table to another
function tableCopy(source, dest) 
	for k, v in pairs(source) do
		dest[k] = v
	end
end

--Saves settings to menu settings.txt
function writeSettings()
	local f, err = io.open("menu settings.txt", "w")
	if err then 
		print("Could not save settings to \"menu settings.txt\"")
		return 
	end
	local strings = {}
	for k, v in pairs(options) do
		table.insert(strings, k:upper().." = "..tostring(v))
	end
	local _, err = f:write(table.concat(strings, "\n"))
	if err then
		menu.info = "Error saving settings"
	else
		menu.info = "Saved settings successfully"
	end
	f:close()
end

--Read settings from menu settings.txt
function readSettings()
	local f, err = io.open("menu settings.txt", "r")
	if err then 
		return 
	end
	for line in f:lines() do
		for k, v in pairs(options) do
			local _, _, key, value = line:upper():find("(%w+)%s*=%s*(%w+)")
			if key == k:upper() then
				local type = type(v)
				if type == "boolean" then
					options[k] = (value == "TRUE" and true or false)
				elseif type == "number" then
					options[k] = tonumber(value)
				end
				break
			end
		end
	end
	f:close()
end

-- Reads from memory and assigns variables based on the memory
function memoryReader()
	readPlayerMemory(p1)
	readPlayerMemory(p2)
	input.previous = input.current
	input.current = joypad.read() -- reads all inputs
end

function readPlayerMemory(player) 
	player.previousHealth = player.health
	player.previousCombo = player.combo
	player.previousGuarding = player.guarding
	player.previousAnimationState = player.animationState
	player.previousRiseFall = player.riseFall
	player.previousHitstun = player.hitstun
	player.previousblockstun = player.blockstun
	player.previousIps = player.ips
	player.previousScaling = player.scaling
	for k, v in pairs(player.memory) do
		player[k] = memory.readbyte(v)
	end
	if player.standGauge < player.standHealth then
		player.standGauge = player.standHealth
	end
end

function inputSorter() --sorts inputs
	p1.previousInputs = p1.inputs
	p1.inputs = getPlayerInputHex("P1 ")
	p2.previousInputs = p2.inputs
	p2.inputs = getPlayerInputHex("P2 ")
end

-- Gets the specified players inputs as a hex
function getPlayerInputHex(player)
	local hex = 0
	for k, v in pairs(inputDictionary) do
		if input.current[player..v] then
			hex = bit.bor(hex, k)
		end
	end
	return hex
end

-- Queues new inputs
function inputHistoryRefresher()
	updatePlayerHistory(p1)
	updatePlayerHistory(p2)
end

function updatePlayerHistory(player)
	local direction = bit.band(player.inputs, 0x0F)
	local previousDirection = bit.band(player.previousInputs, 0x0F)
	if (player.inputs ~= player.previousInputs and player.inputs ~= 0) and
			(player.previousInputs - previousDirection + player.inputs) ~= player.previousInputs and
			(player.previousInputs - previousDirection ~= player.inputs - direction or direction ~= 0) and
			(not (player.inputs - (player.previousInputs - previousDirection) < 0)) then
		for i = 13, 2, - 1 do
			player.inputHistoryTable[i] = player.inputHistoryTable[i - 1]
		end
		if player.previousInputs - previousDirection ~= player.inputs - direction then
			player.inputHistoryTable[1] = player.inputs - (player.previousInputs - previousDirection)
		else
			player.inputHistoryTable[1] = direction
		end
	end
end

function drawDpad(DpadX,DpadY,sideLength)
	gui.box(DpadX,DpadY,DpadX+(sideLength*3),DpadY+sideLength,"black","white")
	gui.box(DpadX+sideLength, DpadY-sideLength, DpadX+(sideLength*2), DpadY+(sideLength*2), "black", "white")
	gui.box(DpadX+1, DpadY+1, DpadX+(sideLength*3)-1, DpadY+sideLength-1,"black")
end

function gameplayLoop() --main loop for gameplay calculations
	updatePlayer(p1, p2)
	updatePlayer(p2, p1)
	memory.writebyte(0x205CC1A, options.music and 0x80 or 0x00) -- Toggle music off or on
	memory.writebyte(0x20314B4, 0x63) -- Infinite Clock Time
	if not options.ips then -- IPS
		memory.writebyte(p1.memory.ips, 0x00)
	end
end

function updatePlayer(player, other) 
	--combo counters
	if (player.previousHealth > player.health or other.combo > other.previousCombo) then
		player.damage = math.abs(player.previousHealth - player.health)
		if (other.combo > 1 and other.previousCombo ~= 0) then
			other.comboDamage = math.abs(other.comboDamage) + player.damage
		else
			other.comboDamage = player.damage
		end
		player.previousDamage = player.damage
	end

	if player.combo >= 2 then
		player.displayComboCounter = player.combo
		player.comboCounterColor = colors.comboCounterActiveColour
	else
		player.comboCounterColor = "white"
	end

	--Health Regen
	if options.healthRefill and ((player.previousCombo > 0 or other.damage ~= 0) and (player.combo == 0)) then
		memory.writebyte(other.memory.healthRefill, 0x90)
		other.damage = 0
	end

	--Meter refill
	if options.meterRefill then
		memory.writebyte(player.memory.meterRefill, 0x680A)
	end

	--Stand refill 
	if options.standGaugeRefill and player.standHealth == 0 then
		memory.writebyte(player.memory.standGaugeRefill, player.standGaugeMax)
	end
end

function inputChecker()
	checkPlayerInput(p1, p2)
	checkPlayerInput(p2, p1)
	if menu.state > 0 then
		updateMenu()
	end
end

function checkPlayerInput(player, other)
	for _, v in pairs(player.buttons) do
		if input.current[v] then
			input.held[v] = input.held[v] + 1
		else
			input.held[v] = 0
		end
	end

	other.previousControl = other.control

	if pressed(player.buttons.coin) then
		openMenu()
	end

	if menu.state > 0 then 
		if pressed(player.buttons.mk) then
			memory.writebyte(other.memory.standGaugeRefill, other.standGaugeMax)
		end

		if pressed(player.buttons.sk) then
			memory.writebyte(player.memory.standGaugeRefill, player.standGaugeMax)
		end
		return
	end

	if input.current[player.buttons.start] then --checks to see if P1 is holding start
		
		other.control = true

		if pressed(player.buttons.mk) then
			memory.writebyte(other.memory.standGaugeRefill, other.standGaugeMax)
		end

		if pressed(player.buttons.sk) then
			memory.writebyte(player.memory.standGaugeRefill, player.standGaugeMax)
		end
	else
		other.control = false
	end

	if pressed(player.buttons.mk) then
		if options.mediumKickHotkey == 1 then
			record(player)
		end
	elseif pressed(player.buttons.sk) then
		if options.strongKickHotkey == 1 then
			replaying(player)
		elseif options.strongKickHotkey == 2 then
			inputPlayback(player)
			inputPlayback(other)
		end
	end

	if held(player.buttons.sk, 15) then
		player.loop = true
	end
end

function record(player)
	player.playbackCount = 0
	player.loop = false
	player.recording = not player.recording
	if player.recording then
		player.recorded = {}
		player.recordedFacing = player.facing
	end
end

function replaying(player)
	player.loop = false
	player.recording = false
	if player.playbackCount == 0 then
		player.playback = player.recorded
		player.playbackCount = #player.recorded
		player.playbackFacing = player.recordedFacing
		player.playbackFlipped = player.facing ~= player.recordedFacing
	else
		player.playbackCount = 0
	end
end

function inputPlayback(player)
	player.recording = false
	player.loop = false
	if player.playbackCount == 0 then
		readInputsFile()
		player.playback = player.inputPlayback
		player.playbackCount = #player.inputPlayback
		player.playbackFacing = player.inputPlaybackFacing
		player.playbackFlipped = player.facing ~= player.inputPlaybackFacing
	else
		player.playbackCount = 0
	end
end

function characterControl()
	input.overwrite = {}

	controlPlayer(p1, p2)
	controlPlayer(p2, p1)

	if next(input.overwrite) ~= nil then --empty table
		joypad.set(input.overwrite)
	end
end

function controlPlayer(player, other)
	-- recording
	if player.recording then
		table.insert(player.recorded, player.inputs)
	end
	-- Direction Lock
	if player.previousControl and not player.control then
		player.directionLock = bit.band(other.inputs, 0x0F) 
		player.directionLockFacing = player.facing
	end
	-- Player 2 menu option controls
	if player.number == 2 and player.playbackCount == 0 then
		-- Guard Action
		if player.guarding > 0 then
			--Push block
			if options.guardAction == 2 then
				local direction = bit.band(0x0F, player.inputs)
				local inputs = { bit.bor(0x70, direction) }
				insertDelay(inputs, options.guardActionDelay, direction)
				setPlayback(player, inputs);
			-- Guard Cancel
			elseif options.guardAction == 3 then
				local inputs = (player.facing == 1 and { 0x08, 0x02, 0x1A } or { 0x04, 0x02, 0x16 })
				local startUps = gcStartup[player.character] or {10, 10}
				local startUp = (player.stand  == 1 and startUps[2] or startUps[1])
				for _ = 1, startUp, 1 do
					table.insert(inputs, 0)
				end
				insertDelay(inputs, options.guardActionDelay, bit.band(player.inputs, 0x0F))
				setPlayback(player, inputs)
			end 
		end
		-- Air Tech
		if options.airTech and canAirTech(player) then
			local inputs
			if options.airTechDirection == 1 then
				inputs = { 0x70 }
			elseif options.airTechDirection == 2 then
				inputs = { 0x72}
			elseif options.airTechDirection == 3 then
				inputs = (player.facing == 1 and { 0x78 } or { 0x74 })
			elseif options.airTechDirection == 4 then
				inputs = (player.facing == 1 and { 0x74 } or { 0x78 })
			end
			insertDelay(inputs, options.airTechDelay, 0)
			setPlayback(player, inputs)
		end
		-- Force Stand
		if options.forceStand > 1 and canReversal(player) then
			if (options.forceStand == 2 and player.stand ~= 1) or
				(options.forceStand == 3 and player.stand == 1) then
				setPlayback(player, { 0x80 })
				memory.writebyte(player.memory.standGaugeRefill, player.standGaugeMax)
			end
		end
	end
	-- Player control
	if player.control then
		local inputs = hexToPlayerInput(other.inputs, player.name)
		tableCopy(inputs, input.overwrite)
	-- Input Playback
	elseif player.playbackCount > 0 then
		local hex =  player.playback[#player.playback - player.playbackCount + 1]
		hex = (player.playbackFlipped and swapHexDirection(hex) or hex)
		local inputs = hexToPlayerInput(hex, player.name)
		tableCopy(inputs, input.overwrite)
		player.playbackCount = player.playbackCount - 1
		if player.playbackCount == 0 and player.loop then
			player.playbackFlipped = player.facing ~= player.playbackFacing
			player.playbackCount = #player.playback
		end
	-- Direction Lock
	elseif player.directionLock ~= 0 then
		local direction = (player.facing == player.directionLockFacing and player.directionLock or swapHexDirection(player.directionLock))
		local inputs = hexToPlayerInput(direction, player.name)
		tableCopy(inputs, input.overwrite)
	end
end

function setPlayback(player, table)
	player.playback = table
	player.playbackCount = #table
	player.playbackFacing = player.facing
	player.loop = false
end

function insertDelay(inputs, number, hex)
	for _ = 1, number, 1 do
		table.insert(inputs, 1, hex)
	end
end

function canAirTech(player)
	return player.previousRiseFall == 0x00 and player.riseFall == 0xFF and player.height > 0 and player.hitstun == 1
end

function canReversal(player)
	if not player.blocking and player.guarding > 0 then
		player.blocking = true
	end
	if player.blocking and player.blockstun == 0xFF then
		player.blocking = false
		return true
	end
	if player.previousHitstun == 1 and player.hitstun ~= 1 then
		return true
	end
	return false
end

function openMenu()
	if menu.state == 0 then
		menu.state = 1
		menu.title = "Training Menu"
		menu.index = 1
		menu.options = rootOptions
		updateMenuInfo()
	else
		menu.state = 0
		gui.clearuncommitted()
	end
end

function updateMenu() 
	if pressedTable(selectInputs) then
		menuSelect()
	elseif pressedTable(cancelInputs) then
		menuCancel()
	elseif repeating("P1 Up") then
		menuUp()
	elseif repeating("P1 Down") then
		menuDown()
	elseif repeating("P1 Left") then
		menuLeft()
	elseif repeating("P1 Right") then
		menuRight()
	end
end

function menuSelect()
	local option = menu.options[menu.index]
	if option.type == optionType.subMenu then
		menu.state = 2
		menu.previousIndex = menu.index
		menu.index = 1
		menu.options = option.options
		menu.title = option.name
		updateMenuInfo()
	elseif option.type == optionType.bool then
		options[option.key] = not options[option.key]
	elseif option.type == optionType.func then
		option.func()
	elseif option.type == optionType.back then
		menuCancel()
	elseif option.type == optionType.info then
		menu.state = 3
		menu.previousIndex = menu.index
		menu.index = 1
		menu.options = infoOptions
		menu.title = option.name
		menu.info = option.infos
	end
end

function menuCancel()
	if menu.state == 1 then --menu
		menu.state = 0
		gui.clearuncommitted()
	elseif menu.state > 1 then --sub menu
		menu.state = 1
		menu.index = menu.previousIndex
		menu.options = rootOptions
		menu.title = "Training Menu"
		updateMenuInfo()
	end
end

function menuLeft()
	local option = menu.options[menu.index]
	local value = options[option.key]
	if option.type == optionType.bool then
		options[option.key] = not value
	elseif option.type == optionType.int then
		options[option.key] = (value == option.min and option.max or value - 1)
	elseif option.type == optionType.list then
		options[option.key] = (value == 1 and #option.list or value - 1)
	elseif option.type == optionType.memory then
		options[option.key] = (value == 0 and memory.readbyte(option.memory) or value - 1)
	end
end

function menuRight()
	local option = menu.options[menu.index]
	local value = options[option.key]
	if option.type == optionType.bool then
		options[option.key] = not value
	elseif option.type == optionType.int then
		options[option.key] = (value >= option.max and option.min or value + 1)
	elseif option.type == optionType.list then
		options[option.key] = (value >= #option.list and 1 or value + 1)
	elseif option.type == optionType.memory then
		options[option.key] = (value >= memory.readbyte(option.memory) and 0 or value + 1)
	end
end

function menuUp()
	if menu.state == 3 then return end
	menu.index = (menu.index == 1 and #menu.options or menu.index - 1)
	updateMenuInfo()
end

function menuDown()
	if menu.state == 3 then return end
	menu.index = (menu.index >= #menu.options and 1 or menu.index + 1)
	updateMenuInfo()
end

function updateMenuInfo() 
	if menu.options[menu.index].info then
		menu.info = menu.options[menu.index].info
	else
		menu.info = ""
	end
end

function guiWriter() -- Writes the GUI
	if menu.state > 0 then
		drawMenu()
	end

	if options.guiStyle == 1 then
		return
	end

	gui.text(18,15, p1.health) -- P1 Health at x:18 and y:15
	gui.text(355,15, p2.health) -- P2 Health
	gui.text(50, 24, p1.standHealth) -- P1's Stand Health
	gui.text(326,24, p2.standHealth) -- P2's Stand Health
	gui.text(135,216,tostring(p1.meter)) -- P1's meter fill
	gui.text(242,216,tostring(p2.meter)) -- P2's meter fill

	if (options.guiStyle > 1) then
		local historyLength = (options.guiStyle == 3 and 13 or 11)
		for i = 1, historyLength, 1 do
			local hex = p1.inputHistoryTable[i]
			local buttonOffset = 0
			if bit.band(hex, 0x10) == 0x10 then --A
				gui.text(hud.xP1+hud.offset*4,hud.yP1-1-((11)*i*hud.scroll),"A", colors.inputHistoryA)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x20) == 0x20 then --B
				gui.text(hud.xP1+hud.offset*4+buttonOffset,hud.yP1-1-((11)*i*hud.scroll),"B", colors.inputHistoryB)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x40) == 0x40 then --C
				gui.text(hud.xP1+hud.offset*4+buttonOffset,hud.yP1-1-((11)*i*hud.scroll),"C", colors.inputHistoryC)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x80) == 0x80 then --S
				gui.text(hud.xP1+hud.offset*4+buttonOffset,hud.yP1-1-((11)*i*hud.scroll),"S", colors.inputHistoryS)
			end
			if bit.band(hex, 0x0F) > 0 then
				drawDpad(hud.xP1,hud.yP1-((11)*i*hud.scroll),hud.offset)
			end
			if bit.band(hex, 0x01) == 0x01 then --Up
				gui.box(hud.xP1+hud.offset+1, hud.yP1-(11*i*hud.scroll), hud.xP1+hud.offset*2-1, hud.yP1-hud.offset+1-(11*i*hud.scroll),"red")
			end
			if bit.band(hex, 0x02) == 0x02 then --Down
				gui.box(hud.xP1+hud.offset+1, hud.yP1+hud.offset-(11*i*hud.scroll), hud.xP1+hud.offset*2-1, hud.yP1+hud.offset*2-(11*i*hud.scroll)-1,"red")
			end
			if bit.band(hex, 0x04) == 0x04 then --Left
				gui.box(hud.xP1+1, hud.yP1+1-(11*i*hud.scroll), hud.xP1+hud.offset, hud.yP1+hud.offset-1-(11*i*hud.scroll),"red")
			end
			if bit.band(hex, 0x08) == 0x08 then --Right
				gui.box(hud.xP1+hud.offset*2, hud.yP1+1-(11*i*hud.scroll), hud.xP1+hud.offset*3-1, hud.yP1+hud.offset-1-(11*i*hud.scroll),"red")
			end
		end
	end
	
	if options.guiStyle == 2 or options.guiStyle == 4 then
		gui.text(8,50,"P1 Damage: "..tostring(p2.previousDamage)) -- Damage of P1's last hit
		gui.text(8,66,"P1 Combo: ")
		gui.text(48,66, p1.displayComboCounter, p1.comboCounterColor) -- P1's combo count
		gui.text(8,58,"P1 Combo Damage: "..tostring(p1.comboDamage)) -- Damage of P1's combo in total
	elseif options.guiStyle == 3 and menu.state == 0 then
		gui.text(146,45,"Damage: ") -- Damage of P1's last hit
		guiTextAlignRight(236,45,p2.previousDamage) -- Damage of P1's last hit
		gui.text(146,61,"Combo: ")
		guiTextAlignRight(236,61,p1.displayComboCounter, p1.comboCounterColor)
		gui.text(146,53,"Combo Damage: ") -- Damage of P1's combo in total
		guiTextAlignRight(236,53,p1.comboDamage) -- Damage of P1's combo in total
		gui.text(146,69,"IPS: ") -- IPS for P1's combo
		if p1.previousIps == 0 or not options.ips then --It flickers on and off if you don't check the menu option
			guiTextAlignRight(236, 69, "OFF", "red")
		else
			guiTextAlignRight(236, 69, "ON", "green")
		end
		gui.text(146,77,"Scaling: ") -- Scaling for P1's combo
		if p1.previousScaling == 0 then
			guiTextAlignRight(236, 77, "OFF", "red")
		else
			guiTextAlignRight(236, 77, "ON", "green")
		end
	end

	if (p1.recording) then
		gui.text(152,32,"Recording", "red")
	elseif (p1.playbackCount > 0) then
		gui.text(152,32,"Replaying", "red")
	end

	if (options.guiStyle == 4) then

		gui.text(300,50,"P2 Damage: " .. tostring(p1.previousDamage)) -- Damage of P2's last hit
		gui.text(300,66,"P2 Combo: ")
		gui.text(348,66, p2.displayComboCounter, p2.comboCounterColor) -- P2's combo count
		gui.text(300,58,"P2 Combo Damage: " .. tostring(p2.comboDamage)) -- Damage of P2's combo in total

		for i = 1, 11, 1 do
			local hex = p2.inputHistoryTable[i]
			local buttonOffset=0
			if bit.band(hex, 0x10) == 0x10 then --A
				gui.text(hud.xP2+hud.offset*4,hud.yP2-1-((11)*i*hud.scroll),"A",colors.inputHistoryA)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x20) == 0x20 then --B
				gui.text(hud.xP2+hud.offset*4+buttonOffset,hud.yP2-1-((11)*i*hud.scroll),"B",colors.inputHistoryB)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x40) == 0x40 then --C
				gui.text(hud.xP2+hud.offset*4+buttonOffset,hud.yP2-1-((11)*i*hud.scroll),"C",colors.inputHistoryC)
				buttonOffset=buttonOffset+6
			end
			if bit.band(hex, 0x80) == 0x80 then --S
				gui.text(hud.xP2+hud.offset*4+buttonOffset,hud.yP2-1-((11)*i*hud.scroll),"S",colors.inputHistoryS)
			end
			if bit.band(hex, 0x0F) > 0 then
				drawDpad(hud.xP2,hud.yP2-((11)*i*hud.scroll),hud.offset)
			end
			if bit.band(hex, 0x01) == 0x01 then --Up
				gui.box(hud.xP2+hud.offset+1, hud.yP2-(11*i*hud.scroll), hud.xP2+hud.offset*2-1, hud.yP2-hud.offset+1-(11*i*hud.scroll),"red")
			end
			if bit.band(hex, 0x02) == 0x2 then --Down
				gui.box(hud.xP2+hud.offset+1, hud.yP2+hud.offset-(11*i*hud.scroll), hud.xP2+hud.offset*2-1, hud.yP2+hud.offset*2-(11*i*hud.scroll)-1,"red")
			end
			if bit.band(hex, 0x04) == 0x04 then --Left
				gui.box(hud.xP2+1, hud.yP2+1-(11*i*hud.scroll), hud.xP2+hud.offset, hud.yP2+hud.offset-1-(11*i*hud.scroll),"red")
			end
			if bit.band(hex, 0x08) == 0x08 then --Right
				gui.box(hud.xP2+hud.offset*2, hud.yP2+1-(11*i*hud.scroll), hud.xP2+hud.offset*3-1, hud.yP2+hud.offset-1-(11*i*hud.scroll),"red")
			end
		end
	end
	if (p2.recording) then
		gui.text(200,32,"Recording", "red")
	elseif (p2.playbackCount > 0) then
		gui.text(200,32,"Replaying", "red")
	end
end

function guiTextAlignRight(x, y, text, color) 
	local t = tostring(text)
	color = color or "white"
	gui.text(x - #t * 4, y, t, color)
end

-- Draws the menu overlay
function drawMenu()
	gui.box(90, 36, 294, 188, colors.menuBackgroundColor, "white")
	gui.text(110, 42, menu.title, colors.menuTitleColor)
	if menu.state ~= 3 then
		for i = 1, #menu.options, 1 do
			local color = (menu.index == i and colors.menuSelectedColor or colors.menuUnselectedColor)
			local option = menu.options[i]
			gui.text(100, 48 + i * 12, option.name, color)
			if option.type == optionType.bool then
				local word = options[option.key] and "Enabled" or "Disabled"
				gui.text(200, 48 + i * 12, word, color)
			elseif option.type == optionType.int then
				local number = options[option.key]
				gui.text(200, 48 + i * 12, number, color)
			elseif option.type == optionType.list then
				local word = option.list[options[option.key]]
				gui.text(200, 48 + i * 12, word, color)
			elseif option.type == optionType.memory then
				local number = options[option.key]
				local word = (number == memory.readbyte(option.memory) and "Max" or number)
				gui.text(200, 48 + i * 12, word, color)
			end
		end
		gui.text(110, 172, menu.info, colors.menuTitleColor)
	else
		for i = 1, #menu.info, 1 do
			gui.text(100, 48 + i * 12, menu.info[i], colors.menuTitleColor)
		end
		gui.text(110, 172, "Return", colors.menuSelectedColor)
	end
end

--register callbacks
emu.registerstart(function()
	memory.writebyte(0x20713A8, 0x09) -- Infinite Credits
	memory.writebyte(0x20312C1, 0x01) -- Unlock all characters
	readSettings()
end)

gui.register(function()
	guiWriter()
end)

while true do 
	memoryReader()
	gameplayLoop()
	inputSorter()
	inputChecker()
	inputHistoryRefresher()
	characterControl()
	emu.frameadvance()
end