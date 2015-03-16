# require 'yaml'

# # If no application configuration exists, copy the default one over...
# unless FileTest.exists?("config/application.yml")
#   FileUtils.cp "config/application.yml.sample", "config/application.yml"
# end

# #ENV.update YAML.load(File.read("config/application.yml"))
# APP_CONFIG = HashWithIndifferentAccess.new(YAML.load(File.read("config/application.yml")))
# #yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
# #APP_CONFIG = HashWithIndifferentAccess.new(yaml_data)

