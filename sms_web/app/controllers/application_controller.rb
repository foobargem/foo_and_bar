class ApplicationController < ActionController::Base
  protect_from_forgery


  def flickr_auth_token
    session[:flickr_auth_token] || nil
  end

  def flickr_logged_in?
    !flickr_auth_token.nil?
  end

  def flickr_authorized!
    unless flickr_logged_in?
      redirect_to flickr_auth_path
      return
    end
  end

end
