TimeToLevel = TimeToLevel or {};

TimeToLevel.ToggleButton = {};
TimeToLevel.ToggleButton.__index = TimeToLevel.ToggleButton;

TimeToLevel.ToggleButton.WIDTH = 44;
TimeToLevel.ToggleButton.HEIGHT = 24;
TimeToLevel.ToggleButton.DRAG_THRESHOLD = 4;

function TimeToLevel.ToggleButton:New(mainWindow)
	local toggle = setmetatable({}, self);

	toggle.mainWindow = mainWindow;
	toggle.control = Turbine.UI.Window();
	toggle.control:SetSize(TimeToLevel.ToggleButton.WIDTH, TimeToLevel.ToggleButton.HEIGHT);
	toggle.control:SetZOrder(80);
	toggle.control:SetVisible(TimeToLevel.Settings.toggleVisible ~= false);

	local left = TimeToLevel.Settings.toggleLeft;
	local top = TimeToLevel.Settings.toggleTop;
	if left == nil then
		left = Turbine.UI.Display.GetWidth() - 55;
	end
	if top == nil then
		top = 310;
	end

	toggle.control:SetPosition(left, top);
	toggle.control:SetOpacity(TimeToLevel.Settings.toggleOpacity or 0.65);

	toggle.button = Turbine.UI.Control();
	toggle.button:SetParent(toggle.control);
	toggle.button:SetPosition(0, 0);
	toggle.button:SetSize(TimeToLevel.ToggleButton.WIDTH, TimeToLevel.ToggleButton.HEIGHT);
	toggle.button:SetBackColor(Turbine.UI.Color(0.72, 0.14, 0.14, 0.16));

	toggle.label = Turbine.UI.Label();
	toggle.label:SetParent(toggle.button);
	toggle.label:SetPosition(0, 0);
	toggle.label:SetSize(TimeToLevel.ToggleButton.WIDTH, TimeToLevel.ToggleButton.HEIGHT);
	toggle.label:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	toggle.label:SetForeColor(Turbine.UI.Color(1, 0.9, 0.85, 0.75));
	toggle.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	toggle.label:SetText("TTL");
	toggle.label:SetMouseVisible(false);

	local function toggleMainWindow()
		if toggle.mainWindow == nil then
			return;
		end

		toggle.mainWindow:SetVisible(not toggle.mainWindow:IsVisible());
	end

	toggle.button.MouseEnter = function()
		toggle.button:SetBackColor(Turbine.UI.Color(0.82, 0.18, 0.18, 0.22));
		toggle.control:SetOpacity(0.9);
	end;

	toggle.button.MouseLeave = function()
		toggle.button:SetBackColor(Turbine.UI.Color(0.72, 0.14, 0.14, 0.16));
		toggle.control:SetOpacity(TimeToLevel.Settings.toggleOpacity or 0.65);
	end;

	toggle.button.MouseDown = function(sender, args)
		if args.Button ~= Turbine.UI.MouseButton.Left then
			return;
		end

		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
		sender.dragged = false;
	end;

	toggle.button.MouseUp = function(sender, args)
		if args.Button ~= Turbine.UI.MouseButton.Left then
			return;
		end

		local wasDragging = sender.dragging;
		sender.dragging = false;

		if wasDragging and not sender.dragged then
			toggleMainWindow();
		elseif wasDragging and sender.dragged then
			toggle:SavePosition();
		end
	end;

	toggle.button.MouseMove = function(sender, args)
		if not sender.dragging then
			return;
		end

		local deltaX = args.X - sender.dragStartX;
		local deltaY = args.Y - sender.dragStartY;

		if not sender.dragged then
			if math.abs(deltaX) < TimeToLevel.ToggleButton.DRAG_THRESHOLD
				and math.abs(deltaY) < TimeToLevel.ToggleButton.DRAG_THRESHOLD then
				return;
			end

			sender.dragged = true;
		end

		local leftPos, topPos = toggle.control:GetPosition();
		toggle.control:SetPosition(leftPos + deltaX, topPos + deltaY);
		sender:SetPosition(0, 0);
		TimeToLevel.ClampWindowPosition(toggle.control);
	end;

	TimeToLevel.ClampWindowPosition(toggle.control);
	return toggle;
end

function TimeToLevel.ToggleButton:SavePosition()
	TimeToLevel.Settings.toggleLeft = self.control:GetLeft();
	TimeToLevel.Settings.toggleTop = self.control:GetTop();
	TimeToLevel.SaveSettings();
end

function TimeToLevel.ToggleButton:SetVisible(visible)
	self.control:SetVisible(visible);
	TimeToLevel.Settings.toggleVisible = visible;
	TimeToLevel.SaveSettings();
end

function TimeToLevel.ToggleButton:IsVisible()
	return self.control:IsVisible();
end
