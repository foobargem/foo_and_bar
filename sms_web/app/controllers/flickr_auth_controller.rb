class FlickrAuthController < ApplicationController

  def new
    FlickRaw.api_key = FLICKR_APP_KEY
    FlickRaw.shared_secret = FLICKR_APP_SECRET
    auth_url = FlickRaw.auth_url :perms => "write"
    redirect_to auth_url
  end

  def callback
    frob = params[:frob]
    auth = flickr.auth.getToken :frob => frob
    session[:flickr_auth_token] = auth

    if admin_signed_in?
      redirect_to admin_root_path
      return
    end

    redirect_to root_path
  end

end
