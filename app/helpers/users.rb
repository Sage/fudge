module Helpers::Users
  def current_user
    @current_user ||= User.find_by_id(session[:userid])
  end

  #def require_user!
  #  redirect '/' unless current_user
  #end
end
