#!/usr/bin/ruby

require 'cinch'
require 'pry'

module Cinch
  class Logger
    class OutputLogger < Logger

    end
  end
end




bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'mynick'
    c.user = 'nickuser'
    c.server = 'irc.freenode.org'
    c.channels = ["#cinch-bots"]
  end

  on :channel,/.*/ do |m|
    m.reply "Yep."
  end
end

binding.pry

bot.start
