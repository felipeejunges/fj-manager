require 'pagy/extras/bootstrap'

vars[:count] ||= (count = collection.count(:all)).is_a?(Hash) ? count.size : count 