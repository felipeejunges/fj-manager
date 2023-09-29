# frozen_string_literal: true

json.array! @clients, partial: 'clients/client', as: :client
