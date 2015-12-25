directory = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{directory}/reschedule/*.rb") { |file| require file }

module Reschedule
end
