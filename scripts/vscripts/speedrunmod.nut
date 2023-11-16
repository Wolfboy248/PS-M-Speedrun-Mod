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
            FastOldApertureTransition(null, 2, "underbounce")

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

            FastOldApertureTransition(1, 13, "once_upon")

            // kill the stupid ass lights
            local stupidLights = Entities.FindByName("logic_relay", "Power_On_Start_Relay")
            EntFireByHandle(stupidLights, "kill", "", 0, null, null)

            break
        
        case "once_upon":
            FastOldApertureTransition(-1, -1, "past_power")

            local startTrig = Entities.FindByClassnameNearest("trigger_once", Vector(3072, -1200, 1900), 10)

            EntFireByHandle(startTrig, "AddOutput", "OnStartTouch entry_door-door_prop:setplaybackrate:3:0.1:-1", 0, null, null)
            
            break

        case "past_power":
            FastOldApertureTransitionPASTPOWER(-1, -1, "ramp")

            local startTrig = Entities.FindByClassnameNearest("trigger_once", Vector(1136, 272, 239), 10)
            EntFireByHandle(startTrig, "AddOutput", "OnStartTouch room_1_door_0-door_prop:setplaybackrate:4:0.1:-1", 0, null, null)

            EntFire("func_button", "press")
            EntFire("sd1_door", "setanimation", "open")
            EntFire("gel_door", "AddOutput", "OnOpen walkway_door1:Open:0:-1")
            EntFire("gel_door", "AddOutput", "OnOpen walkway_door2:Open:0:-1")

            local gelDoor = Entities.FindByClassnameNearest("prop_dynamic", Vector(-2184, -544, -192), 10)
            EntFireByHandle(gelDoor, "kill", "", 0, null, null)

            break

        case "ramp":
            FastOldApertureTransition(-1, -1, "firestorm")

            break

        case "firestorm":
            FastOldApertureTransition(15, null, "firestorm")

            EntFire("r1_gate_1", "kill")

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
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:SetMaxSpeed:800:0:1")
            EntFire("virgil_drop_trigger", "AddOutput", "OnTrigger lift_train:SetSpeed:800:0:1")
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
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:changelevel st_a2_" + nextMap + ":1.8:1")
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
    printl(elename3)
    if(idout<0){
      elename = "autoinstance1-exit_elevator-exit_lift_doortop_movelinear"
      elename2 = "autoinstance1-exit_elevator-exit_lift_train"
      elename3 = "autoinstance1-exit_elevator-exit_lift_doorbottom_movelinear"
    }

    EntFire(elename, "AddOutput", "OnFullyClosed "+elename2+":StartForward::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:1.5:1")
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
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:changelevel st_a2_" + nextMap + ":1:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_fade:Fade::0:1")
    EntFire(elename, "AddOutput", "OnFullyClosed end_command:Command:disconnect:1.5:1")
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