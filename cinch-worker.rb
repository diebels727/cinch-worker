#!/usr/bin/ruby

require 'cinch'
require 'fileutils'
require 'ffaker'
require 'optparse'
require 'tempfile'
require 'pry'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: cinch-worker.rb [options]"

  opts.on("-s","--server SERVER","IRC Server") do |s|
    options[:server] = s
  end
  opts.on("-c","--channel \"CHANNEL\"","IRC Channel") do |c|
    if c[0] == '#'
      options[:channel] = c
    else
      options[:channel] = "##{c}"
    end
  end
  opts.on("--silent","Run silently") do
    options[:silent] = true
  end
  opts.on("--output","Direct output to outfile") do
    options[:output] = true
  end
  opts.on("-l","--log LOG","Log file name") do |l|
    options[:log] = l
  end
end.parse!

module IRC
  class Config
    class << self
      attr_accessor :server,:channel,:channels,:nick,:user,:log
    end
  end
end

IRC::Config.server = options[:server] #'irc.freenode.org'
IRC::Config.channel = options[:channel] #'#cinch-bots'
IRC::Config.channels = [IRC::Config.channel]
IRC::Config.nick = Faker::Internet.user_name
IRC::Config.user = Faker::Internet.email
IRC::Config.log = options[:log]

class LoggerPlugin
  include Cinch::Plugin

  listen_to :connect,    :method => :setup
  listen_to :disconnect, :method => :cleanup
  listen_to :channel,    :method => :log

  def initialize(*args)
    super
    @format = "%Y%m%d%H%M%S"
    name = ::IRC::Config.log || Time.now.strftime("%Y%m%d")
    if !Dir.exists?(IRC::Config.server + "/" + IRC::Config.channel)
      FileUtils.mkpath(IRC::Config.server+"/"+IRC::Config.channel)
    end
    @filename = "#{IRC::Config.server}\/#{IRC::Config.channel}\/#{name}.log"
    @logfile          = File.open(@filename,"a")
    @last_time_check  = Time.now
  end

  def setup(*)
    time = Time.now.strftime(@format)
  end

  def cleanup(*)
    @logfile.close
    time = Time.now.strftime(@format)
  end

  def log(msg)
    time = Time.now.strftime(@format)
    username = msg.user.name
    message = msg.message
    @logfile.puts("{\"timestamp\": \"#{time}\",\"username\":\"#{username}\",\"prefix\":\"#{msg.prefix\",\"message\":\"#{message}\"")
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

if options[:silent]
  loggers = Cinch::LoggerList.new
  bot.loggers = loggers
end

if options[:output]
  if !Dir.exists?(IRC::Config.server + "/" + IRC::Config.channel)
    FileUtils.mkpath(IRC::Config.server+"/"+IRC::Config.channel)
  end
  name = Time.now.strftime("%Y%m%d")
  filename = "#{IRC::Config.server}\/#{IRC::Config.channel}\/#{name}.output"
  bot.loggers << Cinch::Logger::FormattedLogger.new(File.new(filename,'a'))
end

bot.start
