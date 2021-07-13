class RelatedPost < ApplicationRecord
  belongs_to :reference_post, class_name: "User", foreign_key: :reference_post_id
  belongs_to :source_post, class_name: "User", foreign_key: :source_post_id
end
