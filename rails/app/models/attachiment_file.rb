# == Schema Information
#
# Table name: attachiment_files
#
#  id                :string           not null, primary key
#  name              :string(2048)
#  url               :string(2048)
#  markdown          :text
#  local_path        :string(2048)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kibela_id         :string
#  kibela_updated_at :datetime
#
class AttachimentFile < ApplicationRecord
  include Docbase::BaseModule
  has_many :post_attachiment_file
  has_many :post, through: :post_attachiment_file

  MIME_TYPE_TABLE = {
    "png" => "image/png",
    "jpeg" => "image/jpeg",
    "pdf" => "application/pdf",
    "jpg" => "image/jpeg",
    "xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "csv" => "text/csv",
    "gif" => "image/gif",
    "pptx" => "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "doc" => "application/msword",
    "xls" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "bin" => "application/octet-stream",
    "zip" => "application/zip",
    "key" => "application/keynote",
    "mov" => "video/quicktime",
    "docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "mp4" => "video/mp4",
    "yml" => "text/yaml",
    "mp3"=> "audio/mpeg",
    "xlsm" => "application/octet-stream",
    "ai" => "application/octet-stream",
    "txt" => "text/plain",
    "aac" => "audio/aac",
    "m4a" => "audio/aac",
    "json" => "application/json",
    "toesella_external" => "text/plain",
    "rb" => "text/plain",
    "お支払い方法_json" => "text/plain",
    "お届け先情報_json" => "text/plain",
    "定期コース確認画面_json" => "text/plain",
    "定期のお届け日の確認_json" => "text/plain",
    "お申し込み確認_json" => "text/plain",
    "購入履歴_json" => "text/plain",
    "js" => "text/javascript"
  }

  def build_by_docbase(obj)
    self.attributes = {
      name: obj[:name],
      url: obj[:url],
      markdown: obj[:markdown],
      local_path: AttachimentFile.get_file(obj[:id]),
      created_at: obj[:created_at],
      updated_at: obj[:created_at]
    }
    self
  end

  def local_file_path_update!
    self.local_path = File.join(Rails.root.to_s, "attachments", AttachimentFile.last.url.split('/').last)
    self.save!
  end

  def data_uri
    "data:#{mime_type};base64,#{base64encoded_file}"
  end

  def base64encoded_file
    Base64.strict_encode64(File.open(local_path, "rb").read)
  end

  def mime_type
    extension = name.split(".").last.downcase
    mt = MIME_TYPE_TABLE[extension]
    mt = "text/plain" unless mt
    mt
  end

  def upload_to_kibela!
    adapter = Kibela::Adapter.new
    response = adapter.craete_attachment(name, data_uri)
    self.kibela_id = response.data.upload_attachment_with_data_url.attachment.path
    self.save!
  end
end
