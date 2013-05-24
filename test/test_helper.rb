require 'cando'

# Классы и методы, которые должны существовать при использовании библиотеки.

class ApplicationController
  include Cando::Authorization::Helper
end

class Controller < ApplicationController
  # Internal.
  def self.filters
    @filters ||= []
  end

  def self.before_filter(*actions, &filter)
    self.filters << filter
  end

  def owner?; true; end

  def admin?; false; end
end