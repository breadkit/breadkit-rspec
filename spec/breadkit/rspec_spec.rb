# frozen_string_literal: true

require "tempfile"

RSpec.describe "Breadkit matchers" do
  let(:circuit) { Breadkit.load(File.expand_path("../fixtures/led_button.bk.rb", __dir__)) }

  it "matches two references on the same resolved net" do
    expect(circuit).to connect("SW1.1", :VCC)
    expect(circuit).to connect("R1.2", "D1.anode")
    expect(circuit).not_to connect("R1.1", :VCC)
    expect { expect(circuit).not_to connect("missing", :VCC) }
      .to raise_error(ArgumentError, /unknown circuit reference: missing/)
  end

  it "checks the requested switch state" do
    expect(circuit).to connect("R1.1", :VCC).in_state("SW1")
    expect(circuit).not_to connect("R1.1", :GND).in_state("SW1")
    expect { expect(circuit).to connect("R1.1", :VCC).in_state("MISSING") }
      .to raise_error(ArgumentError, /unknown circuit state/)
    expect { expect(circuit).to connect("R1.1", :VCC).in_state("SW1,SW1") }
      .to raise_error(ArgumentError, /unknown circuit state/)
  end

  it "reports the resolved nets when a connection fails" do
    expect { expect(circuit).to connect("R1.1", :VCC) }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError, /R1\.1.*VCC.*separate nets/)
  end

  it "resolves a named combination without enumerating unrelated switches" do
    Tempfile.create(["many-switches", ".bk.rb"]) do |file|
      file.write("board :half\n")
      9.times { |index| file.write("button :SW#{index + 1}, at: \"e#{(index * 3) + 1}\"\n") }
      file.flush

      many_switches = Breadkit.load(file.path)
      expect(many_switches).to connect("a1", "b1").in_state("SW1,SW9")
    end
  end
end
