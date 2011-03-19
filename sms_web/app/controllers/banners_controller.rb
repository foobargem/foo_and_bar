class BannersController < ApplicationController

  def base_ad
    @banner = Banner.last

    respond_to do |format|
      format.json { render :json => {
          :title => @banner.title,
          :content => @banner.content,
          :landing_url => @banner.click_tracking_url,
          :embed_code => @banner.embed_code
        }
      }
    end
  end

end
