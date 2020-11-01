local LibManage = {}

LibManage.Root = "Engine."
LibManage.Core = {"Utility", "OOPS", "Misc", "Entity", "Character", "Engine", "Tile", "Entities", "EntityManager", "Map", "World", "Universe"}
LibManage.Lib = {}

LibManage.Load = function(Self, Name, Alias)
	local Loaded = require(Self.Root .. Name)(Self.Lib)
	LibManage.Lib[Alias or Loaded["Name"] or Name] = Loaded
	return Loaded
end

LibManage.BatchLoad = function(Self, Arguments)
	for ID, Library in next, Arguments do
		Self:Load((type(Library) == "table") and unpack(Library) or Library)
	end
end

LibManage.Init = function(Self)
	Self:BatchLoad(Self.Core)
end

setmetatable(LibManage, {
	__call = function(Self)
		return Self
	end
})

return LibManage