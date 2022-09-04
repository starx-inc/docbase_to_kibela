namespace :sync_groups_and_folders do
  desc "sync groups and folders"
  task :execute => :environment do
    # refs. https://github.com/starx-inc/docbase_to_kibela/pull/6#issuecomment-1236055354
    GROUP_MAPPING_HASH = [
      { kibela_group_id: "R3JvdXAvMTAyNQ", docbase_group_names: ["クラウドロジ開発", "クラウドロジ"] },
      { kibela_group_id: "R3JvdXAvMTAyNg", docbase_group_names: ["リピートライン","リピートライン開発"	] },
      { kibela_group_id: "R3JvdXAvMTA0Ng", docbase_group_names: ["管理部"] },
      { kibela_group_id: "R3JvdXAvMQ", docbase_group_names: ["スタークス社員ONLY","STARX ALL","スタークスWiki"] },
    ]

    FOLDER_MAPPING_HASH = [
      { kibela_group_id: "R3JvdXAvMTAyNQ", folder_name: "10. 移行記事" },
      { kibela_group_id: "R3JvdXAvMTAyNg", folder_name: "13. 移行記事" },
      { kibela_group_id: "R3JvdXAvMTA0Ng", folder_name: "12. 移行記事" },
      { kibela_group_id: "R3JvdXAvMQ", folder_name: "04. 移行記事" }
    ]

    p "start"
    ActiveRecord::Base.transaction do
      GROUP_MAPPING_HASH.each do |hash|
        groups = Group.where(name: hash[:docbase_group_names])
        sync_kibela_group_id(groups, hash[:kibela_group_id])
        create_folders(groups, hash[:kibela_group_id])
      end
    end
    p "completed"
  end

  private

  def sync_kibela_group_id(groups, kibela_group_id)
    groups.update_all(kibela_id: kibela_group_id)
  end

  def create_folders(groups, kibela_group_id)
    folder_name = FOLDER_MAPPING_HASH.select{ |hash| hash[:kibela_group_id] == kibela_group_id }
    folder_name = folder_name.first[:folder_name]
    group_ids = groups.ids
    folders = group_ids.map { |group_id| { name: folder_name, group_id: group_id, created_at: Time.now, updated_at: Time.now } }
    Folder.insert_all!(folders)
  end
end
