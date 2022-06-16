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
require 'test_helper'

class AttachimentFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
