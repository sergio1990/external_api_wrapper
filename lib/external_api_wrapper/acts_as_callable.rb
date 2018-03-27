module ExternalApiWrapper
  module ActsAsCallable
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def call(*opts, &block)
        new(*opts).call(&block)
      end
    end
  end
end
