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