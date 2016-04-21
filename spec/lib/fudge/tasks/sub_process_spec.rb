# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Fudge::Tasks::SubProcess do
  let(:output) { StringIO.new }
  let(:formatter) { Fudge::Formatters::Simple.new(output) }

  describe '#run' do
    it 'takes a command and runs it' do
      expect(described_class.new(:ls)).to run_command [{}, 'ls', {}]
    end

    it 'adds any arguments given' do
      expect(described_class.new(:ls, '-l', '-a')).to run_command [{}, 'ls', '-l', '-a', {}]
    end

    it 'returns false for an unsuccessful command' do
      expect(described_class.new(:ls, '--newnre').run).to be_falsey
    end

    it 'returns true for a successful command' do
      expect(described_class.new(:ls).run).to be_truthy
    end

    context 'when given environment variables' do
      context 'when the task is created' do
        it 'passes the variables to the sub-process' do
          process = described_class.new(%(ruby -e "puts ENV['PATH'];puts ENV['FOO']"), environment: { 'FOO' => 'bar' })

          process.run(formatter: formatter)

          expect(output.string).to eq "#{ENV['PATH']}\nbar\n"
        end
      end

      context 'when the task is run' do
        it 'passes the variables to the sub-process' do
          process = described_class.new(%(ruby -e "puts ENV['PATH'];puts ENV['FOO']"))

          process.run(formatter: formatter, environment: { 'FOO' => 'bar' })

          expect(output.string).to eq "#{ENV['PATH']}\nbar\n"
        end
      end

      context 'when the task is created and when it is run' do
        it 'gives priority to the variables passed in on run' do
          process = described_class.new(%(ruby -e "puts ENV['FOO'];puts ENV['BAZ']"),
                                        environment: { 'FOO' => 'bar', 'BAZ' => 'quux' })

          process.run(formatter: formatter, environment: { 'FOO' => 'codfanglers' })

          expect(output.string).to eq "codfanglers\nquux\n"
        end
      end
    end

    context 'when not given an environment variable' do
      it 'does not make that variable available to the sub-process' do
        process = described_class.new(%(ruby -e "puts ENV['FOO']"))

        process.run(formatter: formatter)

        expect(output.string).to eq "\n"
      end
    end

    context 'when given spawn options' do
      context 'when the task is created' do
        it 'applies those options to the sub-process' do
          process = described_class.new(%(ruby -e "puts ENV['PATH'];puts ENV['FOO']"),
                                        environment: { 'FOO' => 'bar' },
                                        spawn_options: { unsetenv_others: true }) # Should clear environment variables

          process.run(formatter: formatter)

          expect(output.string).to match /\A(nil)?\nbar\n\z/
        end
      end

      context 'when the task is run' do
        it 'applies those options to the sub-process' do
          process = described_class.new(%(ruby -e "puts ENV['PATH'];puts ENV['FOO']"),
                                        environment: { 'FOO' => 'bar' })

          process.run(formatter: formatter, spawn_options: { unsetenv_others: true })

          expect(output.string).to match /\A(nil)?\nbar\n\z/
        end
      end

      context 'when the task is created and when it is run' do
        it 'gives priority to the options passed in on run' do
          process = described_class.new(%(ruby -e "puts ENV['PATH'];puts ENV['FOO']"),
                                        environment: { 'FOO' => 'bar' },
                                        spawn_options: { unsetenv_others: true }) # Clear environment variables

          process.run(formatter: formatter, spawn_options: { unsetenv_others: false }) # Actually, don't!

          expect(output.string).to eq "#{ENV['PATH']}\nbar\n"
        end
      end
    end
  end
end
