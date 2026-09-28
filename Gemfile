# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in breadkit-rspec.gemspec
gemspec
if ENV["BREADKIT_SOURCE"] != "published" && File.file?(File.expand_path("../breadkit/breadkit.gemspec", __dir__))
  gem "breadkit", path: "../breadkit"
end

gem "irb"
gem "rake", "~> 13.0"

gem "rspec", "~> 3.0"

gem "rubocop", "~> 1.21"
