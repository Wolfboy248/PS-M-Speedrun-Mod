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
            EntFire("l_e_gl_door", "setspeed", 350)
            EntFire("l_e_gr_door", "setspeed", 350)

            EntFire("sleepy_lobby_door", "setspeed", 1350)

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

        default:
            break;
    }
}