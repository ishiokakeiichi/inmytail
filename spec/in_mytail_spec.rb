require 'spec_helper'


describe Fluent::MyTailInput do
  before { Fluent::Test.setup }
  TMP_DIR = File.dirname(__FILE__) + "/tmp"
  CONFIG = %[
    path ${path}
    format /^(?<time>.*) (?<req_time>.*)/
    time_format %s.%L
    to_i ${tois}
    tag ${tag}
  ]
  let(:path)   { "#{TMP_DIR}/squid2.log" }
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
    let(:time) { Time.now }
    #let(:emits) do
    #  driver.run do
    #    File.open(path,'a'){|f|
    #      f.puts "12345.12345 99999"
    #    }
    #  end
    #end
    
    context 'typical usage' do
      let(:config) { CONFIG }
      #before do
        #Fluent::Engine.should_receive(:emits).with(tag, time.to_i, {'time'=>'123345', 'req_time' => '99999'} )
      #end
      it { 
          d = Fluent::Test::InputTestDriver.new(Fluent::MyTailInput).configure(
   %[
    path  /root/work/fluent/fluent-plugin-mytail/spec/tmp/squid2.log 
    format /^(?<time>.*) (?<req_time>.*)/
    time_format %s.%L
    to_i time
    tag ats.cache
  ]

)
          d.run do
            File.open("/root/work/fluent/fluent-plugin-mytail/spec/tmp/squid2.log",'w'){|f|
            f.puts '1399642335.109 123'
          }
          end
          e = d.emits
          p e.length
       } 
    end 
  end
  

end
