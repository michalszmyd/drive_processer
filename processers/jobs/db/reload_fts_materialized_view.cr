module Jobs
  module DB
    class ReloadFtsMaterializedView < BaseJob
      def perform
        AppDatabase.exec("REFRESH MATERIALIZED VIEW fts_items_search")
      end
    end
  end
end
