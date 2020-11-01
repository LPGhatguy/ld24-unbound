local World = {}
local Lib, EntityManager, Map

World.Map = nil
World.EntityManager = nil
World.Time = 0

World.Create = function(Self, Tileset, EntityManager, ID)
	New = Self:New()
	New.Map = Map:Create(Tileset, love.image.newImageData("Content/Maps/Map" .. tostring(ID) .. ".png"))
	New.Map:LoadSpecial(love.image.newImageData("Content/Maps/Map" .. tostring(ID) .. "S.png"))
	New.EntityManager = EntityManager

	return New
end

World.Update = function(Self, Delta)
	Self.Time = Self.Time + Delta
	Self.EntityManager:Update(Delta)
end

World.Render = function(Self)
	Self.Map:Render()
end

World.Draw = function(Self)
	Self.Map:Draw()
	Self.EntityManager:Draw()
end

setmetatable(World, {
	__call = function(Self, GLib)
		Lib = GLib
		EntityManager = GLib.EntityManager
		Map = GLib.Map

		GLib.OOPS.Objectify(Self)

		return Self
	end
})

return World