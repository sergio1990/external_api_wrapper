module ExternalApiWrapper
  module Configurable
    REQUIRED_CONFIG_ATTRIBUTES = %i[base_url base_url=].freeze

    InvalidConfigClassError = Class.new(BaseError)

    def self.extended(target_module)
      _add_module_attributes(target_module)
      _provide_attributes_defaults(target_module)
      _add_config_method(target_module)
    end

    class << self
      private

      # rubocop:disable Metrics/MethodLength
      def _add_module_attributes(target_module)
        class << target_module
          attr_accessor :config_class

          def config_class=(klass)
            REQUIRED_CONFIG_ATTRIBUTES.each do |attr_name|
              next if klass.instance_methods.include?(attr_name)
              raise InvalidConfigClassError,
                "The config object should has required attribute `##{attr_name}!`"
            end
            @config_class = klass
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      def _provide_attributes_defaults(target_module)
        target_module.config_class = ::ExternalApiWrapper::Config
      end

      def _add_config_method(target_module)
        target_module.instance_eval do
          def config(&_block)
            @config ||= config_class.new
            block_given? ? yield(@config) : @config
          end
        end
      end
    end
  end
end
