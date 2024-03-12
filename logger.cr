class Logger
  getter path : String

  def self.init(path : String? = "./logs/log.txt")
    @@logger = new(path)
  end

  def self.log(value : String)
    @@logger.try &.log(value)
  end

  def initialize(@path = "/log.txt")
    puts("Logger start: #{path}")
  end

  def log(value : String)
    time = Time.utc

    info = "[#{time}]: #{value}"

    puts(info) unless Env.production?

    File.open(path, "ab+") do |file|
      file.puts info
    end
  end
end
