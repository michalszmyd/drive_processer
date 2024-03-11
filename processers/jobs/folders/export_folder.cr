module Jobs
  class Folders
    class ExportFolder < BaseJob
      def perform
        folder_id = data["id"].as_i

        folder = FolderQuery.new.find(folder_id)

        ::Folders::ZipFolderGenerator.new(folder).to_zip do |filename, filepath|
          Logger.log("#{filename}, #{filepath}")
        end
      end
    end
  end
end
