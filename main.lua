local LibManager = require("Engine.LibraryManager")
local Lib = LibManager.Lib
local Universe, Misc, Engine
local music
local time = 0

function love.load()
	love.graphics.setDefaultImageFilter("nearest", "nearest")
	love.mouse.setGrab(true)
	love.mouse.setVisible(false)

	LibManager:Init()
	Universe = Lib.Universe
	Misc = Lib.Misc
	Engine = Lib.Engine

	Engine.NormalFont = love.graphics.newFont()
	Engine.LetterFont = love.graphics.newFont(16)
	Engine.InfoFont = love.graphics.newFont(24)

	local victory = love.audio.newSource("Content/Sound/Victory.wav", "static")
	local tiles = love.graphics.newImage("Content/Tiles.png")
	local entities = love.graphics.newImage("Content/Entities.png")
	local msgback = love.graphics.newImage("Content/MessageBackground.png")

	local character = Lib.Character:New()
	Engine.Character = character

	local cursor = Lib.Entity:New()
	cursor.Scale = 1
	cursor.Visible = true
	cursor.Type = 13

	Universe:Init(tiles, entities)

	Universe.EntityManager:BatchAdd({character, cursor})

	music = love.audio.newSource("Content/Music/BIND.ogg", "stream")
	music:setLooping(true)
	music:play()
	music:setVolume(0.1)

	Engine.Cursor = cursor
	Engine.MessageBackground = msgback
	Engine.VictorySound = victory
	Engine.Music = music
	Engine.Ambient = {
		love.audio.newSource("Content/Sound/Ambient1.wav", "static"),
		love.audio.newSource("Content/Sound/Ambient2.wav", "static"),
		love.audio.newSource("Content/Sound/Ambient2.wav", "static"),
		love.audio.newSource("Content/Sound/Ambient2.wav", "static")
	}
end

function love.update(Delta)
	time = time + Delta

	if (time < 1) then
		music:setVolume(time / 3.5 + 0.1)
	end

	Misc:Update(Delta)
	Engine:Update(Delta)
	Universe:Update(Delta)

	Universe.Camera = Engine.Character.Position
	Universe.Camera = {X = math.floor(Universe.Camera.X), Y = math.floor(Universe.Camera.Y)}
end

function love.draw()

	if (time < 2) then
		love.graphics.setColor(80 * time, 80 * time, 80 * time)
	end

	Universe:Draw()

	--love.graphics.setColor(225, 225, 225)
	Engine:Draw()

	if (time < 4) then
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(Engine.InfoFont)
		love.graphics.printf("Look here for hints...", 0, 740, 1024, "center")
	elseif (time < 5) then
		love.graphics.setColor(255, 255, 255, 255 - (time - 5) * 255)
		love.graphics.setFont(Engine.InfoFont)
		love.graphics.printf("Look here for hints...", 0, 740, 1024, "center")
	end

	love.graphics.setFont(Engine.NormalFont)
	--[[love.graphics.print("FPS: " .. Misc.FPS, 4, 4)
	love.graphics.print("Screen: (" .. Misc.Mouse.X .. ", " .. Misc.Mouse.Y .. ")", 4, 20)
	love.graphics.print("World: (" .. math.floor(Misc.WorldMouse.X) .. ", " .. math.floor(Misc.WorldMouse.Y) .. ")", 4, 36)
	love.graphics.print("Grid: (" .. Misc.GridMouse.X .. ", " .. Misc.GridMouse.Y .. ")", 4, 50)
	love.graphics.print("Bind Pool: " .. table.concat(Engine.ActionPool, ", "), 4, 88)]]
end

function love.keypressed(Key, Unicode)
	Engine:Keypress(Key)

	if (Key == "escape") then
		love.event.push("quit")
	elseif (Key == "`") then
		local data = love.graphics.newScreenshot()
		data:encode("Screenshot.png")
	end
end

function love.mousepressed()
	Engine:Click()
end