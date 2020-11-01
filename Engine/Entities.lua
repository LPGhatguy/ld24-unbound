local Entities = {}
local Lib

local q = function(Name)
	return {Name = Name}
end

Entities.Quad = {
	{q("Invisible"), q("C1"), q("C2"), q("C3"), q("C4"), q("C5"), q("CG1"), q("CG2"), q("CG3"), q("CG4"), q("CG5")},
	{q("Crosshair"), q("Cursor")}
}

q = nil

Entities.FlatQuad = {}
Entities.Sheet = nil
Entities.Size = 16
Entities.Scale = 3

Entities.LoadQuads = function(Self, Sheet)
	Self.Sheet = Sheet
	local Width, Height = Sheet:getWidth(), Sheet:getHeight()

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

Entities.FlattenQuads = function(Self)
	for Y, QuadSet in next, Self.Quad do
		for X, Quad in next, QuadSet do
			table.insert(Self.FlatQuad, Quad)
		end
	end
end

Entities.Init = function(Self, Entityset)
	Self:LoadQuads(Entityset)
	Self:FlattenQuads()
end

setmetatable(Entities, {
	__call = function(Self, GLib)
		Lib = GLib
		return Self
	end
})

return Entities