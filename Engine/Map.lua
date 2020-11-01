local Map = {}
local Lib, Tile

Map.Layers = {}
Map.MaxTiles = 4000
Map.TileBatch = nil
Map.TileFactor = 1

Map.Create = function(Self, Tileset, Data)
	return Self:New():Init(Tileset, Data)
end

Map.Init = function(Self, Tileset, Data)
	Self.TileBatch = love.graphics.newSpriteBatch(Tileset, Self.MaxTiles)
	Self:Load(Data)
	return Self
end

Map.Load = function(Self, Data)
	local One, Two, Three, Collision = {}, {}, {}, {}

	for Y = 0, Data:getHeight() - 1 do
		One[Y + 1] = {}
		Two[Y + 1] = {}
		Three[Y + 1] = {}
		Collision[Y + 1] = {}

		for X = 0, Data:getWidth() - 1 do
			local R, G, B, A = Data:getPixel(X, Y)
			if (A > 0) then
				local rmatch, gmatch, bmatch

				for ID, TileData in next, Tile.FlatQuad do
					local TileID = TileData.ID
					if (TileID == R and not rmatch) then
						One[Y + 1][X + 1] = ID
						rmatch = true
					end
					if (TileID == G and not gmatch) then
						Two[Y + 1][X + 1] = ID
						gmatch = true
					end
					if (TileID == B and not bmatch) then
						Three[Y + 1][X + 1] = ID
						bmatch = true
					end
					if (rmatch and gmatch and bmatch) then
						break
					end
				end
			end

			if (A < 200) then
				Collision[Y + 1][X + 1] = true
			end
		end
	end

	Self.Layers[1] = Self:Process(One)
	Self.Layers[2] = Self:Process(Two)
	Self.Layers[3] = Self:Process(Three)
	Self.Layers["Collision"] = Self:Process(Collision)
end

Map.LoadSpecial = function(Self, Data)
	local ToInit = {}
	Self.Layers["Special"] = {}

	for Y = 0, Data:getHeight() - 1 do
		local YLoc = Data:getHeight() - Y
		Self.Layers.Special[YLoc] = {}
		for X = 0, Data:getWidth() - 1 do
			local R, G, B, A = Data:getPixel(X, Y)
			if (A > 1) then
				local MatchedTile
				for ID, TileData in next, Tile.FlatQuad do
					if (TileData.ID == R) then
						MatchedTile = TileData
						break
					end
				end

				if (MatchedTile and MatchedTile.Special) then
					Self.Layers.Special[YLoc][X + 1] = MatchedTile.Special:Create(MatchedTile, R, G, B, A, X + 1, YLoc)
				end
			end
		end
	end
end

Map.Process = function(Self, Data)
	local New = {}

	for Y = #Data, 1, -1 do
		table.insert(New, Data[Y])
	end

	return New
end

Map.Render = function(Self)
	local Batch, TileFactor, Scale = Self.TileBatch, Self.TileFactor, Lib.Tile.Scale

	Batch:bind()

	for Layer = 1, 3 do
		for Y, TileSet in next, Self.Layers[Layer] do
			for X, FlatTileID in next, TileSet do
				local TileData = Tile.FlatQuad[FlatTileID]
				if (TileData) then
					Batch:addq(TileData.Quad, X * TileFactor - Self.TileFactor, Y * TileFactor, 0, Scale, -Scale)
				else
					print("Invalid FlatQuad ID", FlatTileID)
				end
			end
		end
	end

	if (Self.Layers.Special) then
		for Y, TileSet in next, Self.Layers.Special do
			for X, FlatTile in next, TileSet do
				local TileData = FlatTile.Tile
				if (TileData) then
					Batch:addq(TileData.Quad, X * TileFactor - Self.TileFactor, Y * TileFactor, 0, Scale, -Scale)
				end
			end
		end
	end

	Batch:unbind()
end

Map.Draw = function(Self)
	love.graphics.draw(Self.TileBatch, 0, 0)
end

setmetatable(Map, {
	__call = function(Self, GLib)
		Lib = GLib

		Tile = GLib.Tile
		Self.TileFactor = Tile.Size * Tile.Scale

		GLib.OOPS.Objectify(Self)
		return Self
	end
})

return Map