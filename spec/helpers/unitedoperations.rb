require 'digest'

def add_guid_reference_implementation(mock_line)
  line = mock_line.dup
  data = add_data(line)

  line[:event_guid] = Digest::SHA1.hexdigest data
  line
end

def add_data(line)
  data = minimum_data(line)
  add_data_one!(line, data)
  add_data_two!(line, data)
  data
end

def minimum_data(line)
  if line[:iso8601].nil?
    data = "#{line[:year]}#{line[:month]}#{line[:day]}" \
           "#{line[:hour]}#{line[:min]}#{line[:sec]}" \
           "#{line[:type].to_s}"
  else
    data = "#{line[:iso8601]}#{line[:type].to_s}"
  end
  data
end

def add_data_one!(line, data)
  data << line[:message] unless line[:message].nil?
  data << line[:victim] unless line[:victim].nil?
  data << line[:offender] unless line[:offender].nil?
  data
end

def add_data_two!(line, data)
  data << line[:server_time].to_s unless line[:server_time].nil?
  data << line[:damage].to_s unless line[:damage].nil?
  data << line[:distance].to_s unless line[:distance].nil?
  data
end
