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
      names = @state_name.split(",", -1)
      switches = names.map { |name| circuit.components[name] }
      valid = names.uniq.length == names.length &&
              switches.all? { |component| component && Array(component.part.data["switch"]).any? }
      raise ArgumentError, "unknown circuit state: #{@state_name}" unless valid

      closed = switches.flat_map { |component| Array(component.part.data["switch"]).map { |pair| [component, pair] } }
      state = Breadkit::State.new(name: @state_name, closed_switches: closed)
    end

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
