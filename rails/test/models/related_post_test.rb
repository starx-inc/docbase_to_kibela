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
require 'test_helper'

class RelatedPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
