local AceLocale = _G.ElvUI[1].Libs.ACL
local L = AceLocale:NewLocale("ElvUI", "ruRU")
if not L then return end
--Translation ZamestoTV
L["NIHILISTZSCHEUI_AUTHOR_INFO"] = "|cffff2020NihilistzscheUI|r от Nihilistzsche"
L["NIHILISTZSCHEUI_CONTACTS"] =
    [=[Сообщайте о проблемах на https://git.tukui.org/Nihilistzsche/ElvUI_NihilistzscheUI/issues]=]

-- Bait Bar
L["Bait Bar"] = "Панель приманок"
L["NihilistzscheUI BaitBar by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI BaitBar от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI BaitBar provides a bar to use fishing baits from."] =
    "NihilistzscheUI BaitBar предоставляет панель для использования рыболовных приманок."
L["Enable the bait bar"] = "Включить панель приманок"
L["Only show the bait bar when you mouseover it"] =
    "Показывать панель приманок только при наведении курсора"

-- BagSetEquipmentIcon
L["BagSetEquipmentIcon"] = "Иконка набора экипировки"

-- ButtonStyle
L["ButtonStyle"] = "Стиль кнопок"
L["NihilistzscheUI ButtonStyle by Nihilistzsche"] = "NihilistzscheUI ButtonStyle от Nihilistzsche"
L["NihilistzscheUI ButtonStyle provides a style setting for ElvUI buttons similar to Masque or ButtonFacade\n"] =
    "NihilistzscheUI ButtonStyle предоставляет настройку стиля для кнопок ElvUI, аналогичную Masque или ButtonFacade\n"
L["Enable the button style."] = "Включить стиль кнопок."

-- WatchBarNotifier
L["WatchBarNotifier"] = "Уведомления панели наблюдения"
L["NihilistzscheUI WatchBarNotifier by Nihilistzsche"] = "NihilistzscheUI WatchBarNotifier от Nihilistzsche"
L["NihilistzscheUI WatchBarNotifier prints out messages to a given chat frame when you gain experience, reputation, artifact xp, or honor.\n"] =
    "NihilistzscheUI WatchBarNotifier выводит сообщения в указанный чат, когда вы получаете опыт, репутацию, опыт артефакта или честь.\n"
L["Enable the watcher."] = "Включить наблюдатель."
L["WatchBarNotifier Options"] = "Настройки уведомлений панели наблюдения"
L["Chat Frame to output XP messages to. 1-10. Enter 0 to disable xp watcher."] =
    "Чат для вывода сообщений об опыте. 1-10. Введите 0, чтобы отключить наблюдение за опытом."
L["Chat Frame to output rep messages to. 1-10. Enter 0 to disable rep watcher."] =
    "Чат для вывода сообщений о репутации. 1-10. Введите 0, чтобы отключить наблюдение за репутацией."
L["Chat Frame to output Artifact XP messages to. 1-10. Enter 0 to disable artifact xp watcher."] =
    "Чат для вывода сообщений об опыте артефакта. 1-10. Введите 0, чтобы отключить наблюдение за опытом артефакта."
L["Chat Frame to output Honor messages to. 1-10. Enter 0 to disable honor watcher."] =
    "Чат для вывода сообщений о чести. 1-10. Введите 0, чтобы отключить наблюдение за честью."

-- FarmBar
L["Added item watch for %s"] = "Добавлено наблюдение за предметом %s"
L["Added currency watch for %s"] = "Добавлено наблюдение за валютой %s"
L["You have |cff00ff00earned|r %d %s (|cff00ffffcurrently|r %d)"] =
    "Вы |cff00ff00получили|r %d %s (|cff00ffffтекущее|r %d)"
L["You have |cffff0000lost|r %d %s (|cff00ffffcurrently|r %d)"] =
    "Вы |cffff0000потеряли|r %d %s (|cff00ffffтекущее|r %d)"
L["Farm Bar"] = "Панель фарма"
L["NihilistzscheUI FarmBar by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI FarmBar от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI FarmBar provides a bar to manually track items and currencies you are farming."] =
    "NihilistzscheUI FarmBar предоставляет панель для ручного отслеживания предметов и валют, которые вы фармите."
L["Enable the farm bar"] = "Включить панель фарма"
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Only show the farm bar when you mouseover it"] =
    "Показывать панель фарма только при наведении курсора"
L["Notify"] = "Уведомлять"
L["Notify you when you gain (or lose) watched items/currencies"] =
    "Уведомлять, когда вы получаете (или теряете) отслеживаемые предметы/валюты"
L["Spacing"] = "Интервал"
L["Spacing between buttons"] = "Интервал между кнопками"
L["Alpha of the bar"] = "Прозрачность панели"
L["Number of buttons on each row"] = "Количество кнопок в каждом ряду"

-- NihilistzscheChat
L["Maximize"] = "Развернуть"
L["Minimize"] = "Свернуть"
L["NihilistzscheChat"] = "NihilistzscheChat"
L["NihilistzscheChat by Nihilistzsche/Hydrazine (tukui.org)"] =
    "NihilistzscheChat от Nihilistzsche/Hydrazine (tukui.org)"
L["NihilistzscheChat makes your chat experience awesome"] =
    "NihilistzscheChat делает ваш чат потрясающим"
L["Border Color"] = "Цвет рамки"
L["Backdrop Color"] = "Цвет фона"
L["AutoFade"] = "Автозатухание"
L["AutoHide"] = "Автоскрытие"
L["ShowTitle"] = "Показывать заголовок"
L["Timestamps"] = "Метки времени"
L["TimeFormat"] = "Формат времени"
L["To"] = "Кому"
L["From"] = "От"

-- ObjectiveTrackerHider
L["ObjectiveTrackerHider"] = "Скрытие трекера заданий"
L["NihilistzscheUI ObjectiveTrackerHider by Nihilistzsche"] = "NihilistzscheUI ObjectiveTrackerHider от Nihilistzsche"
L["NihilistzscheUI ObjectiveTrackerHider hides or collapses the objective tracker based on your configuration."] =
    "NihilistzscheUI ObjectiveTrackerHider скрывает или сворачивает трекер заданий в зависимости от ваших настроек."
L["Enable the objective tracker hider."] = "Включить скрытие трекера заданий."
L["objective tracker Hider Options"] = "Настройки скрытия трекера заданий"
L["Hide during PvP"] = "Скрывать во время PvP"
L["Hide the objective tracker during PvP (i.e. Battlegrounds)"] =
    "Скрывать трекер заданий во время PvP (например, на полях боя)"
L["Hide in arena"] = "Скрывать на арене"
L["Hide the objective tracker when in the arena"] = "Скрывать трекер заданий на арене"
L["Hide in dungeon"] = "Скрывать в подземелье"
L["Hide the objective tracker when in a dungeon"] =
    "Скрывать трекер заданий в подземелье"
L["Hide in raid"] = "Скрывать в рейде"
L["Hide the objective tracker when in a dungeon"] = "Скрывать трекер заданий в рейде"
L["Collapse during PvP"] = "Сворачивать во время PvP"
L["Collapse the objective tracker during PvP (i.e. Battlegrounds)"] =
    "Сворачивать трекер заданий во время PvP (например, на полях боя)"
L["Collapse in arena"] = "Сворачивать на арене"
L["Collapse the objective tracker when in the arena"] =
    "Сворачивать трекер заданий на арене"
L["Collapse in dungeon"] = "Сворачивать в подземелье"
L["Collapse the objective tracker when in a dungeon"] =
    "Сворачивать трекер заданий в подземелье"
L["Collapse in raid"] = "Сворачивать в рейде"
L["Collapse the objective tracker during a raid"] =
    "Сворачивать трекер заданий во время рейда"

-- PartyXP
L["PartyXP"] = "Опыт группы"
L["NihilistzscheUI PartyXP by Nihilistzsche"] = "NihilistzscheUI PartyXP от Nihilistzsche"
L["NihilistzscheUI PartyXP provides a configurable set of party experience bars for use with ElvUI.\n"] =
    "NihilistzscheUI PartyXP предоставляет настраиваемый набор панелей опыта группы для использования с ElvUI.\n"
L["Enable the party experience bars."] = "Включить панели опыта группы."
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["PartyXP Options"] = "Настройки опыта группы"
L["Class Colors"] = "Цвета классов"
L["Use class colors for the experience bars"] =
    "Использовать цвета классов для панелей опыта"
L["Detailed Text"] = "Подробный текст"
L["Use detailed text in the experience bars"] =
    "Использовать подробный текст в панелях опыта"
L["Default Font"] = "Шрифт по умолчанию"
L["The font that the text on the experience bars will use."] =
    "Шрифт, который будет использоваться для текста на панелях опыта."
L["The texture that will be used for the experience bars."] =
    "Текстура, которая будет использоваться для панелей опыта."
L["Variables and Movers"] = "Переменные и перемещение"
L["Vertical offset from parent frame"] =
    "Вертикальное смещение от родительской рамки"
L["Set the Width of the Text Font"] = "Установить ширину шрифта текста"

-- Portal Bar
L["Portal Bar"] = "Панель порталов"
L["NihilistzscheUI PortalBar by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI PortalBar от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI PortalBar provides a bar for mage portals and mage and challenge mode teleports."] =
    "NihilistzscheUI PortalBar предоставляет панель для порталов магов и телепортов в режиме испытаний."
L["Enable the portal bar"] = "Включить панель порталов"
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Only show the farm bar when you mouseover it"] =
    "Показывать панель фарма только при наведении курсора"
L["Spacing"] = "Интервал"
L["Spacing between buttons"] = "Интервал между кнопками"
L["Alpha of the bar"] = "Прозрачность панели"
L["Number of buttons on each row"] = "Количество кнопок в каждом ряду"

-- Profession Bar
L["Profession Bar"] = "Панель профессий"
L["NihilistzscheUI ProfessionBar by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI ProfessionBar от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI ProfessionBar provides an automatically updated bar with profession skills."] =
    "NihilistzscheUI ProfessionBar предоставляет автоматически обновляемую панель с навыками профессий."
L["Enable the profession bar"] = "Включить панель профессий"
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Only show the profession bar when you mouseover it"] =
    "Показывать панель профессий только при наведении курсора"
L["Spacing between buttons"] = "Интервал между кнопками"
L["Alpha of the bar"] = "Прозрачность панели"

-- Raid Prep Bar
L["Raid Prep Bar"] = "Панель подготовки к рейду"
L["NihilistzscheUI RaidPrepBar by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI RaidPrepBar от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI RaidPrepBar provides a bar for your flasks and food."] =
    "NihilistzscheUI RaidPrepBar предоставляет панель для ваших настоек и еды."
L["Enable the raid prep bar"] = "Включить панель подготовки к рейду"
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Only show the farm bar when you mouseover it"] =
    "Показывать панель фарма только при наведении курсора"
L["Spacing"] = "Интервал"
L["Spacing between buttons"] = "Интервал между кнопками"
L["Alpha of the bar"] = "Прозрачность панели"

-- Reminder
L["Add Group"] = "Добавить группу"
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] =
    "Попытка показать иконку напоминания, у которой нет заклинаний. Сначала необходимо добавить заклинание."
L["Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."] =
    "Измените это, если хотите, чтобы модуль напоминаний проверял чары на оружии; это приведёт к игнорированию указанных заклинаний."
L["Combat"] = "Бой"
L["Disable Sound"] = "Отключить звук"
L["Don't play the warning sound."] = "Не проигрывать предупреждающий звук."
L["Group already exists!"] = "Группа уже существует!"
L["Remove Group"] = "Удалить группу"
L["Select Group"] = "Выбрать группу"
L["Role"] = "Роль"
L["Caster"] = "Кастующий"
L["Any"] = "Любой"
L["Spell"] = "Заклинание"
L["Spells"] = "Заклинания"
L["New ID"] = "Новый ID"
L["Remove ID"] = "Удалить ID"
L["Personal Buffs"] = "Личные баффы"
L["If any spell found inside this list is found the icon will hide as well"] =
    "Если найдено заклинание из этого списка, иконка также будет скрыта"
L["Inside BG/Arena"] = "На поле боя/арене"
L["Inside Raid/Party"] = "В рейде/группе"
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] =
    "Вместо скрытия рамки, когда у вас есть бафф, показывать рамку, когда у вас есть бафф."
L["Level Requirement"] = "Требование уровня"
L["Level requirement for the icon to be able to display. 0 for disabled."] =
    "Требование уровня для отображения иконки. 0 для отключения."
L["Negate Spells"] = "Исключить заклинания"
L["New ID (Negate)"] = "Новый ID (Исключить)"
L["Only run checks during combat."] = "Проверять только во время боя."
L["Only run checks inside BG/Arena instances."] = "Проверять только на полях боя/аренах."
L["Only run checks inside raid/party instances."] = "Проверять только в рейдах/группах."
L["REMINDER_DESC"] =
    "Этот модуль показывает предупреждающие иконки на экране, когда у вас отсутствуют баффы или есть баффы, которых не должно быть."
L["Remove ID (Negate)"] = "Удалить ID (Исключить)"
L["Reverse Check"] = "Обратная проверка"
L["Set a talent tree to not follow the reverse check."] =
    "Установить дерево талантов, чтобы не выполнять обратную проверку."
L["Sound"] = "Звук"
L["Sound that will play when you have a warning icon displayed."] =
    "Звук, который будет проигрываться при отображении предупреждающей иконки."
L["Strict Filter"] = "Строгий фильтр"
L["Talent Tree"] = "Дерево талантов"
L["This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."] =
    "Это гарантирует, что вы видите только известные вам заклинания. Вы можете отключить эту опцию, если пытаетесь отслеживать заклинание, которое нельзя напрямую выбрать из книги заклинаний."
L["Tree Exception"] = "Исключение дерева"
L["Weapon"] = "Оружие"
L["You can't remove a default group from the list, disabling the group."] =
    "Вы не можете удалить стандартную группу из списка, группа будет отключена."
L["You must be a certain role for the icon to appear."] =
    "Вы должны иметь определённую роль, чтобы иконка появилась."
L["You must be using a certain talent tree for the icon to show."] =
    "Вы должны использовать определённое дерево талантов, чтобы иконка отображалась."
L["CD Fade"] = "Затухание перезарядки"
L["Cooldown"] = "Перезарядка"
L["On Cooldown"] = "На перезарядке"
L["Reminders"] = "Напоминания"

-- VerticalUnitFrames
L["NihilistzscheUI VerticalUnitFrames "] = "NihilistzscheUI VerticalUnitFrames "
L[" is loaded. Thank you for using it and note that I will always support you."] =
    " загружен. Спасибо за использование, и я всегда вас поддержу."
L["Vertical Unit Frames"] = "Вертикальные рамки юнитов"
L["Enable the Vertical Unit Frames."] = "Включить вертикальные рамки юнитов."
L["Reset Settings"] = "Сбросить настройки"
L["Simple Layout"] = "Простой макет"
L["Use the simple layout from 2.0"] = "Использовать простой макет из версии 2.0"
L["Combo Layout"] = "Комбинированный макет"
L["Use a layout designed to work with ElvUI unitframes"] =
    "Использовать макет, предназначенный для работы с рамками юнитов ElvUI"
L["Vertical Unit Frame Options"] = "Настройки вертикальных рамок юнитов"
L["Hide ElvUI Unitframes"] = "Скрыть рамки юнитов ElvUI"
L["Flash"] = "Мигание"
L["Flash health/power when the low threshold is reached"] =
    "Мигание здоровья/энергии при достижении низкого порога"
L["Text Warning"] = "Текстовое предупреждение"
L["Show a Text Warning when the low threshold is reached"] =
    "Показывать текстовое предупреждение при достижении низкого порога"
L["Horizontal Castbar"] = "Горизонтальная полоса заклинаний"
L["Use a horizontal castbar"] =
    "Использовать горизонтальную полосу заклинаний"
L["Variables"] = "Переменные"
L["Set the Alpha of the Vertical Unit Frame when out of combat"] =
    "Установить прозрачность вертикальной рамки юнита вне боя"
L["Out of Combat Alpha"] = "Прозрачность вне боя"
L["Start flashing health/power under this percentage"] =
    "Начать мигание здоровья/энергии при проценте ниже этого"
L["Raid Icon"] = "Рейдовая иконка"
L["Combat Indicator"] = "Индикатор боя"
L["PVP Text"] = "PvP текст"
L["Wild Mushroom Tracker"] = "Трекер диких грибов"
L["GCD Spark"] = "Искра GCD"
L["Player Vertical Unit Frame"] = "Вертикальная рамка игрока"
L["Target Vertical Unit Frame"] = "Вертикальная рамка цели"
L["Pet Vertical Unit Frame"] = "Вертикальная рамка питомца"
L["Target Target Vertical Unit Frame"] = "Вертикальная рамка цели цели"
L["Pet Target Vertical Unit Frame"] = "Вертикальная рамка цели питомца"
L["What to attach this element to."] = "К чему прикрепить этот элемент."
L["Eclipse"] = "Затмение"
L["Override"] = "Переопределить"
L["Override the texture for this element"] =
    "Переопределить текстуру для этого элемента"
L["NihilistzscheUI VerticalUnitFrames by Nihilistzsche"] = "NihilistzscheUI VerticalUnitFrames от Nihilistzsche"
L["NihilistzscheUI VerticalUnitFrames provides a configurable centered, vertical unit frame option for use with ElvUI.\n"] =
    "NihilistzscheUI VerticalUnitFrames предоставляет настраиваемую центрированную опцию вертикальных рамок юнитов для использования с ElvUI.\n"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Hide the ElvUI Unitframes when the Vertical Unit Frame is enabled"] =
    "Скрыть рамки юнитов ElvUI, когда включена вертикальная рамка юнита"
L["Hide the Vertical Unit Frame when out of Combat"] =
    "Скрыть вертикальную рамку юнита вне боя"
L["Hide Out of Combat"] = "Скрывать вне боя"
L["Enable Mouse"] = "Включить мышь"
L["Enable the mouse to interface with the vertical unit frame (this option has no effect if ElvUI Unitframes are hidden)"] =
    "Включить взаимодействие мыши с вертикальной рамкой юнита (эта опция не действует, если рамки юнитов ElvUI скрыты)"
L["Set the Alpha of the Vertical Unit Frame when in combat"] =
    "Установить прозрачность вертикальной рамки юнита в бою"
L["The texture that will be used for statusbars on this element."] =
    "Текстура, которая будет использоваться для статус-баров этого элемента."
L["Override the font for this element"] = "Переопределить шрифт для этого элемента"
L["Set the font for this element"] = "Установить шрифт для этого элемента"
L["Set the font size for this element"] =
    "Установить размер шрифта для этого элемента"
L["Spacing"] = "Интервал"
L["Texture"] = "Текстура"
L["Tick Color"] = "Цвет тика"
L["Value"] = "Значение"
L["Default"] = "По умолчанию"
L["NihilistzscheUI_VerticalUnitFrames_CREDITS"] = [[Большое спасибо следующим людям:

Tukz, чей код рамок юнитов стал основой для вертикальной рамки юнита
Elv за его потрясающий интерфейс, вдохновивший на версию 3
Hydrazine за вдохновение
Boradan за помощь с настройками
Sgt.Hydra за предложения
ZamestoTV за перевод на русский
NOme за перевод на корейский
BuG за перевод на французский

Сообществу Tukui за поддержку
]]

L["Thank you for using NihilistzscheUI VerticalUnitFrames!"] =
    "Спасибо за использование NihilistzscheUI VerticalUnitFrames!"
L["Here you can choose between the simple layout (only player health and power) or the default layout for the Vertical Unit Frame"] =
    "Здесь вы можете выбрать между простым макетом (только здоровье и энергия игрока) или макетом по умолчанию для вертикальной рамки юнита"
L["Simple Layout"] = "Простой макет"
L["Default Layout"] = "Макет по умолчанию"
L["Simple Layout Set"] = "Установлен простой макет"

L["Equipment Manager"] = "Менеджер экипировки"
L["NihilistzscheUI Equipment Manager by Nihilistzsche, based on work by Azilroka"] =
    "NihilistzscheUI Equipment Manager от Nihilistzsche, основано на работе Azilroka"
L["NihilistzscheUI Equipment Manager provides a bar for managing your equipment sets."] =
    "NihilistzscheUI Equipment Manager предоставляет панель для управления наборами экипировки."
L["General"] = "Общие"
L["Enable"] = "Включить"
L["Enable the equipment manager bar"] = "Включить панель менеджера экипировки"
L["Reset Settings"] = "Сбросить настройки"
L["Reset the settings of this addon to their defaults."] =
    "Сбросить настройки этого аддона на значения по умолчанию."
L["Mouseover"] = "Наведение курсора"
L["Only show the equipment manager bar when you mouseover it"] =
    "Показывать панель менеджера экипировки только при наведении курсора"
L["Size"] = "Размер"
L["Button Size"] = "Размер кнопки"
L["Spacing"] = "Интервал"
L["Spacing between buttons"] = "Интервал между кнопками"
L["Alpha"] = "Прозрачность"
L["Alpha of the bar"] = "Прозрачность панели"

L["Time the frame stays visible"] =
    "Время, в течение которого рамка остаётся видимой"
L["Alpha of the frame when visible"] = "Прозрачность рамки, когда она видима"
L["Delay"] = "Задержка"
L["Delay between updates"] = "Задержка между обновлениями"

L["CooldownBar"] = "Панель перезарядки"
L["NihilistzscheUI CooldownBar by Nihilistzsche"] = "NihilistzscheUI CooldownBar от Nihilistzsche"
L["NihilistzscheUI CooldownBar provides a logarithmic cooldown display similar to SexyCooldown2\n"] =
    "NihilistzscheUI CooldownBar предоставляет логарифмическое отображение перезарядки, аналогичное SexyCooldown2\n"
L["Enable the cooldown bar."] = "Включить панель перезарядки."
L["Autohide"] = "Автоскрытие"
L["Hide the cooldown bar when the mouse is not over it, you are not in combat, and there is nothing tracked on cooldown"] =
    "Скрывать панель перезарядки, когда мышь не над ней, вы не в бою и ничего не отслеживается на перезарядке"
L["Switch Time"] = "Время переключения"
L["Reset Blacklist"] = "Сбросить чёрный список"
L["Reset the blacklist."] = "Сбросить чёрный список."

L["Mounts"] = "Маунты"
L["%sMounts:|r %s added as favorite one."] =
    "%sМаунты:|r %s добавлен как избранный первый."
L["%sMounts:|r %s added as favorite two."] =
    "%sМаунты:|r %s добавлен как избранный второй."
L["%sMounts:|r %s added as favorite three."] =
    "%sМаунты:|r %s добавлен как избранный третий."
L["%sMounts:|r Favorites Cleared"] = "%sМаунты:|r Избранное очищено"
L["%sElvUI|r NihilistzscheUI - Mounts Datatext"] =
    "%sElvUI|r NihilistzscheUI - Текст данных о маунтах"
L["<Left Click> to open Pet Journal."] = "<ЛКМ> для открытия журнала питомцев."
L["<Right Click> to open mount list."] = "<ПКМ> для открытия списка маунтов."
L["<Shift + Left Click> to summon last mount."] =
    "<Shift + ЛКМ> для вызова последнего маунта."
L["<Alt + Click> to reset your favorites."] = "<Alt + Клик> для сброса избранного."
L["<Left Click> a mount to summon it."] = "<ЛКМ> по маунту для его вызова."
L["<Right Click> a mount to pick it up."] = "<ПКМ> по маунту для его выбора."
L["<Shift + Click> a mount to set as favorite 1"] =
    "<Shift + Клик> по маунту для установки в избранное 1"
L["<Ctrl + Click> a mount to set as favorite 2"] =
    "<Ctrl + Клик> по маунту для установки в избранное 2"
L["<Alt + Click> a mount to set as favorite 3"] =
    "<Alt + Клик> по маунту для установки в избранное 3"
L["Companions"] = "Питомцы"
L["%sCompanions:|r %s added as favorite one."] =
    "%sПитомцы:|r %s добавлен как избранный первый."
L["%sCompanions:|r %s added as favorite two."] =
    "%sПитомцы:|r %s добавлен как избранный второй."
L["%sCompanions:|r %s added as favorite three."] =
    "%sПитомцы:|r %s добавлен как избранный третий."
L["%sElvUI|r NihilistzscheUI - Companions Datatext"] =
    "%sElvUI|r NihilistzscheUI - Текст данных о питомцах"
L["<Left Click> to resummon/dismiss pet"] =
    "<ЛКМ> для повторного вызова/отпускания питомца"
L["<Right Click> to open pet list"] = "<ПКМ> для открытия списка питомцев"
L["<Shift + Left Click> to open pet journal"] =
    "<Shift + ЛКМ> для открытия журнала питомцев"
L["<Shift + Right Click> to open filter menu"] = "<Shift + ПКМ> для открытия меню фильтров"
L["<Alt + Click> to reset your favorites."] = "<Alt + Клик> для сброса избранного."
L["<Click> a pet to summon/dismiss it."] =
    "<Клик> по питомцу для его вызова/отпускания."
L["<Shift + Left Click> a pet to pick it up"] = "<Shift + ЛКМ> по питомцу для его выбора"
L["<Alt + Click> a pet to set as favorite 1"] =
    "<Alt + Клик> по питомцу для установки в избранное 1"
L["<Ctrl + Click> a pet to set as favorite 2"] =
    "<Ctrl + Клик> по питомцу для установки в избранное 2"
L["<Ctrl + Alt + Click> a pet to set as favorite 3"] =
    "<Ctrl + Alt + Клик> по питомцу для установки в избранное 3"

L["Combat State Options"] = "Настройки состояния боя"
L["OOC_DESC"] =
    [[Эти настройки позволяют установить различную видимость и параметры наведения курсора при входе или выходе из боя.
Обратите внимание: если вы включите изменение состояния для панели здесь, представленные опции исчезнут из обычных настроек для указанной панели.]]
L["In Combat"] = "В бою"
L["Conditions below will take effet when entering combat."] =
    "Условия ниже вступят в силу при входе в бой."
L["Out of Combat"] = "Вне боя"
L["Conditions below will take effet when leaving combat."] =
    "Условия ниже вступят в силу при выходе из боя."

L["CardinalPoints"] = "Стороны света"
L["Places cardinal points on your minimap (N, S, E, W)"] =
    "Размещает стороны света на вашей миникарте (С, Ю, В, З)"
L["Enable the minimap points"] = "Включить точки миникарты"

L["Artifact Power Button"] = "Кнопка силы артефакта"
L["NihilistzscheUI ArtifactPowerButton by Nihilistzsche"] = "NihilistzscheUI ArtifactPowerButton от Nihilistzsche"
L["NihilistzscheUI ArtifactPowerButton provides a button for you to consume your artifact power items in your bags."] =
    "NihilistzscheUI ArtifactPowerButton предоставляет кнопку для использования предметов силы артефакта в ваших сумках."
L["Enable the artifact power button"] = "Включить кнопку силы артефакта"
L["Only show the artifact power button when you mouseover it"] =
    "Показывать кнопку силы артефакта только при наведении курсора"

L["Warlock Demons"] = "Демоны чернокнижника"
L["Demon Count"] = "Счётчик демонов"
L["Timer bars and counts for demonology demons"] =
    "Таймеры и счётчики для демонов демонологии"
L["Enable the demon count"] = "Включить счётчик демонов"
L["Width of the bars"] = "Ширина полос"
L["Height of the bars"] = "Высота полос"
L["Spacing between bars"] = "Интервал между полосами"

L["CBO_POWER_DISABLED"] =
    "Рамка силы %s отключена. Установка наложения полосы заклинаний на здоровье."
L["I understand"] = "Я понимаю"
L["Arena"] = "Арена"
L["Boss"] = "Босс"
L["Choose which panel to overlay the castbar on."] =
    "Выберите, на какую панель наложить полосу заклинаний."
L["Enable Overlay"] = "Включить наложение"
L["Focus"] = "Фокус"
L["Hide Castbar text. Useful if your power height is very low or if you use power offset."] =
    "Скрыть текст полосы заклинаний. Полезно, если высота полосы энергии очень мала или используется смещение энергии."
L["Hide Text"] = "Скрыть текст"
L["Move castbar text to the left or to the right. Default is 4"] =
    "Переместить текст полосы заклинаний влево или вправо. По умолчанию 4"
L["Move castbar text up or down. Default is 0"] =
    "Переместить текст полосы заклинаний вверх или вниз. По умолчанию 0"
L["Move castbar time to the left or to the right. Default is -4"] =
    "Переместить время полосы заклинаний влево или вправо. По умолчанию -4"
L["Move castbar time up or down. Default is 0"] =
    "Переместить время полосы заклинаний вверх или вниз. По умолчанию 0"
L["Overlay Panel"] = "Панель наложения"
L["Overlay the castbar on the chosen panel."] =
    "Наложить полосу заклинаний на выбранную панель."
L["Player"] = "Игрок"
L["Target"] = "Цель"
L["Text xOffset"] = "Смещение текста по X"
L["Text yOffset"] = "Смещение текста по Y"
L["Time xOffset"] = "Смещение времени по X"
L["Time yOffset"] = "Смещение времени по Y"

L["Color for timers in the MM:SS format"] = "Цвет для таймеров в формате ММ:СС"
L["Cooldowns"] = "Перезарядки"
L["Font Size"] = "Размер шрифта"
L["MM:SS Color"] = "Цвет ММ:СС"
L["MM:SS Threshold"] = "Порог ММ:СС"
L["Sets the size of the timers."] = "Устанавливает размер таймеров."
L["Threshold (in seconds) before text is shown in the MM:SS format. Set to -1 to never change to this format."] =
    "Порог (в секундах), после которого текст отображается в формате ММ:СС. Установите -1, чтобы никогда не использовать этот формат."

L["Above Icons"] = "Над иконками"
L["Additional spacing between icon and statusbar. If a negative value is chosen then the statusbar is shown inside the icon. Changing this requires you to reload UI."] =
    "Дополнительный интервал между иконкой и статус-баром. Если выбрано отрицательное значение, статус-бар отображается внутри иконки. Изменение требует перезагрузки интерфейса."
L["Allows you to choose which texture to use for statusbar backdrops. If disabled, no texture will be used."] =
    "Позволяет выбрать текстуру для фона статус-бара. Если отключено, текстура не используется."
L["Allows you to choose which texture to use for statusbars. If disabled, no texture will be used."] =
    "Позволяет выбрать текстуру для статус-баров. Если отключено, текстура не используется."
L["Always Show Text"] = "Всегда показывать текст"
L["Below Icons"] = "Под иконками"
L["Buffs Threshold"] = "Порог баффов"
L["Buffs"] = "Баффы"
L["Changes the statusbar to use a static color instead of going from green to red the lower duration it has."] =
    "Изменяет статус-бар на использование статичного цвета вместо перехода от зелёного к красному при уменьшении длительности."
L["Choose where you want the statusbar to be positioned. If you position it on the left or right side of the icon I advice you to increase Horizontal Spacing for Buffs and Debuffs. Changing this requires you to reload UI."] =
    "Выберите, где вы хотите разместить статус-бар. Если вы размещаете его слева или справа от иконки, рекомендуется увеличить горизонтальный интервал для баффов и дебаффов. Изменение требует перезагрузки интерфейса."
L["Choose which color you want the statusbar backdrops to use. Tip: use light colors for dark statusbar colors and vice versa."] =
    "Выберите цвет для фона статус-бара. Совет: используйте светлые цвета для тёмных цветов статус-бара и наоборот."
L["Choose which color you want your statusbars to use."] =
    "Выберите цвет для ваших статус-баров."
L["Color when the text is in the HH:MM format (provided by the ExactAuras addon)."] =
    "Цвет, когда текст в формате ЧЧ:ММ (предоставляется аддоном ExactAuras)."
L["Debuffs Threshold"] = "Порог дебаффов"
L["Debuffs"] = "Дебаффы"
L["Decimal Threshold"] = "Порог десятичных"
L["Enable Static Color"] = "Включить статичный цвет"
L["General Options"] = "Общие настройки"
L["Height of the statusbar frame (default: 5). Changing this requires you to reload UI."] =
    "Высота рамки статус-бара (по умолчанию: 5). Изменение требует перезагрузки интерфейса."
L["Hour/Minutes"] = "Часы/Минуты"
L["If enabled, the timers on your buffs will switch to text when duration goes below set threshold."] =
    "Если включено, таймеры ваших баффов переключатся на текст, когда длительность станет ниже установленного порога."
L["If enabled, the timers on your debuffs will switch to text when duration goes below set threshold."] =
    "Если включено, таймеры ваших дебаффов переключатся на текст, когда длительность станет ниже установленного порога."
L["If enabled, the timers on your temporary enchant(s) will switch to text when duration goes below set threshold."] =
    "Если включено, таймеры ваших временных чар переключатся на текст, когда длительность станет ниже установленного порога."
L["Indicator (s, m, h, d)"] = "Индикатор (с, м, ч, д)"
L["Left Side of Icons"] = "Левая сторона иконок"
L["No Duration"] = "Без длительности"
L["Numbers"] = "Числа"
L["Position and Size"] = "Позиция и размер"
L["Right Side of Icons"] = "Правая сторона иконок"
L["Show bars for auras without a duration."] =
    "Показывать полосы для аур без длительности."
L["Show text in addition to statusbars. (You might need to move the text by changing the offset in the Buffs and Debuffs section)"] =
    "Показывать текст в дополнение к статус-барам. (Возможно, потребуется переместить текст, изменив смещение в разделе баффов и дебаффов)"
L["Show timers as bars instead of text."] =
    "Показывать таймеры в виде полос вместо текста."
L["Static Statusbar Color"] = "Статичный цвет статус-бара"
L["Statusbar Backdrop Color"] = "Цвет фона статус-бара"
L["Statusbar Backdrop Texture"] = "Текстура фона статус-бара"
L["Statusbar Height"] = "Высота статус-бара"
L["Statusbar Options"] = "Настройки статус-бара"
L["Statusbar Position"] = "Позиция статус-бара"
L["Statusbar Spacing"] = "Интервал статус-бара"
L["Statusbar Texture"] = "Текстура статус-бара"
L["Statusbar Width"] = "Ширина статус-бара"
L["Switch to text based timers when duration goes below threshold"] =
    "Переключаться на текстовые таймеры, когда длительность становится ниже порога"
L["Temp. Threshold"] = "Порог временных"
L["Temporary Enchants"] = "Временные чары"
L["Text Options"] = "Настройки текста"
L["Text Threshold"] = "Порог текста"
L["Threshold before the timer changes color and goes into decimal form. Set to -1 to disable."] =
    "Порог, после которого таймер меняет цвет и переходит в десятичную форму. Установите -1 для отключения."
L["Threshold in seconds before status bar based timers turn to text."] =
    "Порог в секундах, после которого таймеры на основе статус-бара переходят в текст."
L["Use Backdrop Texture"] = "Использовать текстуру фона"
L["Use Statusbar Texture"] = "Использовать текстуру статус-бара"
L["Width of the statusbar frame (default: 6). Changing this requires you to reload UI."] =
    "Ширина рамки статус-бара (по умолчанию: 6). Изменение требует перезагрузки интерфейса."

L["(Hold Shift) Memory Usage"] = "(Удерживайте Shift) Использование памяти"
L["Announce Freed"] = "Объявить освобождённую память"
L["Announce how much memory was freed by the garbage collection."] =
    "Объявить, сколько памяти было освобождено сборкой мусора."
L["Bandwidth"] = "Пропускная способность"
L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."] =
    "Отображать задержку мира или дома в текстовых данных. Домашняя задержка относится к серверу вашего мира. Локальная задержка относится к текущему локальному серверу."
L["Download"] = "Скачивание"
L["FPS"] = "FPS"
L["Garbage Collect"] = "Сборка мусора"
L["Garbage Collection Freed"] = "Освобождено сборкой мусора"
L["Home"] = "Дом"
L["Home Latency:"] = "Домашняя задержка:"
L["Improved System Datatext"] = "Улучшенные системные текстовые данные"
L["Latency Type"] = "Тип задержки"
L["Left Click:"] = "ЛКМ:"
L["Loaded Addons:"] = "Загруженные аддоны:"
L["MS"] = "МС"
L["Max Addons"] = "Максимум аддонов"
L["Maximum number of addons to show in the tooltip."] =
    "Максимальное количество аддонов для показа в подсказке."
L["No"] = "Нет"
L["Plugins by |cff9382c9Lockslap|r"] = "Плагины от |cff9382c9Lockslap|r"
L["Reload UI"] = "Перезагрузить интерфейс"
L["Reload UI?"] = "Перезагрузить интерфейс?"
L["Right Click:"] = "ПКМ:"
L["Show FPS"] = "Показывать FPS"
L["Show FPS on the datatext."] = "Показывать FPS в текстовых данных."
L["Show Latency"] = "Показывать задержку"
L["Show Memory"] = "Показывать память"
L["Show latency on the datatext."] = "Показывать задержку в текстовых данных."
L["Show total addon memory on the datatext."] =
    "Показывать общее использование памяти аддонами в текстовых данных."
L["Total Addons:"] = "Всего аддонов:"
L["Total CPU:"] = "Общее использование CPU:"
L["Total Memory:"] = "Общая память:"
L["World"] = "Мир"
L["World Latency:"] = "Локальная задержка:"
L["Yes"] = "Да"

L["Ctrl + Click:"] = "Ctrl + Клик:"
L["Left Click:"] = "ЛКМ:"
L["Mining"] = "Горное дело"
L["No Profession"] = "Нет профессии"
L["Open "] = "Открыть "
L["Open Archaeology"] = "Открыть археологию"
L["Open Cooking"] = "Открыть кулинарию"
L["Open First Aid"] = "Открыть первую помощь"
L["Plugins by |cff9382c9Lockslap|r"] = "Плагины от |cff9382c9Lockslap|r"
L["Professions"] = "Профессии"
L["Professions Datatext"] = "Текстовые данные профессий"
L["Right Click:"] = "ПКМ:"
L["Select which profession to display."] = "Выберите профессию для отображения."
L["Shift + Left Click:"] = "Shift + ЛКМ:"
L["Shift + Right Click:"] = "Shift + ПКМ:"
L["Show Hint"] = "Показывать подсказку"
L["Show the hint in the tooltip."] = "Показывать подсказку в подсказке."
L["Smelting"] = "Плавка"

L["<Click> to select a title."] = "<Клик> для выбора титула."
L["A"] = "А"
L["AI"] = "АИ"
L["I"] = "И"
L["J"] = "Д"
L["JR"] = "Мл."
L["Jenkins"] = "Дженкинс"
L["No Titles"] = "Нет титулов"
L["None"] = "Нет"
L["Plugins by |cff9382c9Lockslap|r"] = "Плагины от |cff9382c9Lockslap|r"
L["R"] = "Р"
L["S"] = "С"
L["SZ"] = "СЗ"
L['Title changed to "%s".'] = 'Титул изменён на "%s".'
L["Titles"] = "Титулы"
L["Titles Datatext"] = "Текстовые данные титулов"
L["Use Character Name"] = "Использовать имя персонажа"
L["Use your character's class color and name in the tooltip."] =
    "Использовать цвет класса и имя вашего персонажа в подсказке."
L["You have"] = "У вас есть"
L["You have elected not to use a title."] = "Вы решили не использовать титул."
L["Z"] = "З"
L["name"] = "имя"
L["of"] = "из"
L["the"] = " "
L["titles"] = "титулы"

L["Adds 2 digits in the coords"] = "Добавляет 2 цифры в координаты"
L["Adds 6 pixels at the Main Location Panel height."] =
    "Добавляет 6 пикселей к высоте главной панели местоположения."
L["Adjust All Panels Height."] = "Настроить высоту всех панелей."
L["Adjust coords updates (in seconds) to avoid cpu load. Bigger number = less cpu load. Requires reloadUI."] =
    "Настройка обновления координат (в секундах) для снижения нагрузки на процессор. Большее число = меньшая нагрузка. Требуется перезагрузка интерфейса."
L["Adjust the DataTexts Width."] = "Настроить ширину текстовых данных."
L["Adjust the Location Panel Width."] = "Настроить ширину панели местоположения."
L["All Panels Height"] = "Высота всех панелей"
L["Area Fishing level"] = "Уровень рыбалки в зоне"
L["Auto Colorize"] = "Автоматическая цветокоррекция"
L["Auto resized Location Panel."] =
    "Автоматически изменяемая панель местоположения."
L["Auto width"] = "Автоматическая ширина"
L["Battle Pet level"] = "Уровень боевого питомца"
L[" by Benik (EU-Emerald Dream)"] = " от Benik (EU-Emerald Dream)"
L["Choose font for the Location and Coords panels."] =
    "Выберите шрифт для панелей местоположения и координат."
L["Click : "] = "Клик: "
L["Coordinates"] = "Координаты"
L["Combat Hide"] = "Скрывать в бою"
L["CtrlClick : "] = "Ctrl + Клик: "
L["Datatext Panels"] = "Панели текстовых данных"
L["DataTexts Width"] = "Ширина текстовых данных"
L["Detailed Coords"] = "Подробные координаты"
L["Displays the main zone and the subzone in the location panel"] =
    "Отображает основную зону и подзону в панели местоположения"
L["Enable/Disable battle pet level on the area."] =
    "Включить/отключить уровень боевых питомцев в зоне."
L["Enable/Disable dungeons in the zone, on Tooltip."] =
    "Включить/отключить подземелья в зоне в подсказке."
L["Enable/Disable fishing level on the area."] =
    "Включить/отключить уровень рыбалки в зоне."
L["Enable/Disable hints on Tooltip."] = "Включить/отключить подсказки в подсказке."
L["Enable/Disable layout with shadows."] = "Включить/отключить макет с тенями."
L["Enable/Disable level range on Tooltip."] =
    "Включить/отключить диапазон уровней в подсказке."
L["Enable/Disable recommended dungeons on Tooltip."] =
    "Включить/отключить рекомендуемые подземелья в подсказке."
L["Enable/Disable recommended zones on Tooltip."] =
    "Включить/отключить рекомендуемые зоны в подсказке."
L["Enable/Disable status on Tooltip."] = "Включить/отключить статус в подсказке."
L["Enable/Disable the coords for area dungeons and recommended dungeon entrances, on Tooltip."] =
    "Включить/отключить координаты для подземелий зоны и входов в рекомендуемые подземелья в подсказке."
L["Enable/Disable the currencies, on Tooltip."] =
    "Включить/отключить валюты в подсказке."
L["Enable/Disable the professions, on Tooltip."] =
    "Включить/отключить профессии в подсказке."
L["Enable/Disable the Login Message"] = "Включить/отключить сообщение при входе"
L["Enable/Disable transparent layout."] = "Включить/отключить прозрачный макет."
L["Hide capped"] = "Скрывать максимальный уровень"
L["Hide PvP"] = "Скрывать PvP"
L["Hide Raid"] = "Скрывать рейд"
L["Hides all panels background so you can place them on ElvUI's top or bottom panel."] =
    "Скрывает фон всех панелей, чтобы вы могли разместить их на верхней или нижней панели ElvUI."
L["Hides a profession when the player reaches its highest level."] =
    "Скрывает профессию, когда игрок достигает её максимального уровня."
L[" is loaded. Thank you for using it."] = " загружен. Спасибо за использование."
L["Larger Location Panel"] = "Большая панель местоположения"
L["Location Panel"] = "Панель местоположения"
L["Location Plus "] = "Location Plus "
L["LocationPlus adds a movable player location panel, 2 datatext panels and more"] =
    "LocationPlus добавляет перемещаемую панель местоположения игрока, 2 панели текстовых данных и многое другое"
L["LocationPlus Left Panel"] = "Левая панель LocationPlus"
L["LocationPlus Right Panel"] = "Правая панель LocationPlus"
L["Login Message"] = "Сообщение при входе"
L["Recommended Dungeons :"] = "Рекомендуемые подземелья:"
L["Recommended Zones :"] = "Рекомендуемые зоны:"
L["RightClick : "] = "ПКМ:"
L["Send position to chat"] = "Отправить позицию в чат"
L["Set the font size."] = "Установить размер шрифта."
L["Shadows"] = "Тени"
L["ShiftClick : "] = "Shift + Клик:"
L["Show additional info in the Location Panel."] =
    "Показывать дополнительную информацию в панели местоположения."
L["Show Battle Pet level"] = "Показывать уровень боевого питомца"
L["Show/Hide all panels when in combat"] = "Показывать/скрывать все панели в бою"
L["Show/Hide PvP zones, Arenas and BGs on recommended dungeons and zones."] =
    "Показывать/скрывать PvP-зоны, арены и поля боя в рекомендуемых подземельях и зонах."
L["Show/Hide raids on recommended dungeons."] =
    "Показывать/скрывать рейды в рекомендуемых подземельях."
L["Show/Hide tooltip"] = "Показывать/скрывать подсказку"
L["Show Hints"] = "Показывать подсказки"
L["Show Recommended Dungeons"] = "Показывать рекомендуемые подземелья"
L["Show Recommended Zones"] = "Показывать рекомендуемые зоны"
L["Show zone Dungeons"] = "Показывать подземелья зоны"
L["Toggle Datatexts"] = "Переключить текстовые данные"
L["Toggle WorldMap"] = "Переключить карту мира"
L["Truncates the text rather than auto enlarge the location panel when the text is bigger than the panel."] =
    "Обрезает текст вместо автоматического увеличения панели местоположения, когда текст больше панели."
L["Truncate text"] = "Обрезать текст"
L["Update Timer"] = "Таймер обновления"
L["Use Custom Location Color"] =
    "Использовать пользовательский цвет местоположения"
L["with Entrance Coords"] = "с координатами входа"
L["Zone and Subzone"] = "Зона и подзона"
L["Hide Coords"] = "Скрыть координаты"
L["Show/Hide the coord frames"] = "Показывать/скрывать рамки координат"

--Duplicate
L["Add Group"] = "Добавить группу"
L["Attempted to show a reminder icon that does not have any spells. You must add a spell first."] =
    "Попытка показать иконку напоминания, у которой нет заклинаний. Сначала необходимо добавить заклинание."
L["Change this if you want the Reminder module to check for weapon enchants, setting this will cause it to ignore any spells listed."] =
    "Измените это, если хотите, чтобы модуль напоминаний проверял чары на оружии; это приведёт к игнорированию указанных заклинаний."
L["Combat"] = "Бой"
L["Disable Sound"] = "Отключить звук"
L["Don't play the warning sound."] = "Не проигрывать предупреждающий звук."
L["Group already exists!"] = "Группа уже существует!"
L["If any spell found inside this list is found the icon will hide as well"] =
    "Если найдено заклинание из этого списка, иконка также будет скрыта"
L["Inside BG/Arena"] = "На поле боя/арене"
L["Inside Raid/Party"] = "В рейде/группе"
L["Instead of hiding the frame when you have the buff, show the frame when you have the buff."] =
    "Вместо скрытия рамки, когда у вас есть бафф, показывать рамку, когда у вас есть бафф."
L["Level Requirement"] = "Требование уровня"
L["Level requirement for the icon to be able to display. 0 for disabled."] =
    "Требование уровня для отображения иконки. 0 для отключения."
L["Negate Spells"] = "Исключить заклинания"
L["New ID (Negate)"] = "Новый ID (Исключить)"
L["Only run checks during combat."] = "Проверять только во время боя."
L["Only run checks inside BG/Arena instances."] = "Проверять только на полях боя/аренах."
L["Only run checks inside raid/party instances."] = "Проверять только в рейдах/группах."
L["REMINDER_DESC"] =
    "Этот модуль показывает предупреждающие иконки на экране, когда у вас отсутствуют баффы или есть баффы, которых не должно быть."
L["Remove ID (Negate)"] = "Удалить ID (Исключить)"
L["Reverse Check"] = "Обратная проверка"
L["Set a talent tree to not follow the reverse check."] =
    "Установить дерево талантов, чтобы не выполнять обратную проверку."
L["Sound"] = "Звук"
L["Sound that will play when you have a warning icon displayed."] =
    "Звук, который будет проигрываться при отображении предупреждающей иконки."
L["Spell"] = "Заклинание"
L["Strict Filter"] = "Строгий фильтр"
L["Talent Tree"] = "Дерево талантов"
L["This ensures you can only see spells that you actually know. You may want to uncheck this option if you are trying to monitor a spell that is not directly clickable out of your spellbook."] =
    "Это гарантирует, что вы видите только известные вам заклинания. Вы можете отключить эту опцию, если пытаетесь отслеживать заклинание, которое нельзя напрямую выбрать из книги заклинаний."
L["Tree Exception"] = "Исключение дерева"
L["Weapon"] = "Оружие"
L["You can't remove a default group from the list, disabling the group."] =
    "Вы не можете удалить стандартную группу из списка, группа будет отключена."
L["You must be a certain role for the icon to appear."] =
    "Вы должны иметь определённую роль, чтобы иконка появилась."
L["You must be using a certain talent tree for the icon to show."] =
    "Вы должны использовать определённое дерево талантов, чтобы иконка отображалась."
L["CD Fade"] = "Затухание перезарядки"
L["Cooldown"] = "Перезарядка"
L["On Cooldown"] = "На перезарядке"
L["Reminders"] = "Напоминания"
L["Remove Group"] = "Удалить группу"
L["Select Group"] = "Выбрать группу"
L["Role"] = "Роль"
L["Caster"] = "Кастующий"
L["Any"] = "Любой"
L["Personal Buffs"] = "Личные баффы"
L["Only check if the buff is coming from you."] =
    "Проверять только баффы, исходящие от вас."
L["Spells"] = "Заклинания"
L["New ID"] = "Новый ID"
L["Remove ID"] = "Удалить ID"
