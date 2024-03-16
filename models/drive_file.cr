class DriveFile
  enum FileHosting
    Local
    Discord
    AmazonS3
  end

  DB.mapping({
    id: Int64,
    name: String,
    file_name: String?,
    source_url: String?,
    body: String?,
    external_storage_id: String?,
    deleted_at: Time?,
    pinned: Bool,
    vibrant_color: String?,
    folder_id: Int64?,
    user_id: Int64,
    metadata: JSON::Any,
    hosting_source: Int32?,
    source_signature_created_at: Time?,
    source_signature_duration: Int32?,
    legacy_external_storage_id: String?,
    legacy_source_url: String?,
    created_at: Time,
    updated_at: Time
  })
end
