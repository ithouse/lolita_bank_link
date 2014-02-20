module LolitaBankLink
  # custom log formatter
  class LogFormatter < Logger::Formatter
    def call(severity, time, program_name, message)
      "%5s [%s] (%s) %s :: %s\n" % [severity, time.strftime('%Y-%m-%d %H:%M:%S'), $$, program_name, message]
    end
  end
end
