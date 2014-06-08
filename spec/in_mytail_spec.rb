require 'spec_helper'

require 'tempfile'


describe Fluent::MyTailInput do
  before { Fluent::Test.setup }
  CONFIG = %[
    path ${path}
    format /^(?<time>\\d*\\.\\d*) (?<req_time>\\d*)$/
    time_format %s.%L
    to_i ${tois}
    tag ${tag}
  ]
  let(:path)   { "/var/service/cas/ats/logs/squid2.log" }
  let(:driver) { Fluent::Test::InputTestDriver.new(Fluent::MyTailInput).configure(config)}
  let(:tag)    { 'ats.cache' }
  let(:tois)   { 'time' }

  describe 'test configure' do
    describe 'good configuration' do
      subject { driver.instance }
      
      context "check default" do
        let(:config) { CONFIG }
        it { expect { subject }.not_to raise_error }
      end 
      context "tag is not specified" do
        let(:config) { %[] }
        it { expect { subject }.to raise_error(Fluent::ConfigError) }
      end
      context "to_i is not specified" do
        let(:config) { %[
          path ${path}
          format /^(?<time>\d*\.\d*) (?<req_time>\d*)/
          time_format %s.%L
          tag ${tag}
        ]}
        it { expect { subject }.to raise_error(Fluent::ConfigError) }
      end
    end
  end

  describe 'test emits' do
    let(:tmpf) {Tempfile.new("in_tail_multiline2-") }
    let(:config) { 
    %[
       path #{tmpf.path}
       format /^(?<time>\\d*\\.\\d*) (?<req_time>\\d*)$/
       time_format %s.%L 
       to_i time
       tag ats.cache
     ]
    }
    let(:emits) do
       begin
         d = Fluent::Test::InputTestDriver.new(Fluent::MyTailInput).configure config
         d.run do
           File.open(tmpf,'w'){|f|
             f.puts "1392259627.123 1230"
             f.puts "1492259627.123 1230"
           }
           sleep 1
         end
         d.emits
       ensure
         tmpf.close
       end
    end
    #context 'typical usage' do
      it { expect( emits.length).to eq 2 }
      it { expect( emits[0] ).to match_array ["ats.cache",1392259627,{'req_time' => "1230",'time' => 0}] }
      it { expect( emits[1] ).to match_array ["ats.cache",1492259627,{'req_time' => "1230",'time' => 0}] }
    #end 
  end
  

end
