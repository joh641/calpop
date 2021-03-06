module AdditionalMethods
  module ClassMethods
    # makes the API call and returns the XML response for parsing
    def call_api(uri)
      begin
        xml = open(uri,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
      rescue => e
        raise e.message
      end
      doc = Nokogiri::XML(xml)
    end
    
    # finds the semester based on date
    def find_semester(date)
      year = date.year
      if (Date.new(year,1,1)..Date.new(year,5,15)).cover?(date)
        "Spring"
      elsif (Date.new(year,5,16)..Date.new(year,8,19)).cover?(date)
        "Summer"
      else
        "Fall"
      end
    end

    # splits into half hour time chunks from start to end
    def split_times(start_time, end_time)
      start_int = start_time.gsub(/30$/,"50").to_i
      end_int = end_time[0,4].gsub(/30$/,"50").to_i 
      end_period = end_time[-2] + end_time[-1]
      time_frame = []
      if end_period == "PM"
        if end_int != 1200 and end_int != 1250
          end_int += 1200
        end
        if start_int < 800
          start_int += 1200
        end
      end
      while (start_int < end_int)
          time_frame.push(start_int.to_s.gsub(/50$/,"30").to_i)
          start_int += 50
      end  
      return time_frame
    end
  end
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
