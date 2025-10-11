---@meta zannc-KeepsakePort-config
local config = {
	enabled = true,
	enableGifting = false,

	Thanatos = {
		Enabled = true,
		a_KeepsakeCommon = 1.0,
		b_KeepsakeRare = 1.5,
		c_KeepsakeEpic = 2.0,
		d_KeepsakeHeroic = 2.5,
	},

	Hermes = {
		Enabled = true,
		a_KeepsakeCommon = 1.0,
		b_KeepsakeRare = 1.1,
		c_KeepsakeEpic = 1.2,
		d_KeepsakeHeroic = 1.3,
	},

	Chaos = {
		Enabled = true,
	},

	Megaera = {
		Enabled = true,
	},

	Nyx = {
		Enabled = true,
	},

	Persephone = {
		Enabled = true,
	},
}

local descriptions = {
	enabled = "Set to true to enable the mod, false to disable.",

	Thanatos = {
		Enabled = "Set to true to enable keepsake, false to disable.\nNOTE: When disabling keepsakes, make sure you unequip them and save your game",
		a_KeepsakeCommon = "Increase value to increase damage bonus gained per room, decrease for opposite effect.\nExample: 2.0 will set bonus to +2.0% per room, 0.5 will set it to +0.5% per room",
	},

	Hermes = {
		Enabled = "Set to true to enable keepsake, false to disable.\nNOTE: When disabling keepsakes, make sure you unequip them and save your game",
		a_KeepsakeCommon = "Increase value to increase dodge and movespeed gained per room, decrease for opposite effect.\nExample: 2.0 will set bonus to +2.0% per room, 0.5 will set it to +0.5% per room",
	},

	Persephone = {
		Enabled = "Set to true to enable keepsake, false to disable.\nNOTE: When disabling keepsakes, make sure you unequip them and save your game\nNOTE 2: There is no config for persephone because it will be prone to breaking.",
	},
}

return config, descriptions
