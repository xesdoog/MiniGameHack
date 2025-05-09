---@diagnostic disable: lowercase-global

-- MS Virtual Key Codes: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
local minigame_button = { code = 0x2E, name = "[DEL]" }

---@return string
local function GetBuildNumber()
    local pBnum = memory.scan_pattern("8B C3 33 D2 C6 44 24 20"):add(0x24):rip()
    return pBnum:get_string()
end

local function IsOnline()
    return network.is_session_started() and
    not script.is_active("maintransition")
end

local TARGET_BUILD  <const> = "3504"
local CURRENT_BUILD <const> = GetBuildNumber()
local WM_KEYUP      <const> = 0x0101
local WM_SYSKEYUP   <const> = 0x0105


local local_H3_hack_1   = 53089 -- (1.70 b3504) -- func_.....?\(&Local_53...?, &\(Local_5....?\[Local_3....?\[bLocal_3...? /\*293\*/\]\.f_27 /\*2\*/\]\), 0, joaat\("heist"\), Global_7.....?\.f_1\);
local local_H3_hack_2   = 54155 -- (1.70 b3504) -- func_.....?\(&Local_54...?, &\(Local_5....?\[Local_3....?\[bLocal_3...? /\*293\*/\]\.f_27 /\*2\*/\]\), 0, joaat\("heist"\), Global_7.....?\.f_1\);
local local_H3_hack_1_p = 2861 -- (1.70 b3504) -- func_....?\(&Local_2...?, &\(Local_....?\.f_729\), 4, -1, 0\);
local local_H3_hack_2_p = 3862 -- (1.70 b3504) -- func_....?\(&Local_3...?, &\(Local_....?\.f_729\), 4, -1, 0\);
local local_H4_hack     = 24986 -- (1.70 b3442) -- func_6160(&uLocal_24986, &uLocal_24977[func_395(epctParam1, 3) /*2*/], false, joaat("heist"), Global_786547.f_1);

---@param s script_util
local function minigame_hack(s)
    -- All casino fingerprints and keyboard access control
    if script.is_active("fm_mission_controller_2020") then
        locals.set_int("fm_mission_controller_2020", 9081 + 24, 7)     -- (1.70 b3504) // regex: if .*?\(?Local_.*?.f_280, 13\)\)
        locals.set_int("fm_mission_controller_2020", 1001 + 135, 3)    -- (1.70 b3504) Pass_Remote -- case 3: if .?!func_20\(&\(.?Local_1...?\.f_85\)\)\)
        locals.set_int("fm_mission_controller_2020", 29810, 6)         -- (1.70 b3504) -- Perico drainage port grille cutting -- `switch (iLocal_29810) { case 0: ... else { HUD::DISPLAY_HELP_TEXT_THIS_FRAME("UT_WELD_PROMPT", true); }`
        locals.set_float("fm_mission_controller_2020", 31049 + 3, 100) -- (1.70 b3504) Perico plasma cutting // regex: if \(NETWORK::NETWORK_DOES_NETWORK_ID_EXIST\(Local.*?.f_1\)
        locals.set_int("fm_mission_controller_2020", 1275, 2)          -- (1.70 b3504) Insurance office task (Bottom Dollar Bail Office Mission)  GRAPHICS::DRAW_SPRITE("MPHotwire", "failed" // regex: if \(.?Local_.*? != 4\)
        -- voltlab Complete immediately
        locals.set_int(
            "fm_mission_controller_2020", 1744,                                  -- (1.70 b3504) // regex: .?Local_.*? = Global_.*?.f_.*?.f_10; (regex + match whole word)
            locals.get_int("fm_mission_controller_2020", 1745)                   -- (1.70 b3504) -- Local_1744 +1 or regex search: if \(.?Local_.*? == .?Local_1744\)
        )                                                                        -- (1.70 b3504) -- voltlab The actual value and the target value are always consistent
        locals.set_int("fm_mission_controller_2020", 1746, 3)                    -- (1.70 b3504) Three lines have been connected -- Local_1745 +1 or regex search: if \(.?Local_.*? >= 2\)

        if locals.get_int("fm_mission_controller_2020", 31024) == 3 then         -- Perico password box -- (1.70 b3504) -- if \(.?Local_.*?.f_.*?\[.*?\] == .*?Local_.*? && .?Local_.*? > 0\)
            locals.set_int("fm_mission_controller_2020", 31025, 2)               -- Three sets of passwords have been entered -- (1.70 b3504) case 3:
            locals.set_float("fm_mission_controller_2020", 31025 + 1 + 1,
                locals.get_int("fm_mission_controller_2020", 31025 + 1 + 1 + 1)) -- (1.70 b3504) -- Make the password that has been input is the same as the goal
            locals.set_float("fm_mission_controller_2020", 31025 + 1 + 1 + 2,
                locals.get_int("fm_mission_controller_2020", 31025 + 1 + 1 + 1 + 2)) -- (1.70 b3504) -- Make the password that has been input is the same as the goal
            locals.set_float("fm_mission_controller_2020", 31025 + 1 + 1 + 4,
                locals.get_int("fm_mission_controller_2020", 31025 + 1 + 1 + 1 + 4)) -- (1.70 b3504) -- Make the password that has been input is the same as the goal
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 237, 1.0)                        -- Confirm Password
        end

        local_H4_hack_v = locals.get_int("fm_mission_controller_2020", local_H4_hack) -- Perico finger clone
        if (local_H4_hack_v & (1 << 0)) == 0 then
            local_H4_hack_v = local_H4_hack_v ~ (1 << 0)
            locals.set_int("fm_mission_controller_2020", local_H4_hack, local_H4_hack_v)
        end
    end

    if script.is_active("fm_mission_controller") then
        -- patch for WINIP -----
        locals.set_int("fm_mission_controller", 163, 0)          -- (1.70 3504) AUDIO::PLAY_SOUND_FRONTEND(uLocal_167[0], "HACKING_COUNTDOWN_IP_FIND", 0, true);
        locals.set_int("fm_mission_controller", 164, 0)          -- (1.70 3504) func_...?\("H_USE_PC8", -1\);
        locals.set_int("fm_mission_controller", 179, 7)          -- (1.70 3504) // regex: if \(.?Local_.*? == 5 \|\| .?Local_.*? == 6\)
        -------------------------
        locals.set_int("fm_mission_controller", 1292 + 135, 3)   -- (1.70 3504) case 3 Pass_Remote // regex: if \(\.?Local_.*?.f_135 != 5\)
        locals.set_int("fm_mission_controller", 11814 + 24, 7)   -- (1.70 3504) CIRC_COMP // regex: if \(!.*?\(.?Local_.*?.f_280, 25\)\)
        -- Automatic drilling
        locals.set_float("fm_mission_controller", 10105 + 11, 1) -- (1.70 b3504) Bank drilling  case 0: // regex: if \(.?Local_.*?.f_3 == -1\) // .?Local_.*?.f_3 = AUDIO::GET_SOUND_ID(); // if \(!ENTITY::IS_ENTITY_ATTACHED\(\S+\) && iLocal_\d+\.f_\d+ > 0\.08f\)
        locals.set_int("fm_mission_controller", 10145 + 2, 8)    -- (1.70 b3504) Casino vault door drilling DLC_HEIST3\HEIST_FINALE_LASER_DRILL case 8 // regex: else if \(.?Local_.*?\.f_7 == .*?Local_.*?\.f_37\)

        -- Casino fingerprint access control
        local_H3_hack_1_v = locals.get_int("fm_mission_controller", local_H3_hack_1)
        if (local_H3_hack_1_v & (1 << 0)) == 0 then
            local_H3_hack_1_v = local_H3_hack_1_v ~ (1 << 0)
            locals.set_int("fm_mission_controller", local_H3_hack_1, local_H3_hack_1_v)
        end
        local_H3_hack_2_v = locals.get_int("fm_mission_controller", local_H3_hack_2)
        if (local_H3_hack_2_v & (1 << 0)) == 0 then
            local_H3_hack_2_v = local_H3_hack_2_v ~ (1 << 0)
            locals.set_int("fm_mission_controller", local_H3_hack_2, local_H3_hack_2_v)
        end

        -- Casino double keycards
        locals.set_int("fm_mission_controller", 62381, 5) -- (1.70 b3504) AUDIO::PLAY_SOUND_FROM_ENTITY(-1, "Keycard_Fail", obParam0, "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", true, 10);

        -- Doomsday 1-Server Group (Heist2-Mission1-Prep3:SERVER FARM)  GRAPHICS::DRAW_SPRITE("MPHotwire", "failed"
        locals.set_int("fm_mission_controller", 1566, 2) -- (1.70 b3504) -- regex: AUDIO::SET_VARIABLE_ON_SOUND\(.?Local_....?, "Damage", .*?Local_....?\); switch \(.*?Local_....?\)
    end

    if script.is_active("am_mp_arc_cab_manager") then -- Casino fingerprint access control-exercise
        local_H3_hack_1_p_v = locals.get_int("am_mp_arc_cab_manager", local_H3_hack_1_p)
        if (local_H3_hack_1_p_v & (1 << 0)) == 0 then
            local_H3_hack_1_p_v = local_H3_hack_1_p_v ~ (1 << 0)
            locals.set_int("am_mp_arc_cab_manager", local_H3_hack_1_p, local_H3_hack_1_p_v)
        end
        local_H3_hack_2_p_v = locals.get_int("am_mp_arc_cab_manager", local_H3_hack_2_p)
        if (local_H3_hack_2_p_v & (1 << 0)) == 0 then
            local_H3_hack_2_p_v = local_H3_hack_2_p_v ~ (1 << 0)
            locals.set_int("am_mp_arc_cab_manager", local_H3_hack_2_p, local_H3_hack_2_p_v)
        end
    end

    -- all voltlab
    --[[
      if (.?Local_...? == .?Local_...?)
        {
          AUDIO::PLAY_SOUND_FRONTEND\(-1, "All_Connected_Correct", .*?Param1->f_...?, true\);
        }
    ]]
    if script.is_active("fm_content_island_heist") then
        locals.set_int("fm_content_island_heist", 787, locals.get_int("fm_content_island_heist", 788)) -- (1.70 b3504) // regex: AUDIO::PLAY_SOUND_FRONTEND\(-1, "All_Connected_Correct", .*?Param1->f_...?, true\); -- voltlab The actual value and the target value are always consistent
        locals.set_int("fm_content_island_heist", 789, 3) -- (1.70 b3504)  Three lines have been connected // regex: if \(func_.*?() && .*?Local_...? > 0\)
        locals.set_int("fm_content_island_heist", 10162 + 24, 7) -- (1.70 b3504) // regex: .?Local_1....?\.f_....? = .?Local_...?;
    end

    if script.is_active("fm_content_vehrob_prep") then
        locals.set_int("fm_content_vehrob_prep", 568, locals.get_int("fm_content_vehrob_prep", 569)) -- (1.70 b3504) //regex: AUDIO::PLAY_SOUND_FRONTEND\(-1, "All_Connected_Correct", .?Param1->f_...?, true\); -- voltlab The actual value and the target value are always consistent
        locals.set_int("fm_content_vehrob_prep", 570, 3) -- (1.70 b3504)  Three lines have been connected
        locals.set_int("fm_content_vehrob_prep", 9223 + 24, 7)  -- (1.70 b3504) // regex: .*?Local_....?\.f_....? = .*?Local_....?\.f_....?;
    end

    if script.is_active("am_mp_arc_cab_manager") then
        locals.set_int("am_mp_arc_cab_manager", 476, locals.get_int("am_mp_arc_cab_manager", 477)) -- (1.70 b3504) // regex: AUDIO::PLAY_SOUND_FRONTEND\(-1, "All_Connected_Correct", .*?Param1->f_...?, true\); -- voltlabThe actual value and the target value are always consistent
        locals.set_int("am_mp_arc_cab_manager", 478, 3)                                            -- (1.70 b3504)  Three lines have been connected
    end

    -- All collected data Evil the firewall cracking
    if script.is_active("fm_content_vehrob_casino_prize") then
        locals.set_int("fm_content_vehrob_casino_prize", 1066 + 135, 3) -- (1.70 b3504) case 3 Pass_Remote // regex: switch \(.?Local_....?\.f_135\)
    end

    if script.is_active("fm_content_business_battles") then
        locals.set_int("fm_content_business_battles", 4173 + 24, 7) -- (1.70 b3504) // regex: .?Local_....?\.f_...? = .?Local_....?\.f_...?;
    end

    --mp2024_02 DLC mission1_The_Black_Box_File
    if script.is_active("am_mp_hotwire") then
        locals.set_int("am_mp_hotwire", 298, 2) --(1.70 b3504) GRAPHICS::DRAW_SPRITE("MPHotwire", "failed"
    end

    --mp2024_02 DLC mission2_The_Brute_Force_File (also for mission4_The_Project_Breakaway_File_final)
    if script.is_active("word_hack") then
        locals.set_int("word_hack", 49 + 53, 5) --(1.70 b3504) // MISC::NETWORK_SET_SCRIPT_IS_SAFE_FOR_NETWORK_GAME(); // "MPWordHack_Sprites", "WM_Popup_Complete"  --func_1(&uScriptParam_0, &Global_1981119, &iLocal_49, &uLocal_106); &iLocal_49 - switch (iParam1->f_53) - case 5
    end

    --mp2024_02 DLC mission3_The_Fine_Art_File
    if script.is_active("circuitblockhack") then
        locals.set_int("circuitblockhack", 49 + 9, 2) --(1.70 b3504) AUDIO::PLAY_SOUND_FRONTEND(-1, "Success", "DLC_24-2_Hack_Circuit_Board", true);
    end
    if script.is_active("fm_content_hacker_house_finale") then --fingerprint clone
        locals.set_int("fm_content_hacker_house_finale", 5951 + 1, 5) --(1.70 b3504) func_8654(uParam0, iParam1, 0, joaat("practice"), func_447(9572, -1)); --func_8663(iParam1, uParam0, 8000, "FingerPrint_Success"); // Local_....?\.f_1011\[.*?Param0 /\*5\*/\]\.f_1 = func_....?\(&\(.*?Local_....?\.f_1011\[.*?Param0 /\*5\*/\]\.f_3\), 0, 0\);
    end

    --mp2024_02 DLC mission4_The_Project_Breakaway_File
    local_mp2024_02_m4 = 5097 -- (1.70 b3504) -- func_9013(&Local_5097, 5, 5, 10, 10, 8, 10, 0, 0, 0, 1, 1, 0, 0, 60000, 1, 1, 0, 0, bVar0, -1); --HUD::HIDE_SCRIPTED_HUD_COMPONENT_THIS_FRAME(19); --AUDIO::PLAY_SOUND_FRONTEND(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true);
    local_mp2024_02_m4_v = locals.get_int("fm_content_hacker_whistle_prep", local_mp2024_02_m4)
    if (local_mp2024_02_m4_v & (1 << 26)) == 0 then
        local_mp2024_02_m4_v = local_mp2024_02_m4_v ~ (1 << 26)
        locals.set_int("fm_content_hacker_whistle_prep", local_mp2024_02_m4, local_mp2024_02_m4_v)
    end

    -- int* iParam0, int iParam1, int iParam2, int iParam3, int iParam4, var uParam5, var uParam6, int iParam7, bool bParam8, bool bParam9, bool bParam10, bool bParam11, bool bParam12, bool bParam13, int iParam14, int iParam15, bool bParam16, bool bParam17, bool bParam18, bool bParam19, bool bParam20, bool bParam21
    local minigamelocaltable = {
        [1]  = { script_name = "agency_heist3b",                 minigame_local = 6210 },     -- (1.70 b3504) -- case 4: if (CUTSCENE::CAN_SET_EXIT_STATE_FOR_REGISTERED_ENTITY("Michael", 0)) -- func_809(&Local_6210, 5, 5, 50, 10, 8, 0, 0, 0, 0, 1, 1, 0, 0, 60000, 0, 1, 0, 0, 0, -1);
        [2]  = { script_name = "business_battles_sell",          minigame_local = 452 },      -- (1.70 b3504) -- case 1: if \(func_....?\(.*?\) && HUD::HAS_ADDITIONAL_TEXT_LOADED\(3\)\)
        [3]  = { script_name = "fm_content_business_battles",    minigame_local = 4173 },     -- (1.70 b3504) -- .?Local_....?\.f_...? = .?Local_....?\.f_...?;
        [4]  = { script_name = "fm_content_island_heist",        minigame_local = 10162 },    -- (1.70 b3504) -- .?Local_1....?\.f_....? = .?Local_...?;
        [5]  = { script_name = "fm_content_vehrob_casino_prize", minigame_local = 7774 + 2 }, -- (1.70 b3504) -- .?Local_....?\.f_...? = .?Local_....?\.f_...?; switch \(.?Local_....?\.f_....?\.f_.?\[.?Param0 /\*32\*/\]\.f_..?\)
        [6]  = { script_name = "fm_content_vehrob_police",       minigame_local = 7667 },     -- (1.70 b3504) -- .?Local_....?\.f_...? = .?Local_....?\.f_...?; switch \(.?Local_....?\.f_....?\.f_.?\[.?Param0 /\*32\*/\]\.f_..?\)
        [7]  = { script_name = "fm_content_vehrob_prep",         minigame_local = 9223 },     -- (1.70 b3504) -- .?Local_....?\.f_...? = .?Local_....?\.f_...?; switch \(.?Local_....?\.f_....?\.f_.?\[.?Param0 /\*32\*/\]\.f_..?\)
        [8]  = { script_name = "fm_content_vip_contract_1",      minigame_local = 7408 },     -- (1.70 b3504) -- .?Local_....?\.f_...? = .?Local_....?\.f_...?; switch \(.?Local_....?\.f_....?\.f_.?\[.?Param0 /\*32\*/\]\.f_..?\)
        [9]  = { script_name = "fm_mission_controller_2020",     minigame_local = 29027 },    -- (1.70 b3504) -- if \(!.*?\(.?Local_.*?, 1\) && !.*?\(.?Local_.....?\.f_1, 1\)\)
        [10] = { script_name = "fm_mission_controller",          minigame_local = 9811 },     -- (1.70 b3504) -- func_.....?\(&.?Local_9...?, .*?, 1, .*?\);
        [11] = { script_name = "gb_cashing_out",                 minigame_local = 422 },      -- (1.70 b3504) -- if \(func_....?\(.*?\) && HUD::HAS_ADDITIONAL_TEXT_LOADED\(3\)\)
        [12] = { script_name = "gb_gunrunning_defend",           minigame_local = 2282 },     -- (1.70 b3504) -- if \(func_....?\(.*?\) && HUD::HAS_ADDITIONAL_TEXT_LOADED\(3\)\)
        [13] = { script_name = "gb_sightseer",                   minigame_local = 462 },      -- (1.70 b3504) -- if \(func_....?\(.*?\) && HUD::HAS_ADDITIONAL_TEXT_LOADED\(3\)\)
    }
    --[12]  = {script_name = "gb_casino_heist", minigame_local = }, --Global_2737317
    --[12]  = {script_name = "gb_casino", minigame_local = }, --Global_2737317
    --[12]  = {script_name = "gb_gangops", minigame_local = }, --Global_2737317
    --[12]  = {script_name = "gb_gunrunning", minigame_local = }, --Global_2737317
    --[12]  = {script_name = "gb_infiltration", minigame_local = }, --Global_2737317
    --[12]  = {script_name = "gb_smuggler", minigame_local = }, --Global_2737317
    --[0]  = {script_name = "business_battles", minigame_local = }, --Global_2737317

    for i = 1, 13 do
        if script.is_active(minigamelocaltable[i].script_name) then
            minigame_tmp_v = locals.get_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local) -- WINBRUTE
            if (minigame_tmp_v & (1 << 9)) == 0 then
                minigame_tmp_v = minigame_tmp_v ~ (1 << 9)
                locals.set_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local, minigame_tmp_v)
            end
        end

        if script.is_active(minigamelocaltable[i].script_name) then
            minigame_tmp_v = locals.get_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local) -- WINIP
            if (minigame_tmp_v & (1 << 18)) == 0 then
                minigame_tmp_v = minigame_tmp_v ~ (1 << 18)
                locals.set_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local, minigame_tmp_v)
            end
        end

        if script.is_active(minigamelocaltable[i].script_name) then
            minigame_tmp_v = locals.get_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local) -- Biolab 条形上下浮动对准中间 的小游戏 -- "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"
            if (minigame_tmp_v & (1 << 26)) == 0 then
                minigame_tmp_v = minigame_tmp_v ~ (1 << 26)
                locals.set_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local, minigame_tmp_v)
            end
        end

        if script.is_active(minigamelocaltable[i].script_name) then
            minigame_tmp_v = locals.get_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local) -- Biolab 条形上下浮动对准中间 的小游戏 -- "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"
            if (minigame_tmp_v & (1 << 28)) == 0 then
                minigame_tmp_v = minigame_tmp_v ~ (1 << 28)
                locals.set_int(minigamelocaltable[i].script_name, minigamelocaltable[i].minigame_local, minigame_tmp_v)
            end
        end
    end

    local minigame_tmp_v2 = globals.get_int(2738536) -- (1.70 b3504) -- gb_casino_heist func.*?\(&Global_27.....?, "BBHACK_YET".*?\);

    if (minigame_tmp_v2 & (1 << 9)) == 0 then
        minigame_tmp_v2 = minigame_tmp_v2 ~ (1 << 9)
    end

    if (minigame_tmp_v2 & (1 << 18)) == 0 then
        minigame_tmp_v2 = minigame_tmp_v2 ~ (1 << 18)
    end

    if (minigame_tmp_v2 & (1 << 26)) == 0 then
        minigame_tmp_v2 = minigame_tmp_v2 ~ (1 << 26)
    end

    globals.set_int(2738536, minigame_tmp_v2)

    -- Stash house safe
    -- Credits: ShinyWasabi's Daily Collectibles https://github.com/YimMenu-Lua/DailyCollectibles
    if script.is_active("fm_content_stash_house") then
        for i = 0, 2 do
            local safe_code = locals.get_int("fm_content_stash_house", 140 + 22 + (1 + (i * 2)) + 1) -- (1.70 b3504) -- iLocal_\d+\.f_\d+\[func_\d+\(\) /\*2\*/\] = iLocal_\d+\.f_\d+\[func_\d+\(\) /\*2\*/\] \+ .?Param.?;  -- if \(.?Local_...?\.f_48 && func_....?\(&\(.?Local_...?\.f_50\), 2000, .*?\)\)
            locals.set_float("fm_content_stash_house", 140 + 22 + (1 + (i * 2)), safe_code)
        end

        s:sleep(250)
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 235, 1.0)
        s:sleep(250)
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 235, 1.0)
        s:sleep(250)
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 237, 1.0)
    end
end

gui.get_tab("GUI_TAB_NETWORK"):add_imgui(function()
    ImGui.Spacing()
    ImGui.SeparatorText("Minigame Hack")

    if CURRENT_BUILD ~= TARGET_BUILD then
        ImGui.Text("Minigame Hack is outdated.")
        return
    end

    if not IsOnline() then
        ImGui.Text("Unavailable in single player.")
        return
    end

    if ImGui.Button("Instant Hack") then
        script.run_in_fiber(function(mgh)
            minigame_hack(mgh)
        end)
    end

    if ImGui.IsItemHovered() then
        ImGui.SetTooltip(
            string.format(
                "TIP: You can also press %s to use Minigame Hack without opening the menu.",
                minigame_button.name
            )
        )
    end
end)

if CURRENT_BUILD == TARGET_BUILD then
    event.register_handler(menu_event.Wndproc, function(_, msg, wParam, _)
        if (msg == WM_KEYUP) or (msg == WM_SYSKEYUP) then
            if (wParam == minigame_button.code) then
                script.run_in_fiber(function(mgh)
                    minigame_hack(mgh)
                end)
            end
        end
    end)
end
