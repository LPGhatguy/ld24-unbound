local Misc = {}
local Lib
Misc.Mouse = {X = 0, Y = 0}
Misc.WorldMouse = {X = 0, Y = 0}
Misc.GridMouse = {X = 0, Y = 0}
Misc.Screen = {X = 0, Y = 0}
Misc.Delta = 0
Misc.FPS = 0
Misc.ElapsedTime = 0

Misc.Update = function(Self, Delta)
	Self.Mouse = {X = love.mouse.getX(), Y = love.mouse.getY()}

	local WX, WY = Lib.Universe:ToWorldCoordinates(Self.Mouse.X, Self.Mouse.Y)
	Self.WorldMouse = {X = WX, Y = WY}
	local GX, GY = Lib.Universe:ToGrid(WX, WY)
	Self.GridMouse = {X = GX, Y = GY}

	Self.Delta = Delta
	Self.FPS = love.timer.getFPS()
	Self.ElapsedTime = Self.ElapsedTime + Delta
end

setmetatable(Misc, {
	__call = function(Self, GLib)
		Self.Screen = {X = love.graphics.getWidth(), Y = love.graphics.getHeight()}
		Lib = GLib
		return Self
	end
})

return Misc