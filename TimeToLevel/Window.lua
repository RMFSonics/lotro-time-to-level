
TimeToLevel = TimeToLevel or {};



TimeToLevel.Window = {};

TimeToLevel.Window.__index = TimeToLevel.Window;



TimeToLevel.Window.MIN_WIDTH = 260;

TimeToLevel.Window.MIN_HEIGHT = 204;

TimeToLevel.Window.PADDING = 12;



function TimeToLevel.Window:New()

	local window = setmetatable({}, self);



	TimeToLevel.LoadSettings();



	window.control = Turbine.UI.Lotro.GoldWindow();

	window.control:SetText("Time To Level");

	window.control:SetSize(

		TimeToLevel.Settings.width or TimeToLevel.Window.MIN_WIDTH,

		TimeToLevel.Settings.height or TimeToLevel.Window.MIN_HEIGHT

	);

	window.control:SetPosition(TimeToLevel.Settings.left, TimeToLevel.Settings.top);

	window.control:SetOpacity(TimeToLevel.Settings.opacity);

	window.control:SetVisible(TimeToLevel.Settings.visible);

	window.control:SetZOrder(75);



	window.syncFieldsLocked = false;

	window.alphaScrollLocked = false;



	window.titleLabel = Turbine.UI.Label();

	window.titleLabel:SetParent(window.control);

	window.titleLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);

	window.titleLabel:SetForeColor(Turbine.UI.Color(1, 0.92, 0.78, 0.45));



	window.progressLabel = Turbine.UI.Label();

	window.progressLabel:SetParent(window.control);

	window.progressLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.progressLabel:SetForeColor(Turbine.UI.Color(1, 0.95, 0.9, 0.85));



	window.barBack = Turbine.UI.Control();

	window.barBack:SetParent(window.control);

	window.barBack:SetBackColor(Turbine.UI.Color(0.55, 0.08, 0.08, 0.08));



	window.barFill = Turbine.UI.Control();

	window.barFill:SetParent(window.barBack);

	window.barFill:SetPosition(0, 0);

	window.barFill:SetBackColor(Turbine.UI.Color(0.85, 0.35, 0.72, 0.35));



	window.timeLabel = Turbine.UI.Label();

	window.timeLabel:SetParent(window.control);

	window.timeLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.timeLabel:SetForeColor(Turbine.UI.Color(1, 0.82, 0.72, 0.55));



	window.rateLabel = Turbine.UI.Label();

	window.rateLabel:SetParent(window.control);

	window.rateLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.rateLabel:SetForeColor(Turbine.UI.Color(1, 0.78, 0.88, 0.65));



	window.syncCurrentLabel = Turbine.UI.Label();

	window.syncCurrentLabel:SetParent(window.control);

	window.syncCurrentLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.syncCurrentLabel:SetForeColor(Turbine.UI.Color(1, 0.82, 0.72, 0.55));

	window.syncCurrentLabel:SetText("Cur");



	window.syncCurrentInput = Turbine.UI.Lotro.TextBox();

	window.syncCurrentInput:SetParent(window.control);

	window.syncCurrentInput:SetMultiline(false);

	window.syncCurrentInput:SetFont(Turbine.UI.Lotro.Font.Verdana12);



	window.syncRequiredLabel = Turbine.UI.Label();

	window.syncRequiredLabel:SetParent(window.control);

	window.syncRequiredLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.syncRequiredLabel:SetForeColor(Turbine.UI.Color(1, 0.82, 0.72, 0.55));

	window.syncRequiredLabel:SetText("Need");



	window.syncRequiredInput = Turbine.UI.Lotro.TextBox();

	window.syncRequiredInput:SetParent(window.control);

	window.syncRequiredInput:SetMultiline(false);

	window.syncRequiredInput:SetFont(Turbine.UI.Lotro.Font.Verdana12);



	window.syncButton = Turbine.UI.Lotro.Button();

	window.syncButton:SetParent(window.control);

	window.syncButton:SetText("Sync to XP bar");



	window.alphaLabel = Turbine.UI.Label();

	window.alphaLabel:SetParent(window.control);

	window.alphaLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.alphaLabel:SetForeColor(Turbine.UI.Color(1, 0.82, 0.72, 0.55));

	window.alphaLabel:SetText("Background alpha");



	window.alphaScroll = Turbine.UI.Lotro.ScrollBar();

	window.alphaScroll:SetParent(window.control);

	window.alphaScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);

	window.alphaScroll:SetMinimum(0);

	window.alphaScroll:SetMaximum(100);

	window.alphaScroll:SetSmallChange(1);

	window.alphaScroll:SetLargeChange(5);

	window.alphaScrollLocked = true;

	window.alphaScroll:SetValue(math.floor((TimeToLevel.Settings.opacity or 0.82) * 100 + 0.5));

	window.alphaScrollLocked = false;



	window.alphaValueLabel = Turbine.UI.Label();

	window.alphaValueLabel:SetParent(window.control);

	window.alphaValueLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);

	window.alphaValueLabel:SetForeColor(Turbine.UI.Color(1, 0.78, 0.88, 0.65));

	window.alphaValueLabel:SetText(string.format("%.2f", TimeToLevel.Settings.opacity or 0.82));



	window.resizeCtrl = Turbine.UI.Control();

	window.resizeCtrl:SetParent(window.control);

	window.resizeCtrl:SetSize(16, 16);

	window.resizeCtrl:SetZOrder(200);

	window.resizeCtrl:SetBackColor(Turbine.UI.Color(0.35, 0.45, 0.38, 0.28));



	local function lockSyncFields()

		window.syncFieldsLocked = true;

	end



	local function unlockSyncFields()

		window.syncFieldsLocked = false;

	end



	window.syncCurrentInput.FocusGained = lockSyncFields;

	window.syncRequiredInput.FocusGained = lockSyncFields;

	window.syncCurrentInput.FocusLost = unlockSyncFields;

	window.syncRequiredInput.FocusLost = unlockSyncFields;



	window.syncButton.MouseDown = function(_, args)

		if args.Button == Turbine.UI.MouseButton.Left then

			window:ApplySyncFromInputs();

		end

	end;



	window.alphaScroll.ValueChanged = function(sender)

		if window.alphaScrollLocked then

			return;

		end



		local opacity = sender:GetValue() / 100;

		window:SetOpacity(opacity);

	end;



	window.resizeCtrl.MouseDown = function(sender, args)

		if args.Button ~= Turbine.UI.MouseButton.Left then

			return;

		end



		sender.dragStartX = args.X;

		sender.dragStartY = args.Y;

		sender.dragging = true;

	end;



	window.resizeCtrl.MouseUp = function(sender)

		sender.dragging = false;

		window:SaveSize();

	end;



	window.resizeCtrl.MouseMove = function(sender, args)

		if not sender.dragging then

			return;

		end



		local width, height = window.control:GetSize();

		window.control:SetSize(

			width + (args.X - sender.dragStartX),

			height + (args.Y - sender.dragStartY)

		);

		window:ApplyLayout();

	end;



	window.control.PositionChanged = function()

		window:SavePosition();

	end;



	window.control.Closed = function()

		window:SetVisible(false);

	end;



	window.lastRefreshSeconds = 0;

	window.control:SetWantsUpdates(true);

	window.control.Update = function()

		window:OnUpdate();

	end;



	window:ApplyLayout();

	TimeToLevel.ClampWindowPosition(window.control);

	window:UpdateDisplay({

		level = 0,

		nextLevel = 0,

		xpGained = 0,

		xpRequired = 0,

		xpRemaining = 0,

		percent = 0,

		elapsedSeconds = 0,

		xpPerMinute = 0,

		xpPerHour = 0,

		etaSeconds = nil,

		hasXpSample = false,

	});



	return window;

end



function TimeToLevel.Window:ApplyLayout()

	local width = math.max(self.control:GetWidth(), TimeToLevel.Window.MIN_WIDTH);

	local height = math.max(self.control:GetHeight(), TimeToLevel.Window.MIN_HEIGHT);

	local pad = TimeToLevel.Window.PADDING;

	local contentWidth = width - (pad * 2);

	local inputWidth = math.max(60, math.floor((contentWidth - 90) / 2));



	if width ~= self.control:GetWidth() or height ~= self.control:GetHeight() then

		self.control:SetSize(width, height);

	end



	self.titleLabel:SetPosition(pad, 34);

	self.titleLabel:SetSize(contentWidth, 16);



	self.progressLabel:SetPosition(pad, 52);

	self.progressLabel:SetSize(contentWidth, 16);



	self.barBack:SetPosition(pad, 70);

	self.barBack:SetSize(contentWidth, 10);

	self.barFill:SetHeight(10);



	self.timeLabel:SetPosition(pad, 84);

	self.timeLabel:SetSize(contentWidth, 16);



	self.rateLabel:SetPosition(pad, 100);

	self.rateLabel:SetSize(contentWidth, 16);



	self.syncCurrentLabel:SetPosition(pad, 118);

	self.syncCurrentLabel:SetSize(36, 16);



	self.syncCurrentInput:SetPosition(pad + 40, 116);

	self.syncCurrentInput:SetSize(inputWidth, 20);



	self.syncRequiredLabel:SetPosition(pad + 48 + inputWidth, 118);

	self.syncRequiredLabel:SetSize(40, 16);



	self.syncRequiredInput:SetPosition(pad + 88 + inputWidth, 116);

	self.syncRequiredInput:SetSize(inputWidth, 20);



	self.syncButton:SetPosition(pad, 142);

	self.syncButton:SetSize(contentWidth, 20);



	self.alphaLabel:SetPosition(pad, height - 38);

	self.alphaLabel:SetSize(contentWidth - 48, 16);



	self.alphaScroll:SetPosition(pad, height - 24);

	self.alphaScroll:SetSize(math.max(120, contentWidth - 48), 10);



	self.alphaValueLabel:SetPosition(width - pad - 40, height - 26);

	self.alphaValueLabel:SetSize(40, 16);



	self.resizeCtrl:SetPosition(width - self.resizeCtrl:GetWidth(), height - self.resizeCtrl:GetHeight());



	if TimeToLevel.tracker ~= nil then

		local stats = TimeToLevel.tracker:GetStats();

		if stats ~= nil then

			self:UpdateBar(stats.percent or 0);

		end

	end

end



function TimeToLevel.Window:SetOpacity(opacity)

	local clampedOpacity = math.max(0, math.min(opacity or 0, 1));

	self.control:SetOpacity(clampedOpacity);

	TimeToLevel.Settings.opacity = clampedOpacity;



	self.alphaScrollLocked = true;

	self.alphaScroll:SetValue(math.floor(clampedOpacity * 100 + 0.5));

	self.alphaScrollLocked = false;



	self.alphaValueLabel:SetText(string.format("%.2f", clampedOpacity));

	TimeToLevel.SaveSettings();

end



function TimeToLevel.Window:ApplySyncFromInputs()

	local currentXp = TimeToLevel.ParseNumber(self.syncCurrentInput:GetText());

	local requiredXp = TimeToLevel.ParseNumber(self.syncRequiredInput:GetText());



	if currentXp == nil then

		Turbine.Shell.WriteLine("TimeToLevel: enter your current XP in the Cur box.");

		return;

	end



	if requiredXp == nil or requiredXp <= 0 then

		requiredXp = nil;

	end



	if TimeToLevel.tracker ~= nil then

		TimeToLevel.tracker:Sync(currentXp, requiredXp);

		self:UpdateDisplay(TimeToLevel.tracker:GetStats());

	end

end



function TimeToLevel.Window:UpdateSyncFields(stats)

	if self.syncFieldsLocked or stats == nil then

		return;

	end



	self.syncCurrentInput:SetText(tostring(stats.xpGained or 0));



	if stats.xpRequired ~= nil and stats.xpRequired > 0 then

		self.syncRequiredInput:SetText(tostring(stats.xpRequired));

	end

end



function TimeToLevel.Window:SavePosition()

	TimeToLevel.Settings.left = self.control:GetLeft();

	TimeToLevel.Settings.top = self.control:GetTop();

	TimeToLevel.SaveSettings();

end



function TimeToLevel.Window:SaveSize()

	TimeToLevel.Settings.width = self.control:GetWidth();

	TimeToLevel.Settings.height = self.control:GetHeight();

	TimeToLevel.SaveSettings();

end



function TimeToLevel.Window:OnUpdate()

	local now = TimeToLevel.GetNowSeconds();

	if now - self.lastRefreshSeconds >= 1 then

		self.lastRefreshSeconds = now;

		if TimeToLevel.tracker ~= nil then

			self:UpdateDisplay(TimeToLevel.tracker:GetStats());

		end

	end

end



function TimeToLevel.Window:UpdateBar(percent)

	local width = self.barBack:GetWidth();

	local fillWidth = math.floor(width * math.max(0, math.min(percent, 100)) / 100);

	self.barFill:SetWidth(fillWidth);

end



function TimeToLevel.Window:UpdateDisplay(stats)

	if stats == nil then

		return;

	end



	self:UpdateSyncFields(stats);

	self.titleLabel:SetText(string.format("Level %d -> %d", stats.level, stats.nextLevel));



	if stats.xpRequired <= 0 then

		self.progressLabel:SetText("Max level reached");

		self:UpdateBar(100);

		self.timeLabel:SetText("");

		self.rateLabel:SetText("");

		return;

	end



	if not stats.hasXpSample then

		self.progressLabel:SetText(string.format(

			"0 / %s XP (0.0%%)",

			TimeToLevel.FormatNumber(stats.xpRequired)

		));

		self:UpdateBar(0);

		self.timeLabel:SetText("Waiting for XP chat...");

		self.rateLabel:SetText("Enter bar values below and click Sync");

		return;

	end



	self.progressLabel:SetText(string.format(

		"%s / %s XP (%.1f%%)",

		TimeToLevel.FormatNumber(stats.xpGained),

		TimeToLevel.FormatNumber(stats.xpRequired),

		stats.percent

	));

	self:UpdateBar(stats.percent);



	local etaText = "Level complete";

	if stats.xpRemaining > 0 then

		if stats.etaSeconds ~= nil then

			etaText = string.format("ETA %s", TimeToLevel.FormatDuration(stats.etaSeconds));

		else

			etaText = "ETA --";

		end

	end



	self.timeLabel:SetText(string.format(

		"This level %s  |  %s",

		TimeToLevel.FormatDuration(stats.elapsedSeconds),

		etaText

	));



	self.rateLabel:SetText(string.format(

		"%s XP/min  |  %s XP/hr",

		TimeToLevel.FormatNumber(stats.xpPerMinute),

		TimeToLevel.FormatNumber(stats.xpPerHour)

	));

end



function TimeToLevel.Window:SetVisible(visible)

	self.control:SetVisible(visible);

	TimeToLevel.Settings.visible = visible;

	TimeToLevel.SaveSettings();

end



function TimeToLevel.Window:IsVisible()

	return self.control:IsVisible();

end



function TimeToLevel.Window:ToggleVisible()

	self:SetVisible(not self:IsVisible());

end

