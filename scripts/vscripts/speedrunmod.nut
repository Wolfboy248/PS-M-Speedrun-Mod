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
    EntFireByHandle(trigger, "AddOutput", "OnTrigger !self:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp_" : "st_") + map+"\"):0:1", 0, null, null)
}

srm.mapspawn <- function () {
    switch (mapName) {
        // CHAPTER 1
        case "tramride":
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

            EntFire("lonewolf_loves_speedrunners_sound", "kill")
            EntFire("math_7", "add", "100")
            EntFire("thats_numberwang", "add", "100")
            EntFire("speedrun_go", "use", "")
            EntFire("speedmod", "modifyspeed", "1", 1)

            local endTrigger = Entities.FindByName(null, "lonewolf_is_kind")
            srm.transitionTrigger(endTrigger, "a1_mel_intro")
            break

        case "mel_intro":
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
            break

        // CHAPTER 2
        case "garden_de":
            FastUndergroundTransition(null, 2, "underbounce")

            EntFire("bedroom_button", "unlock")
            EntFire("bedroom_button", "press")

            // OPTIMUS DOOR
            EntFire("func_button", "Press") // this is also the cause of the load crash at the start of the map.
                                            // It's pressing the last door button so it makes the beam fall.

            // remove automatic door trigger in lobby and automatically open it on map load
            local removeTrig = Entities.FindByClassnameNearest("trigger_multiple", Vector(1744, 2460, 96), 10)
            EntFireByHandle(removeTrig, "kill", "", 0, null, null)
            EntFire("lower_office_door", "SetAnimation", "open")

            // beeg door
            EntFire("vault_manager", "AddOutput", "OnChangeToAllTrue vault_door:setplaybackrate:100:0.3:-1")
            break

        case "underbounce":
            FastUndergroundTransition(1, 13, "once_upon")

            break

        case "junkyard":
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
            // EntFire("lift_track_3")
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:startforward")
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:SetSpeed", 3)
            break

        default:
            break;
    }
}

// slightly modified p2sm function that makes old aperture ele's faster. Adjusted to mel's way of transitioning
function FastUndergroundTransition(idin, idout, mapNext){
  if(idout){
    local elename = "InstanceAuto"+idout+"-exit_lift_doortop_movelinear"
    local elename2 = "InstanceAuto"+idout+"-exit_lift_train"
    local elename3 = "InstanceAuto"+idout+"-exit_lift_doorbottom_movelinear"
    if(idout<0){
      elename = "exit_lift_doortop_movelinear"
      elename2 = "exit_lift_train"
      elename3 = "exit_lift_doorbottom_movelinear"
    }

    EntFire(elename, "AddOutput", "OnFullyClosed "+elename2+":StartForward::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed @transition_script:RunScriptCode:TransitionReady():0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed @transition_script:RunScriptCode:modlog(\"Fast transition will be executed in 1 second...\"):0:1")
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

    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:changelevel st_a2_" + nextMap + ":1.8:1")
  }

  
  if(idin){
    local elename = "InstanceAuto"+idin+"-entrance_lift_train"
    local elename2 = "InstanceAuto"+idin+"-entrance_lift_train_path_2"
    if(idin<0){
      elename = "entrance_lift_train"
      elename2 = "entrance_lift_train_path_2"
    }
    EntFire(elename, "SetMaxSpeed", 250)
    EntFire(elename, "SetSpeed", 250, 0.1)
    EntFire(elename2, "inpass", 0, 1.1)
  }
  
}