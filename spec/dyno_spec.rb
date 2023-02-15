# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DarkKnight::Dyno do
  describe '#restart_if_swapping' do
    it 'issues http request to heroku api if memory total exceeds memory quota' do
      stub_restart_request('todo', 'web.1')

      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 513.5)
      subject.restart_if_swapping

      expect_restart_request('todo', 'web.1')
    end

    it 'issues one http request to heroku api even if called multiple times' do
      stub_restart_request('todo', 'web.1')

      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 513.5)
      2.times { subject.restart_if_swapping }

      expect_restart_request('todo', 'web.1')
    end

    it 'does nothing if memory total equals memory quota' do
      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 512.0)

      subject.restart_if_swapping

      expect_no_request
    end

    it 'does nothing false if memory total is lower than memory quota' do
      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 256.0)

      subject.restart_if_swapping

      expect_no_request
    end
  end

  describe '#restart' do
    it 'issues http request to heroku api' do
      stub_restart_request('todo', 'web.1')

      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 513.5)

      subject.restart

      expect_restart_request('todo', 'web.1')
    end
  end

  describe '#swapping?' do
    it 'returns true if memory_total exceeds memory_total' do
      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 513.5)

      expect(subject).to be_swapping
    end

    it 'returns false if memory_total equals memory_total' do
      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 512.0)

      expect(subject).not_to be_swapping
    end

    it 'returns false if memory_total is lower than memory_total' do
      subject = described_class.new(source: 'web.1', memory_quota: 512.00, memory_total: 256.0)

      expect(subject).not_to be_swapping
    end
  end
end
