-- =================================================
--                 Hermes KEEPSAKE
-- =================================================
function CreateKeepsake_Hermes()
	-- Creating Keepsake Order
	table.insert(game.ScreenData.KeepsakeRack.ItemOrder, "FastClearDodgeBonusKeepsake")

	-- Creating Gift Data - using 02 to avoid conflict
	game.GiftData.NPC_Hermes_02 = {
		[1] = {
			Gift = "FastClearDodgeBonusKeepsake",
		},
		InheritFrom = { "DefaultGiftData" },
		Name = "FastClearDodgeBonusKeepsake",
	}

	-- Creating Keepsake Data
	game.TraitData.FastClearDodgeBonusKeepsake = {
		Icon = "Lambent_Plume",
		InheritFrom = { "GiftTrait" },
		Name = "FastClearDodgeBonusKeepsake",
		CustomTrayText = "FastClearDodgeBonusKeepsake_Tray",

		-- Always add these, so it SHUTS UP
		ShowInHUD = true,
		Ordered = true,
		HUDScale = 0.435,
		PriorityDisplay = true,
		ChamberThresholds = { 25, 50 },
		HideInRunHistory = true,
		Slot = "Keepsake",
		InfoBackingAnimation = "KeepsakeSlotBase",
		RecordCacheOnEquip = true,
		TraitOrderingValueCache = -1,
		ActiveSlotOffsetIndex = 0,

		FrameRarities = {
			Common = "Frame_Keepsake_Rank1",
			Rare = "Frame_Keepsake_Rank2",
			Epic = "Frame_Keepsake_Rank3",
		},

		CustomRarityLevels = {
			"TraitLevel_Keepsake1",
			"TraitLevel_Keepsake2",
			"TraitLevel_Keepsake3",
			"TraitLevel_Keepsake4",
		},

		RarityLevels = {
			Common = { Multiplier = config.Hermes.a_KeepsakeCommon },
			Rare = { Multiplier = config.Hermes.b_KeepsakeRare },
			Epic = { Multiplier = config.Hermes.c_KeepsakeEpic },
			Heroic = { Multiplier = config.Hermes.d_KeepsakeHeroic },
		},

		FastClearThreshold = 30,
		FastClearDodgeBonus = {
			BaseValue = 0.01,
			DecimalPlaces = 4,
		},

		FastClearSpeedBonus = {
			BaseValue = 0.01,
			DecimalPlaces = 4,
		},

		AccumulatedDodgeBonus = 0,
		ExtractValues = {
			{
				Key = "FastClearDodgeBonus",
				ExtractAs = "TooltipFastClearDodgeBonus",
				Format = "Percent",
				DecimalPlaces = 2,
			},
			{
				Key = "AccumulatedDodgeBonus",
				ExtractAs = "TooltipAccumulatedBonus",
				Format = "Percent",
				DecimalPlaces = 2,
			},
		},

		SignOffData = {
			{
				Text = "SignoffHermes",
			},
		},
	}
end

-- Call the Function
CreateKeepsake_Hermes()

-- =================================================
--                 Hermes SJSON
-- =================================================
-- Used for when you have it equipped
local keepsake_hermes = sjson.to_object({
	Id = "FastClearDodgeBonusKeepsake_Tray",
	InheritFrom = "FastClearDodgeBonusKeepsake",
	Description = "Gain greater {$Keywords.Dodge} chance and move speed each time you quickly clear an {$Keywords.EncounterAlt}.\n{#StatFormat}Dodge Chance & Move Speed: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P} {#Prev}",
}, Order)

-- In rack description
local keepsakerack_hermes = sjson.to_object({
	Id = "FastClearDodgeBonusKeepsake",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Lambent Plume",
	Description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData.TooltipFastClearDodgeBonus:P} {#Prev}{$Keywords.Dodge} chance and move speed each time you quickly clear an {$Keywords.EncounterAlt}.",
}, Order)

-- Icon JSON data
local keepsakeicon_hermes = sjson.to_object({
	Name = "Lambent_Plume",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Lambent_Plume"),
}, IconOrder)

-- Clear Message in room, fixed from default
function sjson_clearText_Hermes(data)
	for _, v in ipairs(data.Texts) do
		if v.Id == "FastClearDamageBonus" then
			v.DisplayName = "Clear! {#UpgradeFormat}{$TempTextData.ExtractData.TooltipFastClearDodgeBonus:P}"
			break
		end
	end
end

-- Inserting into SJSON
sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsake_hermes)
	table.insert(data.Texts, keepsakerack_hermes)
end)

-- Insert for Icons
sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_hermes)
end)

sjson.hook(HelpTextFile, function(data)
	return sjson_clearText_Hermes(data)
end)

-- =================================================
--              Lua for Clear Times
-- EncounterData_Bos, EncounterData_Generated, EncounterData_MiniBoss, EncounterData
-- =================================================

--               Underground Regions
-- =================================================
-- Erebus Region
game.EncounterData.GeneratedF.FastClearThreshold = 25 -- Base Encounters
game.EncounterData.MiniBossTreant.FastClearThreshold = 35 -- Root Stalker/Weird Plant Boss Encounters
game.EncounterData.MiniBossFogEmitter.FastClearThreshold = 35 -- Shadow Spiller/Fog Encounters
game.EncounterData.BossHecate01.FastClearThreshold = 65 -- Hecate Boss Encounters

-- Oceanus Region
game.EncounterData.GeneratedG.FastClearThreshold = 40 -- Base Encounters
game.EncounterData.MiniBossWaterUnit.FastClearThreshold = 50 -- Spinny Boy Encounters
game.EncounterData.MiniBossCrawler.FastClearThreshold = 65 -- Uh Oh Encounters
game.EncounterData.BossScylla01.FastClearThreshold = 85 -- Scylla Encounters

-- Asphodel Region from Chronos
game.EncounterData.GeneratedAnomalyBase.FastClearThreshold = 60 -- Base Encounter

-- Fields Region
game.EncounterData.GeneratedH_Passive.FastClearThreshold = 40 -- Field Cage Encounters
game.EncounterData.GeneratedH_PassiveSmall.FastClearThreshold = 30 -- Small Field Cage Encounters
game.EncounterData.MiniBossLamia.FastClearThreshold = 55 -- Lamia/Snake Thing Encounters
game.EncounterData.MiniBossVampire.FastClearThreshold = 70 -- Vampire Thing Encounters
game.EncounterData.BossInfestedCerberus01.FastClearThreshold = 100 -- Cerberus Boss Encounters

-- Tartarus/House Of Hades Region
game.EncounterData.GeneratedI.FastClearThreshold = 25 -- Base Encounters
game.EncounterData.MiniBossGoldElemental.FastClearThreshold = 35 -- GoldElemental/Weird Rat Thing idk Encounters
game.EncounterData.BossChronos01.FastClearThreshold = 120 -- Chronos Boss Encounters

--                  Surface Regions
-- =================================================
-- City of Ephyra Region
game.EncounterData.GeneratedN.FastClearThreshold = 35 -- Base & Hub Encounters
game.EncounterData.GeneratedN_Bigger.FastClearThreshold = 45 -- Big? Base Encounters
game.EncounterData.BossPolyphemus01.FastClearThreshold = 75 -- Polyphemus/Cyclops Boss Encounters

-- Rift of Thessaly Region
game.EncounterData.GeneratedO_Intro01.FastClearThreshold = 20 -- Intro Encounters
game.EncounterData.GeneratedO.FastClearThreshold = 40 -- Base Encounters
game.EncounterData.BossEris01.FastClearThreshold = 90 -- Eris Boss Encounters

-- Undone Region Stuff
game.EncounterData.GeneratedP.FastClearThreshold = 0

-- NPC encounters
game.EncounterData.BaseArtemisCombat.FastClearThreshold = 65 -- Artemis Encounters
game.EncounterData.BaseNemesisCombat.FastClearThreshold = 65 -- Nemesis Encounters cause idk if they will ever remove it
game.EncounterData.BaseHeraclesCombat.FastClearThreshold = 65 -- Heracles Encounters
game.EncounterData.BaseIcarusCombat.FastClearThreshold = 65 -- Icarus Encounters

-- print(ModUtil.ToString.Deep(game.EncounterData))
