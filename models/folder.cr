class Folder
      enum ExportStatus
    Empty
    Valid
    Waiting
    Processing
    Error
    Outdated
  end
  DB.mapping({
    id: Int64,
    name: String,
    user_id: Int64,
    folder_private: Bool,
    parent_folder_id: Int64?,
    export_status: Int32?,
    exported_at: Time?,
    export_started_at: String?,
    export_folder_path: String?,
    created_at: Time,
    updated_at: Time
  })
end
