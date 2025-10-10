-- =================================================
--               Thanatos KEEPSAKE
-- =================================================
function CreateKeepsake_Thanatos()
	-- Creating Keepsake Order
	table.insert(game.ScreenData.KeepsakeRack.ItemOrder, "PerfectClearDamageBonusKeepsake")

	-- Creating Gift Data
	game.GiftData.NPC_Thanatos_01 = {
		[1] = {
			Gift = "PerfectClearDamageBonusKeepsake",
		},
		InheritFrom = { "DefaultGiftData" },
		Name = "PerfectClearDamageBonusKeepsake",
	}

	-- Creating Keepsake Data
	game.TraitData.PerfectClearDamageBonusKeepsake = {
		Icon = "Pierced_Butterfly",
		InheritFrom = { "GiftTrait" },
		Name = "PerfectClearDamageBonusKeepsake",
		CustomTrayText = "PerfectClearDamageBonusKeepsake_Tray",

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
			Common = { Multiplier = config.Thanatos.a_KeepsakeCommon },
			Rare = { Multiplier = config.Thanatos.b_KeepsakeRare },
			Epic = { Multiplier = config.Thanatos.c_KeepsakeEpic },
			Heroic = { Multiplier = config.Thanatos.d_KeepsakeHeroic },
		},

		PerfectClearDamageBonus = {
			BaseValue = 1.01,
			SourceIsMultiplier = true,
			DecimalPlaces = 3,
		},
		AddOutgoingDamageModifiers = {
			UseTraitValue = "AccumulatedDamageBonus",
		},
		AccumulatedDamageBonus = 1,

		ExtractValues = {
			{
				Key = "PerfectClearDamageBonus",
				ExtractAs = "TooltipPerfectClearBonus",
				Format = "PercentDelta",
				DecimalPlaces = 1,
			},
			{
				Key = "AccumulatedDamageBonus",
				ExtractAs = "TooltipAccumulatedBonus",
				Format = "PercentDelta",
				DecimalPlaces = 1,
			},
		},

		SignOffData = {
			{
				Text = "SignoffThanatos",
			},
		},
	}
end

-- =================================================
--                 Thanatos SJSON
-- =================================================
-- Used for when you have it equipped
local keepsake_thanatos = sjson.to_object({
	Id = "PerfectClearDamageBonusKeepsake_Tray",
	InheritFrom = "PerfectClearDamageBonusKeepsake",
	Description = "Gain bonus damage each time you clear an {$Keywords.EncounterAlt} without taking damage.\n{#StatFormat}Bonus Damage: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P} {#Prev}",
}, Order)

-- In rack description
local keepsakerack_thanatos = sjson.to_object({
	Id = "PerfectClearDamageBonusKeepsake",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Pierced Butterfly",
	Description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData.TooltipPerfectClearBonus:P} {#Prev}damage each time you clear an {$Keywords.EncounterAlt} without taking damage.",
}, Order)

-- From which Character
local signoff_thanatos = sjson.to_object({
	Id = "SignoffThanatos",
	DisplayName = "From Thanatos",
}, Order)

-- Icon JSON data
local keepsakeicon_thanatos = sjson.to_object({
	Name = "Pierced_Butterfly",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Pierced_Butterfly"),
}, IconOrder)

-- Clear Message in room
local helptext_sjson = sjson.to_object({
	Id = "Hint_PerfectClearDamageBonus",
	DisplayName = "Clear! {#UpgradeFormat}{$TempTextData.ExtractData.TooltipPerfectClearBonus:P}",
}, HelpTextOrder)

-- Inserting into SJSON
sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsake_thanatos)
	table.insert(data.Texts, keepsakerack_thanatos)
	table.insert(data.Texts, signoff_thanatos)
end)

-- Insert for Icons
sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_thanatos)
end)

-- Insert for Text
sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, helptext_sjson)
end)

-- Call the Function
CreateKeepsake_Thanatos()
