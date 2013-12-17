class Swagger::Docs::Config
  def self.base_api_controller; Api::ApiController end
end

Swagger::Docs::Config.register_apis({
	"1.0" => {
		:api_file_path => "public/api/v1/",
		:base_path => "http://calpop.herokuapp.com/populate",
		:clean_directory => false
	}
})