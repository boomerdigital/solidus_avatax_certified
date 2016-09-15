module SolidusAvataxCertified
  class AvataxLog
    def initialize(path_name, file_name, log_info = nil, schedule = nil)
      if !Spree::AvalaraPreference.log_to_stdout.is_true?
        schedule = 'weekly' unless schedule != nil
        @logger ||= Logger.new("#{Rails.root}/log/#{path_name}.log", schedule)
        progname(file_name.split('/').last.chomp('.rb'))
        info(log_info) unless log_info.nil?
      else
        log_info = "-#{file_name} #{log_info}"
        @logger = Logger.new(STDOUT)
      end
    end

    def logger
      @logger
    end

    def enabled?
      Spree::AvalaraPreference.log.is_true? || Spree::AvalaraPreference.log_to_stdout.is_true?
    end

    def progname(progname = nil)
      if enabled?
        progname.nil? ? logger.progname : logger.progname = progname
      end
    end

    def info(log_info = nil)
      if enabled?
        unless log_info.nil?
          logger.info "[AVATAX] #{log_info}"
        end
      end
    end

    def info_and_debug(log_info, response)
      if enabled?
        logger.info "[AVATAX] #{log_info}"
        if response.is_a?(Hash)
          logger.debug "[AVATAX] #{JSON.generate(response)}"
        else
          logger.debug "[AVATAX] #{response}"
        end
      end
    end


    def debug(obj, text = nil)
      if enabled?
        logger.debug "[AVATAX] #{obj.inspect}"
        if text.nil?
          obj
        else
          logger.debug "[AVATAX] text"
          text
        end
      end
    end

    def error(log_info = nil)
      if enabled?
        unless log_info.nil?
          logger.error "[AVATAX] #{log_info}"
        end
      end
    end
  end
end
