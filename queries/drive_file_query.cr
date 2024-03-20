class DriveFileQuery < Azurite::BaseQuery(DriveFile)
  table_name "drive_files"

  def initialize
    super(
      select_clause: "*"
    )
  end

  def deletable
    where_not_nil("deleted_at")
  end
end
