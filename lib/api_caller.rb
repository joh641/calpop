module APICaller

  # makes the API call and returns the XML response for parsing
  def call_api(uri)
    begin
      xml = URI.parse(uri).read
    rescue => e
      raise e.message
    end
    doc = Nokogiri::XML(xml)
  end

end
