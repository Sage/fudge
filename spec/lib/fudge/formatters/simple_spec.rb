require 'spec_helper'

describe Fudge::Formatters::Simple do
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }

  subject { described_class.new(stdout, stderr) }

  describe :error do
    it "returns message in RED" do
      string = subject.error "a message"
      string.should == "a message".foreground(:red)
    end
  end

  describe :success do
    it "returns message in BRIGHT GREEN" do
      string = subject.success "a message"
      string.should == "a message".foreground(:green).bright
    end
  end

  describe :info do
    it "returns message in CYAN" do
      string = subject.info "a message"
      string.should == "a message".foreground(:cyan)
    end
  end

  describe :notice do
    it "returns message in YELLOW" do
      string = subject.notice "a message"
      string.should == "a message".foreground(:yellow)
    end
  end

  describe :normal do
    it "returns unchanged message" do
      string = subject.normal "a message"
      string.should == "a message"
    end
  end

  describe :puts do
    it "outputs message on stdout" do
      subject.puts "a message"
      stdout.string.should == "a message" + "\n"
    end
  end

  describe :write do
    it "supports chaining types to stdout" do
      subject.write do |w|
        w.normal('normal').
          notice('notice').
          info('info').
          success('success')
      end

      stdout.string.should == 'normal' + ' ' +
                              'notice'.foreground(:yellow) + ' ' +
                              'info'.foreground(:cyan) + ' ' +
                              'success'.foreground(:green).bright + "\n"

    end
  end
end
