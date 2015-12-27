require 'active_support/all'
require 'httparty'
require 'kubeclient'
require 'rufus-scheduler'

directory = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{directory}/reschedule/**/*.rb") { |file| require file }

module Reschedule
  module_function

  def self.configure
    yield(configuration) if block_given?
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.logger
    @logger ||= begin
      logger = Logger.new(STDOUT)
      logger.progname = 'Reschedule'
      logger
    end
  end
end
