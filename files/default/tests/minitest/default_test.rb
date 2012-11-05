require File.expand_path('../support/helpers', __FILE__)

describe 'ruby_from_source::default' do

  include Helpers::Betterplace

  it "should install ruby" do
    assert(`/opt/local/bin/ruby -v` =~ /ruby 1.9.3/)
  end

  it "should install the readline-devel package" do
    package('readline-devel').must_be_installed
  end

  it "should have readline support" do
    assert system("echo 'require \"readline\"' | /opt/local/bin/ruby")
  end

end