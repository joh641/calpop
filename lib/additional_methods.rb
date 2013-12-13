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
      month = date.month
      day = date.day
      if month >= 8 and day >= 15
        "Fall"
      elsif month >= 5 and day >= 20
        "Summer"
      else
        "Spring"
      end
    end

    # splits into half hour time chunks from start to end
    def split_times(start_time, end_time)
      start_int = start_time.to_i
      end_int = end_time[0,4].to_i 
      end_period = end_time[-2] + end_time[-1]
      time_frame = []
      if end_period == "PM"
        end_int += 1200
        if start_int < 800
          start_int += 1200
        end
      end
      while (start_int < end_int)
          time_frame.push(start_int)
          start_int += 50
      end  
    end
  end
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
