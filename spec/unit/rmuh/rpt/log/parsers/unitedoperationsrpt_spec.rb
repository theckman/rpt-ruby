# -*- coding: UTF-8 -*-

describe RMuh::RPT::Log::Parsers::UnitedOperationsRPT do
  let(:uorpt) { RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new }

  context '::validate_opts' do
    it 'should not take more than one arg' do
      expect do
        uorpt.send(:regex_match, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect do
        uorpt.send(:regex_match)
      end.to raise_error ArgumentError
    end

    it 'should not fail if arg 1 is a Hash' do
      expect(
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts({})
      ).to be_nil
    end

    it 'should fail if arg 1 is an Array' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts([])
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a String' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts('')
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Regexp' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(//)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Fixnum' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(0)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Float' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(0.0)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is false' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(false)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is true' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(true)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is nil' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.validate_opts(nil)
      end.to raise_error ArgumentError
    end
  end

  context '::new' do
    it 'should not take more than one argument' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not fail if arg 1 is a hash' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new
      end.to_not raise_error
    end

    it 'should fail if arg 1 is an Array' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new([])
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a String' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new('')
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Regexp' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(//)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Fixnum' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(0)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is a Float' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(0.0)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is false' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(false)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is true' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(true)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is nil' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new(nil)
      end.to raise_error ArgumentError
    end

    it 'should return an instance of itself' do
      expect(uorpt).to be_an_instance_of(
        RMuh::RPT::Log::Parsers::UnitedOperationsRPT
      )
    end

    it 'should set @to_zulu to true if nothing provided' do
      expect(uorpt.instance_variable_get(:@to_zulu)).to be_truthy
    end

    it 'should set @timezone to America/Los_Angeles if nothing provided' do
      tz = TZInfo::Timezone.get('America/Los_Angeles')
      expect(uorpt.instance_variable_get(:@timezone)).to eql tz
    end
  end

  context '#regex_match' do
    it 'should take no more than one arg' do
      expect do
        uorpt.send(:regex_match, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        uorpt.send(:regex_match)
      end.to raise_error ArgumentError
    end

    it 'should return nil if line matches nothing' do
      expect(uorpt.send(:regex_match, '')).to be_nil
    end

    it 'should return a Hash if the line matches ANNOUNCEMENT' do
      l = '2014/02/16,  4:13:10 "############################# Start ' \
          'CO08_Escape_Chernarus_V1 #############################"'
      x = uorpt.send(:regex_match, l)
      expect(x).to be_an_instance_of Hash
      expect(x[:type]).to eql :announcement
    end

    it 'should return a Hash if the line matches WOUNDED' do
      l = '2014/02/16,  5:22:55 "4152.41 seconds: Sherminator (CIV) has ' \
          'been team wounded by Xcenocide (WEST) for 1.50828 damage."'
      x = uorpt.send(:regex_match, l)
      expect(x).to be_an_instance_of Hash
      expect(x[:type]).to eql :wounded
    end

    it 'should return a Hash if the line matches KILLED' do
      l = '2014/02/16,  4:11:42 "69.85 seconds: Olli (CIV) has been killed ' \
          'by Yevgeniy Nikolayev (EAST). Olli position: [6553.55,6961.92,' \
          '0.0015564] (GRID 0655306961). Yevgeniy Nikolayev position: ' \
          '[6498.62,6916.71,0.0204163] (GRID 0649806916). Distance between: ' \
          '71.1653 meters. Near players (100m): None."'
      x = uorpt.send(:regex_match, l)
      expect(x).to be_an_instance_of Hash
      expect(x[:type]).to eql :killed
    end

    it 'should return a Hash if the line matches DIED' do
      l = '2014/02/16,  5:15:06 "3683.58 seconds: Appe96 has died at ' \
          '[4602.18,7490.26,2.2435] (GRID 0460207490). Near players (100m): ' \
          '["Olli","nametag47","Villanyi"]"'
      x = uorpt.send(:regex_match, l)
      expect(x).to be_an_instance_of Hash
      expect(x[:type]).to eql :died
    end
  end

  context '#parse' do
    let(:loglines) do
      l1 = '2014/02/16,  5:15:06 "3683.58 seconds: Appe96 has died at ' \
           '[4602.18,7490.26,2.2435] (GRID 0460207490). Near players (100m):' \
           ' ["Olli","nametag47","Villanyi"]"'
      l2 = '2014/02/16,  4:11:42 "69.85 seconds: Olli (CIV) has been killed ' \
           'by Yevgeniy Nikolayev (EAST). Olli position: [6553.55,6961.92,' \
           '0.0015564] (GRID 0655306961). Yevgeniy Nikolayev position: ' \
           '[6498.62,6916.71,0.0204163] (GRID 0649806916). Distance between:' \
           ' 71.1653 meters. Near players (100m): None."'
      ["#{l1}", "#{l2}"]
    end

    it 'should not take more than one arg' do
      expect do
        uorpt.parse(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect do
        uorpt.parse
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is not an instance of Array' do
      expect do
        uorpt.parse(nil)
      end.to raise_error ArgumentError
    end

    it 'should return an Array' do
      ll = []
      x = uorpt.parse(ll)
      expect(x).to be_an_instance_of Array
    end

    it 'should return an Array of hashes if a line matches' do
      x = uorpt.parse(loglines)
      expect(x).to be_an_instance_of Array
      expect(x.empty?).to be_falsey
      x.each { |y| expect(y).to be_an_instance_of Hash }
    end
  end
end
