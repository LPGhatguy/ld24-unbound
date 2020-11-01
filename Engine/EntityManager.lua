local EntityManager = {}
local Lib, Entities

EntityManager.Members = {}

EntityManager.Update = function(Self, Delta)
	for EntityID, Entity in next, Self.Members do
		if (Entity.Update) then
			Entity:Update(Delta)
		else
			Entity.Position.X = Entity.Position.X + (Entity.Velocity.X * Delta)
			Entity.Position.Y = Entity.Position.Y + (Entity.Velocity.Y * Delta)
		end
	end
end

EntityManager.Draw = function(Self)
	local FlatQuad, Scale, Sheet = Entities.FlatQuad, Entities.Scale, Entities.Sheet

	for EntityID, Entity in next, Self.Members do
		if (FlatQuad[Entity.Type] and Entity.Visible) then
			love.graphics.drawq(Sheet, FlatQuad[Entity.Type].Quad, Entity.Position.X, Entity.Position.Y,
				Entity.Rotation, Entity.Scale, -Entity.Scale, 8, 8)
		end
	end
end

EntityManager.Add = function(Self, Entity)
	table.insert(Self.Members, Entity)
	Self:SortMembers()
end

EntityManager.BatchAdd = function(Self, Entities)
	for _, Entity in next, Entities do
		table.insert(Self.Members, Entity)
	end

	Self:SortMembers()
end

EntityManager.SortMembers = function(Self)
	table.sort(Self.Members, Self.EntityCompare)
end

EntityManager.EntityCompare = function(E1, E2)
	return E1.Z > E2.Z
end

EntityManager.Create = function(Self)
	return Self:New()
end

setmetatable(EntityManager, {
	__call = function(Self, GLib)
		Lib = GLib
		Entities = GLib.Entities
		GLib.OOPS.Objectify(Self)
		return Self
	end
})

return EntityManager