require 'yaml'

require './mpris'

RSpec.describe MPRIS do
  it do
    expect(MPRIS.parts(
             "(<{'xesam:album': <''>, 'xesam:artist': <['Some Artist']>, 'xesam:title': <'Song Name'>}>,)"
           )).to eq(
             ["'xesam:album': <''>", "'xesam:artist': <['Some Artist']>", "'xesam:title': <'Song Name'>"]
           )

    expect(MPRIS.parts(
             "(<{'xesam:album': <''>, 'xesam:artist': <['Another Artist']>, 'xesam:title': <\"Another Song' Name\">}>,)"
           )).to eq(
             ["'xesam:album': <''>", "'xesam:artist': <['Another Artist']>", "'xesam:title': <\"Another Song' Name\">"]
           )

    expect(MPRIS.parse_item("'xesam:title': <'Song Name'>")).to eq(
      { key: 'xesam:title', value: 'Song Name' }
    )

    expect(MPRIS.parse_item("'xesam:title': <\"Another Song' Name\">")).to eq(
      { key: 'xesam:title', value: "Another Song' Name" }
    )

    expect(MPRIS.parse(
             "(<{'xesam:album': <''>, 'xesam:artist': <['Some Artist']>, 'xesam:title': <'Song Name'>}>,)"
           )).to eq(
             { 'xesam:album' => '', 'xesam:artist' => 'Some Artist', 'xesam:title' => 'Song Name' }
           )

    expect(MPRIS.parse(
             "(<{'xesam:album': <''>, 'xesam:artist': <['Another Artist']>, 'xesam:title': <\"Another Song' Name\">}>,)"
           )).to eq(
             { 'xesam:album' => '', 'xesam:artist' => 'Another Artist', 'xesam:title' => "Another Song' Name" }
           )

    expect(MPRIS.parse(
             "(<{'mpris:length': <int64 5313641000>, 'mpris:trackid': <objectpath '/org/mpris/MediaPlayer2/TrackList/NoTrack'>, 'xesam:album': <''>, 'xesam:artist': <['']>, 'xesam:title': <''>}>,)"
           )).to eq(
             { 'mpris:length' => 'int64 5313641000',
               'mpris:trackid' => "objectpath '/org/mpris/MediaPlayer2/TrackList/NoTrack'", 'xesam:album' => '', 'xesam:artist' => '', 'xesam:title' => '' }
           )

    expect(MPRIS.parse(
             "(<{'xesam:artist': <['Artist & Another']>, 'xesam:title': <'Song (Live)'>}>,)"
           )).to eq(
             { 'xesam:artist' => 'Artist & Another', 'xesam:title' => 'Song (Live)' }
           )
  end
end
