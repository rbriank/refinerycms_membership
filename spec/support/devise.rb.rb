module Devise
  module Encryptors
    class Plain < Base
      class << self
        def digest(password, *args)
          password
        end

        def salt(*args)
          ""
        end
      end
    end
  end
end

Devise.encryptor = :plain