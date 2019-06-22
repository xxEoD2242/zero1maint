# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: (ENV['AWS_ACCESS_KEY_ID']).to_s,
    aws_secret_access_key: (ENV['AWS_SECRET_ACCESS_KEY']).to_s,
    region: (ENV['S3_REGION']).to_s,
    path_style: true
  }

  config.fog_directory = (ENV['S3_BUCKET_NAME']).to_s
  config.cache_dir     = "#{Rails.root}/tmp/uploads"
  config.fog_public    = true # For Heroku
end
