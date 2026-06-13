RedMF = RedMF or {};
RedMF.TimeToLevel = RedMF.TimeToLevel or {};

function RedMF.TimeToLevel.ParseNumber(value)
	if value == nil then
		return nil;
	end

	local normalized = string.gsub(value, ",", "");
	return tonumber(normalized);
end

function RedMF.TimeToLevel.FormatNumber(value)
	local number = math.floor(value or 0);
	local text = tostring(number);
	local sign = "";

	if string.sub(text, 1, 1) == "-" then
		sign = "-";
		text = string.sub(text, 2);
	end

	text = string.reverse(text);
	text = string.gsub(text, "(%d%d%d)", "%1,");
	text = string.reverse(text);
	text = string.gsub(text, "^,", "");

	return sign .. text;
end

function RedMF.TimeToLevel.FormatDuration(totalSeconds)
	local seconds = math.max(0, math.floor(totalSeconds or 0));
	local hours = math.floor(seconds / 3600);
	local minutes = math.floor((seconds % 3600) / 60);
	local remainder = seconds % 60;

	if hours > 0 then
		return string.format("%d:%02d:%02d", hours, minutes, remainder);
	end

	return string.format("%d:%02d", minutes, remainder);
end

function RedMF.TimeToLevel.NormalizeSeconds(timeValue)
	if timeValue == nil then
		return nil;
	end

	if type(timeValue) == "number" then
		return timeValue;
	end

	if type(timeValue) == "table" then
		local year = timeValue.Year or 0;
		local month = timeValue.Month or 1;
		local day = timeValue.Day or 1;
		local hour = timeValue.Hour or 0;
		local minute = timeValue.Minute or 0;
		local second = timeValue.Second or 0;

		return (((((year * 372 + month) * 31 + day) * 24 + hour) * 60 + minute) * 60 + second);
	end

	return nil;
end

function RedMF.TimeToLevel.GetNowSeconds()
	local now = Turbine.Engine.GetLocalTime();
	if type(now) == "number" then
		return now;
	end

	return RedMF.TimeToLevel.NormalizeSeconds(now) or 0;
end
