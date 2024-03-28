class FolderQuery < Azurite::BaseQuery(Folder)
  table_name "folders"

  def self.pluck(name : String)
    Azurite::BasePluckQuery.new("folders", key: name)
  end

  def initialize
    super(
      select_clause: "*"
    )
  end
end
