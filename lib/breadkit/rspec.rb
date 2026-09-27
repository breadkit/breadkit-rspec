# frozen_string_literal: true

require "breadkit"
require "rspec/expectations"
require_relative "rspec/version"

RSpec::Matchers.define :connect do |left, right|
  chain :in_state do |name|
    @state_name = name.to_s
  end

  match do |circuit|
    raise ArgumentError, "expected a Breadkit::Circuit" unless circuit.is_a?(Breadkit::Circuit)

    if @state_name
      mode = @state_name.include?(",") ? "all" : "single"
      state = circuit.states(mode, budget: 256).find { |candidate| candidate.name == @state_name }
    end
    raise ArgumentError, "unknown circuit state: #{@state_name}" if @state_name && !state

    @left_net = circuit.net_of(left, state)
    @right_net = circuit.net_of(right, state)
    raise ArgumentError, "unknown circuit reference: #{left}" unless @left_net
    raise ArgumentError, "unknown circuit reference: #{right}" unless @right_net

    @left_net.equal?(@right_net)
  end

  failure_message do
    "expected #{left.inspect} and #{right.inspect} to share a net; separate nets " \
      "(#{@left_net&.name || "unknown"} and #{@right_net&.name || "unknown"})"
  end

  failure_message_when_negated do
    "expected #{left.inspect} and #{right.inspect} to be isolated, but both resolve to #{@left_net.name}"
  end
end
