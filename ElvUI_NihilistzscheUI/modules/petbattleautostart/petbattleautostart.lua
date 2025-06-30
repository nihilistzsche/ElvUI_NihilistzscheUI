---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

if not E.Retail then return end
local PBAS = NUI.PetBattleAutoStart
local COMP = NUI.Compatibility

local IsShiftKeyDown = _G.IsShiftKeyDown
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local strsplit = _G.strsplit
local HasControl = _G.HasFullControl
local InCombat = _G.InCombatLockdown
local InPetBattle = _G.C_PetBattles.IsInBattle
local C_Timer_After = _G.C_Timer.After

PBAS.PetTamers = {
    [63194] = { valid = true }, -- Steven Lisbane, Northern Stranglethorn
    [64330] = { valid = true }, -- Julia Stevens, Elwynn Forest
    [65648] = { valid = true }, -- Old macDonald, Westfall
    [65651] = { valid = true }, -- Lindsay, Redright Mountains
    [65655] = { valid = true }, -- Eric Davidson, Duskwood
    [65656] = { valid = true }, -- Bill Buckler, The Cape of Stranglethorne
    [66126] = { valid = true }, -- Zunta, Durotar
    [66135] = { valid = true }, -- Dagra the Fierce, Northern Barrens
    [66136] = { valid = true }, -- Analynn, Ashenvale
    [66137] = { valid = true }, -- Zonya the Sadist, Stonetalon Mountains
    [66352] = { valid = true }, -- Traitor Gluk, Feralas
    [66372] = { valid = true }, -- Merda Stronghoof, Desolace
    [66412] = { valid = true }, -- Elene Flutterfly, Moonglade
    [66422] = { valid = true }, -- Cassandra Kaboom, Southern Barrens
    [66436] = { valid = true }, -- Grazzle the Great, Dustwallow March
    [66442] = { valid = true }, -- Zoltan, Felwood
    [66452] = { valid = true }, -- Kela Grimtotem, Thousand Needles
    [66466] = { valid = true }, -- Stone Cold Trixxy, Winterspring
    [66478] = { valid = true }, -- David Kosse, The Hinterlands
    [66512] = { valid = true }, -- Deiza Plaguehorn, Eastern Plaguelands
    [66515] = { valid = true }, -- Koras Darkhammer, Searing Gorge
    [66518] = { valid = true }, -- Everessa, Swamp of Sorrows
    [66520] = { valid = true }, -- Durin Darkhammer, Burning Steppes
    [66522] = { valid = true }, -- Lydia Accoste, Deadwind Pass
    [66550] = { valid = true }, -- Nicki Tinytech, Hellfire Peninsula
    [66551] = { valid = true }, -- Ras'an, Zangarmarsh
    [66552] = { valid = true }, -- Narrok, Nagrand
    [66553] = { valid = true }, -- Morulu the Elder, Shattrath City
    [66557] = { valid = true }, -- Bloodknight Antari, Shadowmoon Valley
    [66635] = { valid = true }, -- Beegle Blastfuse, Howling Fjord
    [66636] = { valid = true }, -- Nearly Headless Jacob, Crystalsong Forest
    [66638] = { valid = true }, -- Okrut Dragonwaste, Dragonblight
    [66639] = { valid = true }, -- Gutretch, Zul'Drak
    [66675] = { valid = true }, -- Major Payne, Icecrown
    [66730] = { valid = true }, -- Hyuna of the Shrines, The Jade Forest
    [66733] = { valid = true }, -- Mo'ruk, Krasarang Wilds
    [66734] = { valid = true }, -- Farmer Nishi, Valley of the Four Winds
    [66738] = { valid = true }, -- Corageous Yon, Kun-Lai Summit
    [66739] = { valid = true }, -- Wastewalker Shu, Dread Wastes
    [66741] = { valid = true }, -- Aki the Chosen, Vale of Eternal Blossoms
    [66815] = { valid = true }, -- Bordin Steadyfist, Deepholm
    [66819] = { valid = true }, -- Brok, Mount Hyjal
    [66822] = { valid = true }, -- Goz Banefury, Twilight Highlands
    [66824] = { valid = true }, -- Obalis, Uldum
    [66918] = { valid = true }, -- Seeker Zushi, Townlong Steppes
    [68462] = { valid = true }, -- Flowing Pandaren Spiit, Dread Wastes
    [68463] = { valid = true }, -- Burning Pandaren Spirit, Townlong Steppes
    [68464] = { valid = true }, -- Whispering Pandaren Spirit, The Jade Forest
    [68465] = { valid = true }, -- Thundering Pandaren Spirit, Kun-Lai Smmit
    [71924] = { valid = true }, -- wrathion, Celestial Tournament
    [71926] = { valid = true }, -- Lorewalker Cho, Celestial Tournament
    [71927] = { valid = true }, -- Chen Stormstout, Celestial Tournament
    [71929] = { valid = true }, -- Sully "The Pickle" McLeary Celestial Tournament
    [71930] = { valid = true }, -- Shademaster Kiryn, Celestial Tournament
    [71931] = { valid = true }, -- Taran Zhu, Celestial Tournament
    [71932] = { valid = true }, -- Wise Mari, Celestial Tournament
    [71933] = { valid = true }, -- Blingtron 4000, Celestial Tournament
    [71934] = { valid = true }, -- Dr. Ion Goldbloo, Celestial Tournament
    [73626] = { valid = true }, -- Little Tommy Newcomer, Timeless Isle-
    [83837] = { valid = true }, -- Cymre Brightblade, Gorgrond
    [87110] = { valid = true }, -- Tarr the Terrible, Nagrand
    [87122] = { valid = true }, -- Cargra, Frostfire Ridge
    [87123] = { valid = true }, -- Vesharr, Spires of Arak
    [87124] = { valid = true }, -- Ashlei, Shadowmoon Valley
    [87125] = { valid = true }, -- Taralune, Talador
    [90675] = { valid = true }, -- Erris the Collector (Patch 6.1)
    [91014] = { valid = true }, -- Erris the Collector (Patch 6.1)
    [91015] = { valid = true }, -- Erris the Collector (Patch 6.1)
    [91016] = { valid = true }, -- Erris the Collector (Patch 6.1)
    [91017] = { valid = true }, -- Erris the Collector (Patch 6.1)
    [91026] = { valid = true }, -- Kura Thunderhoof (Patch 6.1)
    [91361] = { valid = true }, -- Kura Thunderhoof (Patch 6.1)
    [91362] = { valid = true }, -- Kura Thunderhoof (Patch 6.1)
    [91363] = { valid = true }, -- Kura Thunderhoof (Patch 6.1)
    [91364] = { valid = true }, -- Kura Thunderhoof (Patch 6.1)
    [79858] = { valid = true, noBattle = true }, -- Serr'ah (Patch 6.0)
    [85418] = { valid = true, noBattle = true }, -- Leo the Lioness (Patch 6.0)
    [67370] = { valid = true, noPopup = true }, -- Jeremy Fease, Darkmoon Island
    [85519] = { valid = true, noPopup = true }, -- Cristoph VonFeasel,Darkmoon Island
    -- Legion Master Pet Tamers to be verified: some of them can be “petTamersWithoutPopup”
    -- Dalaran (Patch 7.0)
    [107489] = { valid = true }, -- Amalia / Fight Night: Amalia (Family Familiar)
    [99210] = { valid = true }, -- Bodhi Sunwayver / Fight Night: Bodhi Sunwayver (Family Familiar)
    [99742] = { valid = true }, -- Heliosus / Fight Night: Heliosus
    [99182] = { valid = true }, -- Sir Galveston / Fight Night: Sir Galveston (Family Familiar)
    [105241] = { valid = true }, -- Splint Jr. / Fight Night: Rats!
    [105840] = { valid = true }, -- Stitches Jr. Jr. / Fight Night: Stitches Jr. Jr.
    [97804] = { valid = true }, -- Tiffany Nelson / Fight Night: Tiffany Nelson (Family Familiar)
    -- Azsuna (Patch 7.0)
    [105898] = { valid = true }, -- Blottis / Size Doesn't Matter
    [106476] = { valid = true }, -- Beguiling Orb / Dazed and Confused and Adorable [click to start?!]
    [106552] = { valid = true }, -- Nightwatcher Merayl / Training with the Nightwatchers (Family Familiar)
    [106417] = { valid = true }, -- Vinu / The Wine's Gone Bad
    [106542] = { valid = true }, -- Wounded Azurewing Whelpling / Help a Whelp [click to start?!]
    -- Val'sharah (Patch 7.0)
    [99035] = { valid = true }, -- Durian Strongfruit / Training with Durian (Family Familiar)
    [105093] = { valid = true }, -- Fragment of Fire / Only Pets Can Prevent Forest Fires
    [104992] = { valid = true }, -- The Maw / Meet The Maw
    [105009] = { valid = true }, -- Thistleleaf Bully / Stand Up to Bullies
    [104970] = { valid = true }, -- Xorvasc / Dealing with Satyrs (Family Familiar)
    -- Highmountain (Patch 7.0)
    [99077] = { valid = true }, -- Bredda Tenderhide / Training with Bredda (Family Familiar)
    [99150] = { valid = true }, -- Grixis Tinypop / Tiny Poacher, Tiny Animals (Family Familiar)
    [104782] = { valid = true }, -- Hungry Icefang / Wildlife Protection Force
    [105841] = { valid = true }, -- Lil'idan / It's Illid... Wait.
    [104553] = { valid = true }, -- Odrogg / Snail Fight! (Family Familiar)
    [98572] = { valid = true }, -- Rocko / Rocko Needs a Shave
    -- Stormheim (Patch 7.0)
    [105842] = { valid = true }, -- Chromadon / All Howl, No Bite
    [105455] = { valid = true }, -- Trapper Jarrun / Jarrun's Ladder (Family Familiar)
    [99878] = { valid = true }, -- Ominitron Defense System / Oh, Ominitron
    [98270] = { valid = true }, -- Robert Craig / My Beast's Bidding (Family Familiar)
    [105512] = { valid = true }, -- Envoy of the Hunt / All Pets Go to Heaven
    -- Beasts of Burden:
    [105387] = { valid = true }, -- Andurs
    [105386] = { valid = true }, -- Rydyr
    -- Suramar (Patch 7.0)
    [105250] = { valid = true }, -- Aulier / The Master of Pets (Family Familiar)
    [105323] = { valid = true }, -- Ancient Catacomb Eggs / Clear the Catacombs
    [105674] = { valid = true }, -- Varenne / Chopped (Family Familiar)
    [97709] = { valid = true }, -- Master Tamer Flummox / Flummoxed (Family Familiar)
    [105779] = { valid = true }, -- Felsoul Seer / Threads of Fate
    [105352] = { valid = true }, -- Surging Mana Crystal / Mana Tap
    -- Path 7.1
    [115286] = { valid = true }, -- Crysa
    -- The Broken Shore (Patch 7.2)
    [117934] = { valid = true }, -- Sissix / Illidari Masters: Sissix
    [117950] = { valid = true }, -- Madam Viciosa / Illidari Masters: Madam Viciosa
    [117951] = { valid = true }, -- Nameless Mystic / Illidari Masters: Nameless Mystic
    -- Patch 7.3
    [124617] = { valid = true }, -- Environeer Bert
    -- Battle for Azeroth
    -- Tiragarde Sound
    [141292] = { valid = true }, -- Delia Hanako / That’s a Big Carcass
    [141479] = { valid = true }, -- Burly / Strange Looking Dogs
    [141077] = { valid = true }, -- Kwint / Not So Bad Down Here
    [141215] = { valid = true }, -- Chitara / Unbreakable
    -- Stormsong Valley
    [141046] = { valid = true }, -- Leana Darkwind / Captured Evil
    [141002] = { valid = true }, -- Ellie Vern / Sea Creatures Are Weird
    [140315] = { valid = true }, -- Eddie Fixit / Automated Chaos
    [139987] = { valid = true }, -- Bristlespine / This Little Piggy Has Sharp Tusks
    -- Drustvar
    [140880] = { valid = true }, -- Michael Skarn / What’s the Buzz?
    [140813] = { valid = true }, -- Fizzie Sparkwhistle / Rogue Azerite
    [140461] = { valid = true }, -- Dilbert McClint / Night Horrors
    [139489] = { valid = true }, -- Captain Hermes / Crab People
    -- Zuldazar
    [142114] = { valid = true }, -- Talia Sparkbrow / Add More to the Collection
    [142234] = { valid = true }, -- Zujai / Small Beginnings
    [142151] = { valid = true }, -- Jammer / You’ve Never Seen Jammer Upset
    [142096] = { valid = true }, -- Karaga / Critters are Friends, Not Food
    -- Nazmir
    [141588] = { valid = true }, -- Bloodtusk / Crawg in the Bog
    [141529] = { valid = true }, -- Lozu / Marshdwellers
    [141814] = { valid = true }, -- Korval Darkbeard / Accidental Dread
    [141799] = { valid = true }, -- Grady Prett / Pack Leader
    -- Vol’dun
    [141879] = { valid = true }, -- Keeyo / Keeyo’s Champions of Vol’dun
    [142054] = { valid = true }, -- Kusa / Desert Survivors
    [141969] = { valid = true }, -- Spineleaf / What Do You Mean, Mind Controlling Plants?
    [141945] = { valid = true }, -- Sizzik / Snakes on a Terrace
    -- Stratholme
    [155145] = { valid = true }, -- Critters
    -- Blackrock Depths
    [160209] = { valid = true }, -- Horu Cloudwalker
    [160207] = { valid = true }, -- Therin Skysong
    [160206] = { valid = true }, -- Alran Heartshade
    [160208] = { valid = true }, -- Zuna Skullcrush
    [160210] = { valid = true }, -- Tasha Riley
    [160205] = { valid = true }, -- Pixy Wizzle
    -- Bastion
    [173129] = { valid = true }, -- Thenia
    [173130] = { valid = true }, -- Zolla
    [173131] = { valid = true }, -- Stratios
    [173133] = { valid = true }, -- Jawbone
    -- Maldraxxus
    [173257] = { valid = true }, -- Caregiver Maximillian
    [173263] = { valid = true }, -- Rotgut
    [173267] = { valid = true }, -- Dundley Stickyfingers
    [173274] = { valid = true }, -- Gorgemouth
    -- Revendreth
    [173303] = { valid = true }, -- Scorch
    [173315] = { valid = true }, -- Sylla
    [173324] = { valid = true }, -- Eyegor
    [173331] = { valid = true }, -- Addius the Tormentor
    -- Ardenweald
    [173372] = { valid = true }, -- Glitterdust
    [173376] = { valid = true }, -- Nightfang
    [173377] = { valid = true }, -- Faryl
    [173381] = { valid = true }, -- Rascal
    -- Eye of Azshara
    [179694] = { valid = true }, -- Trainer Iris Greedsway
    -- The Waking Shore
    [189376] = { valid = true }, -- Swog
    [196264] = { valid = true }, -- Haniko
    [201802] = { valid = true }, -- Excavtor Morgrum Emberflint
    -- The Ohn'ahran Plains
    [197102] = { valid = true }, -- Bakhushek
    [197447] = { valid = true }, -- Stormamo
    [201878] = { valid = true }, -- Vikshi Thunderpawu
    -- The Azure Span
    [196069] = { valid = true }, -- Pachu
    [197417] = { valid = true }, -- Arcantus
    [201899] = { valid = true }, -- Ixal Whitemoon
    -- Thaldraszus
    [197336] = { valid = true }, -- Enyobon
    [197350] = { valid = true }, -- Setimothes
    [202458] = { valid = true }, -- Stargazer Xenoth
    -- Zaralek Cavern
    [201004] = { valid = true }, -- Explorer Bezzert
    [204792] = { valid = true }, -- Shinmura
    [204926] = { valid = true }, -- Delver Mardei
    [204934] = { valid = true }, -- Trainer Orlogg
    -- Isle of Dorn
    [223446] = { valid = true }, -- Collector Dyna
    [223407] = { valid = true }, -- Awakened Custodian
    -- The Ringing Deeps
    [223444] = { valid = true }, -- Friendhaver Grem
    [222535] = { valid = true }, -- Haywire Servobot
    -- Hallowfall
    [223442] = { valid = true }, -- Kyrie
    [223409] = { valid = true }, -- Guttergunk
    -- Azj-Kahet
    [223443] = { valid = true }, -- Ziriak
    [223406] = { valid = true }, -- Zaedu
}

function PBAS.TAS_OnClick()
    for i = 1, 4 do
        if _G["StaticPopup" .. i]:IsShown() then
            -- Click "Accept" button to start battle
            _G["StaticPopup" .. i].button1:SetButtonState("PUSHED")
            _G["StaticPopup" .. i].button1:Click()
        end
    end
end

function PBAS:IsTamerValid()
    local validTamer, _, tamerID

    if UnitExists("npc") then -- (Fixes edge case where the tamer has been detargeted)
        _, _, _, _, _, tamerID = strsplit("-", UnitGUID("npc"))
        tamerID = tonumber(tamerID)

        if tamerID and self.PetTamers[tamerID] and self.PetTamers[tamerID].valid then validTamer = true end
    elseif UnitExists("target") then
        _, _, _, _, _, tamerID = strsplit("-", UnitGUID("target"))
        tamerID = tonumber(tamerID)

        if tamerID and self.PetTamers[tamerID] and self.PetTamers[tamerID].valid then validTamer = true end
    end

    return validTamer, tamerID
end

function PBAS:AutoTrainerStart(event)
    if event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE" then
        if IsShiftKeyDown() then return end

        local validTamer, tamerID = self:IsTamerValid()

        if validTamer then
            if event == "GOSSIP_SHOW" then
                -- Check if any quests are completable
                local questIndex
                local availableQuests = C_GossipInfo.GetAvailableQuests()
                local activeQuests = C_GossipInfo.GetActiveQuests()
                if self.db.autoQuestComplete and #activeQuests > 0 then
                    -- Check if any quests are completable
                    for i, info in ipairs(activeQuests) do
                        if info.isComplete then
                            questIndex = i
                            break
                        end
                    end
                end
                local options = C_GossipInfo.GetOptions()
                if self.db.autoQuestAccept and #availableQuests > 0 then
                    C_GossipInfo.SelectAvailableQuest(availableQuests[1].questID)
                    C_GossipInfo.CloseGossip()
                elseif self.db.autoQuestAccept and #activeQuests > 0 and questIndex then
                    C_GossipInfo.SelectActiveQuest(activeQuests[questIndex].questID)
                    C_GossipInfo.CloseGossip()
                elseif
                    self.db.autoStartBattle
                    and #availableQuests == 0
                    and #options > 0
                    and not self.PetTamers[tamerID].noBattle
                then
                    if HasControl() and not InCombat() and not InPetBattle() then
                        -- Determine gossip battle option
                        local battleOption
                        if #options == 1 then
                            battleOption = options[1].gossipOptionID
                        elseif self.PetTamers[tamerID].useFirst then
                            battleOption = options[1].gossipOptionID
                        else
                            for i = #options, 1, -1 do
                                if options[i].type ~= "gossip" then
                                    battleOption = options[i].gossipOptionID
                                    break
                                end
                            end
                        end

                        -- Select gossip battle option, equip items, start battle, set battle type, close gossip window
                        if battleOption then
                            -- Check if the tamer has a popup window for us to use the Safari Hat secure button workaround
                            if self.PetTamers[tamerID].noPopup then -- We can't do the workaround
                                -- Start the pet battle
                                C_Timer_After(1, function()
                                    -- Select proper gossip option
                                    C_GossipInfo.SelectOption(battleOption)
                                end)
                            else -- We can do our workaround
                                -- Select proper gossip option
                                C_GossipInfo.SelectOption(battleOption)

                                -- Start the pet battle
                                C_Timer_After(1, function()
                                    -- Click all StaticPopup dialog Button1s
                                    self.TAS_OnClick()
                                    -- Exit NPC interaction dialog (though this should happen automatically)
                                    C_GossipInfo.CloseGossip()
                                end)
                            end
                        end
                    end
                end
            elseif self.db.autoQuestAccept and event == "QUEST_DETAIL" then
                AcceptQuest()
                C_GossipInfo.CloseGossip()
            elseif self.db.autoQuestComplete and event == "QUEST_PROGRESS" and IsQuestCompletable() then
                CompleteQuest()
                C_GossipInfo.CloseGossip()
            elseif self.db.autoQuestComplete and event == "QUEST_COMPLETE" and GetNumQuestChoices() < 2 then
                GetQuestReward(GetNumQuestChoices())
                C_GossipInfo.CloseGossip()
            end
        end
    end
end

function PBAS:Initialize()
    self.db = E.db.nihilistzscheui.petbattleautostart
    local TrainerEvents = {
        "GOSSIP_SHOW",
        "QUEST_DETAIL",
        "QUEST_PROGRESS",
        "QUEST_COMPLETE",
    }

    for _, event in ipairs(TrainerEvents) do
        self:RegisterEvent(event, "AutoTrainerStart")
    end
end

NUI:RegisterModule(PBAS:GetName())
