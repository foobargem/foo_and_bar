class BannerLogsController < ApplicationController

  def impression
    track("impression")
    render :text => ""
  end

  def click
    track("click")
    redirect_to @log.banner.landing_url
  end

  protected

    def track(action)
      @log = BannerLog.new(
        :banner_id => params[:bid],
        :action => action,
        :user_agent => request.env["HTTP_USER_AGENT"] || nil
      )
      @log.save
    end

end
