# frozen_string_literal: true

require 'axr/runner'

RSpec.describe AxR::Runner do
  describe 'invoke' do
    let!(:setup) do
      AxR.app.send(:reset)

      AxR.app.define do
        layer 'Api'
        layer 'Logic'
        layer 'Repo', isolated: true
      end
    end

    context 'scan files' do
      let(:file_path) { 'spec/examples/one/lib/logic.rb' }

      it 'scan single file with default formatter' do
        runner = described_class.new(file_path)
        res = runner.invoke
        expect(res).to be_instance_of(Hash)
        expect(res.keys).to eq [file_path]
        expect(res[file_path].size).to eq 1
        expect(res[file_path][0]).to be_instance_of(AxR::Scanner::Warning)
      end
    end
  end

  describe '#files_to_scan' do
    context 'with no arguments' do
      it 'all dir/files' do
        runner = described_class.new
        expect(runner.files_to_scan).to eq Dir.glob('**/*.rb')
      end
    end

    context 'with arguments' do
      it 'only given file' do
        runner = described_class.new('spec/examples/one/lib/api.rb')
        expect(runner.files_to_scan.size).to eq 1
        expect(runner.files_to_scan).to eq ['spec/examples/one/lib/api.rb']
      end

      it 'scan given dir with single file' do
        runner = described_class.new('spec/examples/one/lib/isolated')
        expect(runner.files_to_scan.size).to eq 1
        expect(runner.files_to_scan).to eq(
          [
            'spec/examples/one/lib/isolated/isolated.rb'
          ]
        )
      end

      it 'scan given dir' do
        runner = described_class.new('spec/examples/one/lib')
        expect(runner.files_to_scan.size).to eq 5
        expect(runner.files_to_scan).to eq(
          [
            'spec/examples/one/lib/repo.rb',
            'spec/examples/one/lib/api.rb',
            'spec/examples/one/lib/logic.rb',
            'spec/examples/one/lib/isolated/isolated.rb',
            'spec/examples/one/lib/no_context.rb'
          ]
        )
      end
    end
  end
end
