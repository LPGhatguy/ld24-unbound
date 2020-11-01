local Universe = {}
local Lib, Screen

Universe.Worlds = {}
Universe.WorldCount = 8
Universe.World = 1
Universe.CurrentWorld = nil
Universe.Camera = {X = 0, Y = 0}
Universe.Brightness = 170

Universe.Init = function(Self, Tileset, Entityset)
	Self.Tileset = Tileset
	Self.Entityset = Entityset

	Lib.Tile:Init(Tileset)
	Lib.Entities:Init(Entityset)
	Self.EntityManager = Lib.EntityManager:Create(Entityset)

	Self.Worlds[1] = Lib.World:Create(Tileset, Self.EntityManager, 1)
	Self.Worlds[1]:Render()

	Self.CurrentWorld = Self.Worlds[1]
end

Universe.IsCollidable = function(Self, Position)
	local GX, GY = Self:ToGrid(Position.X, Position.Y)
	local CollisionY = Self.CurrentWorld.Map.Layers.Collision[GY]
	return CollisionY and CollisionY[GX]
end

Universe.ToWorldCoordinates = function(Self, X, Y)
	return X - (Screen.X / 2) + Self.Camera.X, -Y + (Screen.Y / 2) + Self.Camera.Y
end

Universe.ToGrid = function(Self, X, Y)
	return math.floor(X / (Lib.Tile.Size * Lib.Tile.Scale) + 1), math.floor(Y / (Lib.Tile.Size * Lib.Tile.Scale) + 1)
end

Universe.FromGrid = function(Self, X, Y)
	return (X * (Lib.Tile.Size * Lib.Tile.Scale)), (Y * (Lib.Tile.Size * Lib.Tile.Scale))
end

Universe.ToScreenCoordinates = function(Self, X, Y)
	--TODO: This
	return X, Y
end

Universe.Update = function(Self, Delta)
	Self.CurrentWorld:Update(Delta)
end

Universe.Draw = function(Self)
	local Light = Self.Brightness + 30 * math.sin(Lib.Misc.ElapsedTime / 2)
	love.graphics.setColor(Light, Light, Light)
	Universe:StartDraw()
	Self.CurrentWorld:Draw()
	Universe:EndDraw()
end

Universe.StartDraw = function(Self)
	love.graphics.push()
	love.graphics.scale(1, -1)
	love.graphics.translate(-Self.Camera.X + Screen.X / 2, -Self.Camera.Y - (Screen.Y / 2))
end

Universe.EndDraw = function(Self)
	love.graphics.pop()
end

setmetatable(Universe, {
	__call = function(Self, GLib)
		Lib = GLib
		Screen = GLib.Misc.Screen
		return Self
	end
})

return Universe