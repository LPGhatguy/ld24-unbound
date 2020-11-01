local Entity = {}
Entity.Position = {X = 0, Y = 0}
Entity.Velocity = {X = 0, Y = 0}
Entity.RotVelocity = 0
Entity.Z = 0
Entity.Rotation = 0
Entity.Scale = 3
Entity.Type = 1
Entity.Visible = true

setmetatable(Entity, {
	__call = function(Self, GLib)
		GLib.OOPS.Objectify(Self)

		return Self
	end
})

return Entity