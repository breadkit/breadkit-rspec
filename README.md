# breadkit-rspec

RSpec matchers for resolved [Breadkit](https://github.com/breadkit/breadkit) circuits.

## Install from source

The first gem release is pending. Until then, add both source repositories to
your Gemfile:

```ruby
gem "breadkit", git: "https://github.com/breadkit/breadkit.git", branch: "main"
gem "breadkit-rspec", git: "https://github.com/breadkit/breadkit-rspec.git", branch: "main"
```

Require the matchers in `spec/spec_helper.rb`:

```ruby
require "breadkit/rspec"
```

## Test a circuit

```ruby
RSpec.describe "LED circuit" do
  let(:circuit) { Breadkit.load("circuits/led.bk.rb") }

  it "connects the LED through the resistor" do
    expect(circuit).to connect("R1.2", "D1.anode")
    expect(circuit).not_to connect("D1.cathode", :VCC)
  end

  it "connects the switched input when pressed" do
    expect(circuit).to connect("R1.1", :VCC).in_state("SW1")
  end
end
```

`connect` resolves pin aliases, named nets, and hole IDs through
`Breadkit::Circuit#net_of`. It fails when either reference is unknown. Use
`.in_state("SW1")` for a switch state; an unknown state raises an error.

## Development

Clone `breadkit` and `breadkit-rspec` as sibling directories, then run
`bundle install` and `bundle exec rake` here. The gem is independent of
`breadkit-lint` and `breadkit-render`.

MIT licensed. See [LICENSE.txt](LICENSE.txt).
