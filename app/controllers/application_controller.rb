class ApplicationController < ActionController::API
  def current_user
    # If test situation when user is logged in
    User.first

    # If test situation when user is not logged in
    # nil
  end

  # This is actual my current_user method
  # current_user method depends on the person
  # def current_user
  #   token = AccessToken.find_token(bearer_token)

  #   if token && !token.expired?
  #     @current_user ||= token.user
  #   end
  # end
end
