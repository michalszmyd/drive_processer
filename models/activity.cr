require "./base_model"

class Activity
  enum ActivityActionType
    Visit
    Create
    Update
    Delete
    Restore
  end

  enum ActivityResourceType
    Folder
    File
    Application
    Search
    Session
    User
    FileShare
    FolderFiles
    Folders
  end

  DB.mapping({
    resource:       Int32,
    resource_id:    Int64?,
    action:         Int32,
    metadata:       JSON::Any?,
    request_info:   JSON::Any,
    application_id: Int64?,
    user_id:        Int64?,
  })
end
