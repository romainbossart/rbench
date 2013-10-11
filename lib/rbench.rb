require 'benchmark'

require "rbench/version"
require 'rbench/runner'
require 'rbench/column'
require 'rbench/group'
require 'rbench/report'
require 'rbench/summary'

module RBench
  def self.run(times=1, &block)
    Runner.new(times).run(&block)
  end
end
