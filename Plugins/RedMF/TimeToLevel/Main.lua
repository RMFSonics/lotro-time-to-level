import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

import "RedMF.TimeToLevel.Settings";
import "RedMF.TimeToLevel.Callbacks";
import "RedMF.TimeToLevel.Util";
import "RedMF.TimeToLevel.LevelXpCost";
import "RedMF.TimeToLevel.Window";
import "RedMF.TimeToLevel.ToggleButton";
import "RedMF.TimeToLevel.Tracker";

RedMF.TimeToLevel.debugChat = false;

RedMF.TimeToLevel.window = RedMF.TimeToLevel.Window:New();
RedMF.TimeToLevel.toggleButton = RedMF.TimeToLevel.ToggleButton:New(RedMF.TimeToLevel.window);
RedMF.TimeToLevel.tracker = RedMF.TimeToLevel.Tracker:New(RedMF.TimeToLevel.window);
RedMF.TimeToLevel.tracker:Start();

RedMF.TimeToLevel.command = Turbine.ShellCommand();

function RedMF.TimeToLevel.command:Execute(_, args)
	if args == nil or args == "" then
		RedMF.TimeToLevel.tracker:ReportToChat();
		return;
	end

	if args == "show" then
		RedMF.TimeToLevel.window:SetVisible(true);
	elseif args == "hide" then
		RedMF.TimeToLevel.window:SetVisible(false);
	elseif args == "toggle" then
		RedMF.TimeToLevel.window:ToggleVisible();
	elseif args == "button show" then
		RedMF.TimeToLevel.toggleButton:SetVisible(true);
	elseif args == "button hide" then
		RedMF.TimeToLevel.toggleButton:SetVisible(false);
	elseif args == "button toggle" then
		RedMF.TimeToLevel.toggleButton:SetVisible(not RedMF.TimeToLevel.toggleButton:IsVisible());
	elseif args == "reset" then
		RedMF.TimeToLevel.tracker:Reset();
		Turbine.Shell.WriteLine("TimeToLevel: session reset for this level.");
	elseif args == "debug" then
		RedMF.TimeToLevel.debugChat = not RedMF.TimeToLevel.debugChat;
		if RedMF.TimeToLevel.debugChat then
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

		currentXp = RedMF.TimeToLevel.ParseNumber(currentXp);
		requiredXp = RedMF.TimeToLevel.ParseNumber(requiredXp);

		if currentXp == nil then
			Turbine.Shell.WriteLine("TimeToLevel: usage /ttl sync <current xp> [required xp]");
		else
			RedMF.TimeToLevel.tracker:Sync(currentXp, requiredXp);
		end
	else
		self:GetHelp();
	end
end

function RedMF.TimeToLevel.command:GetHelp()
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

Turbine.Shell.AddCommand("ttl", RedMF.TimeToLevel.command);
Turbine.Shell.WriteLine("TimeToLevel v1.2.2 loaded. Click TTL to toggle, drag to move.");

Plugins["TimeToLevel"].Unload = function()
	RedMF.TimeToLevel.tracker:Stop();
	if RedMF.TimeToLevel.window ~= nil then
		RedMF.TimeToLevel.window:SavePosition();
		RedMF.TimeToLevel.window:SaveSize();
	end
	if RedMF.TimeToLevel.toggleButton ~= nil then
		RedMF.TimeToLevel.toggleButton:SavePosition();
	end
	Turbine.Shell.RemoveCommand("ttl");
end;
