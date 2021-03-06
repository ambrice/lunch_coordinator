# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  layout "standard-layout"

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5c63830d083a3e7f1a238795b77e812a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

protected

  def group_required
    @group = Group.find(params[:group_id])
    unless @group.id == current_user.group.id
      flash[:error] = "Not a member of that group"
      redirect_to root_url
    end
  end
end
