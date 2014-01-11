require 'rspec'
RSpec.configure{|config|
	config.color=true
}

if !defined?(RUBY_ENGINE)||RUBY_ENGINE=='ruby'
	require 'simplecov'
	SimpleCov.start do
		add_filter 'spec'
	end
end

require File.expand_path(File.dirname(__FILE__)+'/../lib/cosvon')