require 'cando/authorization'

# Основной модуль.
module Cando
=begin
  Метод предоставлен для применения ограничений к классу действий.

  ~~~~~ ruby
    Cando.authorize(ArticlesController) do |auth|
      # permissions
    end
  ~~~~~
=end
  def self.authorize(controller, &auth)
    yield Authorization.new(controller)
    self
  end

=begin
  Метод предоставлен для расширения классов действий.

  ~~~~~ ruby
    class ApplicationController
      extend Cando
    end

    class ArticlesController < ApplicationController
      authorize do
        # permissions
      end
    end
  ~~~~~
=end
  def authorize(&auth)
    Authorization.new(self).instance_exec &auth
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