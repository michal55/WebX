module Logging
  class Logger

    def initialize(attributes = {})
      @severity = attributes[:severity]
    end

    def write severity, msg, id, type
      json = {}
      json['severity'] = severity
      json['msg'] = msg
      json['resource_id'] = id
      json['resource_type'] = type
      store json
    end

    def debug msg, resource
      write 1, msg, resource.id, resource.class.name.downcase if @severity == 1
    end

    def warning msg, resource
      write 2, msg, resource.id, resource.class.name.downcase if @severity <= 2
    end

    def error msg, resource
      write 3, msg, resource.id, resource.class.name.downcase
    end

    def store log
      # POST to elastic index
      Log.create(log)
    end
  end
end
