class VideosController < ApplicationController

  def index
    scoped = Video.scoped

    @videos = scoped.select("title, stream_url")

    respond_to do |format|
      format.json { render :json => @videos.to_json }
    end
  end

end
