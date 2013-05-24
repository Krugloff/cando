# Cando

Библиотека для авторизации пользователей на основе существующих вспомогательных методов.

## Installation

Add this line to your application's Gemfile:

`gem 'cando', git: 'http://github.com/Krugloff/cando'`

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install cando --source 'http://github.com/Krugloff/cando'`

## Usage

~~~~~ ruby
  Cando.authorize(ArticlesController) do |auth|
    auth.for_client *%(show index)
    auth.for_owner *%(edit update delete)
    auth.for_admin *%(new create)
  end
~~~~~

ИЛИ

~~~~~ ruby
  class ApplicationController
    extend Cando
  end

  class ArticlesController < ApplicationController
    authorize do
      for_client *%(show index)
      for_owner *%(edit update delete)
      for_admin *%(new create)
    end
  end
~~~~~

+ Ограничение доступа может быть установлено с помощью любых методов вида `for_<helper>`;

+ Доступ к переданным действиям будет разрешен только при положительном результате вызова `.client?`,`.owner?`, `.admin?` в теле требуемого действия;

+ Отсутствие необходимого предиката считается исключением  
`Cando::Errors::NoHelper`

+ Запрет доступа считается исключением  
`Cando::Errors::AccessDenied`

+ Для ApplicationController (или Cando::Authorization::Helper) будут добавлены соответствующие вспомогательные методы, которые могут быть использованы в шаблонах.

  ~~~~~ ruby
    <%= for_admin { create_link } %>
  ~~~~~

  Ссылка будет отображаться только при положительном результате вызова метода `.admin?`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
