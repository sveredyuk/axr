# frozen_string_literal: true

require 'axr/runner'

RSpec.describe AxR::Runner do
  describe '#files_to_scan' do
    context 'no args' do
      it 'all dir/files' do
        runner = described_class.new
        expect(runner.files_to_scan).to eq Dir.glob('**/*.rb')
      end
    end

    context 'with args' do
      it 'only given file' do
        runner = described_class.new(['spec/examples/one/lib/api/api.rb'])
        expect(runner.files_to_scan.size).to eq 1
        expect(runner.files_to_scan).to eq ['spec/examples/one/lib/api/api.rb']
      end

      it 'scan given dir with single file' do
        runner = described_class.new(['spec/examples/one/lib/api'])
        expect(runner.files_to_scan.size).to eq 1
        expect(runner.files_to_scan).to eq(['spec/examples/one/lib/api/api.rb'])
      end

      it 'scan given dir' do
        runner = described_class.new(['spec/examples/one/lib'])
        expect(runner.files_to_scan.size).to eq 3
        expect(runner.files_to_scan).to eq(
          [
            'spec/examples/one/lib/logic/logic.rb',
            'spec/examples/one/lib/api/api.rb',
            'spec/examples/one/lib/repo/repo.rb'
          ]
        )
      end
    end
  end
end
