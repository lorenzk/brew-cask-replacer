#!/usr/bin/env ruby
require 'fileutils'

# Array of installed applications to exclude. Ex: Firefox Beta
# exclude = ["firefox"]
exclude = []

Dir.glob('/Applications/*.app').each do |path|
  next if File.symlink?(path)

  # Remove version numbers at the end of the name
  app = path.slice(14..-1).sub(/.app\z/, '').sub(/ \d*\z/, '')
  searchresult = `brew cask search #{app}`
  puts searchresult

  next unless searchresult =~ /Exact match/

  token = searchresult.split("\n")[1]

  next unless exclude.grep(/#{token}/).empty?

  puts "Installing #{token}..."
  begin
    FileUtils.mv(path, File.expand_path('~/.Trash/'))
  rescue Errno::EPERM, Errno::EEXIST
    puts "ERROR: Could not move #{path} to Trash"
    next
  end
  puts `brew cask install #{token} --appdir=/Applications`
end
