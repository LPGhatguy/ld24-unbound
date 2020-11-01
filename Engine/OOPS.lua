local OOPS = {}
local Lib

OOPS.Base = {}

OOPS.Base.New = function(Object)
	return Lib.Utility.TableCopy(Object)
end

OOPS.Base.Inherit = function(To, From)
	Lib.Utility.TableMerge(From, To)
end

OOPS.Objectify = function(Object)
	OOPS.Base.Inherit(Object, OOPS.Base)
end

setmetatable(OOPS, {
	__call = function(Self, GLib)
		Lib = GLib

		return Self
	end
})

return OOPS