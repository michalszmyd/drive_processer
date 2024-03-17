class FolderQuery < Azurite::BaseQuery(Folder)
  def initialize
    super(
      from_clause: "folders",
      select_clause: "*"
    )
  end
end
