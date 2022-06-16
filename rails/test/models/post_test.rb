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
#  kibela_updated_at :datetime
#
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
