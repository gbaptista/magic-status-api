require 'open3'

module MPRIS
  SOURCES = <<~BASH
    dbus-send --session --dest=org.freedesktop.DBus \
      --type=method_call --print-reply /org/freedesktop/DBus \
      org.freedesktop.DBus.ListNames | grep org.mpris.MediaPlayer2 |
      awk -F\\" '{print $2}' | cut -d '.' -f4- | sort
  BASH

  METADATA = <<~BASH
    gdbus call \
      --session \
      --dest={id} \
      --object-path /org/mpris/MediaPlayer2 \
      --method org.freedesktop.DBus.Properties.Get \
      org.mpris.MediaPlayer2.Player Metadata
  BASH

  def meta
    sources, = Open3.capture2(SOURCES)
    sources = sources.split("\n")

    result = []

    sources.each do |source|
      id = "org.mpris.MediaPlayer2.#{source}"

      meta, = Open3.capture2(METADATA.sub('{id}', id).to_s)

      result << parse(meta)
    end

    result
  end

  def parse(raw)
    result = {}

    parts(raw).map { |r| parse_item(r) }.each do |item|
      result[item[:key]] = item[:value]
    end

    result
  end

  def parts(raw)
    result = raw.sub(/^\(<\{/, '').sub(/\}>,\)$/, '').split('>, ').map do |partial|
      "#{partial}>"
    end

    result[-1] = result.last[0..(result.last.length - 2)]

    result
  end

  def parse_item(raw)
    parts = raw.split(': <')

    key = parts[0]
    value = "<#{parts[1]}"

    4.times do
      ['"', "'", ['[', ']'], ['<', '>']].each do |params|
        key = smart_strip(key, params)
        value = smart_strip(value, params)
      end
    end

    { key:, value: }
  end

  def smart_strip(content, params)
    first = params
    last = params

    first, last = params if params.is_a? Array

    result = content.strip

    if result[0] == first && result[-1] == last
      result = result[1..(result.length - 2)]
    end

    result
  end

  module_function :meta, :parse, :parts, :parse_item, :smart_strip
end
