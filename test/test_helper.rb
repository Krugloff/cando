require 'cando'

# Классы и методы, которые должны существовать при использовании библиотеки.

class ApplicationController
  # Internal.
  def self.helpers
    @helpers ||= []
  end

  def self.helper_method(name)
    self.helpers << name
  end
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