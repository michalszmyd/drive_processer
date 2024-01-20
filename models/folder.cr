class Folder
  DB.mapping({
    id: Int64,
    name: String,
    user_id: Int64,
    folder_private: Bool,
    parent_folder_id: Int64?,
    created_at: Time,
    updated_at: Time
  })
end
