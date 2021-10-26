module Telerobot
  module Types
    class Award < Base
      attribute :title, String
    end

    class Country < Base
      attribute :title, String
      attribute :code, String
    end

    class User < Base
      attribute :id, Integer
      attribute :first_name, String
      attribute :last_name, String
      attribute :country, Country
      attribute :awards, array_of(Award)
    end

    class Report < Base
      attribute :id, Integer
      attribute :text, String
      attribute :date, Integer
      attribute :from, User
    end
  end
end
