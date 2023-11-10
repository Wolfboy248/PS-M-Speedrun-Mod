//********************************************************************************************
//all of the shit (i dont know how to code)
//********************************************************************************************

function AddOutput(entityname,event,func){
  local entity = GetEntity(entityname)
  if(entity){
    EntFire(entity.GetName(),"RunScriptFile","transitions/sp_transition_list.nut",0.0)
    entity.ConnectOutput(event,func)
  }else{
    //modlog("Failed to add output \""+event+":"+func+"\" for entity \""+entityname+"\"")
  }
}

function SpeedrunModLoad() {
    switch(GetMapName()) { 
        case "st_a1_mel_intro":
        printl("=================================")
        printl("======== MEL INTRO LOADED =======")
        printl("=================================")
        EntFire("AutoInstance1-tram_Subway_Model", "Kill", 0, 1)
        local stupidDor = null
        local temp = null
        while (temp = Entities.Next(temp)) {
        if (temp == null) { continue }
        if (temp.entindex() == 950) { stupidDor = temp; break }
        }
        if (stupidDor != null) {
            stupidDor.SetOrigin(Vector(164, 2472, 12584))
        }

        local stupidDor2 = null
        local temp2 = null
        while (temp2 = Entities.Next(temp2)) {
        if (temp2 == null) { continue }
        if (temp2.entindex() == 948) { stupidDor2 = temp2; break }
        }
        if (stupidDor2 != null) {
            stupidDor2.SetOrigin(Vector(164, 2328, 12584))
        }

        local stupidDor3 = null
        local temp3 = null
        while (temp3 = Entities.Next(temp3)) {
        if (temp3 == null) { continue }
        if (temp3.entindex() == 900) { stupidDor3 = temp3; break }
        }
        if (stupidDor3 != null) {
            stupidDor3.SetOrigin(Vector(208, 3116, 12584))
        }

        local stupidDor4 = null
        local temp4 = null
        while (temp4 = Entities.Next(temp4)) {
        if (temp4 == null) { continue }
        if (temp4.entindex() == 901) { stupidDor4 = temp4; break }
        }
        if (stupidDor4 != null) {
            stupidDor4.SetOrigin(Vector(352, 3116, 12584))
        }
        break

        case "st_a3_junkyard":
        printl("=================================")
        printl("======== JUNKYARD LOADED ========")
        printl("=================================")
        EntFire("func_button", "Press")
        EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.3)
        EntFire("Junkyard_Entrance_Door", "SetAnimation", "open_idle", 0.5) // Just in case (I don't know why this is also here in srm lmao)
        EntFire("junkyard_entrance_prop", "Kill", 0, 1)

        // my favourite activity is killing doors YEP
        EntFire("corridor_slidy_door", "Kill", 0, 1)
        EntFire("upper_door_4", "Kill", 0, 1)
        EntFire("AutoInstance1-door_model1", "Kill", 0, 1)
    }
}

SpeedrunModLoad()