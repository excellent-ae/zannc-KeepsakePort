-- =================================================
--               Persephone KEEPSAKE
-- =================================================
function CreateKeepsake_Persephone()
	-- Creating Keepsake Order
	table.insert(game.ScreenData.KeepsakeRack.ItemOrder, "ChamberStackTrait")

	-- Creating Gift Data
	game.GiftData.NPC_Persephone_01 = {
		MaxedRequirement = {},
		MaxedIcon = "Keepsake_Persephone_Corner",
		MaxedSticker = "Keepsake_Persephone",

		[1] = {
			Gift = "ChamberStackTrait",
		},
		InheritFrom = { "DefaultGiftData" },
		Name = "ChamberStackTrait",
	}
	if config.enableGifting then
		game.GiftData.NPC_Persephone_01.MaxedRequirement = { { PathTrue = { "GameState", "TextLinesRecord", "HadesWithPersephoneGift06" } } }
	end

	-- Creating Keepsake Data
	game.TraitData.ChamberStackTrait = {
		Icon = "Pom_Blossom",
		InheritFrom = { "GiftTrait" },
		Name = "ChamberStackTrait",

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
			Common = {
				Multiplier = 1.0,
			},
			Rare = {
				Multiplier = 5 / 6,
			},
			Epic = {
				Multiplier = 4 / 6,
			},
			Heroic = {
				Multiplier = 3 / 6,
			},
		},

		RoomsPerUpgrade = {
			Amount = {
				BaseValue = 6,
			},
			TraitStacks = 1, -- Adding cause of TraitLogic in h2
			ReportValues = {
				ReportedRoomsPerUpgrade = "Amount",
			},
		},
		CurrentRoom = 0,
		ExtractValues = { {
			Key = "ReportedRoomsPerUpgrade",
			ExtractAs = "TooltipRoomInterval",
		} },

		SignOffData = {
			{
				GameStateRequirements = {},
				Text = "SignoffPersephone_Max",
			},
			{
				Text = "SignoffPersephone",
			},
		},
	}
	if config.enableGifting then
		game.TraitData.ChamberStackTrait.SignOffData[0].GameStateRequirements = { {
			PathTrue = { "GameState", "TextLinesRecord", "HadesWithPersephoneGift06" },
		} }
	end
end

-- =================================================
--                Persephone SJSON
-- =================================================
-- Used for when you have it equipped and in the rack
local keepsakerack_persephone = sjson.to_object({
	Id = "ChamberStackTrait",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Pom Blossom",
	Description = "After every {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipRoomInterval} {#Prev}{$Keywords.EncounterPlural}, gain {#UseGiftPointFormat}+1 Lv.{!Icons.Pom} {#Prev}{#ItalicFormat}(a random {$Keywords.GodBoon} grows stronger){#Prev}",
}, Order)

-- From which Character
local signoff_persephone = sjson.to_object({
	Id = "SignoffPersephone",
	DisplayName = "From Persephone",
}, Order)

local signoff_persephonemax = sjson.to_object({
	Id = "SignoffPersephone_Max",
	DisplayName = "From {#AwardMaxFormat}Persephone{#Prev}; you share a {#AwardMaxFormat}Growing Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}The dead live on in the underworld, and her nurturing instinct there also thrives.",
}, Order)

-- Icon JSON data
local keepsakeicon_persephone = sjson.to_object({
	Name = "Pom_Blossom",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Pom_Blossom"),
}, IconOrder)

local keepsakemaxCorner_persephone = sjson.to_object({
	Name = "Keepsake_Persephone_Corner",
	InheritFrom = "KeepsakeMax_Corner",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Persephone"),
}, IconOrder)

local keepsakemax_persephone = sjson.to_object({
	Name = "Keepsake_Persephone",
	InheritFrom = "KeepsakeMax",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Persephone_02"),
}, IconOrder)

-- Inserting into SJSON
sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsakerack_persephone)
	table.insert(data.Texts, signoff_persephone)
	table.insert(data.Texts, signoff_persephonemax)
end)

-- Insert for Icons
sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_persephone)
	table.insert(data.Animations, keepsakemaxCorner_persephone)
	table.insert(data.Animations, keepsakemax_persephone)
end)

-- Call the Function
CreateKeepsake_Persephone()
