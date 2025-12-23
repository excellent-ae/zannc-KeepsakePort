---@meta _
---@diagnostic disable
local mods = rom.mods

---@module 'LuaENVY-ENVY-auto'
mods["LuaENVY-ENVY"].auto()

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]

---@module 'zannc-KeepsakePort-config'
config = chalk.auto("config.lua")
public.config = config
