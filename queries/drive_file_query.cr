class DriveFileQuery < BaseQuery(DriveFile)
  def initialize
    super(
      from_clause: "drive_files",
      select_clause: "*"
    )
  end

  def deletable
    where_not_nil("deleted_at")
      .where("deleted_at > ?", [Time.utc - 7.days])
  end
end
