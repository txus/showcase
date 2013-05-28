require 'repository'

class User < ActiveRecord::Base
  has_many :followed_users, through: :followings, foreign_key: :from_id

  def follow(user)
    followings = ::Repository.for(:following)
    followings.save followings.new(from_id: self.id, to_id: user.id)
  end

  def post_status(text)
    statuses = ::Repository.for(:status)
    statuses.save statuses.new(text: text, user_id: self.id)
  end
end

module ActiveRecordRepository
  class Repository
    def model_class
      raise NotImplementedError
    end

    def new(attributes = {})
      model_class.new(attributes)
    end

    def save(object)
      object.save
      return object
    end

    def find_by_id(n)
      model_class.find(n)
    end

    def find_by_ids(ns)
      model_class.where(id: ns)
    end
  end

  UserRepository = Class.new(Repository) do
    def model_class; ::User; end
  end

  StatusRepository = Class.new(Repository) do
    def model_class; ::Status; end
    def viewable_by(user_id)
      followed_user_ids = ::Repository.for(:user)
        .find_by_id(user_id)
        .followed_users
        .map(&:id)

      model_class.where(user_id: followed_user_ids)
    end
  end

  FollowingRepository = Class.new(Repository) do
    def model_class; ::Following; end
    def find_by_from_id(from_id)
      model_class.where(from_id: from_id)
    end
  end
end
