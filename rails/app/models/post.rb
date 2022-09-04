# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  user_id           :bigint
#  title             :string(1024)
#  body              :text
#  origin_url        :string(1024)
#  scope             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kibela_id         :string
#  kibela_url        :string
#  kibela_updated_at :datetime
#
class Post < ApplicationRecord
  include Docbase::BaseModule

  belongs_to :user, optional: true
  has_many :comments, dependent: :delete_all
  accepts_nested_attributes_for :comments
  has_many :post_attachiment_files, dependent: :delete_all
  has_many :attachiment_files, through: :post_attachiment_files
  accepts_nested_attributes_for :attachiment_files
  has_many :tags, dependent: :delete_all
  accepts_nested_attributes_for :tags
  has_many :groups, dependent: :delete_all
  accepts_nested_attributes_for :groups
  has_many :related_posts, foreign_key: :source_post_id, dependent: :delete_all
  accepts_nested_attributes_for :related_posts

  class << Post
    def get_by_docbase(from_updated_at, to_updated_at)
      responses = posts(from_updated_at: from_updated_at, to_updated_at: to_updated_at)
    end

    def sync_by_docbase(from_updated_at, to_updated_at, next_path = nil)
      responses = posts(from_updated_at: from_updated_at, to_updated_at: to_updated_at, next_path: next_path)
      post_objects = responses[:body][:posts]
      post_objects.select{|o| o[:draft] == false && o[:archived] == false}.map do |o|
        post = Post.find_or_initialize_by(id: o[:id])
        post.transaction do
          post.build_by_docbase(o)
          post.save!
          post.sync_comments(o)
          post.sync_groups(o)
          post.sync_tags(o)
          post.sync_attachiment_files(o)
        end
      end
      responses[:next_page]
    end
  end

  def build_by_docbase(obj)
    user = User.find_by(id: obj.dig(:user, :id))
    self.attributes = {
      user: user,
      title: obj[:title],
      body: obj[:body],
      origin_url: obj[:url],
      scope: obj[:scope],
      created_at: obj[:created_at],
      updated_at: obj[:updated_at]
    }
    self
  end

  def sync_comments(obj)
    # 新規・更新をインスタンスに反映
    obj[:comments].each do |obj_comment|
      # 挿入・更新
      comment = comments.find_or_initialize_by(id: obj_comment[:id])
      comment.build_by_docbase(obj_comment).save!
    end
    # 削除
    exists_ids = obj[:comments].map{|c| c[:id] }
    comments.where.not(id: exists_ids).delete_all
    self
  end

  def sync_groups(obj)
    # 新規・更新をインスタンスに反映
    obj[:groups].each do |obj_group|
      # 挿入・更新
      group = groups.find_or_initialize_by(name: obj_group[:name])
      group.build_by_docbase(obj_group).save!
    end
    # 削除
    exists_names = obj[:groups].map{|c| c[:name] }
    groups.where.not(name: exists_names).delete_all
    self
  end

  def sync_tags(obj)
    # 新規・更新をインスタンスに反映
    obj[:tags].each do |obj_tag|
      # 挿入・更新
      tag = tags.find_or_initialize_by(name: obj_tag[:name])
      tag.build_by_docbase(obj_tag).save!
    end
    # 削除
    exists_names = obj[:tags].map{|c| c[:name] }
    tags.where.not(name: exists_names).delete_all
    self
  end

  def sync_attachiment_files(obj)
    # 新規・更新をインスタンスに反映
    attachiment_file_ids = obj[:attachments].map do |obj_attachment|
      # 挿入・更新
      attachiment_file = AttachimentFile.find_or_initialize_by(id: obj_attachment[:id])
      attachiment_file.build_by_docbase(obj_attachment).save!
      post_attachiment_file = post_attachiment_files.find_or_initialize_by(attachiment_file: attachiment_file)
      post_attachiment_file.save!
      attachiment_file.id
    end
    # 削除
    post_attachiment_files.where.not(attachiment_file_id: attachiment_file_ids).destroy_all
    self
  end

  def upload_to_kibela!
    adapter = Kibela::Adapter.new
    # groupに紐づいていない場合は「01. 全社 > すべて > 12. 移行記事」のフォルダに格納
    # 最初のグループを優先する
    group_ids = [groups&.first&.kibela_id || 'R3JvdXAvMQ']
    folders = [{ groupId: group_ids.first, folderName: groups&.first&.folders&.first&.name || '12. 移行記事' }]
    author_id = user.kibela_id
    response = adapter.create_note(title, body, group_ids, folders, author_id)
    self.kibela_id = 
    self.kibela_updated_at = Time.now
    self.save!
  end
end
