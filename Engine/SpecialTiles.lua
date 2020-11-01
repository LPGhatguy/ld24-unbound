--This is NOT a library!
local Tiles = {}
local Lib

Tiles.Paper = {}
Tiles.Paper.Texts = {
[[
4:00 AM, July 17th, 1963/n/n
The local geologists say the seismic activity has died down enough to venture into
the tunnels of the structure to begin a damage assessment. Roger and David are my team
on this assignment -- both friends from high school that have hardly matured since.
I'd imagine it's going to be just like all the other earthquake damage assessments done
in the area. The building code in this area is so strict I'm sure there's no real damage.
/n/n
We've been assigned to stay down here for 2 days, and we've been given all the necessary
equipment to carry out our duties.
]],
[[
4:15 AM, July 17th, 1963/n/n
I've got a bit of downtime due to the fact that there's quite a bit of debris blocking the
path. Roger and David are much heavier set than me, so they're taking care of it.
It's hard to believe that this was once an office building; my initial damage predictions
appear to have been a bit off.
]],
[[
5:30 AM, July 17th, 1963/n/n
It took us longer than we anticipated to break through the rock, as it filled the entire hallway
leading into the next set of corridors. It seems like some of the hallways here have been crushed
off completely by pieces of the building that were higher up. Most of them still seem O.K. though.
It's a miracle anything survived, really.
]],
[[
9:00 AM, July 17th, 1963/n/n
We just returned from doing a complete inspection of this level, primarily through the access tunnels.
It'll have to be demolished and rebuilt, that much is certain, but of course,
our job is to find how deep the demolition has to go.
/n/n
We noticed these strange tiles that have "G"s written on them, it looks like they're covered
in some sort of glass. I wonder how they weren't destroyed in the earthquake. We're finishing
up our surveys of the area, then we'll head to the utility tunnels down a few levels.
]],
[[
1:00 PM, July 17th, 1963/n/n
Upon entering the underground utility tunnels, we knew immediately that the pipes would need to be
repaired. The piping down here is expansive and expensive; too expensive to replace, but too important
to let fall into disrepair. There are pieces of pipe busted everywhere, not to mention broken walkway.
Navigating the area is difficult, but still relatively possible.
/n/n
Roger and David went back to the surface to get the proper materials for repairing pipes as we had
no idea that the earthquake was severe enough to damage them. They told me they'd be back within 3
hours. I stayed back to plan out what repairs exactly would need to be had.
]],
[[
3:15 PM, July 17th, 1963/n/n
I'm no geologist, but that felt like a large earthquake to me. I ducked into a tool storage station
and waited as it felt the world was being shaken apart.
/n/n
Upon emerging from the shelter, I noticed both ends of the tunnel were now sealed tight by rock,
probably several feet thick. This isn't turning out to be the greatest repair mission I've been
on, and it happens to be steering towards the worst.
]],
[[
9:45 PM, July 17th, 1963/n/n
After waiting for several hours, there is no indication that a rescue team is on the way. They
couldn't cut through rock that thick anyway. I've decided to try to get below the utility tunnels,
where there should be a way to the surface independent of the building we entered through. Besides,
I'll bet I've got a better chance of getting out through the lowest level tunnels than any rescue
team would have of cutting through that rock.
]],
[[
3:30 AM, July 18th, 1963/n/n
I didn't wander very far from where I entered the utility tunnels in the off-chance that the
rescue workers somehow manage to break through. It feels like the atmosphere of this place is
leaking into my mind, it feels like the darkness is trying to pry open my head and let insanity in.
I can't tell if the sounds I'm hearing are in my head or if I'm being followed by something that
isn't human.
]],
[[
????/n/n
This is the end. I can feel my body giving way to the heavy weight of the darkness, a darkness
weighing more than my mind can bear. My emotions feel bent, crooked, my heart black and corrupt.
/n
I feel that I will never leave this place.
]]
}

for Index, Text in next, Tiles.Paper.Texts do
	Tiles.Paper.Texts[Index] = Text:gsub("\n", " "):gsub("/n", "\n")
end

Tiles.Paper.Create = function(Self, Tile, R, G, B, A)
	local Paper = {Text = Tiles.Paper.Texts[G] or "Invalid Text"}
	Paper.Tile = Tile

	Paper.Click = function(Self)
		Lib.Engine.Message = Self.Text
		Lib.Engine.ShowMessage = true
	end

	return Paper
end

Tiles.EndPaper = {}
Tiles.EndPaper.Create = function(Self, Tile, R, G, B, A)
	local Paper = {Text = Tiles.Paper.Texts[G] or "Invalid Text"}
	Paper.Tile = Tile

	Paper.Click = function(Self)
		Lib.Engine.TheEnd = true
		Lib.Engine.Message = Self.Text
		Lib.Engine.ShowMessage = true
	end

	return Paper
end

Tiles.LevelChange = {}
Tiles.LevelChange.Create = function(Self, Tile, R, G, B, A)
	local Changer = {}
	Changer.Set = true
	Changer.Tile = Tile

	Changer.Collide = function(Self)
		if (Self.Set) then
			Self.Set = false
			if (Lib.Universe.World < Lib.Universe.WorldCount) then
				Lib.Engine.CycleWorld = true
			else
				Lib.Engine:Victory()
			end
		end
	end

	return Changer
end

Tiles.LevelStart = {}
Tiles.LevelStart.Create = function(Self, Tile, R, G, B, A, X, Y)
	local Starter = {}
	Starter.Tile = Tile

	local WX, WY = Lib.Universe:FromGrid(X, Y)

	Lib.Engine.Character.Position = {X = WX - 32, Y = WY - 32}
	Lib.Universe.Brightness = Lib.Universe.Brightness - 8

	return Starter
end

setmetatable(Tiles, {
	__call = function(Self, GLib)
		Lib = GLib
		return Self
	end
})

return Tiles