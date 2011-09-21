if defined?(Rails) && Rails::VERSION::MAJOR == 3
  module Lolita
    module BankLink
      class Engine < Rails::Engine
      end
    end
  end
end
