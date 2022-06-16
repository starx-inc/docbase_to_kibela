class TransferRule < ActiveYaml::Base
  set_root_path Rails.root.join('storage')
  set_filename "transfer_rule"
end