FIRST_MAP_WITH_POTATO_GUN <- ""

::srm <- {}

mapName <- GetMapName().slice(6)
advanced <- GetMapName().slice(0,2) == "sp"

srm.log <- function (...) {
    for (local i = 0; i< vargc; i++) {
		printl(vargv[i] + (vargc > 1 ? "\t" : ""));
	}
}

srm.transitionTrigger <- function (trigger, map) {
    EntFireByHandle(trigger, "AddOutput", "OnStartTouch end_command:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + map+"\"):1:1", 0, null, null)
    EntFireByHandle(trigger, "AddOutput", "OnStartTouch end_fade:Fade::0:1", 0, null, null)
}
srm.transitionTrigger2 <- function (trigger, map) {
    EntFireByHandle(trigger, "AddOutput", "OnStartTouch end_command:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + map+"\"):2:1", 0, null, null)
}

srm.mapspawn <- function () {
    switch (mapName) {
        // CHAPTER 1
        case "tramride":
            srmFog()
            local auto = Entities.FindByClassnameNearest("logic_auto", Vector(-6096, -6152, -112), 10)
            EntFireByHandle(auto, "disable", "", 0, null, null)
            EntFire("StartFade", "FadeReverse", "")
            EntFire("StartFade", "kill", "")
            EntFire("mel_logo", "kill")
            EntFire("mel_logo_camera_mover", "kill")
            EntFire("Intro_Viewcontroller", "disable", "", 3)                           // fuck??
            EntFire("Mel_Logo_Sound", "kill", "")
            EntFire("StartFade2", "kill", "")
            EntFire("StartFade", "FadeReverse", "", 2)
            EntFire("Subway_TankTrain", "StartForward", "", 0.6)
            EntFire("chapter_subtitle_text", "Display", "", 3)
            EntFire("chapter_title_text", "Display", "", 3)
            EntFire("chapter_subtitle_text", "kill", "", 4)
            EntFire("chapter_title_text", "kill", "", 4)

            EntFire("lonewolf_loves_speedrunners_sound", "kill")
            EntFire("math_7", "add", "100")
            EntFire("thats_numberwang", "add", "100")
            EntFire("speedrun_go", "use", "")
            EntFire("speedmod", "modifyspeed", "1", 1)

            local endTrigger = Entities.FindByName(null, "lonewolf_is_kind")
            srm.transitionTrigger(endTrigger, "a1_mel_intro")
            break

        case "mel_intro":
            srmFog()
            EntFire("autoinstance1-tram_subway_model", "setplaybackrate", 100, 0.2)
            EntFire("lift_door", "kill") // couldnt change speed for some reason
            EntFire("lift_gate_1", "setspeed", 350, 1)

            EntFire("l_e_gl_door", "setspeed", 350)
            EntFire("l_e_gr_door", "setspeed", 350)
            EntFire("Lobby_Right_Door_Left_Move", "setspeed", 200)
            EntFire("Lobby_Right_Door_Right_Move", "setspeed", 200)
            EntFire("Sitting_Room_Door_Right_Move", "setspeed", 200)
            EntFire("Sitting_Room_Door_Left_Move", "setspeed", 200)

            local endTrigger = Entities.FindByClassnameNearest("trigger_once", Vector(404, 4723.01, 12361.5), 10)
            srm.transitionTrigger(endTrigger, "a1_garden")
            break

        case "garden":
            srmFog()
            EntFire("lift_door", "kill")
            EntFire("autoinstance1-l_e_gr_door", "open", 0, 0.2)
            EntFire("autoinstance1-l_e_gl_door", "open", 0, 0.2)
            EntFire("autoinstance1-l_e_gr_door", "setspeed", 450, 0.3)
            EntFire("autoinstance1-l_e_gl_door", "setspeed", 450, 0.3)
            EntFire("autoinstance1-intro_huge_door_right", "open", 0, 0.2)
            EntFire("autoinstance1-intro_huge_door_left", "open", 0, 0.2)

            // destroy open door trigger
            local doorTrig = Entities.FindByClassnameNearest("trigger_multiple", Vector(2208, 1664, 96), 10)
            EntFireByHandle(doorTrig, "Kill", "", 0, null, null)

            // MOORDOOR
            EntFire("sleepy_lobby_door", "SetAnimation", "open", 0.3)
            EntFire("door_button", "Press")
            EntFire("sleep_lab_real_door", "SetAnimation", "open", 0.3)

            EntFire("sleep_button", "unlock", 0, 1)
            EntFire("open_bed_rl", "trigger", 0, 1)

            EntFire("sleep_button", "AddOutput", "OnPressed end_command:Command:stopvideos:0.03:1")
            break

        // CHAPTER 2
        case "garden_de":
            FastOldApertureTransition(null, 2, "a2_underbounce")
            srmFog()

            EntFire("bedroom_button", "unlock")
            EntFire("bedroom_button", "press")

            // remove pgun anim
            EntFire("relay_melgun", "kill")

            // giving the portal gun and killing wooden door
            EntFire("pickup_scene", "AddOutput", "OnPressed relay_melgun:Kill:give_portalgun:0:1")
            // EntFire("pickup_scene", "AddOutput", "OnPressed door_brush:Kill::0:1")
            // EntFire("pickup_scene", "AddOutput", "OnPressed pg_wood_blocker:TurnOff::0:1")
            EntFire("pickup_scene", "AddOutput", "OnPressed end_command:Command:give_portalgun:0:1")
            EntFire("pickup_scene", "AddOutput", "OnPressed end_command:Command:upgrade_portalgun:0.1:1")

            // killing the doors from the start
            EntFire("pg_wood_blocker", "TurnOff")
            EntFire("door_brush", "kill")

            // teleporting player. Not used.
            // EntFire("pickup_scene", "AddOutput", "OnPressed end_command:Command:script_execute meltele:0:1")

            // OPTIMUS DOOR
            EntFire("func_button", "Press") // this is also the cause of the load crash at the start of the map.
                                            // It's pressing the last door button so it makes the beam fall.

            // remove automatic door trigger in lobby and automatically open it on map load
            local removeTrig = Entities.FindByClassnameNearest("trigger_multiple", Vector(1744, 2460, 96), 10)
            EntFireByHandle(removeTrig, "kill", "", 0, null, null)
            EntFire("lower_office_door", "SetAnimation", "open")

            // beeg door
            EntFire("vault_manager", "AddOutput", "OnChangeToAllTrue vault_door:setplaybackrate:50:0.3:-1")
            break

        case "underbounce":
            underbounceTeleport()
            srmFog()

            FastOldApertureTransition(1, 13, "a2_once_upon")

            // kill the stupid ass lights
            local stupidLights = Entities.FindByName("logic_relay", "Power_On_Start_Relay")
            EntFireByHandle(stupidLights, "kill", "", 0, null, null)

            break

        case "once_upon":
            FastOldApertureTransition(-1, -1, "a2_past_power")
            srmFog()

            local startTrig = Entities.FindByClassnameNearest("trigger_once", Vector(3072, -1200, 1900), 10)

            EntFireByHandle(startTrig, "AddOutput", "OnStartTouch entry_door-door_prop:setplaybackrate:3:0.1:-1", 0, null, null)

            break

        case "past_power":
            FastOldApertureTransitionPASTPOWER(-1, -1, "a2_ramp")
            srmFog()

            local startTrig = Entities.FindByClassnameNearest("trigger_once", Vector(1136, 272, 239), 10)
            EntFireByHandle(startTrig, "AddOutput", "OnStartTouch room_1_door_0-door_prop:setplaybackrate:4:0.1:-1", 0, null, null)

            EntFire("func_button", "press")
            EntFire("sd1_door", "setanimation", "open")
            EntFire("gel_door", "AddOutput", "OnOpen walkway_door1:Open:0:-1")
            EntFire("gel_door", "AddOutput", "OnOpen walkway_door2:Open:0:-1")

            // fast gel
            EntFire("orange_gel_door", "AddOutput", "OnOpen gel_1:start::0:1")

            local gelDoor = Entities.FindByClassnameNearest("trigger_multiple", Vector(-2048, -528, -128), 10)
            EntFireByHandle(gelDoor, "kill", "", 0.1, null, null)
            EntFire("orange_pump_station_door_1-open", "trigger")
            EntFire("orange_pump_station_door_1ap", "open")

            break

        case "ramp":
            FastOldApertureTransition(-1, -1, "a2_firestorm")
            srmFog()

            break

        case "firestorm":
            FastOldApertureTransition(15, null, "a2_firestorm")
            srmFog()

            EntFire("r1_gate_1", "kill")

            // STUPID TRIGGER PUSH WHY THE FUCK DO YOU EXIST!!!!!
            EntFire("intro_push", "Kill")

            EntFire("lower_lift_button", "unlock", 0, 0.2)
            EntFire("lower_lift_button", "press", 0, 0.3)
            EntFire("main_elevator", "setmaxspeed", 300, 0.4)
            EntFire("main_elevator", "setspeed", 300, 0.5)

            EntFire("main_elevator_up_relay", "AddOutput", "OnTrigger main_elevator:SetMaxSpeed:300:0.1:1")
            EntFire("main_elevator_up_relay", "AddOutput", "OnTrigger main_elevator:SetSpeed:300:0.1:1")

            EntFire("AutoInstance1-sd1_door2", "SetAnimation", "open")
            EntFire("intro_door_trigger", "kill")
            EntFire("intro_ap", "open")
            local door1Trig = Entities.FindByClassnameNearest("trigger_multiple", Vector(0, 184, 320), 10)
            EntFireByHandle(door1Trig, "kill", "", 0, null, null)
            EntFire("office_1_door_1", "SetAnimation", "open")

            local firstAPTrig = Entities.FindByClassnameNearest("trigger_multiple", Vector(0, 104, 320), 10)
            EntFireByHandle(firstAPTrig, "AddOutput", "OnStartTouch AutoInstance1-sd1_door2:setanimation:close:0:1", 0, null, null)

            // cutscene with the smoke and fire and smoke
            EntFire("AutoInstance1-sd1_door", "SetAnimation", "open")
            local door2Trig = Entities.FindByClassnameNearest("trigger_multiple", Vector(-96, 968, 320), 10)
            EntFireByHandle(door2Trig, "kill", "", 0, null, null)

            // all of the fire shit
            EntFire("o1_det_counter", "AddOutput", "OnAllTrue o1_door_fire:stop::0:1")
            EntFire("o1_det_counter", "AddOutput", "OnAllTrue o1_fire_light:turnoff::0:1")
            EntFire("o1_det_counter", "AddOutput", "OnAllTrue o1_door_1-open:trigger::0.2:1")
            EntFire("o1_det_counter", "AddOutput", "OnAllTrue wc_door_1-door_move_up:open::1.2:1")
            EntFire("o1_det_counter", "AddOutput", "OnAllTrue wc_door_1-door_move_down:open::1.2:1")

            // after the fire cutscene
            EntFire("Offices_2_Door_1", "SetAnimation", "open")
            local door3Trig = Entities.FindByClassnameNearest("trigger_multiple", Vector(1408, 1816, 320), 10)
            EntFireByHandle(door3Trig, "kill", "", 0, null, null)
            EntFire("AutoInstance1-lever_hinge", "AddOutput", "OnFullyOpen AutoInstance1-sd1_door1:setplaybackrate:30:0.01:-1")

            // open pump control doors faster
            EntFire("Pre_Pump_Control_Room_Activate", "AddOutput", "OnTrigger Pre_Pump_Control_Room_Door_Trigger:Enable:0:-1")
            local pumpDoorTrig = Entities.FindByClassnameNearest("trigger_multiple", Vector(3376, 2504, 312), 10)
            EntFireByHandle(pumpDoorTrig, "AddOutput", "OnStartTouch pre_pump_control_room_left_door:setplaybackrate:50:0.01:-1", 0, null, null)
            EntFireByHandle(pumpDoorTrig, "AddOutput", "OnEndTouch pre_pump_control_room_left_door:setplaybackrate:50:0.01:-1", 0, null, null)

            // big door time yayayyyayayayayayy vault_exit_relay
            local beginningTrig = Entities.FindByClassnameNearest("trigger_once", Vector(5192, 2160, 448), 10)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch vault_exit_relay:trigger::0:1", 0, null, null)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch vault_door:setplaybackrate:20:0.1:1", 0, null, null)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch vault_exit_lift_down_relay:kill::0:1", 0, null, null)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch pumproom_lift_tracktrain:startforward::0:1", 0, null, null)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch pumproom_lift_tracktrain:setmaxspeed:200:0.11:1", 0, null, null)
            EntFireByHandle(beginningTrig, "AddOutput", "OnStartTouch pumproom_lift_tracktrain:setspeed:200:0.2:1", 0, null, null)
            EntFire("pumproom_lift_rope1", "SetParent", "pumproom_lift_rotate")
            EntFire("pumproom_lift_rope2", "SetParent", "pumproom_lift_rotate")
            EntFire("pumproom_lift_rope3", "SetParent", "pumproom_lift_rotate")
            EntFire("pumproom_lift_rope4", "SetParent", "pumproom_lift_rotate")

            // ending trigger
            local endTrig = Entities.FindByClassnameNearest("trigger_once", Vector(4976, 2160, 2497.13), 10)
            EntFireByHandle(endTrig, "AddOutput", "OnStartTouch end_fade:Fade::0:1", 0, null, null)
            srm.transitionTrigger2(endTrig, "a3_junkyard")
            EntFireByHandle(endTrig, "AddOutput", "OnStartTouch end_command:Command:disconnect:2.5:1", 0, null, null)

            // open all of ne noors
            local buttonDoor1 = Entities.FindByClassnameNearest("func_button", Vector(1164, 1392, 308), 10)
            EntFireByHandle(buttonDoor1, "press", "", 0, null, null)
            local buttonDoor2 = Entities.FindByClassnameNearest("func_button", Vector(4712, 2160, 312.5), 10)
            EntFireByHandle(buttonDoor2, "press", "", 0, null, null)
            EntFire("vault_exit_door", "setanimation", "vert_door_slow_opening", 0.3)
            local lastTrig = Entities.FindByClassnameNearest("trigger_once", Vector(5212, 2140, 2497.13), 10)
            EntFireByHandle(lastTrig, "kill", "", 0.3, null, null)

            break

        case "junkyard":
            srmFog()

            // beginning door button to open door (crazy)
            EntFire("func_button", "Press")
            // open ne noor faster
            EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.3)
            EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.5) // Just in case (I don't know why this is also here in srm lmao)

            EntFire("junkyard_entrance_prop", "setplaybackrate", 300)
            EntFire("junkyard_entrance_prop", "SetAnimation", "vert_door_opening")
            EntFire("junkyard_entrance_ap", "open")

            // main door trigger kill cuz we do that at the start of tha map spawn
            local mainDoorTrig = Entities.FindByClassnameNearest("trigger_once", Vector(432, -352, 112), 10)
            EntFireByHandle(mainDoorTrig, "Kill", "", 0, null, null)

            // my favourite activity is killing doors YEP
            EntFire("corridor_slidy_door", "Kill", 0, 1)
            EntFire("upper_door_4", "Kill", 0, 1)
            EntFire("AutoInstance1-door_model1", "Kill", 0, 1)

            // ending ele
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:startforward")
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:teleporttopathnode:lift_track_2:0:1")
            local eleTrig = Entities.FindByClassnameNearest("trigger_once", Vector(20, 768, 48), 10)
            EntFireByHandle(eleTrig, "AddOutput", "OnStartTouch end_fade:Fade::1.5:-1", 0, null, null)
            srm.transitionTrigger2(eleTrig, "a3_concepts")
            EntFireByHandle(eleTrig, "AddOutput", "OnStartTouch end_command:Command:disconnect:3:-1", 0, null, null)
            break

        case "concepts":
          srmFog()
          EntFire("env_fog_controller", "SetEndDist", "3000")

          // FUCKING STUPID START ELEVATOR!!!! DO NOT TOUCH!!!!!!! (IT SUCKS)
          local startEle = Entities.FindByClassnameNearest("func_tracktrain", Vector(-192, 352, -1552), 10)
          local OMGPLAYER = Entities.FindByClassnameNearest("player", Vector(0, 0, 0), 10000)
          EntFireByHandle(OMGPLAYER, "setlocalorigin", "581 352 -500", 0.25, null, null)
          startEle.SetOrigin(Vector(581, 352, -450))
          EntFire("autoinstance1-elevator_1_top_path_4", "setlocalorigin", "581 352 -450")
          EntFire("autoinstance1-elevator_1_top_path_2", "setlocalorigin", "581 352 -450")
          EntFire("autoinstance1-elevator_1_top_path_1", "setlocalorigin", "581 352 -450")
          EntFire("autoinstance1-elevator_1_top_path_3", "setlocalorigin", "581 352 -450")
          EntFire("autoinstance1-elevator_1_top_path_1", "AddOutput", "OnPass autoinstance1-elevator_1:startforward::0.03:1")
          EntFire("autoinstance1-elevator_1_top_path_3", "AddOutput", "OnPass autoinstance1-elevator_1:startforward::0.03:1")
          EntFire("autoinstance1-elevator_1_top_path_2", "AddOutput", "OnPass autoinstance1-elevator_1:startforward::0.03:1")
          EntFire("autoinstance1-elevator_1_top_path_4", "AddOutput", "OnPass autoinstance1-elevator_1:startforward::0.03:1")
          EntFire("autoinstance1-elevator_1_top_path_3", "AddOutput", "OnPass autoinstance1-elevator_1:setmaxspeed:300:0.1:1")
          EntFire("autoinstance1-elevator_1_top_path_3", "AddOutput", "OnPass autoinstance1-elevator_1:setspeed:300:0.103:1")

          // chamber
          EntFire("@entry_door", "open", "", 3)

          // doors
          EntFire("test_2_door", "open")
          EntFire("exit_door", "open")
          EntFire("test_2_door_araeportal", "open")

          // add a fade for the start
          EntFire("end_command", "Command", "ent_fire end_fade fadereverse")
          EntFire("end_command", "Command", "fadein", 0.3)

          // ending ele
          local endEleTrig = Entities.FindByClassnameNearest("trigger_once", Vector(1632, 248, 64), 10)
          EntFireByHandle(endEleTrig, "kill", "", 0, null, null)
          EntFire("InstanceAuto9-close", "AddOutput", "OnTrigger !self:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + "a3_paint_fling"+"\"):2.5:1")
          EntFire("InstanceAuto9-close", "AddOutput", "OnTrigger end_fade:Fade::0:1")
          EntFire("InstanceAuto9-logic_source_elevator_door_open", "trigger")
          break

        case "paint_fling":
          srmFog()
          FastNewApertureTransitions(52, 34)
          EntFire("env_fog_controller", "SetEndDist", "3000")

          EntFire("Entrance_Door", "open", "", 3)
          local betweenChambersTrig = Entities.FindByClassnameNearest("trigger_once", Vector(-664, 832.01, 256), 10)
          EntFireByHandle(betweenChambersTrig, "AddOutput", "OnStartTouch Entry_door_2:open::0:1", 0, null, null)

          break

        case "faith_plate":
          FastNewApertureTransitions(53, 2)
          srmFog()
          EntFire("env_fog_controller", "SetEndDist", "5000")

          EntFire("Entry_Door", "open", "", 3)
          EntFire("entry_door_areaportal", "open", "", 3)
          EntFire("cooridor_1_floor_panels_open_relay", "trigger")
          EntFire("cooridor_1_floor_panels_open_relay", "kill", 0.3)
          EntFire("BTS_1_Vert_Door_1", "setanimation", "vert_door_opening")
          EntFire("BTS_1_Vert_Door_2", "setanimation", "vert_door_opening")
          local trig1 = Entities.FindByClassnameNearest("trigger_once", Vector(736, 3904, 148), 10)
          EntFireByHandle(trig1, "kill", "", 0, null, null)
          local trig2 = Entities.FindByClassnameNearest("trigger_once", Vector(736, 4296, 192) 10)
          EntFireByHandle(trig2, "AddOutput", "OnStartTouch bts_1_areaportal:open::0:1", 0, null, null)
          local trig3 = Entities.FindByClassnameNearest("trigger_once", Vector(752, 4576, 200), 10)
          EntFireByHandle(trig3, "kill", "", 0, null, null)
          EntFire("let_virgil_help_rl", "trigger")

          // ending ele
          EntFire("cs_virgil_126", "kill")
          EntFire("AutoInstance2-logic_source_elevator_door_open", "trigger")
          EntFire("autoinstance2-close", "AddOutput", "OnTrigger end_fade:Fade::1.2:1")
          EntFire("autoinstance2-close", "AddOutput", "OnTrigger end_command:Command:disconnect:4:1")
          EntFire("autoinstance2-close", "AddOutput", "OnTrigger end_command:Command:changelevel "+ (advanced ? "sp_" : "st_") + "a3_transition:3:1")

          break

        case "transition":
          FastNewApertureTransitions(40, 28)
          srmFog()

          EntFire("@entry_door", "open", "", 3)
          local trig1 = Entities.FindByClassnameNearest("trigger_multiple", Vector(664, -3072, 448), 10)
          EntFireByHandle(trig1, "kill", "", 0, null, null)
          EntFire("obroom_door", "setanimation", "open")
          // enable the observatory room portal placement helper (not in use)
          // EntFire("obs_room_helper", "enable")
          EntFire("tc_entry_door", "open")

          EntFire("doorzed-door_move_up", "setspeed", "500")
          EntFire("doorzed-door_move_down", "setspeed", "500")

          local door1 = Entities.FindByClassnameNearest("func_button", Vector(3200, 110, 504), 10)
          EntFireByHandle(door1, "press", "", 0, null, null)
          EntFire("bts_bipart_door_2-door_move_up", "setspeed", "500")
          EntFire("bts_bipart_door_2-door_move_down ", "setspeed", "500")
          EntFire("breaker_lever", "AddOutput", "OnPressed oa_entry_darkness:disable::0:1")
          EntFire("oa_glare", "kill")

          break

        case "overgrown":
          FastNewApertureTransitions(-1, 39)
          srmFog()

          // starting cutscene (likely equally as bad as concepts)
          local player = Entities.FindByClassnameNearest("player", Vector(0, 0, 0), 10000)
          EntFire("intro_elevator_train", "setlocalorigin", "-1211 -3296 -400")
          EntFireByHandle(player, "setlocalorigin", "-1211 -3296 -460", 0.1, null, null)
          local deathTrig = Entities.FindByClassnameNearest("trigger_hurt", Vector(-904, -3232, -264), 10)
          EntFireByHandle(deathTrig, "disable", "", 0, null, null)
          EntFireByHandle(deathTrig, "enable", "", 4, null, null)
          EntFire("top_path_1", "setlocalorigin", "-1211 -3296 -400")
          EntFire("top_path_2", "setlocalorigin", "-1211 -3296 -400")
          EntFire("top_path_3", "setlocalorigin", "-1211 -3296 -400")
          EntFire("top_path_4", "setlocalorigin", "-1211 -3296 -400")
          EntFire("top_path_4", "AddOutput", "OnPass intro_elevator_train:setmaxspeed:350:0.2:1")
          EntFire("top_path_4", "AddOutput", "OnPass intro_elevator_train:setspeed:350:0.3:1")
          EntFire("top_path_7", "setlocalorigin", "-1211 -3296 -400")
          EntFire("top_path_5", "setlocalorigin", "-1211 -3296 0")
          EntFire("top_path_5", "AddOutput", "OnPass intro_elevator:setanimation:dooropen:0.2:1")
          player.SetOrigin(Vector(-1211, -3296, -400 - 50))

          // Fade for the start cuz its shit
          EntFire("end_command", "Command", "ent_fire end_fade fadereverse")
          EntFire("end_command", "Command", "fadein", 0.3)

          // doing this stupid ahh trigger on map load
          local startTrig = Entities.FindByClassnameNearest("trigger_once", Vector(-576, -2898, -65.13), 10)
          EntFireByHandle(startTrig, "kill", "", 0, null, null)
          EntFire("intro_vert_door", "setanimation", "vert_door_opening")
          EntFire("intro_ap", "open")
          EntFire("skylight_1", "turnon")
          EntFire("office_ap", "open")
          EntFire("intro_light_flicker_timer", "Enable")
          EntFire("office_steam_noise", "playsound")
          EntFire("office_steam", "start")

          // office
          local door1 = Entities.FindByClassnameNearest("func_button", Vector(-350, -2228, 56), 10)
          EntFireByHandle(door1, "press", "", 0, null, null)
          local trig1 = Entities.FindByClassnameNearest("trigger_multiple", Vector(-352, -1816, 64), 10)
          EntFireByHandle(trig1, "kill", "", 0, null, null)
          EntFire("AutoInstance1-sd1_door1", "setanimation", "open")
          EntFire("block_button", "enablemotion")
          EntFire("office_button", "unlock")
          EntFire("office_button", "AddOutput", "OnPressed office_escape_door:setplaybackrate:300:0.03:1")
          local trig2 = Entities.FindByClassnameNearest("trigger_once", Vector(336, -1424, 63.99), 10)
          EntFireByHandle(trig2, "kill", "", 0, null, null)
          EntFire("intro_lift_entrance", "setanimation", "vert_door_opening")
          EntFire("intro_lift_ap", "open")

          // chamber(s)
          EntFire("door_5", "open")
          EntFire("@entry_door1", "open")

          break

        case "tb_over_goo":
          FastNewApertureTransitions(101, 32)
          srmFog()
          EntFire("env_fog_controller", "SetEndDist", "7000")

          EntFire("Entrance_door", "open", "", 2.5)

          // chamber(s)
          EntFire("r2_entrance_door", "open")


          break

        case "two_of_a_kind":
          FastNewApertureTransitions(-1, 24)
          srmFog()

          EntFire("r1_entrance_door", "open", "", 2.5)

          // chamber(s)
          EntFire("r2_entrance_door", "open")

          break

        case "destroyed":
          FastNewApertureTransitions(-1, -1)
          srmFog()

          // chamber(s)
          EntFire("iw_entry_door", "open")

        case "factory":
          sillyStupidFactorySucks()
          srmFog()
          EntFire("env_fog_controller", "SetEndDist", "6000")

          EntFire("AutoInstance1-inlex_door_entry", "open", "", 4.5)
          local door1 = Entities.FindByClassnameNearest("func_button", Vector(2798, -514, 200), 10)
          EntFireByHandle(door1, "press", "", 0, null, null)

          // BtS
          EntFire("BTS_2_door_1", "setanimation", "vert_door_opening")
          local door2 = Entities.FindByClassnameNearest("trigger_once", Vector(3200, -288, 240), 10)
          EntFireByHandle(door2, "kill", "", 0, null, null)
          local trig1 = Entities.FindByClassnameNearest("trigger_multiple", Vector(3408, 104, 208), 10)
          EntFireByHandle(trig1, "kill", "", 0, null, null)
          EntFire("AutoInstance1-moth_cb_lever_hinge1", "AddOutput", "OnOpen BTS_3_Door_1:setanimation:open:0:1")
          EntFire("AutoInstance1-moth_cb_lever_hinge1", "AddOutput", "OnOpen BTS_3_Door_1:setplaybackrate:5:0.03:1")
          local trig2 = Entities.FindByClassnameNearest("trigger_once", Vector(5085.08, -104.76, 208), 10)
          EntFireByHandle(trig2, "kill", "", 0, null, null)
          EntFire("BTS_3_exit_door", "setanimation", "vert_door_opening")
          local trig3 = Entities.FindByClassnameNearest("trigger_multiple", Vector(5784, -800, 592), 10)
          EntFireByHandle(trig3, "kill", "", 0, null, null)
          EntFire("BTS_4_Door_1", "setanimation", "open")
          local trig4 = Entities.FindByClassnameNearest("trigger_multiple", Vector(5360, -936, 592), 10)
          EntFireByHandle(trig4, "kill", "", 0, null, null)
          EntFire("Autoinstance1-BTS_4_door_2", "setanimation", "open")
          local trig5 = Entities.FindByClassnameNearest("trigger_multiple", Vector(6456, -2304, 594), 10)
          EntFireByHandle(trig5, "kill", "", 0, null, null)
          EntFire("InstanceAuto10-door_model", "setanimation", "open")
          local trig6 = Entities.FindByClassnameNearest("trigger_multiple", Vector(6652, -2608, 594), 10)
          EntFireByHandle(trig6, "kill", "", 0, null, null)
          EntFire("InstanceAuto9-door_model", "setanimation", "open")
          local trig7 = Entities.FindByClassnameNearest("trigger_once", Vector(8464, -2736, 485.33), 10)
          EntFireByHandle(trig7, "kill", "", 0, null, null)
          EntFire("AutoInstance1-d_factory_end_door", "setanimation", "vert_door_opening")

          break

        default:
            break;
    }
}

function melgunTeleport() {
  player.SetVelocity(Vector(0, 0, 0))
  player.SetAngles(0.86, -147.77, 0.00)
  player.SetOrigin(Vector(2865.38, 1665.63, 96.03))
}

function srmFog() {
  EntFire("env_fog_controller", "SetColorSecondary", "70 40 0")
  EntFire("env_fog_controller", "SetColor", "70 40 0")
  EntFire("env_fog_controller", "SetStartDist", "-50")
  EntFire("env_fog_controller", "SetEndDist", "7000")
}

function underbounceTeleport() {
  player.SetOrigin(Vector(-552, -192, -101))

  EntFire("autoinstance1-entrance_lift_prop", "kill", 0.1)
  EntFire("autoinstance1-entrance_lift_doortop_prop", "disable", 0, 0)
  EntFire("AutoInstance1-entrance_lift_doorbottom_prop", "disable", 0, 0)
  EntFire("autoinstance1-entrance_lift_doortop_prop", "enable", 0, 1)
  EntFire("AutoInstance1-entrance_lift_doorbottom_prop", "enable", 0, 1)
  EntFire("autoinstance1-entrance_lift_doortop_movelinear", "open", 0, 1)
  EntFire("AutoInstance1-entrance_lift_doorbottom_movelinear", "open", 0, 1)

  local door = null
  local door2 = null
  local temp = null
  local temp2 = null
  while (temp = Entities.Next(temp)) {
    if (temp == null) { break }
    if (temp.entindex() == 42) { door = temp; break }
  }
  if (door != null) {
    EntFireByHandle(door, "kill", "", 1, null, null)
  }
  while (temp2 = Entities.Next(temp2)) {
    if (temp2 == null) { break }
    if (temp2.entindex() == 41) { door2 = temp2; break }
  }
  if (door2 != null) {
    EntFireByHandle(door2, "kill", "", 1, null, null)
  }


  local startEle = Entities.FindByClassnameNearest("func_tracktrain", Vector(-552, -5824, -192) 10)
  startEle.SetOrigin(Vector(-552, -192, -50))
  EntFireByHandle(startEle, "setmaxspeed", "250", 0, null, null)
  EntFireByHandle(startEle, "setspeed", "250", 0, null, null)

  local path = Entities.FindByClassnameNearest("path_track", Vector(-552, -5824, 192) 10)
  path.SetOrigin(Vector(-552, -192, 181))
}

// slightly modified p2sm function that makes old aperture ele's faster. Adjusted to mel's way of transitioning
function FastOldApertureTransition(idin, idout, mapNext){
  if(idout){
    local elename = "InstanceAuto"+idout+"-exit_lift_doortop_movelinear"
    local elename2 = "InstanceAuto"+idout+"-exit_lift_train"
    local elename3 = "InstanceAuto"+idout+"-exit_lift_doorbottom_movelinear"
    if(idout<0){
      elename = "exit_elevator-exit_lift_doortop_movelinear"
      elename2 = "exit_elevator-exit_lift_train"
      elename3 = "exit_elevator-exit_lift_doorbottom_movelinear"
    }

    EntFire(elename, "AddOutput", "OnFullyClosed "+elename2+":StartForward::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:2.5:1")
    EntFire(elename2, "SetMaxSpeed", 250)

    //make end eles already opened
    EntFire(elename, "Open")
    EntFire(elename3, "Open")
  }

  if(mapNext){
    local elename = "InstanceAuto"+idout+"-exit_lift_doortop_movelinear"
    local nextMap = mapNext

    if(idout<0){
      elename = "exit_elevator-exit_lift_doortop_movelinear"
    }
    EntFire(elename, "AddOutput", "OnFullyClosed !self:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + nextMap+"\"):2:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:2.5:1")
  }


  if(idin){
    local elename = "InstanceAuto"+idin+"-entrance_lift_train"
    local elename2 = "InstanceAuto"+idin+"-entrance_lift_train_path_2"
    if(idin<0){
      elename = "elevator-entrance_lift_train"
      elename2 = "elevator-entrance_lift_train_path_2"
    }
    EntFire(elename, "SetMaxSpeed", 250)
    EntFire(elename, "SetSpeed", 250, 0.1)
    EntFire(elename2, "inpass", 0, 0.7)
  }

}

function FastOldApertureTransitionPASTPOWER(idin, idout, mapNext){
  if(idout){
    local elename = "autoinstance1-exit_elevator-exit_lift_doortop_movelinear"
    local elename2 = "autoinstance1-exit_elevator-exit_lift_train"
    local elename3 = "autoinstance1-exit_elevator-exit_lift_doorbottom_movelinear"
    if(idout<0){
      elename = "autoinstance1-exit_elevator-exit_lift_doortop_movelinear"
      elename2 = "autoinstance1-exit_elevator-exit_lift_train"
      elename3 = "autoinstance1-exit_elevator-exit_lift_doorbottom_movelinear"
    }

    EntFire(elename, "AddOutput", "OnFullyClosed "+elename2+":StartForward::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:2.5:1")
    EntFire(elename2, "SetMaxSpeed", 250)

    //make end eles already opened
    EntFire(elename, "Open")
    EntFire(elename3, "Open")
  }

  if(mapNext){
    local elename = "autoinstance1-exit_elevator-exit_lift_doortop_movelinear"
    local nextMap = mapNext

    if(idout<0){
      elename = "autoinstance1-exit_elevator-exit_lift_doortop_movelinear"
    }
    EntFire(elename, "AddOutput", "OnFullyClosed !self:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + nextMap+"\"):2:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:2.5:1")
  }


  if(idin){
    local elename = "InstanceAuto"+idin+"-entrance_lift_train"
    local elename2 = "InstanceAuto"+idin+"-entrance_lift_train_path_2"
    if(idin<0){
      elename = "elevator-entrance_lift_train"
      elename2 = "elevator-entrance_lift_train_path_2"
    }
    EntFire(elename, "SetMaxSpeed", 250)
    EntFire(elename, "SetSpeed", 250, 0.1)
    EntFire(elename2, "inpass", 0, 0.7)
  }

}

function FastNewApertureTransitions(idin, idout) {
  printl(idin)
  if(idout){
    local elename = "instanceauto"+idout+"-close"
    local elename2 = "instanceauto"+idout+"-elevator_1"
    local elename3 = "departure_logic-logic_source_elevator_door_open"
    if(idout<0){
      elename = "departure_logic-close"
      elename2 = "departure_logic-elevator_1"
      elename3 = "departure_logic-logic_source_elevator_door_open"
      
    }

    EntFire(elename, "AddOutput", "OnTrigger "+elename2+":StartForward::0.8:1")
    EntFire(elename2, "SetMaxSpeed", 250)

    // open ending ele from start of map and killing last trigger
    EntFire("InstanceAuto"+idout+"-logic_source_elevator_door_open", "trigger")
    EntFire("departure_logic-logic_source_elevator_door_open", "trigger")
    EntFire("InstanceAuto"+idout+"-signs_on", "trigger")
    EntFire("instanceauto"+idout+"-source_elevator_door_open_trigger", "kill")
    EntFire("departure_logic-logic_source_elevator_door_open", "kill")
    EntFire(elename, "AddOutput", "OnTrigger InstanceAuto"+idout+"-elevator_1_player_teleport:RunScriptCode:ReadyForTransition():1.3:1")
    EntFire(elename, "AddOutput", "OnTrigger departure_logic-elevator_1_player_teleport:RunScriptCode:ReadyForTransition():1.3:1")
  }

  if(idin){
    local elename = "InstanceAuto"+idin+"-elevator_1"
    local elename2 = Entities.FindByName("trigger_once", "InstanceAuto"+idin+"-source_elevator_door_open_trigger")
    if(idin<0){
      elename = "arrival_logic-elevator_1"
      elename2 = "arrival_logic-source_elevator_door_open_trigger"
    }
    EntFire(elename, "SetMaxSpeed", 450)
    EntFire(elename, "SetSpeed", 450, 0.1)
    EntFireByHandle(elename2, "AddOutput", "OnStartTouch instanceauto"+idin+"-open:trigger::0:1", 0, null, null)
    EntFireByHandle(elename2, "AddOutput", "OnStartTouch instanceauto"+idin+"-open:kill::0.3:1", 0, null, null)
    EntFire("arrival_logic-open", "trigger", "", 1.6)
    EntFire("arrival_logic-open", "kill", "", 1.7)

    // local trigPos = elename2.GetOrigin();
    // elename2.SetOrigin(Vector(trigPos.x, trigPos.y, trigPos.z + 300))

  }
}

function sillyStupidFactorySucks() {
  local elename = "AutoInstance1-arrival_logic-elevator_1"
  local elename2 = "AutoInstance1-arrival_logic-source_elevator_door_open_trigger"
  EntFire(elename, "setmaxspeed", 450)
  EntFire(elename, "setspeed", 450, 0.1)
  EntFire(elename2, "AddOutput", "OnStartTouch autoinstance1-arrival_logic-open:trigger::0.2:1")
  EntFire(elename2, "AddOutput", "OnStartTouch autoinstance1-arrival_logic-open:kill::0.23:1")
}