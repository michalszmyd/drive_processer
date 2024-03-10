require "lucky_env"

LuckyEnv.load?(".env")

require "avram"

require "./config/**"
require "./rabbit_mq/**"

require "./models/**"
require "./queries/**"
require "./generators/**"
require "./processers/**"

## shared lib
require "./shared/lib/discord/**"
require "./shared/lib/s3/**"
require "./shared/lib/awscr/**"
