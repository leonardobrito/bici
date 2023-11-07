# frozen_string_literal: true

class UsersIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      email: {
        tokenizer: "keyword",
        filter: ["lowercase"]
      }
    }
  }

  index_scope User::Record
  field :email, analyzer: "email"
end
