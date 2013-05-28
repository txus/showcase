require 'showcase/timeline'
require 'showcase/status_presenter'

class TimelineController < ApplicationController
  before_filter :authenticate_user!

  def show
    @statuses = timeline.map(&StatusPresenter.method(:new))
  end

  private

  def timeline
    @timeline ||= Showcase::Timeline.new(current_user)
  end
end