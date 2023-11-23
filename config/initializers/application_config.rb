 AppConfig = Rails.application.config_for(:application)

 unless AppConfig["pandoc_path"].blank?
  PandocRuby.pandoc_path = AppConfig["pandoc_path"]
 end