class FakeJob
  attr_accessor :id

  def initialize
    @id = SecureRandom.uuid
  end
end

def run_job(klass)
  klass.new.call(FakeJob.new, Time.now)
end
