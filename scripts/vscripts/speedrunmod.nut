::srm <- {}

srm.log <- function (...) {
    for (local i = 0; i< vargc; i++) {
		printl(vargv[i] + (vargc > 1 ? "\t" : ""));
	}
}

srm.mapspawn <- function () {
    local mapName = GetMapName().slice(6)
    local advanced = GetMapName().slice(0,2) == "sp"

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
            EntFireByHandle(endTrigger, "AddOutput", "OnTrigger !self:RunScriptCode:SendToConsole(\"changelevel "+ (advanced ? "sp" : "st") + "_a1_mel_intro\"):0:1", 0, null, null)
            break

        case "mel_intro":
            // kills the start door in the tram
            EntFire("AutoInstance1-tram_Subway_Model", "Kill", 0, 1)

            // this is supposed to move the fucking door but it wont move the fucking door why
            EntFire(Entities.FindByName(prop_dynamic, Lobby_Right_Door_Left_Move).SetOrigin(Vector(-100, -1000, 1000)))

            // lemme just do stuff in this map man nothing works
            EntFire("cs_cave_05", "Kill", 0, 1)
            EntFire("cs_cave_06", "Kill", 0, 1)
            EntFire("cs_cave_07", "Kill", 0, 1)
            EntFire("cs_cave_08", "Kill", 0, 1)
            EntFire("cs_cave_09", "Kill")

            // PLEASE JUST LET ME KILL STUFF AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA (hi alexz :])
            EntFire("@command", "Command", "ent_fire lift_door break", 1)

            break

        case "junkyard":

            // beginning door button to open door (crazy)
            EntFire("func_button", "Press")
            // open ne noor faster
            EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.3)
            EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.5) // Just in case (I don't know why this is also here in srm lmao)

            // my favourite activity is killing doors YEP
            EntFire("corridor_slidy_door", "Kill", 0, 1)
            EntFire("upper_door_4", "Kill", 0, 1)
            EntFire("AutoInstance1-door_model1", "Kill", 0, 1)

        default:
            break;
    }
}