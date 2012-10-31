require 'refinerycms-core'
require 'refinerycms-settings'

module Refinery
  autoload :MembershipsGenerator, 'generators/refinery/memberships/memberships_generator'

  module Memberships
    require 'refinery/memberships/engine'

    autoload :Version, 'refinery/memberships/version'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
