<p align="center">
  <a href="https://github.com/breadkit/breadkit"><img src="https://raw.githubusercontent.com/breadkit/breadkit/main/site/favicon.svg" width="72" height="72" alt="Breadkit logo"></a>
</p>

<h1 align="center">breadkit-rspec</h1>

<p align="center">
  <strong>Test Breadkit circuit connections and switch states with RSpec.</strong>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/breadkit-rspec"><img src="https://img.shields.io/gem/v/breadkit-rspec.svg" alt="RubyGems version"></a>
  <a href="https://github.com/breadkit/breadkit-rspec/actions/workflows/ci.yml"><img src="https://github.com/breadkit/breadkit-rspec/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
  <img src="https://img.shields.io/badge/Ruby-%3E%3D%203.3-CC342D.svg" alt="Ruby 3.3 or newer">
  <a href="LICENSE.txt"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
</p>

Assert that pins, board holes, and named nets share a connection in a resolved
[Breadkit](https://github.com/breadkit/breadkit) circuit. Check connections in
named switch states with the same matcher.

## Quick start

Install in an RSpec project with Ruby 3.3 or newer. `breadkit-rspec` depends on
Breadkit 0.2.x:

```sh
gem install breadkit-rspec
```

With Bundler, add `gem "breadkit-rspec", "~> 0.1"` to your Gemfile instead.

Load the matcher in `spec/spec_helper.rb`:

```ruby
require "breadkit/rspec"
```

With Breadkit's [LED and button example](https://github.com/breadkit/breadkit/blob/main/examples/01_led_button.bk.rb)
saved as `circuits/led.bk.rb`, add a spec:

```ruby
RSpec.describe "LED circuit" do
  let(:circuit) { Breadkit.load("circuits/led.bk.rb") }

  it "connects the LED through the resistor" do
    expect(circuit).to connect("R1.2", "D1.anode")
    expect(circuit).not_to connect("D1.cathode", :VCC)
  end

  it "connects the input when the button is pressed" do
    expect(circuit).to connect("R1.1", :VCC).in_state("SW1")
  end
end
```

`connect` accepts pin aliases, hole IDs, and named nets. An unknown reference
raises `ArgumentError`; a failed connection expectation reports the resolved
nets.

## Switch states

Use `.in_state("SW1")` to close one switch or `.in_state("SW1,SW2")` to close
several. Other switches stay open, so you do not need to enumerate every switch
combination. Unknown or repeated switch names raise `ArgumentError`.

## Development

Clone Breadkit and this gem as sibling directories, then run:

```sh
git clone https://github.com/breadkit/breadkit.git
git clone https://github.com/breadkit/breadkit-rspec.git
cd breadkit-rspec
bundle install
bundle exec rake
```

## License

[MIT](LICENSE.txt).
