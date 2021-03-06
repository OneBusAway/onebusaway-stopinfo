class Log < ActiveRecord::Base
  self.table_name = "logs"
  
  def self.updateAttributes(update, sessionhash, userid)
        
    if sessionhash[:intersection_pos][:needs_verification] == "true"
      update.position = "needs verification"
    else
      update.position = sessionhash[:intersection_pos][:value] 
    end
      
    if sessionhash[:sign_type][:needs_verification] == "true" 
      update.sign_type = "needs verification"
    else
      update.sign_type = sessionhash[:sign_type][:value]
    end
      
    if sessionhash[:sign_inset][:needs_verification] == "true" 
      update.sign_position = "needs verification"
    else
      update.sign_position = sessionhash[:sign_inset][:value]
    end
      
    if sessionhash[:sched_holder][:needs_verification] == "true" 
      update.schedule_holder = "needs verification"
    else
      update.schedule_holder = sessionhash[:sched_holder][:value]
    end
    
    if sessionhash[:shelter_count][:needs_verification] == "true" 
      update.shelters = "needs verification"
    else
      update.shelters = sessionhash[:shelter_count][:value]
    end
      
    if sessionhash[:bench_count][:needs_verification] == "true"
      update.benches = "needs verification"
    else
      update.benches = sessionhash[:bench_count][:value]
    end
      
    if sessionhash[:can_count][:needs_verification] == "true" 
      update.trash_can = "needs verification"
    else
      update.trash_can = sessionhash[:can_count][:value]
    end
    
    if sessionhash[:shelter_offset][:needs_verification] == "true" 
      update.shelter_position = "needs verification"
    else
      update.shelter_position = sessionhash[:shelter_offset][:value]
    end
    
    if sessionhash[:shelter_orientation][:needs_verification] == "true" 
      update.shelter_orientation = "needs verification"
    else
      update.shelter_orientation = sessionhash[:shelter_orientation][:value]
    end
    
    if sessionhash[:lighting][:needs_verification] == "true" 
      update.lighting = "needs verification"
    else
      update.lighting = sessionhash[:lighting][:value]
    end
    
    if userid
      update.comment = sessionhash[:comment]
    else
      update.comment = "not logged in"
    end
    
  end
  
end