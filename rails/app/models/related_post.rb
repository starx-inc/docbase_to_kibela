# == Schema Information
#
# Table name: related_posts
#
#  id                :bigint           not null, primary key
#  reference_post_id :bigint           not null
#  source_post_id    :bigint           not null
#  converted         :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class RelatedPost < ApplicationRecord
  belongs_to :reference_post, class_name: "User", foreign_key: :reference_post_id
  belongs_to :source_post, class_name: "User", foreign_key: :source_post_id
end
