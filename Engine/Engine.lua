local Engine = {}
local Lib

Engine.Keys = {forward='w', backward='s', left='a', right='d', sprint='lshift'}--{}
Engine.UsedKeys = {escape=true, ["`"]=true}
Engine.ActionPool = {}--{"forward", "backward", "left", "right", "sprint"}
Engine.Message = "Hello, world!"
Engine.ShowMessage = false
Engine.FadeOut, Engine.FadeIn, Engine.CycleWorld = false, true, false
Engine.FadeMusic = false
Engine.ScreenCover = 255
Engine.NextAmbient = 0
Engine.Ambient = {}
Engine.EndTime = 0

Engine.DoAmbient = function(Self)
	if (Lib.Universe.World >= 5 and Lib.Misc.ElapsedTime > Self.NextAmbient) then
		Self.Ambient[math.random(1, #Self.Ambient)]:play()
		Self.NextAmbient = Lib.Misc.ElapsedTime + math.random(5, 30)
	end
end

Engine.Keypress = function(Self, Key)
	Self:TryBind(Key)

	Engine.ShowMessage = false

	Self.End = Self.TheEnd

	if (Self.End) then
		Self.EndTime = Lib.Misc.ElapsedTime
	end
end

Engine.TryBind = function(Self, Key)
	if (not Self.UsedKeys[Key] and #Self.ActionPool > 0) then
		for ID, Action in next, Self.ActionPool do
			Self.Keys[Action] = Key
			break
		end
		table.remove(Self.ActionPool, 1)
		Self.UsedKeys[Key] = true

		return true
	end

	return false
end

Engine.IsActionDown = function(Self, Action)
	return Self.Keys[Action] and love.keyboard.isDown(Self.Keys[Action])
end

Engine.Victory = function(Self)
	love.audio.play(Self.VictorySound)
end

Engine.Draw = function(Self)
	if (Self.End) then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, 1024, 768)

		love.graphics.setFont(Self.InfoFont)
		love.graphics.setColor(180, 180, 180)
		love.graphics.printf("THE END", 0, 360, 1024, "center")
	else
		if (Self.ShowMessage) then
			love.graphics.draw(Self.MessageBackground, 300, 0, 0, 16, 16)

			love.graphics.setFont(Self.LetterFont)
			love.graphics.setColor(0, 0, 0)
			love.graphics.printf(Self.Message .. "\n\n-- Daniel McArthur", 370, 64, 380)

			love.graphics.setColor(255, 255, 255)
			love.graphics.setFont(Self.InfoFont)
			love.graphics.printf("Press any key to continue...", 0, 740, 1024, "center")
		end

		love.graphics.setColor(0, 0, 0, Self.ScreenCover)
		love.graphics.rectangle("fill", 0, 0, 1024, 768)
	end
end

Engine.Update = function(Self, Delta)
	if (Self.End) then
		if (Lib.Misc.ElapsedTime - Self.EndTime > 3) then
			love.event.push("quit")
			return
		end
	end

	local Character = Self.Character

	Character.Sprint = Self:IsActionDown("sprint")
	Character.Walking = false
	if (Self:IsActionDown("forward")) then
		Character.Walking = not Character.Colliding
		Character:Forward()
	elseif (Self:IsActionDown("backward")) then
		Character.Walking = not Character.Colliding
		Character:Backward()
	end

	if (Self:IsActionDown("right")) then
		Character.Walking = not Character.Colliding
		Character:Right()
	elseif (Self:IsActionDown("left")) then
		Character.Walking = not Character.Colliding
		Character:Left()
	end

	Self.Cursor.Position = Lib.Misc.WorldMouse
	Self.Cursor.Rotation = Character.Rotation

	if (Self.CycleWorld) then
		Self.CycleWorld = false
		Self.FadeOut = true
	elseif (Self.FadeOut) then
		Self.ScreenCover = Self.ScreenCover + Delta * 255
		if (Self.ScreenCover > 255) then
			Self.ScreenCover = 255
			Self.FadeOut = false
			Self.LoadWorld = true
		end
	elseif (Self.LoadWorld) then
		Lib.Universe.World = Lib.Universe.World + 1
		local World = Lib.Universe.World
		Lib.Universe.Worlds[World] = Lib.World:Create(Lib.Universe.Tileset, Lib.Universe.EntityManager, World)
		Lib.Universe.Worlds[World]:Render()
		Lib.Universe.CurrentWorld = Lib.Universe.Worlds[World]

		if (World > 4 and World ~= 8) then
			Self.FadeMusic = true
		end

		Self.LoadWorld = false
		Self.FadeIn = true
	elseif (Self.FadeIn) then
		Self.ScreenCover = Self.ScreenCover - Delta * 255
		if (Self.ScreenCover < 0) then
			Self.ScreenCover = 0
			Self.FadeIn = false
		end
	end

	if (Self.FadeMusic) then
		local volume = Self.Music:getVolume()
		if (volume <= 0) then
			Self.Music:stop()
			Self.FadeMusic = false
		else
			Self.Music:setVolume(Self.Music:getVolume() - Delta)
		end
	end

	Self:DoAmbient()
end

Engine.Click = function(Self)
	local GX, GY = Lib.Misc.GridMouse.X, Lib.Misc.GridMouse.Y
	local SpecialY = Lib.Universe.CurrentWorld.Map.Layers.Special[GY]
	if (SpecialY and SpecialY[GX]) then
		local Special = SpecialY[GX]
		if (Special.Click) then
			Special:Click()
		end
	end
end

setmetatable(Engine, {
	__call = function(Self, GLib)
		Lib = GLib
		return Self
	end
})

return Engine