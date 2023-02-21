#!/usr/bin/env ruby -wU


require_relative 'lib/required'
begin
  PDF::TextGetter.get_from_folder(File.expand_path('.'))
rescue PDF::TextGetter::TextGetterError => e
  puts e.message.rouge
  puts e.backtrace.join("\n").rouge if debug?
  exit e.error_code
rescue Exception => e
  puts e.message.rouge
  puts e.backtrace.join("\n").rouge
  exit 1
end
exit 0
