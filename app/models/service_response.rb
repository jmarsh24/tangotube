class ServiceResponse
  attr_reader :errors, :called
  attr_accessor :metadata

  def initialize
    @errors = []
    @metadata = {}
  end

  def return
    @called = true
    self
  end

  def successful?
    raise_not_called_exception unless called?
    @errors.empty? && called?
  end

  private

  def raise_not_called_exception
    raise Exceptions::ServiceNotPerformed,
          "You can't check whether this service has been successful, as you "\
          "haven't called it yet! Make sure your #call method returns the "\
          "'.return' method."
  end

  def called?
    @called
  end
end
