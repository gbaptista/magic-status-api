require 'json'
require 'roda'

require './mpris'

class App < Roda
  MAX_LENGTH = 80

  def build_message(data)
    return '' unless data['Metadata']['xesam:artist']

    message = "#{data['Metadata']['xesam:artist']} - #{data['Metadata']['xesam:title']}"

    message = data['Metadata']['xesam:title'] if data['Metadata']['xesam:title'].index(
      data['Metadata']['xesam:artist']
    )

    message = message.sub(/- YouTube$/, '').strip if message[/- YouTube$/]

    message = "#{message[0..(MAX_LENGTH - 1)].strip}..." if message.length > MAX_LENGTH

    message
  end

  route do |r|
    r.get 'music' do
      response['Content-Type'] = 'application/json'

      dbus = []
      messages = []

      MPRIS.meta.each do |data|
        dbus << data
        next if data['Metadata']['xesam:title'] == ''

        messages << build_message(data)
      end

      JSON.generate({ messages:, dbus: })
    end

    r.get 'music-progress' do
      response['Content-Type'] = 'application/json'

      dbus = []
      messages = []

      MPRIS.meta.each do |data|
        dbus << data

        next if data['Metadata']['xesam:title'] == ''

        message = build_message(data)

        message = { label: { text: message } }

        if data['Position'] && data['Metadata']['mpris:length'] && data['Metadata']['mpris:length'].positive?
          message[:progress] =
            { value: data['Position'] / data['Metadata']['mpris:length'].to_f }
        end

        messages << message
      end

      JSON.generate({ messages:, dbus: })
    end

    r.get 'time' do
      response['Content-Type'] = 'application/json'

      time = Time.now

      messages = [time.strftime('%k:%M:%S'), time.strftime('%k:%M')]

      JSON.generate({ messages: })
    end
  end
end

run App.freeze.app
