RedMF = RedMF or {};
RedMF.TimeToLevel = RedMF.TimeToLevel or {};

RedMF.TimeToLevel.ToggleButton = {};
RedMF.TimeToLevel.ToggleButton.__index = RedMF.TimeToLevel.ToggleButton;

RedMF.TimeToLevel.ToggleButton.WIDTH = 44;
RedMF.TimeToLevel.ToggleButton.HEIGHT = 24;

function RedMF.TimeToLevel.ToggleButton:New(mainWindow)
	local toggle = setmetatable({}, self);

	toggle.mainWindow = mainWindow;
	toggle.control = Turbine.UI.Window();
	toggle.control:SetSize(RedMF.TimeToLevel.ToggleButton.WIDTH, RedMF.TimeToLevel.ToggleButton.HEIGHT);
	toggle.control:SetZOrder(80);
	toggle.control:SetVisible(RedMF.TimeToLevel.Settings.toggleVisible ~= false);

	local left = RedMF.TimeToLevel.Settings.toggleLeft;
	local top = RedMF.TimeToLevel.Settings.toggleTop;
	if left == nil then
		left = Turbine.UI.Display.GetWidth() - 55;
	end
	if top == nil then
		top = 310;
	end

	toggle.control:SetPosition(left, top);
	toggle.control:SetOpacity(RedMF.TimeToLevel.Settings.toggleOpacity or 0.65);

	toggle.button = Turbine.UI.Control();
	toggle.button:SetParent(toggle.control);
	toggle.button:SetPosition(0, 0);
	toggle.button:SetSize(RedMF.TimeToLevel.ToggleButton.WIDTH, RedMF.TimeToLevel.ToggleButton.HEIGHT);
	toggle.button:SetBackColor(Turbine.UI.Color(0.72, 0.14, 0.14, 0.16));

	toggle.label = Turbine.UI.Label();
	toggle.label:SetParent(toggle.button);
	toggle.label:SetPosition(0, 0);
	toggle.label:SetSize(RedMF.TimeToLevel.ToggleButton.WIDTH, RedMF.TimeToLevel.ToggleButton.HEIGHT);
	toggle.label:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	toggle.label:SetForeColor(Turbine.UI.Color(1, 0.9, 0.85, 0.75));
	toggle.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	toggle.label:SetText("TTL");

	toggle.button.MouseEnter = function()
		toggle.button:SetBackColor(Turbine.UI.Color(0.82, 0.18, 0.18, 0.22));
		toggle.control:SetOpacity(0.9);
	end;

	toggle.button.MouseLeave = function()
		toggle.button:SetBackColor(Turbine.UI.Color(0.72, 0.14, 0.14, 0.16));
		toggle.control:SetOpacity(RedMF.TimeToLevel.Settings.toggleOpacity or 0.65);
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

		if sender.dragging then
			sender.dragging = false;
		end

		if not sender.dragged and toggle.mainWindow ~= nil then
			toggle.mainWindow:ToggleVisible();
		end

		toggle:SavePosition();
	end;

	toggle.button.MouseMove = function(sender, args)
		if not sender.dragging then
			return;
		end

		local leftPos, topPos = toggle.control:GetPosition();
		toggle.control:SetPosition(
			leftPos + (args.X - sender.dragStartX),
			topPos + (args.Y - sender.dragStartY)
		);
		sender:SetPosition(0, 0);
		sender.dragged = true;
		RedMF.TimeToLevel.ClampWindowPosition(toggle.control);
	end;

	RedMF.TimeToLevel.ClampWindowPosition(toggle.control);
	return toggle;
end

function RedMF.TimeToLevel.ToggleButton:SavePosition()
	RedMF.TimeToLevel.Settings.toggleLeft = self.control:GetLeft();
	RedMF.TimeToLevel.Settings.toggleTop = self.control:GetTop();
	RedMF.TimeToLevel.SaveSettings();
end

function RedMF.TimeToLevel.ToggleButton:SetVisible(visible)
	self.control:SetVisible(visible);
	RedMF.TimeToLevel.Settings.toggleVisible = visible;
	RedMF.TimeToLevel.SaveSettings();
end

function RedMF.TimeToLevel.ToggleButton:IsVisible()
	return self.control:IsVisible();
end
