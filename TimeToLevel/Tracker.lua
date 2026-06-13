TimeToLevel = TimeToLevel or {};

TimeToLevel.Tracker = {};
TimeToLevel.Tracker.__index = TimeToLevel.Tracker;

function TimeToLevel.Tracker:New(window)
	local tracker = setmetatable({}, self);
	tracker.window = window;
	tracker.player = Turbine.Gameplay.LocalPlayer:GetInstance();
	tracker.level = tracker.player:GetLevel();
	tracker.xpGained = 0;
	tracker.sessionXpEarned = 0;
	tracker.levelStartTotal = nil;
	tracker.lifetimeFloor = nil;
	tracker.lastLifetimeTotal = nil;
	tracker.xpRequiredOverride = nil;
	tracker.levelStartSeconds = TimeToLevel.GetNowSeconds();
	tracker.hasXpSample = false;
	tracker.lastSaveSeconds = 0;
	tracker.chatHandler = function(_, args) tracker:OnChatReceived(args); end;
	tracker.levelHandler = function() tracker:OnLevelChanged(); end;
	return tracker;
end

function TimeToLevel.Tracker:LoadState()
	local saved = Turbine.PluginData.Load(Turbine.DataScope.Character, "TimeToLevelState");
	if saved == nil then
		return;
	end

	if saved.level == self.level then
		if saved.dataVersion ~= TimeToLevel.DATA_VERSION then
			self.xpRequiredOverride = nil;
			self.levelStartTotal = nil;
		end

		self.xpGained = saved.xpGained or 0;
		self.sessionXpEarned = saved.sessionXpEarned or 0;
		self.levelStartTotal = saved.levelStartTotal;
		self.lifetimeFloor = saved.lifetimeFloor;
		self.lastLifetimeTotal = saved.lastLifetimeTotal;
		self.xpRequiredOverride = saved.xpRequiredOverride;
		self.levelStartSeconds = TimeToLevel.NormalizeSeconds(saved.levelStartSeconds)
			or TimeToLevel.GetNowSeconds();
		self.hasXpSample = (self.xpGained or 0) > 0 or (self.sessionXpEarned or 0) > 0;
	else
		self:ResetLevelSession(self.level);
	end
end

function TimeToLevel.Tracker:SaveState()
	Turbine.PluginData.Save(Turbine.DataScope.Character, "TimeToLevelState", {
		dataVersion = TimeToLevel.DATA_VERSION,
		level = self.level,
		xpGained = self.xpGained,
		sessionXpEarned = self.sessionXpEarned,
		levelStartTotal = self.levelStartTotal,
		lifetimeFloor = self.lifetimeFloor,
		lastLifetimeTotal = self.lastLifetimeTotal,
		xpRequiredOverride = self.xpRequiredOverride,
		levelStartSeconds = self.levelStartSeconds,
	}, function(success)
		if not success then
			Turbine.Shell.WriteLine("TimeToLevel: failed to save state.");
		end
	end);
end

function TimeToLevel.Tracker:ResetLevelSession(level)
	self.level = level or self.player:GetLevel();
	self.xpGained = 0;
	self.sessionXpEarned = 0;
	self.levelStartTotal = nil;
	self.lifetimeFloor = nil;
	self.lastLifetimeTotal = nil;
	self.xpRequiredOverride = nil;
	self.levelStartSeconds = TimeToLevel.GetNowSeconds();
	self.hasXpSample = false;
	self:SaveState();
	self:RefreshDisplay();
end

function TimeToLevel.Tracker:GetXpRequired()
	if self.xpRequiredOverride ~= nil and self.xpRequiredOverride > 0 then
		return self.xpRequiredOverride;
	end

	return TimeToLevel.GetXpToLevel(self.level);
end

function TimeToLevel.Tracker:GetElapsedSeconds()
	return math.max(0, TimeToLevel.GetNowSeconds() - self.levelStartSeconds);
end

function TimeToLevel.Tracker:GetStats()
	local xpRequired = self:GetXpRequired();
	local xpRemaining = math.max(0, xpRequired - self.xpGained);
	local elapsed = self:GetElapsedSeconds();
	local percent = 0;

	if xpRequired > 0 then
		percent = (self.xpGained / xpRequired) * 100;
	end

	local xpPerSecond = 0;
	local xpPerMinute = 0;
	local xpPerHour = 0;
	local etaSeconds = nil;

	if self.hasXpSample and elapsed > 0 and self.sessionXpEarned > 0 then
		xpPerSecond = self.sessionXpEarned / elapsed;
		xpPerMinute = xpPerSecond * 60;
		xpPerHour = xpPerSecond * 3600;

		if xpRemaining > 0 and xpPerSecond > 0 then
			etaSeconds = xpRemaining / xpPerSecond;
		elseif xpRemaining == 0 then
			etaSeconds = 0;
		end
	elseif self.hasXpSample and elapsed > 0 and self.xpGained > 0 and self.sessionXpEarned == 0 then
		xpPerSecond = self.xpGained / elapsed;
		xpPerMinute = xpPerSecond * 60;
		xpPerHour = xpPerSecond * 3600;

		if xpRemaining > 0 and xpPerSecond > 0 then
			etaSeconds = xpRemaining / xpPerSecond;
		elseif xpRemaining == 0 then
			etaSeconds = 0;
		end
	end

	return {
		level = self.level,
		nextLevel = self.level + 1,
		xpGained = self.xpGained,
		xpRequired = xpRequired,
		xpRemaining = xpRemaining,
		percent = percent,
		elapsedSeconds = elapsed,
		xpPerMinute = xpPerMinute,
		xpPerHour = xpPerHour,
		etaSeconds = etaSeconds,
		hasXpSample = self.hasXpSample,
	};
end

function TimeToLevel.Tracker:IsCharacterXpMessage(message)
	if message == nil then
		return false;
	end

	local lower = string.lower(message);

	if string.find(lower, "legendary", 1, true)
		or string.find(lower, "reward track", 1, true)
		or string.find(lower, "war-steed", 1, true)
		or string.find(lower, "warsteed", 1, true)
		or string.find(lower, "crafting experience", 1, true)
		or string.find(lower, "proficiency experience", 1, true)
		or string.find(lower, "mastery experience", 1, true) then
		return false;
	end

	return string.find(lower, "earned", 1, true) ~= nil
		and string.find(lower, " xp", 1, true) ~= nil;
end

function TimeToLevel.Tracker:ParseXpMessage(message)
	if message == nil or not self:IsCharacterXpMessage(message) then
		return nil;
	end

	local gainStr, totalStr = string.match(
		message,
		"You.ve earned ([%d,]+) [Xx][Pp] for a total of ([%d,]+) [Xx][Pp]"
	);

	if gainStr == nil then
		gainStr = string.match(message, "You.ve earned ([%d,]+) [Xx][Pp]");
	end

	if gainStr == nil then
		gainStr = string.match(message, "You earn ([%d,]+) experience points?")
			or string.match(message, "You have gained ([%d,]+) experience points?");
	end

	local gain = TimeToLevel.ParseNumber(gainStr);
	local total = TimeToLevel.ParseNumber(totalStr);

	if gain == nil and total == nil then
		return nil;
	end

	return {
		gain = gain,
		total = total,
	};
end

function TimeToLevel.Tracker:ApplyXpMessage(xpMessage)
	if xpMessage == nil then
		return false;
	end

	local gain = xpMessage.gain or 0;
	local total = xpMessage.total;
	local required = self:GetXpRequired();

	if gain > 0 then
		self.sessionXpEarned = self.sessionXpEarned + gain;
	end

	if total ~= nil then
		self.lastLifetimeTotal = total;

		if required > 0 and total <= required * 1.1 then
			self.xpGained = total;
		elseif self.lifetimeFloor ~= nil then
			self.xpGained = math.max(0, total - self.lifetimeFloor);
		elseif gain > 0 then
			self.xpGained = self.xpGained + gain;
		else
			return false;
		end
	elseif gain > 0 then
		self.xpGained = self.xpGained + gain;
	else
		return false;
	end

	self.hasXpSample = true;
	return true;
end

function TimeToLevel.Tracker:Sync(currentXp, requiredXp)
	if currentXp ~= nil and currentXp >= 0 then
		self.xpGained = currentXp;
		self.sessionXpEarned = 0;
		self.levelStartSeconds = TimeToLevel.GetNowSeconds();
		self.hasXpSample = true;

		if self.lastLifetimeTotal ~= nil then
			self.lifetimeFloor = self.lastLifetimeTotal - currentXp;
		end
	end

	if requiredXp ~= nil and requiredXp > 0 then
		self.xpRequiredOverride = requiredXp;
		TimeToLevel.LevelXpCost[self.level + 1] = requiredXp;
	end

	self:SaveState();
	self:RefreshDisplay();

	Turbine.Shell.WriteLine(string.format(
		"TimeToLevel: synced to %s / %s XP for level %d.",
		TimeToLevel.FormatNumber(self.xpGained),
		TimeToLevel.FormatNumber(self:GetXpRequired()),
		self.level
	));
end

function TimeToLevel.Tracker:ParseLevelUp(message)
	if message == nil then
		return nil;
	end

	local level = string.match(message, "reached Level (%d+)")
		or string.match(message, "advanced to Level (%d+)")
		or string.match(message, "Level (%d+)!");

	return tonumber(level);
end

function TimeToLevel.Tracker:OnChatReceived(args)
	if args == nil or args.Message == nil then
		return;
	end

	local message = args.Message;

	local lower = string.lower(message);
	if TimeToLevel.debugChat
		and (string.find(lower, " xp", 1, true) or string.find(lower, "experience", 1, true)) then
		Turbine.Shell.WriteLine(string.format("TimeToLevel debug [%s]: %s", tostring(args.ChatType), message));
	end

	local xpMessage = self:ParseXpMessage(message);
	if self:ApplyXpMessage(xpMessage) then
		self:RefreshDisplay();
		self:MaybeSaveState();
		return;
	end

	local newLevel = self:ParseLevelUp(message);
	if newLevel ~= nil and newLevel > self.level then
		self:ResetLevelSession(newLevel);
	end
end

function TimeToLevel.Tracker:OnLevelChanged()
	local currentLevel = self.player:GetLevel();
	if currentLevel ~= self.level then
		self:ResetLevelSession(currentLevel);
	end
end

function TimeToLevel.Tracker:MaybeSaveState()
	local now = TimeToLevel.GetNowSeconds();
	if now - self.lastSaveSeconds >= 15 then
		self.lastSaveSeconds = now;
		self:SaveState();
	end
end

function TimeToLevel.Tracker:RefreshDisplay()
	if self.window ~= nil then
		self.window:UpdateDisplay(self:GetStats());
	end
end

function TimeToLevel.Tracker:Start()
	self:LoadState();
	TimeToLevel.AddCallback(Turbine.Chat, "Received", self.chatHandler);
	TimeToLevel.AddCallback(self.player, "LevelChanged", self.levelHandler);
	self:RefreshDisplay();
end

function TimeToLevel.Tracker:Stop()
	TimeToLevel.RemoveCallback(Turbine.Chat, "Received", self.chatHandler);
	TimeToLevel.RemoveCallback(self.player, "LevelChanged", self.levelHandler);
	self:SaveState();
end

function TimeToLevel.Tracker:Reset()
	self:ResetLevelSession(self.player:GetLevel());
end

function TimeToLevel.Tracker:ReportToChat()
	local stats = self:GetStats();

	if stats.xpRequired <= 0 then
		Turbine.Shell.WriteLine(string.format("TimeToLevel: level %d appears to be at the level cap.", stats.level));
		return;
	end

	if not stats.hasXpSample then
		Turbine.Shell.WriteLine(string.format(
			"TimeToLevel: level %d -> %d. Gain XP to start timing (0 / %s).",
			stats.level,
			stats.nextLevel,
			TimeToLevel.FormatNumber(stats.xpRequired)
		));
		return;
	end

	local etaText = "ready now";
	if stats.xpRemaining > 0 then
		if stats.etaSeconds ~= nil then
			etaText = TimeToLevel.FormatDuration(stats.etaSeconds);
		else
			etaText = "unknown";
		end
	end

	Turbine.Shell.WriteLine(string.format(
		"TimeToLevel: %d -> %d | %s / %s (%.1f%%) | this level %s | %s XP/min | ETA %s",
		stats.level,
		stats.nextLevel,
		TimeToLevel.FormatNumber(stats.xpGained),
		TimeToLevel.FormatNumber(stats.xpRequired),
		stats.percent,
		TimeToLevel.FormatDuration(stats.elapsedSeconds),
		TimeToLevel.FormatNumber(stats.xpPerMinute),
		etaText
	));
end
