# frozen_string_literal: true

RSpec.describe "Breadkit matchers" do
  let(:circuit) { Breadkit.load(File.expand_path("../../../breadkit/examples/01_led_button.bk.rb", __dir__)) }

  it "matches two references on the same resolved net" do
    expect(circuit).to connect("SW1.1", :VCC)
    expect(circuit).to connect("R1.2", "D1.anode")
    expect(circuit).not_to connect("R1.1", :VCC)
    expect(circuit).not_to connect("missing", :VCC)
  end

  it "checks the requested switch state" do
    expect(circuit).to connect("R1.1", :VCC).in_state("SW1")
    expect(circuit).not_to connect("R1.1", :GND).in_state("SW1")
    expect { expect(circuit).to connect("R1.1", :VCC).in_state("MISSING") }
      .to raise_error(ArgumentError, /unknown circuit state/)
  end

  it "reports the resolved nets when a connection fails" do
    expect { expect(circuit).to connect("R1.1", :VCC) }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError, /R1\.1.*VCC.*separate nets/)
  end
end
