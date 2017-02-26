module Logging
  module Logger
    extend self

    #usage: Logging::Logger.debug("error message", extraction.id)

    def writer severity, msg, id, type
      json = {}
      json['severity'] = severity
      json['msg'] = msg
      json['resource_id'] = id
      json['resource_type'] = type
      output json
    end

    def debug msg, id, type
      writer 1, msg, id, type
    end

    def warning msg, id, type
      writer 2, msg, id, type
    end

    def error msg, id, type
      writer 3, msg, id, type
    end

    def output log
      # Posts to elastic index
      Log.create(log)
    end
  end
end
