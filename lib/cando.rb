require 'cando/authorization'

# Основной модуль.
module Cando
  class << self

    # Используется для применения ограничений к классу действий.
    def authorize(controller, &auth)

      # ApplicationController может не существовать ранее.
      if defined? ApplicationController and @first_include.nil?
        ApplicationController.class_exec do
          include Cando::Authorization::Helper
        end
        @first_include = false
      end

      yield Authorization.new(controller)
      self
    end
  end

  module Errors
    # Доступ к действию запрещен.
    class AccessDenied < StandardError
      attr_accessor :type

      def initialize(name)
        @type = name.to_s.chomp(??).to_sym
        super("You should be #{@type}")
      end
    end

    # Необходимый предикат не найден.
    class NoHelper < NoMethodError
      def initialize(name, controller)
        super("You must be define method '#{name}' for #{controller}", name)
      end
    end
  end
end