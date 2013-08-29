# If no application configuration exists, copy the default one over...
unless FileTest.exists?("config/application.yml")
  FileUtils.cp "config/application.yml.sample", "config/application.yml"
end

ENV.update YAML.load(File.read("config/application.yml"))

