if zone == "false" and GHUD_notifications == true then
    if firstload==1 then
       if GHUD_log_stats then
          t_radarEnter[id] = {pos = system.getWaypointFromPlayerPos()}
       end
    end
 end