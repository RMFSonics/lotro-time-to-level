import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

import "TimeToLevel.TimeToLevel.Settings";
import "TimeToLevel.TimeToLevel.Callbacks";
import "TimeToLevel.TimeToLevel.Util";
import "TimeToLevel.TimeToLevel.LevelXpCost";
import "TimeToLevel.TimeToLevel.Window";
import "TimeToLevel.TimeToLevel.ToggleButton";
import "TimeToLevel.TimeToLevel.Tracker";

TimeToLevel.debugChat = false;

TimeToLevel.window = TimeToLevel.Window:New();
TimeToLevel.toggleButton = TimeToLevel.ToggleButton:New(TimeToLevel.window);
TimeToLevel.tracker = TimeToLevel.Tracker:New(TimeToLevel.window);
TimeToLevel.tracker:Start();

TimeToLevel.command = Turbine.ShellCommand();

function TimeToLevel.command:Execute(_, args)
	if args == nil or args == "" then
		TimeToLevel.tracker:ReportToChat();
		return;
	end

	if args == "show" then
		TimeToLevel.window:SetVisible(true);
	elseif args == "hide" then
		TimeToLevel.window:SetVisible(false);
	elseif args == "toggle" then
		TimeToLevel.window:ToggleVisible();
	elseif args == "button show" then
		TimeToLevel.toggleButton:SetVisible(true);
	elseif args == "button hide" then
		TimeToLevel.toggleButton:SetVisible(false);
	elseif args == "button toggle" then
		TimeToLevel.toggleButton:SetVisible(not TimeToLevel.toggleButton:IsVisible());
	elseif args == "reset" then
		TimeToLevel.tracker:Reset();
		Turbine.Shell.WriteLine("TimeToLevel: session reset for this level.");
	elseif args == "debug" then
		TimeToLevel.debugChat = not TimeToLevel.debugChat;
		if TimeToLevel.debugChat then
			Turbine.Shell.WriteLine("TimeToLevel: chat debug enabled.");
		else
			Turbine.Shell.WriteLine("TimeToLevel: chat debug disabled.");
		end
	elseif string.sub(args, 1, 5) == "sync " then
		local currentXp, requiredXp = string.match(args, "^sync ([%d,]+) ([%d,]+)$");
		if currentXp == nil then
			currentXp = string.match(args, "^sync ([%d,]+)$");
			requiredXp = nil;
		end

		currentXp = TimeToLevel.ParseNumber(currentXp);
		requiredXp = TimeToLevel.ParseNumber(requiredXp);

		if currentXp == nil then
			Turbine.Shell.WriteLine("TimeToLevel: usage /ttl sync <current xp> [required xp]");
		else
			TimeToLevel.tracker:Sync(currentXp, requiredXp);
		end
	else
		self:GetHelp();
	end
end

function TimeToLevel.command:GetHelp()
	Turbine.Shell.WriteLine("TimeToLevel commands:");
	Turbine.Shell.WriteLine("  /ttl            report current stats");
	Turbine.Shell.WriteLine("  /ttl show       show window");
	Turbine.Shell.WriteLine("  /ttl hide       hide window");
	Turbine.Shell.WriteLine("  /ttl toggle     toggle window");
	Turbine.Shell.WriteLine("  /ttl button show|hide|toggle  TTL launcher button");
	Turbine.Shell.WriteLine("  /ttl reset      reset this level session");
	Turbine.Shell.WriteLine("  /ttl sync <cur> [need]  match your XP bar");
	Turbine.Shell.WriteLine("  /ttl debug      log XP-related chat lines");
end

Turbine.Shell.AddCommand("ttl", TimeToLevel.command);
Turbine.Shell.WriteLine("TimeToLevel v1.2.5 loaded. Click TTL to toggle, drag to move.");

Plugins["TimeToLevel"].Unload = function()
	TimeToLevel.tracker:Stop();
	if TimeToLevel.window ~= nil then
		TimeToLevel.window:SavePosition();
		TimeToLevel.window:SaveSize();
	end
	if TimeToLevel.toggleButton ~= nil then
		TimeToLevel.toggleButton:SavePosition();
	end
	Turbine.Shell.RemoveCommand("ttl");
end;
