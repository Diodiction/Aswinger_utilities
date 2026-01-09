-- Aswinger_utilities.lua
local colors = {
    { name = "Black", id = 0 },
    { name = "Carbon Black", id = 147 },
    { name = "Graphite", id = 1 },
    { name = "Anthracite Black", id = 11 },
    { name = "Black Steel", id = 2 },
    { name = "Dark Steel", id = 3 },
    { name = "Silver", id = 4 },
    { name = "Bluish Silver", id = 5 },
    { name = "Rolled Steel", id = 6 },
    { name = "Shadow Silver", id = 7 },
    { name = "Stone Silver", id = 8 },
    { name = "Midnight Silver", id = 9 },
    { name = "Cast Iron Silver", id = 10 },
    { name = "Red", id = 27 },
    { name = "Torino Red", id = 28 },
    { name = "Formula Red", id = 29 },
    { name = "Lava Red", id = 150 },
    { name = "Blaze Red", id = 30 },
    { name = "Grace Red", id = 31 },
    { name = "Garnet Red", id = 32 },
    { name = "Sunset Red", id = 33 },
    { name = "Cabernet Red", id = 34 },
    { name = "Wine Red", id = 143 },
    { name = "Candy Red", id = 35 },
    { name = "Hot Pink", id = 135 },
    { name = "Pfister Pink", id = 137 },
    { name = "Salmon Pink", id = 136 },
    { name = "Sunrise Orange", id = 36 },
    { name = "Orange", id = 38 },
    { name = "Bright Orange", id = 138 },
    { name = "Classic Gold", id = 37 },
    { name = "Gold", id = 99 },
    { name = "Bronze", id = 90 },
    { name = "Yellow", id = 88 },
    { name = "Race Yellow", id = 89 },
    { name = "Dew Yellow", id = 91 },
    { name = "Dark Green", id = 49 },
    { name = "Racing Green", id = 50 },
    { name = "Sea Green", id = 51 },
    { name = "Olive Green", id = 52 },
    { name = "Bright Green", id = 53 },
    { name = "Gasoline Green", id = 54 },
    { name = "Lime Green", id = 92 },
    { name = "Green", id = 139 },
    { name = "Hunter Green", id = 144 },
    { name = "Securicor Green", id = 125 },
    { name = "Midnight Blue", id = 141 },
    { name = "Galaxy Blue", id = 61 },
    { name = "Dark Blue", id = 62 },
    { name = "Saxon Blue", id = 63 },
    { name = "Blue", id = 64 },
    { name = "Mariner Blue", id = 65 },
    { name = "Harbor Blue", id = 66 },
    { name = "Diamond Blue", id = 67 },
    { name = "Surf Blue", id = 68 },
    { name = "Nautical Blue", id = 69 },
    { name = "Racing Blue", id = 73 },
    { name = "Ultra Blue", id = 70 },
    { name = "Light Blue", id = 74 },
    { name = "Fluorescent Blue", id = 140 },
    { name = "Epsilon Blue", id = 157 },
    { name = "Very Dark Blue", id = 146 },
    { name = "Police Blue", id = 127 },
    { name = "Chocolate Brown", id = 96 },
    { name = "Creek Brown", id = 95 },
    { name = "Feltzer Brown", id = 94 },
    { name = "Maple Brown", id = 97 },
    { name = "Saddle Brown", id = 98 },
    { name = "Straw Brown", id = 99 },
    { name = "Moss Brown", id = 100 },
    { name = "Bison Brown", id = 101 },
    { name = "Woodbeech Brown", id = 102 },
    { name = "Beechwood Brown", id = 103 },
    { name = "Sienna Brown", id = 104 },
    { name = "Sandy Brown", id = 105 },
    { name = "Bleached Brown", id = 106 },
    { name = "Schafter Purple", id = 71 },
    { name = "Spinnaker Purple", id = 72 },
    { name = "Midnight Purple", id = 142 },
    { name = "Bright Purple", id = 145 },
    { name = "Cream", id = 107 },
    { name = "Champagne", id = 93 },
    { name = "Ice White", id = 111 },
    { name = "Frost White", id = 112 },
    { name = "Pure White", id = 134 },
    { name = "Default Alloy", id = 156 },
    { name = "Secret Gold", id = 160 }
}

local colorNames = {}
for _, c in ipairs(colors) do
    table.insert(colorNames, c.name)
end

-- UI 상태 변수
local selectedPrimaryIndex = 0
local selectedSecondaryIndex = 0
local selectedPearlescentIndex = 0
local selectedWheelIndex = 0

local customPrimary = {1.0, 0.0, 0.0, 1.0}
local customSecondary = {0.0, 0.0, 1.0, 1.0}

-- 기능 변수
local isRainbowActive = false 
local rainbowSpeed = 0.005    
local currentHue = 0.0       
local isGtaPlusActive = false
local isUnlockChameleonActive = false

--Armor Variables
local FillArmourActive = false
local ArmourLoopDelay = 1000
local AdditionalArmour = 0   
local isFastRespawnActive = false

-- 차량 감지 및 복구 변수
local isPlayerInVehicle = false
local currentVehicle = 0
local originalColors = nil




-- Logic Functions

function CaptureOriginalColors()
    if originalColors == nil and currentVehicle ~= 0 then
        originalColors = {}

        -- 조합 번호(Combination)를 저장 (가장 안전한 방법)
        local combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(currentVehicle)
        
        if combo == -1 then combo = 0 end
        originalColors.combination = combo
        originalColors.wheelType = VEHICLE.GET_VEHICLE_WHEEL_TYPE(currentVehicle)

        notification.show("Original State Saved (ID: " .. tostring(combo) .. ")")
    end
end

function ResetToOriginalColors()
    script.run_in_fiber(function()
        if currentVehicle ~= 0 and originalColors ~= nil then
            isRainbowActive = false 

            if VEHICLE.GET_VEHICLE_MOD_KIT(currentVehicle) ~= 0 then
                VEHICLE.SET_VEHICLE_MOD_KIT(currentVehicle, 0)
            end

            if VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR then VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(currentVehicle) end
            if VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR then VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(currentVehicle) end

            VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(currentVehicle, originalColors.combination)

            if VEHICLE.GET_VEHICLE_WHEEL_TYPE(currentVehicle) ~= originalColors.wheelType then
                VEHICLE.SET_VEHICLE_WHEEL_TYPE(currentVehicle, originalColors.wheelType)
            end

            notification.show("Colors Reset to Factory Default.")
        else
            if currentVehicle ~= 0 then
                VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(currentVehicle)
                VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(currentVehicle)
                VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(currentVehicle, 0)
                notification.show("Force Reset to Default.")
            else
                notification.show("No vehicle to reset.")
            end
        end
    end)
end

function ApplyPresetColors()
    script.run_in_fiber(function()
        if currentVehicle ~= 0 then
            CaptureOriginalColors()
            isRainbowActive = false 

            if VEHICLE.GET_VEHICLE_MOD_KIT(currentVehicle) ~= 0 then
                VEHICLE.SET_VEHICLE_MOD_KIT(currentVehicle, 0)
            end

            if colors and #colors > 0 then
                local primaryID = colors[selectedPrimaryIndex + 1].id
                local secondaryID = colors[selectedSecondaryIndex + 1].id
                local pearlID = colors[selectedPearlescentIndex + 1].id
                local wheelID = colors[selectedWheelIndex + 1].id

                if VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR then VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(currentVehicle) end
                if VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR then VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(currentVehicle) end

                VEHICLE.SET_VEHICLE_COLOURS(currentVehicle, primaryID, secondaryID)
                VEHICLE.SET_VEHICLE_EXTRA_COLOURS(currentVehicle, pearlID, wheelID)
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(currentVehicle, 0.0)

                notification.show("Applied Indexed Colors.")
            end
        else
            notification.show("Not in a vehicle!")
        end
    end)
end

function ApplyCustomRGB()
    script.run_in_fiber(function()
        if currentVehicle ~= 0 then
            CaptureOriginalColors()
            isRainbowActive = false

            if VEHICLE.GET_VEHICLE_MOD_KIT(currentVehicle) ~= 0 then
                VEHICLE.SET_VEHICLE_MOD_KIT(currentVehicle, 0)
            end

            local r1 = math.floor(customPrimary[1] * 255)
            local g1 = math.floor(customPrimary[2] * 255)
            local b1 = math.floor(customPrimary[3] * 255)

            local r2 = math.floor(customSecondary[1] * 255)
            local g2 = math.floor(customSecondary[2] * 255)
            local b2 = math.floor(customSecondary[3] * 255)

            VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(currentVehicle, r1, g1, b1)
            VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(currentVehicle, r2, g2, b2)

            notification.show("Custom RGB Applied.")
        else
            notification.show("No vehicle detected.")
        end
    end)
end

local function RefillArmourNow()
    local player = PLAYER.PLAYER_ID()
    local ped = PLAYER.PLAYER_PED_ID()

    local baseMax = 100
    local targetArmour = baseMax + AdditionalArmour

    PLAYER.SET_PLAYER_MAX_ARMOUR(player, targetArmour)
    PED.SET_PED_ARMOUR(ped, targetArmour)
end

-- Helper for Requests
local function TriggerGlobalRequest(globalId, requestName)
    script.run_in_fiber(function()
        globals.set_int(globalId, 1)
        notification.show("Request Sent: " .. requestName)
    end)
end

-- SecuroServ

-- globals.set_int(1892798 + (player * 615) + 10, 0) -- SecuroServ VIP/CEO
-- globals.set_int(1892798 + (player * 615) + 10, 1) -- SecuroServ Associate/Bodyguard
 
-- Motorcycle Club President
-- globals.set_int(1892798 + (player * 615) + 10, 0) -- MC President ? why is this same as VIP/CEO
-- globals.set_int(1892798 + (player * 615) + 10 + 433, 1) -- MC Member

-- Drawing Loop
menu.on_draw(function()
    if ImGui.BeginTabBar("Main_Tabs") then
        
        -- Tab 1: Vehicle Colors 
        if ImGui.BeginTabItem("Vehicle Colors") then
            
            -- Section: Reset
            ImGui.Separator()
            ImGui.Spacing()
            if ImGui.Button("Colour Factory Reset") then
                ResetToOriginalColors()
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            -- Section: Presets
            ImGui.TextColored(1.0, 0.8, 0.0, 1.0, "Preset Colors")
            ImGui.Spacing()

            ImGui.Combo("Primary", colorNames, selectedPrimaryIndex, function(idx) selectedPrimaryIndex = idx end)
            ImGui.Combo("Secondary", colorNames, selectedSecondaryIndex, function(idx) selectedSecondaryIndex = idx end)
            ImGui.Combo("Pearlescent", colorNames, selectedPearlescentIndex, function(idx) selectedPearlescentIndex = idx end)
            ImGui.Combo("Wheels", colorNames, selectedWheelIndex, function(idx) selectedWheelIndex = idx end)
            
            ImGui.Spacing()
            
            if ImGui.Button("Apply Presets") then 
                ApplyPresetColors() 
            end
            
            ImGui.SameLine()
            
            if ImGui.Button("Randomize") then
                selectedPrimaryIndex = math.random(0, #colorNames - 1)
                selectedSecondaryIndex = math.random(0, #colorNames - 1)
                selectedPearlescentIndex = math.random(0, #colorNames - 1)
                selectedWheelIndex = math.random(0, #colorNames - 1)
                notification.show("Colors Randomized")
            end

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            -- Section: Custom RGB
            ImGui.TextColored(1.0, 0.8, 0.0, 1.0, "Custom RGB Mix")
            ImGui.Spacing()

            local changed1, changed2
            customPrimary, changed1 = ImGui.ColorEdit3("Primary RGB", customPrimary)
            customSecondary, changed2 = ImGui.ColorEdit3("Secondary RGB", customSecondary)

            if ImGui.Button("Apply Static RGB") then 
                ApplyCustomRGB() 
            end

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            -- Section: Rainbow Mode
            ImGui.TextColored(1.0, 0.8, 0.0, 1.0, "Rainbow Mode")
            ImGui.Spacing()
            
            local changed
            isRainbowActive, changed = ImGui.Checkbox("Enable Rainbow Loop", isRainbowActive)
            
            if isRainbowActive then
                rainbowSpeed, _ = ImGui.SliderFloat("Rainbow Speed", rainbowSpeed, 0.0, 0.01, "%.4f")
            end

            -- Section: Unlock Chameleon Paints
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ImGui.TextColored(1.0, 0.8, 0.0, 1.0, "Unlockables")
            ImGui.Spacing()
            
            local changedChameleon
            isUnlockChameleonActive, changedChameleon = ImGui.Checkbox("Unlock Chameleon Paints", isUnlockChameleonActive)
            if changedChameleon and isUnlockChameleonActive then
                notification.show("Chameleon Paints Unlocked.")
            end

            ImGui.EndTabItem()
        end
        

        -- Tab 2: Player
        if ImGui.BeginTabItem("Player") then
            ImGui.TextColored(0.0, 1.0, 0.0, 1.0, "Local Player Stats")
            ImGui.Separator()
            ImGui.Spacing()

            AdditionalArmour, _ = ImGui.SliderInt("Additional Armour (+)", AdditionalArmour, 0, 200)
            ImGui.Spacing()
            
            if ImGui.Button("Fill Armour Max (Once)") then
                RefillArmourNow()
                notification.show("Armour Refilled (Max: " .. tostring(100 + AdditionalArmour) .. ")")
            end

            ImGui.Spacing()

            -- Auto Fill Loop
            local changed
            FillArmourActive, changed = ImGui.Checkbox("Auto Fill Armour (Loop)", FillArmourActive)
            ImGui.SameLine()
            ImGui.TextDisabled("(?) Keeps armour full")
            ArmourLoopDelay, _ = ImGui.SliderInt("Loop Delay (ms)", ArmourLoopDelay, 0, 5000)
            ImGui.Spacing()
            ImGui.TextColored(0.5, 0.5, 0.5, 1.0, "Tip: 1000ms = 1 second")

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            --Fast Respawn Option
            ImGui.TextColored(1.0, 0.0, 0.0, 1.0, "Respawn")
            ImGui.Spacing()
            
            local changedRespawn
            isFastRespawnActive, changedRespawn = ImGui.Checkbox("Fast Respawn", isFastRespawnActive)
            if isFastRespawnActive then
                ImGui.SameLine()
                ImGui.TextDisabled("(Active)")
            end

            ImGui.EndTabItem()
        end

        -- Tab 3: Request (Services)
        if ImGui.BeginTabItem("Request") then
            ImGui.TextColored(0.0, 1.0, 1.0, 1.0, "Services & Vehicles")
            ImGui.Separator()
            ImGui.Spacing()

            ImGui.Text("Service Vehicles")
            if ImGui.Button("Request MOC") then TriggerGlobalRequest(2733138 + 577, "Mobile Operations Center") end
            ImGui.SameLine()
            if ImGui.Button("Request Avenger") then TriggerGlobalRequest(2733138 + 585, "Avenger") end
            ImGui.SameLine()
            if ImGui.Button("Request Terrorbyte") then TriggerGlobalRequest(2733138 + 591, "Terrorbyte") end
            
            if ImGui.Button("Request Kosatka") then TriggerGlobalRequest(2733138 + 613, "Kosatka") end
            ImGui.SameLine()
            if ImGui.Button("Request Acid Lab") then TriggerGlobalRequest(2733138 + 592, "Acid Lab") end
            
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            ImGui.Text("Utility & Support")
            if ImGui.Button("Request Dinghy") then TriggerGlobalRequest(2733138 + 626, "Dinghy") end
            ImGui.SameLine()
            if ImGui.Button("Request Taxi") then TriggerGlobalRequest(2733138 + 509, "Taxi") end
            
            if ImGui.Button("Request Acid Lab Bike") then TriggerGlobalRequest(2733138 + 648, "Acid Lab Bike") end
            if ImGui.Button("Request Bail Transporter") then TriggerGlobalRequest(2733138 + 362, "Bail Office Transporter") end
            
            ImGui.Spacing()
            if ImGui.Button("Request RC Bandito") then TriggerGlobalRequest(2733138 + 5828, "RC Bandito") end
            ImGui.SameLine()
            if ImGui.Button("Request RC Tank") then TriggerGlobalRequest(2733138 + 5829, "RC Tank") end

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            ImGui.Text("Pickups & Drops")
            if ImGui.Button("Request Ammo Drop") then TriggerGlobalRequest(2733138 + 538, "Ammo Drop") end
            if ImGui.Button("Request Bull Shark Testosterone") then TriggerGlobalRequest(2733138 + 546, "Bull Shark Testosterone") end
            
            ImGui.Spacing()
            if ImGui.Button("Request Boat Pickup") then TriggerGlobalRequest(2733138 + 539, "Boat Pickup") end
            ImGui.SameLine()
            if ImGui.Button("Request Heli Pickup") then TriggerGlobalRequest(2733138 + 540, "Helicopter Pickup") end
            
            if ImGui.Button("Request Heli Pickup (SuperVolito)") then 
                script.run_in_fiber(function()
                    globals.set_int(2733138 + 547, 1) -- Set SuperVolito Flag
                    globals.set_int(2733138 + 540, 1) -- Request Heli
                    notification.show("Request Sent: SuperVolito Pickup") -- 여기도 직접 텍스트 수정
                end)
            end

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            ImGui.Text("Combat Support")
            if ImGui.Button("Backup Helicopter") then TriggerGlobalRequest(2733138 + 3579, "Backup Helicopter") end
            ImGui.SameLine()
            if ImGui.Button("Cayo Heli Backup") then TriggerGlobalRequest(2733138 + 490, "Cayo Perico Support Heli") end
            if ImGui.Button("Request Airstrike") then TriggerGlobalRequest(2733138 + 3580, "Airstrike") end

            ImGui.Spacing()
            ImGui.Text("Ballistic Equipment")
            if ImGui.Button("Equip Ballistic") then TriggerGlobalRequest(2733138 + 548, "Ballistic Equipment") end
            ImGui.SameLine()
            if ImGui.Button("Remove Ballistic") then 
                 script.run_in_fiber(function()
                    globals.set_int(2733138 + 548, 2) -- Remove is value 2 (implied)
                    notification.show("Request Sent: Remove Ballistic Equipment")
                end)
            end

            ImGui.EndTabItem()
        end

        -- [[ Tab 2: GTA+ & Misc ]]
        if ImGui.BeginTabItem("GTA+ & Misc") then
            ImGui.Text("GTA+ Emulation")
            ImGui.Separator()
            ImGui.Spacing()
            
            local changed
            isGtaPlusActive, changed = ImGui.Checkbox("Enable GTA+ Membership", isGtaPlusActive)
            
            if changed and not isGtaPlusActive then
                script.run_in_fiber(function()
                    globals.set_bit(1970058 + 3, 2)   
                    globals.clear_bit(1970058 + 3, 3) 
                    globals.clear_bit(1970058 + 3, 1) 
                    globals.set_int(1970058, 0)       
                    notification.show("GTA+ Disabled")
                end)
            end
            
            ImGui.Spacing()
            ImGui.TextWrapped("Enabling this will force set GTA+ global variables in a loop.")
            
            ImGui.EndTabItem()
        end

        ImGui.EndTabBar()
    end
end)

-- Rainbow Loop
script.register_looped(function()
    if isRainbowActive and currentVehicle ~= 0 then
        
        currentHue = currentHue + rainbowSpeed
        if currentHue > 1.0 then 
            currentHue = 0.0 
        end

        local r_f, g_f, b_f = ImGui.ColorConvertHSVtoRGB(currentHue, 1.0, 1.0)
        local r = math.floor(r_f * 255)
        local g = math.floor(g_f * 255)
        local b = math.floor(b_f * 255)

        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(currentVehicle, r, g, b)
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(currentVehicle, r, g, b)
    end
    script.yield(0) 
end)

-- GTA+ 
script.register_looped(function()
    if isGtaPlusActive then
        globals.clear_bit(1970058 + 3, 2) -- Needs Refresh
        globals.set_bit(1970058 + 3, 3) -- Disable Auto Refresh
        globals.set_bit(1970058 + 3, 1) -- Was Membership Checked
        globals.set_int(1970058, 1) -- Has Membership       
    end
    script.yield(500) 
end)


script.register_looped(function()
    if isUnlockChameleonActive then
        -- First: Tuner/Chameleon Paints Unlock
        globals.set_int(262145 + 32627, -1)
        globals.set_int(262145 + 32628, -1)
        globals.set_int(262145 + 32681, -1)
        globals.set_int(262145 + 32682, -1)
        
        -- Then: Additional Unlocks
        globals.set_int(105397 + 50, 0)
        globals.set_int(105397 + 51, 0)
    end
    script.yield(1000) -- no need to run this too frequently tho
end)

-- 차량 감지 및 데이터 초기화 루프 
script.register_looped(function()
    local ped = PLAYER.PLAYER_PED_ID()
    if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
        
        if veh ~= 0 then
            if currentVehicle ~= veh then
                currentVehicle = veh
                isPlayerInVehicle = true
                originalColors = nil  
                isRainbowActive = false 
                VEHICLE.SET_VEHICLE_MAX_SPEED(currentVehicle, -1.0)
            end
        else
            isPlayerInVehicle = false
            currentVehicle = 0
        end
    else
        isPlayerInVehicle = false
        currentVehicle = 0
    end
    script.yield(100)
end)



script.register_looped(function()
    if FillArmourActive then
        RefillArmourNow()
        script.yield(ArmourLoopDelay)
    else
        script.yield(0)
    end        
end) 

script.register_looped(function()
    if isFastRespawnActive then
        -- Global_2673274.f_1762.f_756 = 2
        -- 2673274 + 1762 + 756 = 2675792
        globals.set_int(2675792, 2)
    end
    script.yield(0) -- 매 프레임 체크
end)



-- TESTING AREA
-- globals.set_int(2733138 + 5828, 1) - request RE Bandito

-- script.run_in_fiber(function()
--     local safe = globals.get_int(262145 + 23773)
--     local player = PLAYER.PLAYER_ID()

--     notification.show("Safe: " .. safe)
--     globals.set_int(262145 + 23773, 250000)
--     globals.set_int(1845299 + (player * 883) + 260 + 364 +5, 250000)
-- end)

