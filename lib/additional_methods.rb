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
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
