require 'repository'

module MemoryRepository
  module Model
    def self.new(*attributes, &block)
      Class.new do
        attr_accessor *attributes
        def initialize(attrs = {})
          attrs.each { |k,v| send(:"#{k}=", v) }
        end
      end.tap { |klass| klass.class_eval(&block) if block }
    end
  end

  User = Model.new(:id, :username) do
    def follow(user)
      followings = ::Repository.for(:following)
      followings.save followings.new(from_id: self.id, to_id: user.id)
    end

    def followed_users
      ::Repository.for(:user).followed_by(self.id)
    end

    def post_status(text)
      statuses = ::Repository.for(:status)
      statuses.save statuses.new(text: text, user_id: self.id)
    end
  end

  Status = Model.new(:id, :text, :user_id)
  Following = Model.new(:id, :from_id, :to_id)

  class Repository
    def initialize
      @records = {}
      @id = 1
    end

    def model_class
      raise NotImplementedError
    end

    def new(attributes = {})
      model_class.new(attributes)
    end

    def save(object)
      object.id = @id
      @records[@id] = object
      @id += 1
      return object
    end

    def find_by_id(n)
      @records[n.to_i]
    end

    def find_by_ids(ns)
      @records.select { |k,v| ns.include? k }.values
    end
  end

  UserRepository = Class.new(Repository) do
    def model_class; MemoryRepository::User; end
    def followed_by(follower_id)
      ids = ::Repository.for(:following).find_by_from_id(follower_id).map(&:to_id)
      find_by_ids(ids)
    end
  end

  StatusRepository = Class.new(Repository) do
    def model_class; MemoryRepository::Status; end
    def viewable_by(user_id)
      followed_user_ids = ::Repository.for(:user)
        .find_by_id(user_id)
        .followed_users
        .map(&:id)
      @records.select { |k, r| followed_user_ids.include? r.user_id }.values
    end
  end

  FollowingRepository = Class.new(Repository) do
    def model_class; MemoryRepository::Following; end
    def find_by_from_id(from_id)
      @records.select { |k, r| r.from_id == from_id.to_i }.values
    end
  end
end
