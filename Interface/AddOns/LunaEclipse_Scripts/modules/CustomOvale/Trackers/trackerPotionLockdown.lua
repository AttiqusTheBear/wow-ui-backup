local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerPotionLockdown";
	local trackerPotionLockdown = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- Any potion that shares the cooldown will work, this is just to see if its locked without relying on a potion the player has.
	local POTION_OF_THE_OLD_WAR = 127844;
	
	-- Variable to store whether potions are currently locked down
	local potionLockedDown = false;
	--</private-static-properties>

	--<public-static-methods>
    function trackerPotionLockdown:BAG_UPDATE_COOLDOWN(event, ...)
		if not potionLockedDown then
			local start, duration, enabled = GetItemCooldown(POTION_OF_THE_OLD_WAR);
		
			if enabled == 0 then
				potionLockedDown = true;
			end
		end
    end

    function trackerPotionLockdown:PLAYER_REGEN_DISABLED()
        potionLockedDown = false;

        self:RegisterEvent("BAG_UPDATE_COOLDOWN");
    end

    function trackerPotionLockdown:PLAYER_REGEN_ENABLED()
        self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
        
		potionLockedDown = false;
   end

	function trackerPotionLockdown:OnEnable()	
        self:RegisterEvent("PLAYER_REGEN_DISABLED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");

        OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerPotionLockdown:OnDisable()
        OvaleState:UnregisterState(self);

		self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerPotionLockdown.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerPotionLockdown.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether potions are in combat lockdown
	statePrototype.PotionCombatLockdown = function(state)
		return potionLockedDown or false;
	end
    --</public-static-methods>
end