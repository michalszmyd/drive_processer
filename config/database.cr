database_name = "drive_#{Env.environment}"

class AppDatabase < Avram::Database
end

AppDatabase.configure do |settings|
  if Env.production?
    settings.credentials = Avram::Credentials.parse(ENV["DATABASE_URL"])
  else
    settings.credentials = Avram::Credentials.parse?(ENV["DATABASE_URL"]?) || Avram::Credentials.new(
      database: database_name,
      hostname: ENV["DB_HOST"]? || "localhost",
      port: ENV["DB_PORT"]?.try(&.to_i) || 5432,
      # Some common usernames are "postgres", "root", or your system username (run 'whoami')
      username: ENV["DB_USERNAME"]?,
      # Some Postgres installations require no password. Use "" if that is the case.
      password: ENV["DB_PASSWORD"]?
    )
  end
end

Avram.configure do |settings|
  settings.database_to_migrate = AppDatabase

  # In production, allow lazy loading (N+1).
  # In development and test, raise an error if you forget to preload associations
  settings.lazy_load_enabled = Env.production?

  # Always parse `Time` values with these specific formats.
  # Used for both database values, and datetime input fields.
  # settings.time_formats << "%F"
end
