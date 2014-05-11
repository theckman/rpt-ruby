# -*- coding: UTF-8 -*-

describe RMuh::RPT::Log::Util::UnitedOperationsRPT do
  context '::DTR' do
    it 'should be an instance of String' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsRPT::DTR
      ).to be_an_instance_of String
    end
  end

  context '::KILLED' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsRPT::KILLED
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  4:11:42 "69.85 seconds: Olli (CIV) has been killed ' \
          'by Yevgeniy Nikolayev (EAST). Olli position: [6553.55,6961.92,' \
          '0.0015564] (GRID 0655306961). Yevgeniy Nikolayev position: ' \
          '[6498.62,6916.71,0.0204163] (GRID 0649806916). Distance between: ' \
          '71.1653 meters. Near players (100m): None."'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::KILLED.match(l)
      expect(m).to_not be_nil
      expect(m['year']).to eql '2014'
      expect(m['month']).to eql '02'
      expect(m['day']).to eql '16'
      expect(m['hour']).to eql '4'
      expect(m['min']).to eql '11'
      expect(m['sec']).to eql '42'
      expect(m['server_time']).to eql '69.85'
      expect(m['victim']).to eql 'Olli'
      expect(m['victim_team']).to eql 'CIV'
      expect(m['offender']).to eql 'Yevgeniy Nikolayev'
      expect(m['offender_team']).to eql 'EAST'
      expect(m['victim_position']).to eql '6553.55,6961.92,0.0015564'
      expect(m['victim_grid']).to eql '0655306961'
      expect(m['offender_position']).to eql '6498.62,6916.71,0.0204163'
      expect(m['offender_grid']).to eql '0649806916'
      expect(m['distance']).to eql '71.1653'
      expect(m['nearby_players']).to eql 'None.'
    end
  end

  context '::DIED' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsRPT::DIED
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  5:15:06 "3683.58 seconds: Appe96 has died at ' \
          '[4602.18,7490.26,2.2435] (GRID 0460207490). Near players (100m): ' \
          '["Olli","nametag47","Villanyi"]"'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::DIED.match(l)
      expect(m).to_not be_nil
      expect(m['year']).to eql '2014'
      expect(m['month']).to eql '02'
      expect(m['day']).to eql '16'
      expect(m['hour']).to eql '5'
      expect(m['min']).to eql '15'
      expect(m['sec']).to eql '06'
      expect(m['server_time']).to eql '3683.58'
      expect(m['victim']).to eql 'Appe96'
      expect(m['victim_position']).to eql '4602.18,7490.26,2.2435'
      expect(m['victim_grid']).to eql '0460207490'
      expect(m['nearby_players']).to eql '["Olli","nametag47","Villanyi"]'
    end
  end

  context '::WOUNDED' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsRPT::WOUNDED
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  5:22:55 "4152.41 seconds: Sherminator (CIV) has ' \
          'been team wounded by Xcenocide (WEST) for 1.50828 damage."'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::WOUNDED.match(l)
      expect(m).to_not be_nil
      expect(m['year']).to eql '2014'
      expect(m['month']).to eql '02'
      expect(m['day']).to eql '16'
      expect(m['hour']).to eql '5'
      expect(m['min']).to eql '22'
      expect(m['sec']).to eql '55'
      expect(m['server_time']).to eql '4152.41'
      expect(m['victim']).to eql 'Sherminator'
      expect(m['victim_team']).to eql 'CIV'
      expect(m['offender']).to eql 'Xcenocide'
      expect(m['offender_team']).to eql 'WEST'
      expect(m['damage']).to eql '1.50828'
    end
  end

  context '::ANNOUNCEMENT' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsRPT::ANNOUNCEMENT
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  4:13:10 "############################# Start ' \
          'CO08_Escape_Chernarus_V1 #############################"'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::ANNOUNCEMENT.match(l)
      expect(m).to_not be_nil
      expect(m['year']).to eql '2014'
      expect(m['month']).to eql '02'
      expect(m['day']).to eql '16'
      expect(m['hour']).to eql '4'
      expect(m['min']).to eql '13'
      expect(m['sec']).to eql '10'
      expect(m['head']).to eql '#############################'
      expect(m['message']).to eql 'Start CO08_Escape_Chernarus_V1'
      expect(m['tail']).to eql '#############################'
    end
  end
end
