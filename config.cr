require "lucky_env"

LuckyEnv.load?(".env")

require "avram"

require "./config/**"
require "./rabbit_mq/**"

require "./models/**"
require "./queries/**"
require "./generators/**"
require "./processers/**"
