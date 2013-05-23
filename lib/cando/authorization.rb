=begin
  Используется для преобразования переданных ограничений в фильтры для действий.
=end
module Cando class Authorization
  def initialize(controller)
    @controller = controller
  end

=begin
  Используется для обработки методов вида `for_<name>`, которым передаются идентификаторы действий.

  Для каждого метода создается вспомогательный метод с тем же названием и определяется фильтр, выполняющий авторизацию.
=end
  def method_missing(name, *args)
    if /for_(?<helper>\w+)/ =~ name
      helper << '?'
      define_helper(name, helper)
      define_filter(helper, args)
      self
    end
  end

=begin
  Используется для создания вспомогательных методов, принимающих блок, выполняемый только если соответствующий предикат истинен. По умолчанию вспомогательные методы добавляются в ApplicationController.

  ~~~~~ ruby
    <%= for_admin { create_link } %>
  ~~~~~

  Ссылка будет отображаться только при положительном результате вызова метода `.admin?`.
=end
  def define_helper(name, helper)

    return if Helper.method_defined? name

    Helper.class_exec(name, helper) do |name, helper|
      define_method(name) { |&block| block.call if send(helper) }
    end

    ApplicationController.helper_method(name) if defined? ApplicationController
  end

=begin
  Используется для добавления фильтров, отвечающих за авторизацию. Действие будет разрешено только если соответствующий предикат истинен. Другие случаи считаются исключением.

  ~~~~~ ruby
    auth.for_owner *%i(new create)
  ~~~~~

  Доступ к переданным действиям будет разрешен только при положительном результате вызова метода `.owner?`.
=end
  def define_filter(name, actions)
    @controller.before_filter only: actions do |controller|
      controller.respond_to?(name) or
        raise Errors::NoHelper.new name, controller.class.name

      controller.send(name) or
        raise Errors::AccessDenied.new name
    end
  end

=begin
  Используется для хранения вспомогательных методов, когда в приложении осутствует класс ApplicationController.
=end
  module Helper
  end
end end