class ReputationController < ApplicationController
 
  def badges
  end
  
  def create
  	  user = User.find_by_id(cookies[:user_id])

  	  if (params[:settings][:display_name].length > 20)
  	  	flash[:notice] = "Please keep display name under 20 characters."
  	  else
  	  	user.name = params[:settings][:display_name]
        user.address = params[:settings][:address]
  	  	user.visible = params[:settings][:visible]
  	  	
  	  	if user.visible == 1
  	  		userWithRank = User.find_by_sql("select t.id, (select count(*) from users x where x.visible=1 AND x.points > t.points) AS position from users t where t.id = " + cookies[:user_id])
      
  	  		# Add 1 because this indexes from 0
      		userRank = userWithRank[0].position + 1
      
     
	  		# Badgechecking things here
	  		if (userRank <= 20)
      			if(!user.badges.include? "004")
      				user.badges = user.badges + "004"
      				flash[:alert] = "Congratulations! You are a Top Contributor!"
	  			end
	  		elsif (user.badges.include? "004")
	  			user.badges = user.badges.gsub("004", "")
	  		end
	  	else
	  		if (user.badges.include? "004")
	  			user.badges = user.badges.gsub("004", "")
	  			user.save
	  		end
	  	end
	  		
  	  	flash[:notice] = "Changes saved."
  	  end
  	  user.save
  	  redirect_to '/profile'
  	  
  end
  
  def profile
    user = User.find_by_id(cookies[:user_id])
    
    if(user == nil)
      redirect_to missinguser_url
    else
      userLog = BusStop.usageLogger
      userLog.info("Profile view from #{session[:device_id]} at #{Time.now}")
      userLog.info("User logged in as #{cookies[:user_email]}")
      userLog.info("")
    end
  end
  
  def publicprofile
    @user = User.find_by_id(params[:id])
    @displayInfo = ""
    
    if(@user == nil)
      @displayInfo = "no user"
    elsif(@user.visible == 0)
      @user = nil
      @displayInfo = "hidden"
    elsif(@user == User.find_by_id(cookies[:user_id]))
      @displayInfo = "same user"
    end
  end
  
  def top
    @userList = User.find_by_sql("select t.*, (select count(*) from users x where x.visible=1 AND x.points > t.points) AS position from users t where t.visible = 1 AND t.points > 0 order by t.points desc")
    
    userLog = BusStop.usageLogger
    userLog.info("Viewing top contributors list at #{Time.now}")
    
    if(!cookies[:user_email].blank?)
      userLog.info("User logged in as #{cookies[:user_email]}")
    elsif(!session[:device_id].blank?)
      userLog.info("Accessed from device #{session[:device_id]}")
    end
    
    userLog.info("")
  end
  
  def confirmdelete
    @user = User.find_by_id(cookies[:user_id])
  end
  
  def delete
    @user = User.find_by_id(cookies[:user_id])
    
    Authorization.where(:user_id => cookies[:user_id]).destroy_all
    @user.destroy
    
    cookies.delete(:user_email)
    cookies.delete(:user_id)
    
    redirect_to accountdeleted_url
  end
  
  def usernotfound
  end
end
