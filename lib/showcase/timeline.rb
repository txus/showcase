require 'repository'

module Showcase
  class Timeline
    include Enumerable

    def initialize(user)
      @user = user
    end

    def each(&block)
      if block
        statuses.each(&block)
      else
        statuses.each
      end
    end

    def statuses
      Repository.for(:status).viewable_by(user.id)
    end

    private
    attr_reader :user
  end
end
