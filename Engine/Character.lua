local Character = {}
local Lib, Vector2
--Character.Position = {X=0, Y=160}
Character.Anim = {2, 3, 4, 3, 2, 5, 6, 5}
Character.AnimRate = 0.1
Character.AnimPassed = 0
Character.AnimFrame = 1
Character.ARotation = 0
Character.WalkSpeed = 100
Character.SprintSpeed = 200
Character.Walking = false
Character.Sprint = false
Character.Colliding = false
Character.Aim = true

Character.CycleAnimFrame = function(Self)
	Self.AnimFrame = Self.AnimFrame + 1
	if (Self.AnimFrame > #Self.Anim) then
		Self.AnimFrame = 1
	end

	Self.Type = Self.Anim[Self.AnimFrame]
end

Character.Forward = function(Self)
	Self.Velocity.X = math.cos(Self.ARotation)
	Self.Velocity.Y = math.sin(Self.ARotation)
end

Character.Backward = function(Self)
	Self.Velocity.X = -math.cos(Self.ARotation)
	Self.Velocity.Y = -math.sin(Self.ARotation)
end

Character.Right = function(Self)
	Self.Velocity.X = Self.Velocity.X + math.sin(Self.ARotation)
	Self.Velocity.Y = Self.Velocity.Y - math.cos(Self.ARotation)
end

Character.Left = function(Self)
	Self.Velocity.X = Self.Velocity.X - math.sin(Self.ARotation)
	Self.Velocity.Y = Self.Velocity.Y + math.cos(Self.ARotation)
end

Character.Update = function(Self, Delta)
	local mdx, mdy = Lib.Misc.WorldMouse.X - Self.Position.X, Lib.Misc.WorldMouse.Y - Self.Position.Y
	Self.ARotation = math.atan2(mdy, mdx)
	Self.Rotation = Self.ARotation - math.pi / 2

	if (Self.Walking) then
		Self.AnimPassed = Self.AnimPassed + Delta
		if (Self.AnimPassed > Self.AnimRate) then
			Self:CycleAnimFrame()
			Self.AnimPassed = Self.AnimPassed - Self.AnimRate
		end
	else
		Self.AnimFrame = 1
		Self.Type = Self.Anim[1]
	end

	Lib.Utility.NormalizeVector(Self.Velocity, Self.Sprint and Self.SprintSpeed or Self.WalkSpeed)
	local NewPosition = {X=Self.Position.X + Self.Velocity.X * Delta,
		Y=Self.Position.Y + Self.Velocity.Y * Delta}

	if (Lib.Universe:IsCollidable(NewPosition)) then
		Self.Colliding = true
	else
		Self.Colliding = false
		Self.Position = NewPosition
	end

	local GX, GY = Lib.Universe:ToGrid(Self.Position.X, Self.Position.Y)
	local SpecialY = Lib.Universe.CurrentWorld.Map.Layers.Special[GY]
	if (SpecialY and SpecialY[GX]) then
		local Special = SpecialY[GX]
		if (Special.Collide) then
			Special:Collide()
		end
	end

	Self.Velocity = {X = 0, Y = 0}
end

setmetatable(Character, {
	__call = function(Self, GLib)
		Lib = GLib
		Vector2 = GLib.Vector2

		GLib.OOPS.Objectify(Self)
		Self:Inherit(GLib.Entity)
		return Self
	end
})

return Character