class PostAttachimentFile < ApplicationRecord
  belongs_to :post
  belongs_to :attachiment_file

end
