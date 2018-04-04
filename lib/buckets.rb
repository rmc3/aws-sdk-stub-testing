require 'aws-sdk'

class Buckets
  DEFAULT_S3_REGION = 'us-east-1'

  def initialize(region: nil)
    @region = region || DEFAULT_S3_REGION
    @s3 = Aws::S3::Resource.new(region: @region)
  end

  def get_all_bucket_names
    return @s3.buckets.map{|bucket| bucket.name}
  end
end
