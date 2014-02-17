# -*- coding: UTF-8 -*-
require 'rspec'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperationsrpt')

describe RMuh::RPT::Log::Util::UnitedOperationsRPT do
  context '::DTR' do
    it 'should be an instance of String' do
      RMuh::RPT::Log::Util::UnitedOperationsRPT::DTR
        .should be_an_instance_of String
    end
  end

  context '::KILLED' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsRPT::KILLED
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  4:11:42 "69.85 seconds: Olli (CIV) has been killed ' \
          'by Yevgeniy Nikolayev (EAST). Olli position: [6553.55,6961.92,' \
          '0.0015564] (GRID 0655306961). Yevgeniy Nikolayev position: ' \
          '[6498.62,6916.71,0.0204163] (GRID 0649806916). Distance between: ' \
          '71.1653 meters. Near players (100m): None."'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::KILLED.match(l)
      m.should_not be_nil
      m['year'].should eql '2014'
      m['month'].should eql '02'
      m['day'].should eql '16'
      m['hour'].should eql '4'
      m['min'].should eql '11'
      m['sec'].should eql '42'
      m['server_time'].should eql '69.85'
      m['victim'].should eql 'Olli'
      m['victim_team'].should eql 'CIV'
      m['offender'].should eql 'Yevgeniy Nikolayev'
      m['offender_team'].should eql 'EAST'
      m['victim_position'].should eql '6553.55,6961.92,0.0015564'
      m['victim_grid'].should eql '0655306961'
      m['offender_position'].should eql '6498.62,6916.71,0.0204163'
      m['offender_grid'].should eql '0649806916'
      m['distance'].should eql '71.1653'
      m['nearby_players'].should eql 'None.'
    end
  end

  context '::DIED' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsRPT::DIED
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  5:15:06 "3683.58 seconds: Appe96 has died at ' \
          '[4602.18,7490.26,2.2435] (GRID 0460207490). Near players (100m): ' \
          '["Olli","nametag47","Villanyi"]"'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::DIED.match(l)
      m.should_not be_nil
      m['year'].should eql '2014'
      m['month'].should eql '02'
      m['day'].should eql '16'
      m['hour'].should eql '5'
      m['min'].should eql '15'
      m['sec'].should eql '06'
      m['server_time'].should eql '3683.58'
      m['victim'].should eql 'Appe96'
      m['victim_position'].should eql '4602.18,7490.26,2.2435'
      m['victim_grid'].should eql '0460207490'
      m['nearby_players'].should eql '["Olli","nametag47","Villanyi"]'
    end
  end

  context '::WOUNDED' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsRPT::WOUNDED
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  5:22:55 "4152.41 seconds: Sherminator (CIV) has ' \
          'been team wounded by Xcenocide (WEST) for 1.50828 damage."'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::WOUNDED.match(l)
      m.should_not be_nil
      m['year'].should eql '2014'
      m['month'].should eql '02'
      m['day'].should eql '16'
      m['hour'].should eql '5'
      m['min'].should eql '22'
      m['sec'].should eql '55'
      m['server_time'].should eql '4152.41'
      m['victim'].should eql 'Sherminator'
      m['victim_team'].should eql 'CIV'
      m['offender'].should eql 'Xcenocide'
      m['offender_team'].should eql 'WEST'
      m['damage'].should eql '1.50828'
    end
  end

  context '::ANNOUNCEMENT' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsRPT::ANNOUNCEMENT
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = '2014/02/16,  4:13:10 "############################# Start ' \
          'CO08_Escape_Chernarus_V1 #############################"'
      m = RMuh::RPT::Log::Util::UnitedOperationsRPT::ANNOUNCEMENT.match(l)
      m.should_not be_nil
      m['year'].should eql '2014'
      m['month'].should eql '02'
      m['day'].should eql '16'
      m['hour'].should eql '4'
      m['min'].should eql '13'
      m['sec'].should eql '10'
      m['head'].should eql '#############################'
      m['message'].should eql 'Start CO08_Escape_Chernarus_V1'
      m['tail'].should eql '#############################'
    end
  end
end
