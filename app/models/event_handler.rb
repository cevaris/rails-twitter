class EventHandler
  def initialize(logger)
    @logger   = logger
    @messages = []
  end

  def fire(event)
    @messages.push(event)
  end

  def flush
    if @messages.present?
      @logger.write(@messages) 
    end
  end
end
