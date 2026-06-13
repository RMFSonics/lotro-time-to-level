RedMF = RedMF or {};
RedMF.TimeToLevel = RedMF.TimeToLevel or {};

RedMF.TimeToLevel.Settings = {
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

function RedMF.TimeToLevel.LoadSettings()
	local saved = Turbine.PluginData.Load(Turbine.DataScope.Account, "TimeToLevelSettings");
	if saved == nil then
		return;
	end

	if saved.left ~= nil then
		RedMF.TimeToLevel.Settings.left = saved.left;
	end
	if saved.top ~= nil then
		RedMF.TimeToLevel.Settings.top = saved.top;
	end
	if saved.width ~= nil then
		RedMF.TimeToLevel.Settings.width = saved.width;
	end
	if saved.height ~= nil then
		RedMF.TimeToLevel.Settings.height = saved.height;
	end
	if saved.opacity ~= nil then
		RedMF.TimeToLevel.Settings.opacity = saved.opacity;
	end
	if saved.visible ~= nil then
		RedMF.TimeToLevel.Settings.visible = saved.visible;
	end
	if saved.toggleLeft ~= nil then
		RedMF.TimeToLevel.Settings.toggleLeft = saved.toggleLeft;
	end
	if saved.toggleTop ~= nil then
		RedMF.TimeToLevel.Settings.toggleTop = saved.toggleTop;
	end
	if saved.toggleOpacity ~= nil then
		RedMF.TimeToLevel.Settings.toggleOpacity = saved.toggleOpacity;
	end
	if saved.toggleVisible ~= nil then
		RedMF.TimeToLevel.Settings.toggleVisible = saved.toggleVisible;
	end
end

function RedMF.TimeToLevel.SaveSettings()
	Turbine.PluginData.Save(Turbine.DataScope.Account, "TimeToLevelSettings", {
		left = RedMF.TimeToLevel.Settings.left,
		top = RedMF.TimeToLevel.Settings.top,
		width = RedMF.TimeToLevel.Settings.width,
		height = RedMF.TimeToLevel.Settings.height,
		opacity = RedMF.TimeToLevel.Settings.opacity,
		visible = RedMF.TimeToLevel.Settings.visible,
		toggleLeft = RedMF.TimeToLevel.Settings.toggleLeft,
		toggleTop = RedMF.TimeToLevel.Settings.toggleTop,
		toggleOpacity = RedMF.TimeToLevel.Settings.toggleOpacity,
		toggleVisible = RedMF.TimeToLevel.Settings.toggleVisible,
	});
end

function RedMF.TimeToLevel.ClampWindowPosition(window)
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
