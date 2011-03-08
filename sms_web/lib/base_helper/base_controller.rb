module BaseContoller
  
  def self.included(c)
    c.helper_method :return_url, :stored_param, :stored_param?, :browser_is?, :browser_class_name, :ie6?
  end

  #
  def return_url(default)
    session[:return_to] || default
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  #
  def stored_param(key)
    session[:stored_param] ||= {}
    if params[key]
      session[:stored_param][key] = params[key]
    else
      session[:stored_param][key]
    end
  end

  def stored_param?(param_name, rhs)
    v = stored_param(param_name)

    if rhs.is_a?(Array)
      rhs.include?(v)
    else
      rhs == v
    end
  end
  
  
  #
  def browser_is?(name)
    browser_name == name
  end
  
  def browser_name
    ua = request.user_agent.downcase
 
    if ua =~ /firefox\//
      :firefox
    elsif ua =~ /opera\//
      :opera
    elsif ua =~ /chrome\//
      :chrome
    elsif ua =~ /safari\//
      :safari
    elsif ua =~ /msie/
      :ie
    else
      nil
    end
  end

  def browser_class_name
    ua = request.user_agent.downcase

    if ua =~ /firefox\//
      "FF"
    elsif ua =~ /opera\//
      "Opera"
    elsif ua =~ /chrome\//
      "Chrome"
    elsif ua =~ /safari\//
      "Safari"
    elsif matched = ua.match(/msie (\d+\.\d+)/)
      version = matched[1].to_i
      "IE IE#{version}"
    else
      "NotMatched"
    end
  end
  
  def ie6?
    ua = request.user_agent.downcase
    
    if matched = ua.match(/msie (\d+\.\d+)/)
      version = matched[1].to_i
    else
      version = nil
    end
    
    (version == 6)
  end


end
