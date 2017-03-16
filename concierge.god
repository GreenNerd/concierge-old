God.watch do |w|
  w.name = 'natapp'
  w.start = "#{File.dirname(__FILE__)}/bin/natapp"
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end
