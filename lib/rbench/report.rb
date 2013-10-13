module Enumerable

    # over the enumerable, compute the sum
    def sum
        self.inject(0){|accum, i| accum + i }
    end

    # over the enumerable, compute the mean
    def mean
        self.sum/self.length.to_f
    end

    # over the enumerable, compute the [sample variance]
    # (http://en.wikipedia.org/wiki/Variance#Population_variance_and_sample_variance)
    def sample_variance
        m = self.mean
        sum = self.inject(0){|accum, i| accum +(i-m)**2 }
        sum/(self.length - 1).to_f
    end

    # over the enumerable, compute the [population variance]
    # (http://en.wikipedia.org/wiki/Variance#Population_variance_and_sample_variance)
    def population_variance
        m = self.mean
        sum = self.inject(0){|accum, i| accum +(i-m)**2 }
        sum/(self.length - 0).to_f
    end

    # over the enumerable, compute the standard deviation. Note we choose the population variance for this.
    def standard_deviation
        return Math.sqrt(self.population_variance)
    end

end

module RBench
    class Report
        self.instance_methods.each do |m|
            send(:undef_method, m) unless m =~ /^(__|object_id|is_a?|kind_of?|respond_to?|hash|inspect|instance_eval|eql?)/
        end

        attr_reader :name, :cells

        def initialize(runner, group, name, times=nil,&block)
            @runner = runner
            @group  = group
            @name   = name
            @times  = (times || runner.times).ceil
            @cells  = {}
            @block  = block 

            # Setting the default for all cells
            runner.columns.each {|c| @cells[c.name] = c.name == :times ? "x#{@times}" : c.default }

            new_self = (class << self; self end)
            @runner.columns.each do |column|
                new_self.class_eval <<-CLASS
                def #{column.name}(val=nil,&block)
                    stdtim = 0
                    tim =   if block_given?
                        timings = (1..@times).map { Benchmark.measure { block } .real }
                        stdtim = timings.standard_deviation
                        timings.mean
                    else
                        val
                    end

                    @cells[#{column.name.inspect}] = tim
                    @cells[#{column.name.inspect}_stddev] = stdtim*3/tim
                end
                CLASS
            end
    end

    def run
        # runs the actual benchmarks. If there is only one column, just evaluate the block itself.
        if @runner.columns.length == 1
            stdtim = 0
            timings = (1..@times).map { Benchmark.measure {@block}.real }
            tim = timings.mean
            @cells[@runner.columns.first.name] = tim
            @cells["#{@runner.columns.first.name}_stddev"] = timings.standard_deviation*3/tim
            # @cells[@runner.columns.first.name] = Benchmark.measure { @times.times(&@block) }.real
        else
            self.instance_eval(&@block)
        end
        # puts its row now that it is complete
        puts to_s
    end

    def to_s
        out = "%-#{@runner.desc_width}s" % name
        @runner.columns.each do |column|
            value = @cells[column.name]
            value = @cells.values_at(*value) if value.is_a?(Array)
            value = nil if value.is_a?(Array) && value.compact.length != 2

            if column.stddev
                value = { :metric => @cells[column.name], :std => @cells["#{column.name}_stddev".to_sym] }
            end

            out << column.to_s(value)
        end
        out << @runner.newline
    end
end
end
