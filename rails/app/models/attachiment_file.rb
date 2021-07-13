class AttachimentFile < ApplicationRecord
  include Docbase::BaseModule
  has_many :post_attachiment_file
  has_many :post, through: :post_attachiment_file

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
end
