class DriveFileQuery < BaseQuery(DriveFile)
  def initialize
    super(
      from_clause: "drive_files",
      select_clause: "*"
    )
  end
end
