require "lucky_env"

LuckyEnv.load?(".env")

require "avram"

require "./logger"

# shared lib
require "./shared/lib/discord/**"
require "./shared/lib/s3/**"
require "./shared/lib/awscr/**"
require "./shared/lib/azurite/**"
require "./shared/lib/drive_files/**"

require "./config/**"
require "./rabbit_mq/**"

require "./models/**"
require "./queries/**"
require "./generators/**"
require "./processers/**"
require "./services/**"
