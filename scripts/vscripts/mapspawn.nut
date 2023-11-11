if(!("Entities" in this)) return;
IncludeScript("speedrunmod.nut")

local auto = Entities.FindByClassname(null, "logic_auto")

if(!auto){
    auto = Entities.CreateByClassname("logic_auto")
    if (!auto) {
        srm.log(@"
        !!!!!!!!!!!!!!!!!!!!!!!!
        MAPSPAWN FAILED TO LOAD!
        !!!!!!!!!!!!!!!!!!!!!!!!\n"
        )
        return
    }
}

EntFireByHandle(auto, "AddOutput", "OnMapSpawn !self:RunScriptCode:srm.mapspawn():0:1", 0, null, null)