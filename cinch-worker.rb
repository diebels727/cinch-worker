#!/usr/bin/ruby

require 'cinch'
require 'fileutils'
require 'ffaker'
require 'pry'

module IRC
  class Config
    class << self
      attr_accessor :server,:channel,:channels,:nick,:user
    end
  end
end

IRC::Config.server = 'irc.freenode.org'
IRC::Config.channel = '#cinch-bots'
IRC::Config.channels = [IRC::Config.channel]
IRC::Config.nick = 'undulatedLo'
IRC::Config.user = '2lokey'

class LoggerPlugin
  include Cinch::Plugin

  listen_to :connect,    :method => :setup
  listen_to :disconnect, :method => :cleanup
  listen_to :channel,    :method => :log

  def initialize(*args)
    super
    @format = "%Y%m%d%H%M%S"
    name = Time.now.strftime("%Y%m%d")
    if !Dir.exists?(IRC::Config.server)
      FileUtils.mkpath(IRC::Config.server+"/"+IRC::Config.channel)
    end
    @filename = "#{IRC::Config.server}\/#{IRC::Config.channel}\/#{name}.log"
    @logfile          = File.open(@filename,"a")
    @last_time_check  = Time.now
  end

  def setup(*)
    time = Time.now.strftime(@format)
    @logfile.puts("[#{time}]: Starting up ...")
  end

  def cleanup(*)
    @logfile.close
    time = Time.now.strftime(@format)
    @logfile.puts("[#{time}]: Shutting down ...")
  end

  def log(msg)
    time = Time.now.strftime(@format)
    username = msg.user.name
    message = msg.message
    @logfile.puts("[#{time}][#{username}][#{msg.prefix}]: #{message}")
    @logfile.flush #write messages immediately
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = IRC::Config.nick
    c.user = IRC::Config.user
    c.server = IRC::Config.server
    c.channels = IRC::Config.channels
    c.plugins.plugins = [LoggerPlugin]
  end
end

bot.start
