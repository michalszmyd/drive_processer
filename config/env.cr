ENVIRONMENT = ENV["ENVIRONMENT"]

class Env
  DEFAULT_ENV = "development"
  PRODUCTION_ENV = "production"
  TEST_ENV = "test"

  ENVIRONMENTS = [DEFAULT_ENV, TEST_ENV, PRODUCTION_ENV]

  def self.environment
    ENVIRONMENT.in?(ENVIRONMENTS) ? ENVIRONMENT : DEFAULT_ENV
  end

  def self.production?
    environment == PRODUCTION_ENV
  end

  def self.development?
    environment == PRODUCTION_ENV
  end

  def self.test?
    environment == TEST_ENV
  end
end
