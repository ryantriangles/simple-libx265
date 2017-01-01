#!/usr/bin/env ruby
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Simple libx265"

  opts.on('-iFILENAME', :REQUIRED, 'Input video file') do |i|
    options[:input] = i
  end

  opts.on('--crf constant_rate_factor', Integer, 'Constant rate factor') do |crf|
    options[:crf] = crf
  end

  opts.on('--bitrate bitrate', Integer, 'Bitrate') do |bitrate|
    options[:bitrate] = bitrate
  end

  opts.on('--offset offset', String, 'HH:MM:SS') do |offset|
    options[:offset] = offset
  end

  opts.on('--dest destination', String, 'Destination folder') do |dest|
    options[:dest] = dest
  end

  opts.on('--preset preset', String, 'Preset') do |preset|
    options[:preset] = preset
  end

  opts.on('--res resolution', String, '480p, 576p, 720p, or 1080p') do |res|
    options[:res] = case res
                    when '480p'
                      '-s 960x480'
                    when '576p'
                      '-s 1024x576'
                    when '720p'
                      '-s 1280x720'
                    when '1080p'
                      '-s 1920x1080'
                    else
                      ''
                    end
  end

  opts.on('--segment segment', String, 'Segment time') do |seg|
    options[:segment] = "-t #{seg}"
  end
end.parse!

if options[:crf] and options[:bitrate] then
  puts "ERROR: You can't specify both a constant rate factor and a bitrate!"
  exit
end

output_filename = options[:input].split('\\')[-1].rpartition('.')[0] + ".mp4"
probe = `ffprobe -i "#{options[:input]}" 2>&1`
preset = options[:preset] || "medium"

if options[:offset] then
  offset = "-ss #{options[:offset]}"
else
  offset = ""
end

unless options[:segment]
  options[:segment] = ""
end


if options[:crf] then
  `ffmpeg -y #{offset} -i "#{options[:input]}" #{options[:res]} -c:v libx265 -preset #{preset} -x265-params crf=#{options[:crf]} -c:a copy #{options[:segment]} "#{options[:dest]}\\#{output_filename}"`
end

if options[:bitrate] then
  `ffmpeg -y #{offset} -i "#{options[:input]} #{options[:res]} -c:v libx265 -preset #{preset} -x265-params -b:v #{options[:bitrate]}k -c:a copy #{options[:segment]} "#{options[:dest]}\\#{output_filename}"`
end
