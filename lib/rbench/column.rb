module RBench
  class Column
    attr_accessor :name, :title, :width, :compare, :stddev, :default
    
    def initialize(runner, name, options = {})
      @runner  = runner
      @name    = name
      @title   = options[:title] || (@name == :times ? "" : @name.to_s.upcase)
      @width   = options[:width] || [@title.length,14].max
      @compare = options[:compare]
      @stddev  = options[:stddev]
      @default = @compare ? @compare : options[:default]
    end
    
    def to_s(val=title)
      str = case val
        when Array      then "%#{width-1}.2f" % (val[0] / val[1]) + "x"
        when Float      then "%#{width}.3f" % val
        when Integer    then "%#{width}.0f" % val
        when TrueClass  then " "*(width/2.0).floor + "X" + " "*(width/2.0).floor
        when String     then "%#{width}s" % (val)[0,width]
        when Hash       then 
            if val[:std] and val[:metric]
                "%#{(2.0*width/3.0).floor}.1f ±%2.1f" % [ val[:metric], val[:std] ]
            elsif val[:metric]
                "%#{width}.3f" % val[:metric]
            else
                " " * width
            end
        when Object     then " " * width
      end
      return " #{(str.to_s+" "*width)[0,width]} |"
    end
  end
end
