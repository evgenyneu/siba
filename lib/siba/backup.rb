# encoding: UTF-8

module Siba
  class Backup
    include Siba::LoggerPlug
    include Siba::FilePlug

    def backup(path_to_options_yml, path_to_log_file)
      run_backup path_to_options_yml, path_to_log_file
    ensure
      Siba.cleanup
    end

private

    def run_backup(path_to_options_yml, path_to_log_file)
      LoggerPlug.create "Backup", path_to_log_file
      options = Siba::OptionsLoader.load_yml path_to_options_yml
      Siba.current_dir = File.dirname path_to_options_yml
      Siba.settings = options["settings"] || {}
      Siba.backup_name = File.basename path_to_options_yml, ".yml"

      TmpDir.test_access 
      SibaTasks.new(options, path_to_options_yml).backup
      Siba.cleanup_tmp_dir
    rescue Exception => e 
      logger.fatal e
      logger.log_exception e, true
    end

#     def upload_file_to_amazon_s3(path_to_file, file_name = nil)
#       s3_settings = get_config_setting AWS_S3_ConfigName 
#       amazon_s3_bucket = get_config_setting AWS_S3_BucketConfigName, s3_settings 
#       access_key_id = get_config_setting AWS_S3_AccessKeyIDConfigName, s3_settings
#       secret_key = get_config_setting AWS_S3_SecretKeyIDConfigName, s3_settings
# 
#       Log.exit "File #{path_to_file} does not exist" unless File.file?(path_to_file) 
# 
#       file_name = File.basename(path_to_file) if file_name.nil?
#       Log.log "Uploading '#{file_name}' to Amazon S3 '#{amazon_s3_bucket}'..."
# 
#       AWS::S3::Base.establish_connection!(
#         :access_key_id => access_key_id,
#         :secret_access_key => secret_key);
# 
#       AWS::S3::S3Object.store(file_name, open(path_to_file), amazon_s3_bucket)
#     end
  end
end
