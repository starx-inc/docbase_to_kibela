class Group < ApplicationRecord
  belongs_to :post

  def build_by_docbase(obj)
    self.attributes = {
      name: obj[:name]
    }
    self
  end
end
