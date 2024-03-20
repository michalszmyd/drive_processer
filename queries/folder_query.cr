class FolderQuery < Azurite::BaseQuery(Folder)
  table_name "folders"

  def initialize
    super(
      select_clause: "*"
    )
  end
end
