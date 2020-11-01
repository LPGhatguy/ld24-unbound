local Tile = {}

local SpecialTiles = require("Engine.SpecialTiles")

local t = function(Name, ID, SpecialName)
	return {Name = Name, ID = ID, Special = SpecialTiles[SpecialName]}
end

Tile.Quad =  {
	{t("Tile", 1), t("Scuff1", 100), t("Scuff2", 101), t("Scuff3", 102), t("Scuff4", 103), t("Scuff5", 104), t("Glass G", 105), t("Paper", 200, "Paper"), t("Start", 201, "LevelStart"), t("End", 202, "LevelChange"), t("EndPaper", 203, "EndPaper")},
	{t("Ledge Up", 2), t("Ledge Down", 3), t("Ledge Left", 4), t("Ledge Right", 5), t("Ledge Bottom Left", 6), t("Ledge Top Left", 7), t("Ledge Top Right", 8), t("Ledge Bottom Right", 9), t("LedgeIn Bottom Left", 10), t("LedgeIn Top Left", 11), t("LedgeIn Top Right", 12), t("LedgeIn Bottom Right", 13)},
	{t("Metal Plate", 50), t("Red Metal", 51), t("Pipe Down", 52), t("Pipe Up", 53), t("Concrete 1", 54), t("Concrete 2", 55), t("Concrete 3", 56), t("Sandstone Base", 57)}
}

t = nil

Tile.Size = 16
Tile.Scale = 4
Tile.FlatQuad = {}

Tile.LoadQuads = function(Self, Source)
	local Width, Height = Source:getWidth(), Source:getHeight()

	for Y = 0, (Height / Self.Size) - 1 do
		Self.Quad[Y+1] = Self.Quad[Y+1] or {}
		for X = 0, (Width / Self.Size) - 1 do
			if (Self.Quad[Y+1][X+1]) then
				Self.Quad[Y+1][X+1]["Quad"] = love.graphics.newQuad(X * Self.Size, Y * Self.Size,
					Self.Size, Self.Size, Width, Height)
			end
		end
	end
end

Tile.FlattenQuads = function(Self)
	for Y, QuadSet in next, Self.Quad do
		for X, Quad in next, QuadSet do
			table.insert(Self.FlatQuad, Quad)
		end
	end
end

Tile.Init = function(Self, Tileset)
	Self:LoadQuads(Tileset)
	Self:FlattenQuads()
end

setmetatable(Tile, {
	__call = function(Self, GLib)
		SpecialTiles(GLib)
		return Self
	end
})

return Tile