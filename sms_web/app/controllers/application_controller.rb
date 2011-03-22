class ApplicationController < ActionController::Base
  protect_from_forgery


  def flickr_auth_token
    session[:flickr_auth_token] || nil
  end

  def flickr_logged_in?
    !flickr_auth_token.nil?
  end
  helper_method :flickr_logged_in?

  def flickr_authorized!
    unless flickr_logged_in?
      redirect_to flickr_auth_path
      return
    end
  end


  def set_locale
    I18n.locale = :ko
  end
  before_filter :set_locale


  def store_params
    unless request.query_string.blank?
      query = request.query_string.split(/\?/)[-1]
      parts = query.split(/&|=/).map{|v| URI.decode(v) }
      session[:params] = Hash[*parts]
      logger.debug session[:params]
    else
      session[:params] = nil
    end
  end

  def stored_params
    session[:params] || {}
  end

end
