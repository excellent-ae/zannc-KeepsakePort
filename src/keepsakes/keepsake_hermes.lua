-- =================================================
--                 Hermes KEEPSAKE
-- =================================================
function CreateKeepsake_Hermes()
	-- Creating Keepsake Order
	table.insert(game.ScreenData.KeepsakeRack.ItemOrder, "FastClearDodgeBonusKeepsake")

	-- Creating Gift Data - using 02 to avoid conflict
	game.GiftData.NPC_Hermes_02 = {
		MaxedRequirement = {},
		MaxedIcon = "Keepsake_Hermes_Corner_Port",
		MaxedSticker = "Keepsake_Hermes_Port",

		[1] = {
			Gift = "FastClearDodgeBonusKeepsake",
		},
		InheritFrom = { "DefaultGiftData" },
		Name = "FastClearDodgeBonusKeepsake",
	}
	if config.enableGifting then
		game.GiftData.NPC_Hermes_02.MaxedRequirement = { { PathTrue = { "GameState", "TextLinesRecord", "HermesGift08" } } }
	end

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
			Heroic = "Frame_Keepsake_Rank4",
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

		FastClearThreshold = 40,
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
				GameStateRequirements = {},
				Text = "SignoffHermes_Max",
			},
			{
				Text = "SignoffHermes",
			},
		},
	}
	if config.enableGifting then
		game.TraitData.FastClearDodgeBonusKeepsake.SignOffData[0].GameStateRequirements = { {
			PathTrue = { "GameState", "TextLinesRecord", "HermesGift08" },
		} }
	end
end

-- =================================================
--                 Hermes SJSON
-- =================================================
-- Used for when you have it equipped
local keepsake_hermes = sjson.to_object({
	Id = "FastClearDodgeBonusKeepsake_Tray",
	InheritFrom = "FastClearDodgeBonusKeepsake",
	Description = "Gain greater {$Keywords.Dodge} chance and {#BoldFormatGraft}move {#Prev}speed each time you quickly clear an {$Keywords.EncounterAlt}.\n{#StatFormat}Dodge Chance & Move Speed: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P} {#Prev}",
}, Order)

-- In rack description
local keepsakerack_hermes = sjson.to_object({
	Id = "FastClearDodgeBonusKeepsake",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Lambent Plume",
	Description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData.TooltipFastClearDodgeBonus:P} {#Prev}{$Keywords.Dodge} chance and {#BoldFormatGraft}move {#Prev}speed each time you quickly clear an {$Keywords.EncounterAlt}.",
}, Order)

-- Icon JSON data
local keepsakeicon_hermes = sjson.to_object({
	Name = "Lambent_Plume",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Lambent_Plume"),
}, IconOrder)

local keepsakemaxCorner_hermes = sjson.to_object({
	Name = "Keepsake_Hermes_Corner_Port",
	InheritFrom = "KeepsakeMax_Corner",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Hermes"),
}, IconOrder)

local keepsakemax_hermes = sjson.to_object({
	Name = "Keepsake_Hermes_Port",
	InheritFrom = "KeepsakeMax",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Hermes_02"),
}, IconOrder)

local hermes_helptext_sjson = sjson.to_object({
	Id = "Hint_FastClearDamageBonus",
	DisplayName = "Clear! {#UpgradeFormat}{$TempTextData.ExtractData.TooltipFastClearDodgeBonus:P}",
}, HelpTextOrder)

local ActiveTraitSingle_Custom = sjson.to_object({
	Name = "ActiveTraitSingle_Custom",
	FilePath = "GUI\\HUD\\ActiveTraitTimer\\ActiveTraitTimer",
	GroupName = "Combat_Menu_Additive",
	EndFrame = 30,
	NumFrames = 30,
	PlaySpeed = 1,
	StartFrame = 1,
	Scale = 0.75,
	OffsetY = -10,
	OffsetX = 25,
	PlayBackwards = true,
	AddColor = true,
	FlipHorizontal = true,
	Red = 1,
	Green = 0.6,
	Blue = 0.1,
	VisualFxIntervalMin = 1.0,
	VisualFxIntervalMax = 1.00001,
	VisualFx = "ActiveTraitSingleFlash",
	Loop = false,
	ChainTo = "TraitUpdate",
}, HUDOrder)

sjson.hook(GUIHUDVFXFile, function(data)
	table.insert(data.Animations, ActiveTraitSingle_Custom)
end)

-- Inserting into SJSON
sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsake_hermes)
	table.insert(data.Texts, keepsakerack_hermes)
end)

-- Insert for Icons
sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_hermes)
	table.insert(data.Animations, keepsakemaxCorner_hermes)
	table.insert(data.Animations, keepsakemax_hermes)
end)

-- Insert for Text
sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, hermes_helptext_sjson)
end)

--#region ClearTimes
-- =================================================
--              Lua for Clear Times
-- EncounterData_Bos, EncounterData_Generated, EncounterData_MiniBoss, EncounterData
-- =================================================

game.EncounterData.BossEncounter.FastClearThreshold = 80 -- Generic Boss

game.EncounterData.BossPrometheus01.FastClearThreshold = 110 -- Prometheus
game.EncounterData.BossTyphonHead01.FastClearThreshold = 90 -- IDK
game.EncounterData.BossZagreus01.FastClearThreshold = 130 -- Zagreus

game.EncounterData.CapturePoint.FastClearThreshold = 55 -- Asphodel?
game.EncounterData.GeneratedAnomalyBase.FastClearThreshold = 55 -- Asphodel?

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
game.EncounterData.BossChronos01.FastClearThreshold = 130 -- Chronos Boss Encounters

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
game.EncounterData.GeneratedP.FastClearThreshold = 50
game.EncounterData.GeneratedQ.FastClearThreshold = 65

-- NPC encounters
game.EncounterData.BaseArtemisCombat.FastClearThreshold = 65 -- Artemis Encounters
game.EncounterData.BaseNemesisCombat.FastClearThreshold = 65 -- Nemesis Encounters cause idk if they will ever remove it
game.EncounterData.BaseHeraclesCombat.FastClearThreshold = 65 -- Heracles Encounters
game.EncounterData.BaseIcarusCombat.FastClearThreshold = 65 -- Icarus Encounters
game.EncounterData.BaseAthenaCombat.FastClearThreshold = 50 -- Athena

-- print(ModUtil.ToString.Deep(game.EncounterData))
--#endregion

CreateKeepsake_Hermes()
