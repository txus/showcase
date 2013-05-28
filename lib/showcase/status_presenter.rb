class StatusPresenter
  def initialize(status)
    @status = status
  end

  def text
    status.text
  end

  private
  attr_reader :status
end
