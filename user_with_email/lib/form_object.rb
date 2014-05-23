module FormObject
  class Base
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming

    attr_accessor :user

    def initialize(user)
      @user = user
    end

    class << self
      def attributes(*names, of: nil)
        if of.nil?
          attr_accessor *names
        else
          names.each do |attribute|
            delegate attribute, to: :user
            delegate "#{attribute}=", to: :user
          end
        end
      end

      alias_method :attribute, :attributes
    end

  end
end