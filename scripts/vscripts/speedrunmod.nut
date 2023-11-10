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
        default:
            break;
    }
}