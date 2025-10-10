function DamageHero_wrap(base, victim, triggerArgs)
	if triggerArgs.DamageAmount ~= nil and triggerArgs.DamageAmount > 0 and not triggerArgs.Silent then
		if game.CurrentRun.CurrentRoom.Encounter ~= nil and game.CurrentRun.CurrentRoom.Encounter.InProgress and not triggerArgs.PureDamage then
			game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage = true

			if ScreenState.ActiveObjectives.PerfectClear ~= nil then
				thread(MarkObjectiveFailed, "PerfectClear")
				PerfectClearObjectiveFailedPresentation(CurrentRun)
			end

			if not game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage and not game.CurrentRun.CurrentRoom.BlockClearRewards and not game.CurrentRun.CurrentRoom.PerfectEncounterCleared and IsCombatEncounterActive(CurrentRun) then
				for i, traitData in ipairs(game.CurrentRun.Hero.Traits) do
					local perfectClearDamageData = traitData.PerfectClearDamageBonus or (traitData.AddOutgoingDamageModifiers and traitData.AddOutgoingDamageModifiers.UndamagedMultiplier)
					if perfectClearDamageData then
						PerfectClearTraitFailedPresentation(traitData)
					end
				end
			end
		end
	end
end

local function CheckForKeepsakeTraits(args)
	if HeroHasTrait("PerfectClearDamageBonusKeepsake") then
		local traitData = GetHeroTrait("PerfectClearDamageBonusKeepsake")
		if not game.CurrentRun.CurrentRoom.BlockClearRewards then
			local currentRoom = game.CurrentRun.CurrentRoom
			if currentRoom and not game.CurrentRun.Hero.IsDead and currentRoom.Encounter ~= nil and currentRoom.Encounter.EncounterType ~= "NonCombat" and not currentRoom.Encounter.Completed and not currentRoom.Encounter.PlayerTookDamage then
				TraitUIActivateTrait(traitData, args)
			end
		end
	end
end

function TraitUIActivateTraits_Wrap(base, args)
	CheckForKeepsakeTraits()
end

function StartEncounterEffects_wrap(base, encounter)
	-- encounter.StartTime = CurrentRun.GameplayTime could I use this?

	-- Assign a start counter to all active encounters, specifically for Hermes boon
	if game.CurrentRun.CurrentRoom.ActiveEncounters ~= nil then
		for k, encounter in pairs(game.CurrentRun.CurrentRoom.ActiveEncounters) do
			encounter.StartTime = game._worldTime
			-- print(encounter.StartTime)
			-- print(game._worldTime)
			-- print(game.CurrentRun.GameplayTime)
		end
	end

	CheckForKeepsakeTraits()
end

-- Specifically for Thanatos Keepsake
-- A bit silly and was annoying to figure out.
function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	if currentEncounter == currentRoom.Encounter or currentEncounter == game.MapState.EncounterOverride then
		-- For Thanatos
		if game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage ~= nil then
			currentEncounter.PlayerTookDamage = game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage
		end

		if not currentRoom.BlockClearRewards then
			for k, traitData in pairs(CurrentRun.Hero.Traits) do
				if not currentEncounter.PlayerTookDamage and traitData.PerfectClearDamageBonus then
					traitData.AccumulatedDamageBonus = traitData.AccumulatedDamageBonus + (traitData.PerfectClearDamageBonus - 1)
					PerfectClearTraitSuccessPresentation(traitData)
					CurrentRun.CurrentRoom.PerfectEncounterCleared = true
				end
			end
		end

		-- For Hermes in fields, very crude but hopefully works, makes it so if encounter has threshold
		-- calculate the clear time, else set clear time to arbritrary high number to fail encounter automatically (done to combat NPC rooms)
		if currentEncounter.FastClearThreshold then
			for k, encounter in pairs(CurrentRun.CurrentRoom.ActiveEncounters) do
				-- Check clear time, used later in original function
				currentEncounter.ClearTime = game._worldTime - encounter.StartTime
			end
		else
			-- If no threshold, either its undefined, broken, or NPC/NonCombat room, set clear time to 200 to auto fail hermes
			currentEncounter.ClearTime = 200
		end
	end
end

function PerfectClearTraitStartPresentation(traitData, args)
	PlaySound({ Name = "/EmptyCue" })
	TraitUIActivateTrait(traitData, args)
end

function PerfectClearTraitFailedPresentation(traitData)
	TraitUIDeactivateTrait(traitData)
	PlaySound({ Name = "/SFX/ThanatosHermesKeepsakeFail" })
	-- thread(PlayVoiceLines, HeroVoiceLines.KeepsakeChallengeFailedVoiceLines, true)
	local existingTraitData = GetExistingUITrait(traitData)
	if existingTraitData and existingTraitData.AnchorId ~= nil then
		Shake({ Id = existingTraitData.AnchorId, Distance = 3, Speed = 500, Duration = 0.25 })
		Flash({ Id = existingTraitData.AnchorId, Speed = 2, MinFraction = 0, MaxFraction = 0.8, Color = Color.Black, ExpireAfterCycle = true })
	end
end

function PerfectClearTraitSuccessPresentation(traitData)
	wait(0.50)
	TraitUIDeactivateTrait(traitData)
	local existingTraitData = GetExistingUITrait(traitData)
	if existingTraitData ~= nil and existingTraitData.AnchorId ~= nil then
		CreateAnimation({ Name = "KeepsakeSparkleEmitter", DestinationId = existingTraitData.AnchorId, GroupName = "Overlay" })
		PlaySound({ Name = existingTraitData.EquipSound or "/Leftovers/Menu Sounds/TalismanPowderDownLEGENDARY", Id = CurrentRun.Hero.ObjectId })
	end
	CreateAnimation({ Name = "KeepsakeLevelUpFlare", DestinationId = CurrentRun.Hero.ObjectId, Scale = 1.0 })
	local soundId = PlaySound({ Name = "/SFX/ThanatosAttackBell", Id = CurrentRun.Hero.ObjectId })
	SetVolume({ Id = soundId, Value = 0.3 })
	thread(InCombatText, CurrentRun.Hero.ObjectId, "Hint_PerfectClearDamageBonus", 2.0, { ShadowScaleX = 1.5, LuaKey = "TempTextData", LuaValue = traitData })
	ShakeScreen({ Speed = 500, Distance = 4, FalloffSpeed = 1000, Duration = 0.3 })
end
