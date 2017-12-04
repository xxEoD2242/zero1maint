class Report < ApplicationRecord
  
  
  has_many :report_users
  has_many :users, through: :report_users
  
  has_many :request_reports
  has_many :requests, through: :request_reports
  
  has_many :report_vehicles
  has_many :vehicles, through: :report_vehicles
  
  has_many :event_reports
  has_many :events, through: :event_reports
  
  has_many :part_reports
  has_many :parts, through: :part_reports
  
  has_many :report_vehicle_orders
  
  paginates_per 5
  
  mount_uploader :report_doc, ReportDocUploader
  
  
  STATUSES = ['Created', 'Viewed', 'Filed']
  TYPES = ['Weekly', 'Weekly-RZR', 'Monthly', 'Vehicle', 'Event', 'Work Order', 'Part', 'Financial', 'Labor']
  
  def download_url
    @report = Report.find(params[:id])
    Aws.config.update({
      region: "#{ENV['S3_REGION']}",
      credentials: Aws::Credentials.new("#{ENV['AWS_ACCESS_KEY_ID']}", "#{ENV['AWS_SECRET_ACCESS_KEY']}")
    })
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket("#{ENV['S3_BUCKET_NAME']}")
    object = bucket.object("#{@report.report_doc}")
    
    
    url_options = { 
      expires_in:                   60.minutes, 
      use_ssl:                      true, 
      response_content_disposition: "attachment; filename=\"#{@report.report_doc}\""
    }

    object[ self.path ].url_for( :read, url_options ).to_s
  end
  
end
