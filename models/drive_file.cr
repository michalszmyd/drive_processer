class DriveFile
  DB.mapping({
    id: Int64,
    name: String,
    file_name: String?,
    source_url: String?,
    body: String?,
    external_storage_id: String?,
    archived: Bool,
    pinned: Bool,
    vibrant_color: String?,
    folder_id: Int64,
    user_id: Int64,
    metadata: JSON::Any,
    created_at: Time,
    updated_at: Time
  })
end
