RedMF = RedMF or {};
RedMF.TimeToLevel = RedMF.TimeToLevel or {};

function RedMF.TimeToLevel.AddCallback(object, event, callback)
	if object[event] == nil then
		object[event] = callback;
	elseif type(object[event]) == "table" then
		table.insert(object[event], callback);
	else
		object[event] = { object[event], callback };
	end
	return callback;
end

function RedMF.TimeToLevel.RemoveCallback(object, event, callback)
	if object[event] == nil then
		return;
	end

	if type(object[event]) == "function" then
		if object[event] == callback then
			object[event] = nil;
		end
		return;
	end

	for index, existing in ipairs(object[event]) do
		if existing == callback then
			table.remove(object[event], index);
			break;
		end
	end

	if #object[event] == 0 then
		object[event] = nil;
	elseif #object[event] == 1 then
		object[event] = object[event][1];
	end
end
