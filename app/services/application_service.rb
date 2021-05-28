# frozen_string_literal: true

# a common service
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
