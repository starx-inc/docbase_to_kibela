class KibelaGroup < ActiveHash::Base
  require 'yaml'
  field :name

  class << self
    def sync_to_file
      serialize_objects = all.map(&:attributes)
      YAML.dump(serialize_objects, Rails.root.join('storage', 'kibela_groups.yml'))
    end

    def load(force=false)
      if count.zero? || force
        delete_all
        return unless File.exist? Rails.root.join('storage', 'kibela_groups.yml')
        array = YAML.load_file(Rails.root.join('storage', 'kibela_groups.yml'))
        array.map {|row| self.new(row)}.each(&:save!)
      end
    end

    def load_by_kibela
      adapter = Kibela::Adapter.new
      responses = adapter.get_groups
      delete_all
      responses.data.groups.nodes.map do |node|
        self.new(id: node.id, name: node.name)
      end.each(&:save!)
    end
  end




end