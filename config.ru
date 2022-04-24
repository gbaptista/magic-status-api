require 'json'
require 'roda'

require './mpris'

class App < Roda
  route do |r|
    r.get 'music' do
      response['Content-Type'] = 'application/json'

      messages = []

      MPRIS.meta.each do |data|
        next if data['xesam:title'] == ''

        messages << "#{data['xesam:artist']} - #{data['xesam:title']}"
      end

      JSON.generate({ messages: })
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
