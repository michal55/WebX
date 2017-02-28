module Logging
  module Logger
    extend self
    @debug_level = 1
    @warning_level = 2
    @error_level = 3

    #usage: Logging::Logger.debug("error message", extraction.id)

    def set_log_level level
      @log_level = level
    end

    def write severity, msg, id, type
      json = {}
      json['severity'] = severity
      json['msg'] = msg
      json['resource_id'] = id
      json['resource_type'] = type
      store json
    end

    def debug msg, resource, level=@debug_level
      write 1, msg, resource.id, resource.class.name.downcase if level <= @debug_level
    end

    def warning msg, resource, level=@warning_level
      write 2, msg, resource.id, resource.class.name.downcase if level <= @warning_level
    end

    def error msg, resource, level=@error_level
      write 3, msg, resource.id, resource.class.name.downcase if level <= @error_level
    end

    def store log
      # Posts to elastic index
      Log.create(log)
    end

    def search resource_id
      response = Log.search(
          {
              query: {
                  bool: {
                      must: {
                          match: { resource_id: resource_id }
                      }
                  }
              }
          }
      )
      response['hits']['hits']
    end
  end
end
