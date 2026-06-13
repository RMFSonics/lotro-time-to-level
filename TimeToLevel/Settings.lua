TimeToLevel = TimeToLevel or {};

TimeToLevel.Settings = {
	left = 20,
	top = 120,
	width = 300,
	height = 204,
	opacity = 0.82,
	visible = true,
	toggleLeft = nil,
	toggleTop = nil,
	toggleOpacity = 0.65,
	toggleVisible = true,
};

function TimeToLevel.LoadSettings()
	local saved = Turbine.PluginData.Load(Turbine.DataScope.Account, "TimeToLevelSettings");
	if saved == nil then
		return;
	end

	if saved.left ~= nil then
		TimeToLevel.Settings.left = saved.left;
	end
	if saved.top ~= nil then
		TimeToLevel.Settings.top = saved.top;
	end
	if saved.width ~= nil then
		TimeToLevel.Settings.width = saved.width;
	end
	if saved.height ~= nil then
		TimeToLevel.Settings.height = saved.height;
	end
	if saved.opacity ~= nil then
		TimeToLevel.Settings.opacity = saved.opacity;
	end
	if saved.visible ~= nil then
		TimeToLevel.Settings.visible = saved.visible;
	end
	if saved.toggleLeft ~= nil then
		TimeToLevel.Settings.toggleLeft = saved.toggleLeft;
	end
	if saved.toggleTop ~= nil then
		TimeToLevel.Settings.toggleTop = saved.toggleTop;
	end
	if saved.toggleOpacity ~= nil then
		TimeToLevel.Settings.toggleOpacity = saved.toggleOpacity;
	end
	if saved.toggleVisible ~= nil then
		TimeToLevel.Settings.toggleVisible = saved.toggleVisible;
	end
end

function TimeToLevel.SaveSettings()
	Turbine.PluginData.Save(Turbine.DataScope.Account, "TimeToLevelSettings", {
		left = TimeToLevel.Settings.left,
		top = TimeToLevel.Settings.top,
		width = TimeToLevel.Settings.width,
		height = TimeToLevel.Settings.height,
		opacity = TimeToLevel.Settings.opacity,
		visible = TimeToLevel.Settings.visible,
		toggleLeft = TimeToLevel.Settings.toggleLeft,
		toggleTop = TimeToLevel.Settings.toggleTop,
		toggleOpacity = TimeToLevel.Settings.toggleOpacity,
		toggleVisible = TimeToLevel.Settings.toggleVisible,
	});
end

function TimeToLevel.ClampWindowPosition(window)
	local displayWidth = Turbine.UI.Display.GetWidth();
	local displayHeight = Turbine.UI.Display.GetHeight();
	local left = window:GetLeft();
	local top = window:GetTop();
	local width = window:GetWidth();
	local height = window:GetHeight();

	if left + width > displayWidth then
		left = displayWidth - width;
	end
	if top + height > displayHeight then
		top = displayHeight - height;
	end
	if left < 0 then
		left = 0;
	end
	if top < 0 then
		top = 0;
	end

	window:SetPosition(left, top);
end
