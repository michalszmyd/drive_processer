module DriveFiles
  class EraseFiles
    getter older_than_in_days : Int32?

    def initialize(@older_than_in_days)
    end

    def call
      DriveFileQuery
        .new
        .deletable
        .where("deleted_at < ?", [Time.utc - resolve_days])
        .results
        .each do |drive_file|
          EraseFile.new(drive_file).call
        end
    end

    private def resolve_days
      older_than_in_days ? older_than_in_days.not_nil!.days : 0.days
    end
  end
end
