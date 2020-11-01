local Utility = {}

Utility.TableCopy = function(From, To)
	To = To or {}

	for Index, Value in pairs(From) do
		if (type(Value) == "table") then
			To[Index] = Utility.TableCopy(Value, {})
		else
			To[Index] = Value
		end
	end

	return To
end

Utility.TableMerge = function(From, To)
	for Index, Value in pairs(From) do
		if (not To[Index]) then
			if (type(Value) == "table") then
				To[Index] = Utility.TableCopy(Value, {})
			else
				To[Index] = Value
			end
		end
	end

	return To
end

Utility.NormalizeVector = function(Vector, NewLength)
	local Length = math.sqrt(Vector.X^2 + Vector.Y^2)
	if (Length ~= 0) then
		NewLength = (NewLength or 1)
		Vector.X = Vector.X * NewLength / Length
		Vector.Y = Vector.Y * NewLength / Length
	end
end

Utility.CircleSquareIntersect = function(Point1, Radius, SqCenter, SqSize)

end

setmetatable(Utility, {
	__call = function(Self)
		return Self
	end
})

return Utility