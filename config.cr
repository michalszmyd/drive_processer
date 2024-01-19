require "lucky_env"

LuckyEnv.load?(".env")

require "avram"

require "./config/**"
require "./rabbit_mq/**"

require "./generators/**"
require "./models/**"
require "./processers/**"
