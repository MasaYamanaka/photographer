#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "optparse"
require "active_resource"

opts = OptionParser.new do |opt|
  OPTS = {}
  opt.banner = <<"EOS"
NAME
    #{File.basename($0, '.*')} - Create, edit or destroy an article

SYNOPSIS
    ruby #{File.basename($0)} [options] new
    ruby #{File.basename($0)} [options] edit id
    ruby #{File.basename($0)} [options] destroy id

DESCRIPTION
    Create, edit or destroy an article

OPTIONS
EOS
  opt.on("-v", "--[no-]verbose", "Run verbosely") {|v| OPTS[:verbose] = v}
  opt.on('-t text','New body text') {|v| OPTS[:t] = v}
end
opts.parse!

if OPTS[:verbose]
  ActiveResource::Base.logger = Logger.new($stderr)
end

class Article < ActiveResource::Base
  self.site = 'http://localhost:3030'
end

if ARGV.length < 1
  puts opts
  exit
else
  subcommand = ARGV.shift

  case subcommand
  when "new"
    title = "Hello Rails"
    body = "I am on Rails!"
    status = "public"

    print "Type in title [#{title}]> "
    answer1 = STDIN.gets.chomp
    title = answer1 unless answer1 == ""
    print "Type in body [#{body}]> "
    answer2 = STDIN.gets.chomp
    body = answer2 unless answer2 == ""
    print "Type in status [#{status}]> "
    answer3 = STDIN.gets.chomp
    status = answer3 unless answer3 == ""

    article = Article.new(title: title, body: body, status: status)
    article.save
  when "edit"
    article = Article.find(ARGV[0])
    if OPTS[:t]
      article.body = OPTS[:t]
    else
      print "Type in new body text [#{article.body}]> "
      answer = STDIN.gets.chomp
      # binding.irb
      article.body = answer unless answer == ""
    end
    article.save
    # p article.reload
  when "destroy"
    article = Article.find(ARGV[0])
    print "Are you sure you want to destroy this article (#{article.title})? [y/N]> "
    answer = STDIN.gets.chomp
    if answer.downcase == "y"
      article.destroy
    end
  end
end
