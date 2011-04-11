# encoding: utf-8
module Tools
  class StatsGenerator

    def initialize
      @car_stats = {}
      @model_stats = {}
    end

    # just for nginx
    def analysis(log_file_ptn)
      Dir.glob(log_file_ptn).each do |log_path|
        File.open(log_path, "r") do |f|
          f.each_line do |line|
            row = line.split(" ")
            uri = row[6]
            next if uri.nil?

            analysis_car(uri) if uri.match(/^\/cars\/.*?/)
            analysis_model(uri) if uri.match(/^\/racing_models\/.*?/)
          end
        end
      end
    end


    def write_to_file(file_path = nil)
      File.open(file_path, "w") do |f|

        f.puts "# car ---------------------------"
        @car_stats.sort_by{ |k, v| v }.reverse.each do |k, v|
          car = cars.find_by_id(k)
          next if car.nil?

          f.puts sprintf(" name: %20s\t counts: %5d", car.name, v)
        end

        f.puts ""
        f.puts "# Racing Model ------------------"

        @model_stats.sort_by{ |k, v| v }.reverse.each do |k, v|
          model = models.find_by_id(k)
          next if model.nil?

          f.puts sprintf(" name: %20s\t counts: %5d", model.name, v)
        end
        
      end
    end


    protected

      def analysis_car(uri)
        uri = uri.gsub("/cars/", "") 
          
        if m = uri.match(/^([\d]{1,})/)
          id = m[1]
          @car_stats[id] = @car_stats[id].to_i + 1 
        elsif m = uri.match(/^(photos).*?([\d]{1,}).*/)
          id = m[2]
          @car_stats[id] = @car_stats[id].to_i + 1 
        end 
      end


      def analysis_model(uri)
        uri = uri.gsub("/racing_models/", "") 

        if m = uri.match(/^([\d]{1,})\.json$/)
          id = m[1]
          @model_stats[id] = @model_stats[id].to_i + 1 
        elsif m = uri.match(/^([\d]{1,})\/photos\.json/)
          id = m[1]
          @model_stats[id] = @model_stats[id].to_i + 1
        end
      end


      def cars
        Car.where("id in (?)", @car_stats.keys)
      end

      def models
        RacingModel.where("id in (?)", @model_stats.keys)
      end

    
  end
end
