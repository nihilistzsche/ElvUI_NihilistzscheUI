local AceLocale = _G.ElvUI[1].Libs.ACL
local L = AceLocale:NewLocale("ElvUI", "zhCN")
if not L then
  return
end

L["NIHILISTUI_AUTHOR_INFO"] = "|cffff2020NihilistzscheUI|r by Nihilistzsche"
L["NIHILISTUI_CONTACTS"] = [=[Report issues at https://git.tukui.org/Nihilistzsche/ElvUI_NihilistzscheUI/issues]=]

-- Bait Bar
L["Bait Bar"] = true
L["NihilistzscheUI BaitBar by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI BaitBar provides a bar to use fishing baits from."] = true
L["Enable the bait bar"] = true
L["Only show the bait bar when you mouseover it"] = true

-- ButtonStyle
L["ButtonStyle"] = true
L["NihilistzscheUI ButtonStyle by Nihilistzsche"] = true
L["NihilistzscheUI ButtonStyle provides a style setting for ElvUI buttons similar to Masque or ButtonFacade\n"] = true
L["Enable the button style."] = true

-- WatchBarNotifier
L["WatchBarNotifier"] = true
L["NihilistzscheUI WatchBarNotifier by Nihilistzsche"] = true
L[
    "NihilistzscheUI WatchBarNotifier prints out messages to a given chat frame when you gain experience, reputation, artifact xp, or honor.\n"
  ] = true
L["Enable the watcher."] = true
L["WatchBarNotifier Options"] = true
L["Chat Frame to output XP messages to.  1-10.  Enter 0 to disable xp watcher."] = true
L["Chat Frame to output rep messages to.  1-10.  Enter 0 to disable rep watcher."] = true
L["Chat Frame to output Artifact XP messages to.  1-10.  Enter 0 to disable artifact xp watcher."] = true
L["Chat Frame to output Honor messages to.  1-10.  Enter 0 to disable honor watcher."] = true

-- FarmBar
L["Added item watch for %s"] = true
L["Added currency watch for %s"] = true
L["You have |cff00ff00earned|r %d %s (|cff00ffffcurrently|r %d)"] = true
L["You have |cffff0000lost|r %d %s (|cff00ffffcurrently|r %d)"] = true
L["Farm Bar"] = true
L["NihilistzscheUI FarmBar by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI FarmBar provides a bar to manually track items and currencies you are farming."] = true
L["Enable the farm bar"] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["Only show the farm bar when you mouseover it"] = true
L["Notify"] = true
L["Notify you when you gain (or lose) watched items/currencies"] = true
L["Spacing"] = true
L["Spacing between buttons"] = true
L["Alpha of the bar"] = true
L["Number of buttons on each row"] = true

-- NihilistzscheChat
L["Maximize"] = true
L["Minimize"] = true
L["NihilistzscheChat"] = true
L["NihilistzscheChat by Nihilistzsche/Hydrazine (tukui.org)"] = true
L["NihilistzscheChat makes your chat experience awesome"] = true
L["Border Color"] = true
L["Backdrop Color"] = true
L["AutoFade"] = true
L["AutoHide"] = true
L["ShowTitle"] = true
L["Timestamps"] = true
L["TimeFormat"] = true
L["To"] = true
L["From"] = true

-- ObjectiveTrackerHider
L["ObjectiveTrackerHider"] = true
L["NihilistzscheUI ObjectiveTrackerHider by Nihilistzsche"] = true
L["NihilistzscheUI ObjectiveTrackerHider hides or collapses the objective tracker based on your configuration."] = true
L["Enable the objective tracker hider."] = true
L["objective tracker Hider Options"] = true
L["Hide during PvP"] = true
L["Hide the objective tracker during PvP (i.e. Battlegrounds)"] = true
L["Hide in arena"] = true
L["Hide the objective tracker when in the arena"] = true
L["Hide in dungeon"] = true
L["Hide the objective tracker when in a dungeon"] = true
L["Hide in raid"] = true
L["Hide the objective tracker when in a dungeon"] = true
L["Collapse during PvP"] = true
L["Collapse the objective tracker during PvP (i.e. Battlegrounds)"] = true
L["Collapse in arena"] = true
L["Collapse the objective tracker when in the arena"] = true
L["Collapse in dungeon"] = true
L["Collapse the objective tracker when in a dungeon"] = true
L["Collapse in raid"] = true
L["Collapse the objective tracker during a raid"] = true

-- PartyXP
L["PartyXP"] = true
L["NihilistzscheUI PartyXP by Nihilistzsche"] = true
L["NihilistzscheUI PartyXP provides a configurable set of party experience bars for use with ElvUI.\n"] = true
L["Enable the party experience bars."] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["PartyXP Options"] = true
L["Class Colors"] = true
L["Use class colors for the experience bars"] = true
L["Detailed Text"] = true
L["Use detailed text in the experience bars"] = true
L["Default Font"] = true
L["The font that the text on the experience bars will use."] = true
L["The texture that will be used for the experience bars."] = true
L["Variables and Movers"] = true
L["Vertical offset from parent frame"] = true
L["Set the Width of the Text Font"] = true

-- Portal Bar
L["Portal Bar"] = true
L["NihilistzscheUI PortalBar by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI PortalBar provides a bar for mage portals and mage and challenge mode teleports."] = true
L["Enable the portal bar"] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["Only show the farm bar when you mouseover it"] = true
L["Spacing"] = true
L["Spacing between buttons"] = true
L["Alpha of the bar"] = true
L["Number of buttons on each row"] = true

-- Profession Bar
L["Profession Bar"] = true
L["NihilistzscheUI ProfessionBar by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI ProfessionBar provides an automatically updated bar with profession skills."] = true
L["Enable the profession bar"] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["Only show the profession bar when you mouseover it"] = true
L["Spacing between buttons"] = true
L["Alpha of the bar"] = true

-- Raid Prep Bar
L["Raid Prep Bar"] = true
L["NihilistzscheUI RaidPrepBar by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI RaidPrepBar provides a bar for your flasks and food."] = true
L["Enable the raid prep bar"] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["Only show the farm bar when you mouseover it"] = true
L["Spacing"] = true
L["Spacing between buttons"] = true
L["Alpha of the bar"] = true

-- Reminder
L["Add Group"] = true
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] = true
L[
    "Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."
  ] = true
L["Combat"] = true
L["Disable Sound"] = true
L["Don't play the warning sound."] = true
L["Group already exists!"] = true
L["Remove Group"] = true
L["Select Group"] = true
L["Role"] = true
L["Caster"] = true
L["Any"] = true
L["Spell"] = true
L["Spells"] = true
L["New ID"] = true
L["Remove ID"] = true
L["Personal Buffs"] = true
L["If any spell found inside this list is found the icon will hide as well"] = true
L["Inside BG/Arena"] = true
L["Inside Raid/Party"] = true
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] = true
L["Level Requirement"] = true
L["Level requirement for the icon to be able to display. 0 for disabled."] = true
L["Negate Spells"] = true
L["New ID (Negate)"] = true
L["Only run checks during combat."] = true
L["Only run checks inside BG/Arena instances."] = true
L["Only run checks inside raid/party instances."] = true
L["Only check if the buff is coming from you."] = "只当增益是是你自身施放时检查."
L["REMINDER_DESC"] = true
L["Remove ID (Negate)"] = true
L["Reverse Check"] = true
L["Set a talent tree to not follow the reverse check."] = true
L["Sound"] = true
L["Sound that will play when you have a warning icon displayed."] = true
L["Strict Filter"] = true
L["Talent Tree"] = true
L[
    "This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."
  ] = true
L["Don't play the warning sound."] = true
L["Tree Exception"] = true
L["Weapon"] = true
L["You can't remove a default group from the list, disabling the group."] = true
L["You must be a certain role for the icon to appear."] = true
L["You must be using a certain talent tree for the icon to show."] = true
L["CD Fade"] = true
L["Cooldown"] = true
L["On Cooldown"] = true
L["Reminders"] = true

-- VerticalUnitFrames
L["NihilistzscheUI VerticalUnitFrames "] = true
L[" is loaded. Thank you for using it and note that I will always support you."] = true
L["Vertical Unit Frames"] = true
L["Enable the Vertical Unit Frames."] = true
L["Reset Settings"] = true
L["Simple Layout"] = true
L["Use the simple layout from 2.0"] = true
L["Combo Layout"] = true
L["Use a layout designed to work with ElvUI unitframes"] = true
L["Vertical Unit Frame Options"] = true
L["Hide ElvUI Unitframes"] = true
L["Flash"] = true
L["Flash health/power when the low threshold is reached"] = true
L["Text Warning"] = true
L["Show a Text Warning when the low threshold is reached"] = true
L["Horizontal Castbar"] = true
L["Use a horizontal castbar"] = true
L["Variables"] = true
L["Set the Alpha of the Vertical Unit Frame when out of combat"] = true
L["Out of Combat Alpha"] = true
L["Start flashing health/power under this percentage"] = true
L["Raid Icon"] = true
L["Combat Indicator"] = true
L["PVP Text"] = true
L["Wild Mushroom Tracker"] = true
L["GCD Spark"] = true
L["Player Vertical Unit Frame"] = true
L["Target Vertical Unit Frame"] = true
L["Pet Vertical Unit Frame"] = true
L["Target Target Vertical Unit Frame"] = true
L["Pet Target Vertical Unit Frame"] = true
L["What to attach this element to."] = true
L["Eclipse"] = true
L["Override"] = true
L["Override the texture for this element"] = true
L["NihilistzscheUI VerticalUnitFrames by Nihilistzsche"] = true
L[
    "NihilistzscheUI VerticalUnitFrames provides a configurable centered, vertical unit frame option for use with ElvUI.\n"
  ] = true
L["Reset the settings of this addon to their defaults."] = true
L["Hide the ElvUI Unitframes when the Vertical Unit Frame is enabled"] = true
L["Hide the Vertical Unit Frame when out of Combat"] = true
L["Hide Out of Combat"] = true
L["Enable Mouse"] = true
L[
    "Enable the mouse to interface with the vertical unit frame (this option has no effect if ElvUI Unitframes are hidden)"
  ] = true
L["Set the Alpha of the Vertical Unit Frame when in combat"] = true
L["The texture that will be used for statusbars on this element."] = true
L["Override the font for this element"] = true
L["Set the font for this element"] = true
L["Set the font size for this element"] = true
L["Spacing"] = true
L["Texture"] = true
L["Tick Color"] = true
L["Value"] = true
L["Default"] = true
L["NihilistzscheUI_VerticalUnitFrames_CREDITS"] =
  [[Many thanks to the following people:

Tukz whose unitframe code was the basis for the Vertical Unit Frame
Elv for his amazing UI which was the inspiration for version 3
Hydrazine for inspiration
Boradan for help with the options
Sgt.Hydra for suggestions
Darth Predator for the Russian translation
NOme for the Korean translation
BuG for the French translation

The Tukui community for being supportive
]]

L["Thank you for using NihilistzscheUI VerticalUnitFrames!"] = true
L[
    "Here you can choose between the simple layout (only player health and power) or the default layout for the Vertical Unit Frame"
  ] = true
L["Simple Layout"] = true
L["Default Layout"] = true
L["Simple Layout Set"] = true

L["Equipment Manager"] = true
L["NihilistzscheUI Equipment Manager by Nihilistzsche, based on work by Azilroka"] = true
L["NihilistzscheUI Equipment Manager provides a bar for managing your equipment sets."] = true
L["General"] = true
L["Enable"] = true
L["Enable the equipment manager bar"] = true
L["Reset Settings"] = true
L["Reset the settings of this addon to their defaults."] = true
L["Mouseover"] = true
L["Only show the equipment manager bar when you mouseover it"] = true
L["Size"] = true
L["Button Size"] = true
L["Spacing"] = true
L["Spacing between buttons"] = true
L["Alpha"] = true
L["Alpha of the bar"] = true

L["Time the frame stays visible"] = true
L["Alpha of the frame when visible"] = true
L["Delay"] = true
L["Delay between updates"] = true

L["CooldownBar"] = true
L["NihilistzscheUI CooldownBar by Nihilistzsche"] = true
L["NihilistzscheUI CooldownBar provides a logarithmic cooldown display similar to SexyCooldown2\n"] = true
L["Enable the cooldown bar."] = true
L["Autohide"] = true
L["Hide the cooldown bar when the mouse is not over it, you are not in combat, and there is nothing tracked on cooldown"] =
  true
L["Switch Time"] = true
L["Reset Blacklist"] = true
L["Reset the blacklist."] = true

L["Mounts"] = true
L["%sMounts:|r %s added as favorite one."] = true
L["%sMounts:|r %s added as favorite two."] = true
L["%sMounts:|r %s added as favorite three."] = true
L["%sMounts:|r Favorites Cleared"] = true
L["%sElvUI|r NihilistzscheUI - Mounts Datatext"] = true
L["<Left Click> to open Pet Journal."] = true
L["<Right Click> to open mount list."] = true
L["<Shift + Left Click> to summon last mount."] = true
L["<Alt + Click> to reset your favorites."] = true
L["<Left Click> a mount to summon it."] = true
L["<Right Click> a mount to pick it up."] = true
L["<Shift + Click> a mount to set as favorite 1"] = true
L["<Ctrl + Click> a mount to set as favorite 2"] = true
L["<Alt + Click> a mount to set as favorite 3"] = true
L["Companions"] = true
L["%sCompanions:|r %s added as favorite one."] = true
L["%sCompanions:|r %s added as favorite two."] = true
L["%sCompanions:|r %s added as favorite three."] = true
L["%sElvUI|r NihilistzscheUI - Companions Datatext"] = true
L["<Left Click> to resummon/dismiss pet"] = true
L["<Right Click> to open pet list"] = true
L["<Shift + Left Click> to open pet journal"] = true
L["<Shift + Right Click> to open filter menu"] = true
L["<Alt + Click> to reset your favorites."] = true
L["<Click> a pet to summon/dismiss it."] = true
L["<Shift + Left Click> a pet to pick it up"] = true
L["<Alt + Click> a pet to set as favorite 1"] = true
L["<Ctrl + Click> a pet to set as favorite 2"] = true
L["<Ctrl + Alt + Click> a pet to set as favorite 3"] = true

L["Combat State Options"] = true
L["OOC_DESC"] =
  [[This options allow you to set different visibility and mouseover setting when entering or leaving combat.
Please note: if you enable state change for a bar here the presented options will disapper from the regular options for the said bar.]]
L["In Combat"] = true
L["Conditions below will take effet when entering combat."] = true
L["Out of Combat"] = true
L["Conditions below will take effet when leaving combat."] = true

L["CardinalPoints"] = true
L["Places cardinal points on your minimap (N, S, E, W)"] = true
L["Enable the minimap points"] = true

L["Artifact Power Button"] = true
L["NihilistzscheUI ArtifactPowerButton by Nihilistzsche"] = true
L["NihilistzscheUI ArtifactPowerButton provides a button for you to consume your artifact power items in your bags."] =
  true
L["Enable the artifact power button"] = true
L["Only show the artifact power button when you mouseover it"] = true

L["Warlock Demons"] = true
L["Demon Count"] = true
L["Timer bars and counts for demonology demons"] = true
L["Enable the demon count"] = true
L["Width of the bars"] = true
L["Height of the bars"] = true
L["Spacing between bars"] = true

L["CBO_POWER_DISABLED"] = "The %s power frame is disabled. Setting castbar overlay to health instead."
L["I understand"] = true
L["Arena"] = true
L["Boss"] = true
L["Choose which panel to overlay the castbar on."] = true
L["Enable Overlay"] = true
L["Focus"] = true
L["Hide Castbar text. Useful if your power height is very low or if you use power offset."] = true
L["Hide Text"] = true
L["Move castbar text to the left or to the right. Default is 4"] = true
L["Move castbar text up or down. Default is 0"] = true
L["Move castbar time to the left or to the right. Default is -4"] = true
L["Move castbar time up or down. Default is 0"] = true
L["Overlay Panel"] = true
L["Overlay the castbar on the chosen panel."] = true
L["Player"] = true
L["Target"] = true
L["Text xOffset"] = true
L["Text yOffset"] = true
L["Time xOffset"] = true
L["Time yOffset"] = true

L["Color for timers in the MM:SS format"] = true
L["Cooldowns"] = true
L["Font Size"] = true
L["MM:SS Color"] = true
L["MM:SS Threshold"] = true
L["Sets the size of the timers."] = true
L["Threshold (in seconds) before text is shown in the MM:SS format. Set to -1 to never change to this format."] = true

L["Above Icons"] = true
L[
    "Additional spacing between icon and statusbar. If a negative value is chosen then the statusbar is shown inside the icon. Changing this requires you to reload UI."
  ] = true
L["Allows you to choose which texture to use for statusbar backdrops. If disabled, no texture will be used."] = true
L["Allows you to choose which texture to use for statusbars. If disabled, no texture will be used."] = true
L["Always Show Text"] = true
L["Below Icons"] = true
L["Buffs Threshold"] = true
L["Buffs"] = true
L["Changes the statusbar to use a static color instead of going from green to red the lower duration it has."] = true
L[
    "Choose where you want the statusbar to be positioned. If you position it on the left or right side of the icon I advice you to increase Horizontal Spacing for Buffs and Debuffs. Changing this requires you to reload UI."
  ] = true
L[
    "Choose which color you want the statusbar backdrops to use. Tip: use light colors for dark statusbar colors and vice versa."
  ] = true
L["Choose which color you want your statusbars to use."] = true
L["Color when the text is in the HH:MM format (provided by the ExactAuras addon)."] = true
L["Debuffs Threshold"] = true
L["Debuffs"] = true
L["Decimal Threshold"] = true
L["Enable Static Color"] = true
L["General Options"] = true
L["Height of the statusbar frame (default: 5). Changing this requires you to reload UI."] = true
L["Hour/Minutes"] = true
L["If enabled, the timers on your buffs will switch to text when duration goes below set threshold."] = true
L["If enabled, the timers on your debuffs will switch to text when duration goes below set threshold."] = true
L["If enabled, the timers on your temporary enchant(s) will switch to text when duration goes below set threshold."] =
  true
L["Indicator (s, m, h, d)"] = true
L["Left Side of Icons"] = true
L["No Duration"] = true
L["Numbers"] = true
L["Position and Size"] = true
L["Right Side of Icons"] = true
L["Show bars for auras without a duration."] = true
L[
    "Show text in addition to statusbars. (You might need to move the text by changing the offset in the Buffs and Debuffs section)"
  ] = true
L["Show timers as bars instead of text."] = true
L["Static Statusbar Color"] = true
L["Statusbar Backdrop Color"] = true
L["Statusbar Backdrop Texture"] = true
L["Statusbar Height"] = true
L["Statusbar Options"] = true
L["Statusbar Position"] = true
L["Statusbar Spacing"] = true
L["Statusbar Texture"] = true
L["Statusbar Width"] = true
L["Switch to text based timers when duration goes below threshold"] = true
L["Temp. Threshold"] = true
L["Temporary Enchants"] = true
L["Text Options"] = true
L["Text Threshold"] = true
L["Threshold before the timer changes color and goes into decimal form. Set to -1 to disable."] = true
L["Threshold in seconds before status bar based timers turn to text."] = true
L["Use Backdrop Texture"] = true
L["Use Statusbar Texture"] = true
L["Width of the statusbar frame (default: 6). Changing this requires you to reload UI."] = true

L["(Hold Shift) Memory Usage"] = true
L["Announce Freed"] = true
L["Announce how much memory was freed by the garbage collection."] = true
L["Bandwidth"] = true
L[
    "Display world or home latency on the datatext.  Home latency refers to your realm server.  World latency refers to the current world server."
  ] = true
L["Download"] = true
L["FPS"] = true
L["Garbage Collect"] = true
L["Garbage Collection Freed"] = true
L["Home"] = true
L["Home Latency:"] = true
L["Improved System Datatext"] = true
L["Latency Type"] = true
L["Left Click:"] = true
L["Loaded Addons:"] = true
L["MS"] = true
L["Max Addons"] = true
L["Maximum number of addons to show in the tooltip."] = true
L["No"] = true
L["Plugins by |cff9382c9Lockslap|r"] = true
L["Reload UI"] = true
L["Reload UI?"] = true
L["Right Click:"] = true
L["Show FPS"] = true
L["Show FPS on the datatext."] = true
L["Show Latency"] = true
L["Show Memory"] = true
L["Show latency on the datatext."] = true
L["Show total addon memory on the datatext."] = true
L["Total Addons:"] = true
L["Total CPU:"] = true
L["Total Memory:"] = true
L["World"] = true
L["World Latency:"] = true
L["Yes"] = true

L["Ctrl + Click:"] = true
L["Left Click:"] = true
L["Mining"] = true
L["No Profession"] = true
L["Open "] = true
L["Open Archaeology"] = true
L["Open Cooking"] = true
L["Open First Aid"] = true
L["Plugins by |cff9382c9Lockslap|r"] = true
L["Professions"] = true
L["Professions Datatext"] = true
L["Right Click:"] = true
L["Select which profession to display."] = true
L["Shift + Left Click:"] = true
L["Shift + Right Click:"] = true
L["Show Hint"] = true
L["Show the hint in the tooltip."] = true
L["Smelting"] = true

L["<Click> to select a title."] = true
L["A"] = true
L["AI"] = true
L["I"] = true
L["J"] = true
L["JR"] = true
L["Jenkins"] = true
L["No Titles"] = true
L["None"] = true
L["Plugins by |cff9382c9Lockslap|r"] = true
L["R"] = true
L["S"] = true
L["SZ"] = true
L['Title changed to "%s".'] = true
L["Titles"] = true
L["Titles Datatext"] = true
L["Use Character Name"] = true
L["Use your character's class color and name in the tooltip."] = true
L["You have"] = true
L["You have elected not to use a title."] = true
L["Z"] = true
L["name"] = true
L["of"] = true
L["the"] = true
L["titles"] = true

L["Adds 2 digits in the coords"] = true
L["Adds 6 pixels at the Main Location Panel height."] = true
L["Adjust All Panels Height."] = true
L["Adjust coords updates (in seconds) to avoid cpu load. Bigger number = less cpu load. Requires reloadUI."] = true
L["Adjust the DataTexts Width."] = true
L["Adjust the Location Panel Width."] = true
L["All Panels Height"] = true
L["Area Fishing level"] = true
L["Auto Colorize"] = true
L["Auto resized Location Panel."] = true
L["Auto width"] = true
L["Battle Pet level"] = true
L[" by Benik (EU-Emerald Dream)"] = true
L["Choose font for the Location and Coords panels."] = true
L["Click : "] = true
L["Coordinates"] = true
L["Combat Hide"] = true
L["CtrlClick : "] = true
L["Datatext Panels"] = true
L["DataTexts Width"] = true
L["Detailed Coords"] = true
L["Displays the main zone and the subzone in the location panel"] = true
L["Enable/Disable battle pet level on the area."] = true
L["Enable/Disable dungeons in the zone, on Tooltip."] = true
L["Enable/Disable fishing level on the area."] = true
L["Enable/Disable hints on Tooltip."] = true
L["Enable/Disable layout with shadows."] = true
L["Enable/Disable level range on Tooltip."] = true
L["Enable/Disable recommended dungeons on Tooltip."] = true
L["Enable/Disable recommended zones on Tooltip."] = true
L["Enable/Disable status on Tooltip."] = true
L["Enable/Disable the coords for area dungeons and recommended dungeon entrances, on Tooltip."] = true
L["Enable/Disable the currencies, on Tooltip."] = true
L["Enable/Disable the professions, on Tooltip."] = true
L["Enable/Disable the Login Message"] = true
L["Enable/Disable transparent layout."] = true
L["Hide capped"] = true
L["Hide PvP"] = true
L["Hide Raid"] = true
L["Hides all panels background so you can place them on ElvUI's top or bottom panel."] = true
L["Hides a profession when the player reaches its highest level."] = true
L[" is loaded. Thank you for using it."] = true
L["Larger Location Panel"] = true
L["Location Panel"] = true
L["Location Plus "] = true
L["LocationPlus adds a movable player location panel, 2 datatext panels and more"] = true
L["LocationPlus Left Panel"] = true
L["LocationPlus Right Panel"] = true
L["Login Message"] = true
L["Recommended Dungeons :"] = true
L["Recommended Zones :"] = true
L["RightClick : "] = true
L["Send position to chat"] = true
L["Set the font size."] = true
L["Shadows"] = true
L["ShiftClick : "] = true
L["Show additional info in the Location Panel."] = true
L["Show Battle Pet level"] = true
L["Show/Hide all panels when in combat"] = true
L["Show/Hide PvP zones, Arenas and BGs on recommended dungeons and zones."] = true
L["Show/Hide raids on recommended dungeons."] = true
L["Show/Hide tooltip"] = true
L["Show Hints"] = true
L["Show Recommended Dungeons"] = true
L["Show Recommended Zones"] = true
L["Show zone Dungeons"] = true
L["Toggle Datatexts"] = true
L["Toggle WorldMap"] = true
L["Truncates the text rather than auto enlarge the location panel when the text is bigger than the panel."] = true
L["Truncate text"] = true
L["Update Timer"] = true
L["Use Custom Location Color"] = true
L["with Entrance Coords"] = true
L["Zone and Subzone"] = true
L["Hide Coords"] = true
L["Show/Hide the coord frames"] = true

L["Add Group"] = "添加光环组"
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] =
  "尝试显示一个提示但没有任何技能. 你必须先添加一个技能."
L[
    "Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."
  ] = "改变Buff提示模块来检查武器附魔, 设置这个将导致它忽略所有的技能列表."
L["Combat"] = "战斗"
L["Disable Sound"] = "禁用警报音"
L["Don't play the warning sound."] = "不播放警报提示音."
L["Group already exists!"] = "组已经存在!"
L["Remove Group"] = "删除组"
L["Select Group"] = "选择组"
L["Role"] = "职责"
L["Caster"] = "施法者"
L["Any"] = "任意"
L["Spell"] = "技能"
L["Spells"] = "技能"
L["New ID"] = "新技能ID"
L["Remove ID"] = "移除技能ID"
L["Personal Buffs"] = "自身施放的增益"
L["If any spell found inside this list is found the icon will hide as well"] = "列表中的任何技能图标将会被隐藏"
L["Inside BG/Arena"] = "战场/竞技场内"
L["Inside Raid/Party"] = "团队或队伍内"
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] = "当你拥有此增益时显示, 没有时隐藏."
L["Level Requirement"] = "等级需求"
L["Level requirement for the icon to be able to display. 0 for disabled."] = "达到此等级才能显示. 设置为 0 禁用此功能."
L["Negate Spells"] = "如已拥有下列增益则不显示"
L["New ID (Negate)"] = "新技能ID (已拥有)"
L["Only run checks during combat."] = "只在战斗中检查."
L["Only run checks inside BG/Arena instances."] = "只在战场/竞技场中检查."
L["Only run checks inside raid/party instances."] = "只在队伍/团队中检查."
L["Only check if the buff is coming from you."] = "只当增益是是你自身施放时检查."
L["REMINDER_DESC"] = "缺失增益提醒设置."
L["Remove ID (Negate)"] = "移除技能ID (已拥有)"
L["Reverse Check"] = "逆向检查"
L["Set a talent tree to not follow the reverse check."] = "设置一个不用遵守逆向检查的天赋."
L["Sound"] = "警报音效"
L["Sound that will play when you have a warning icon displayed."] = "当警告图标显示时播放声音."
L["Strict Filter"] = "严格匹配"
L["Talent Tree"] = "天赋"
L[
    "This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."
  ] = "这将保证只会显示你已经学会的技能. 如果你想监视一个你不会的技能, 你可以取消这个选项."
L["Don't play the warning sound."] = "不播放警报提示音."
L["Tree Exception"] = "天赋例外"
L["Weapon"] = "武器"
L["You can't remove a default group from the list, disabling the group."] = "你不能删除过滤器的预设组, 仅能禁用此预设组."
L["You must be a certain role for the icon to appear."] = "你必需选择一个确定的职责来显示此图标."
L["You must be using a certain talent tree for the icon to show."] = "你必需选择一个确定的天赋来显示此图标."
L["CD Fade"] = "冷却过程透明度"
L["Cooldown"] = "冷却CD"
L["On Cooldown"] = "冷却CD时"
L["Reminders"] = "缺失增益提醒"
