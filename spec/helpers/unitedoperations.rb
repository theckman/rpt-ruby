# -*- coding: UTF-8 -*-
require 'digest'

def spec_guid_reference_implementation(mock_line)
  line = mock_line.dup
  data = spec_add_data(line)

  line[:event_guid] = Digest::SHA1.hexdigest data
  line
end

def spec_add_data(line)
  data = spec_minimum_data(line)
  spec_add_data_one!(line, data)
  spec_add_data_two!(line, data)
  data
end

def spec_minimum_data(line)
  if line[:iso8601].nil?
    data = "#{line[:year]}#{line[:month]}#{line[:day]}" \
           "#{line[:hour]}#{line[:min]}#{line[:sec]}" \
           "#{line[:type]}"
  else
    data = "#{line[:iso8601]}#{line[:type]}"
  end
  data
end

def spec_add_data_one!(line, data)
  data << line[:message] unless line[:message].nil?
  data << line[:victim] unless line[:victim].nil?
  data << line[:offender] unless line[:offender].nil?
  data << line[:server_time].to_s unless line[:server_time].nil?
  data << line[:damage].to_s unless line[:damage].nil?
  data
end

def spec_add_data_two!(line, data)
  data << line[:distance].to_s unless line[:distance].nil?
  data << line[:player] unless line[:player].nil?
  data << line[:player_beguid] unless line[:player_beguid].nil?
  data << line[:channel] unless line[:channel].nil?
  data
end

def spec_killed_line
  {
    type: :killed, year: 2014, month: 2, day: 16, hour: 0, min: 7, sec: 22,
    server_time: 4517.73, victim: 'Althain', victim_team: 'WEST',
    offender: 'Geth', offender_team: 'CIV', iso8601: '2014-02-16T00:07:22Z',
    victim_position: '12789.4,12697.3,0.00152588', victim_grid: '1278912697',
    offender_position: '12795.3,12704.7,0.00137329', distance: 9.5636,
    offender_grid: '1279512704', nearby_players: ['Brig.Gold101st'],
    dtg: '160007Z FEB 14'
  }
end

def spec_died_line
  {
    type: :died, year: 2014, month: 2, day: 16, hour: 1, min: 30, sec: 53,
    server_time: 4280.29, victim_position: '4194.01,1633.02,0.00143814',
    dtg: '160130Z FEB 14', nearby_players: [
      'Synxe', 'Naught', 'Kiesbye', 'Aphex', 'Jeff Kid', 'Adam1', 'Lord Yod',
      'Small', 'Mixtrate', 'James', 'Nickster', 'Tankman', 'JamaicanJews',
      'Besiden'],
    iso8601: '2014-02-16T01:30:53Z', victim_grid: '0419401633'
  }
end

def spec_wounded_line
  {
    type: :wounded, year: 2014, month: 2, day: 16, hour: 0, min: 7, sec: 21,
    server_time: 4517.55, victim: 'Althain', victim_team: 'WEST',
    offender: 'Geth', offender_team: 'CIV', damage: 0.0780736,
    iso8601: '2014-02-16T00:07:21Z', dtg: '160007Z FEB 14'
  }
end

def spec_announcement_line
  {
    type: :announcement, year: 2014, month: 2, day: 16, hour: 1, min: 47,
    sec: 43, head: '#############################', dtg: '160147Z FEB 14',
    message: 'Start CO30_Operation_Trident_v2C',
    tail: '#############################',
    iso8601: '2014-02-16T01:47:43Z'
  }
end

def spec_chat_line
  {
    type: :chat, hour: 5, min: 43, sec: 29, channel: 'group', player: 'Chris',
    message: 'Ew ban Mara', year: 2014, month: 2, day: 16,
    iso8601: '2014-02-16T05:43:29Z', dtg: '160543Z FEB 14',
    event_guid: '8365d6da7375fde963371004b52012af0ef03678'
  }
end

def spec_beguid_line
  {
    type: :guid, hour: 5, min: 53, sec: 49,
    player_beguid: 'fd5c7ecf1f986badce8b5ece3f4d853a', player: 'Brock Samson',
    year: 2014, month: 2, day: 16, iso8601: '2014-02-16T05:53:49Z',
    dtg: '160553Z FEB 14',
    event_guid: '89aeda0db1f774936619cd3e3ce392e28c1a3871'
  }
end
