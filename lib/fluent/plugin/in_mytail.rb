module Fluent
  require 'fluent/plugin/in_tail'

  class  MyTailInput < TailInput
    Fluent::Plugin.register_input('mytail', self)
    
    config_param :to_i, :string
    
    def configure(conf)
      super
    
      @to_i = @to_i.split(',').map {|key| key.strip }
    end
    
    def parse_line(line)
      time, record = @parser.parse(line)
      @to_i.each {|key|
        record[key] = record[key].to_i
      }
      return time, record
    end
  end
end
