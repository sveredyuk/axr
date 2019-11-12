# frozen_string_literal: true

require 'axr/scanner'

require_relative '../examples/one/one'

RSpec.describe AxR::Scanner do
  let!(:setup) do
    AxR.app.send(:reset)

    AxR.app.define do
      layer Api
      layer Logic
      layer Repo, isolated: true
    end
  end

  let(:result) { described_class.new(file_path: file_path).scan }

  describe '#scan' do
    context 'top level' do
      let(:file_path) { 'spec/examples/one/lib/api/api.rb' }

      it 'extract file entities' do
        expect(result).to be_instance_of(AxR::Scanner)

        expect(result.context).to           be_instance_of(AxR::Scanner::Detection)
        expect(result.context.loc).to       eq 'module Api'
        expect(result.context.loc_num).to   eq 3
        expect(result.context.name).to      eq 'Api'

        expect(result.dependecies.size).to       eq 1
        expect(result.dependecies[0]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[0].loc).to     eq 'Logic::Runner.new.call'
        expect(result.dependecies[0].loc_num).to eq 6

        expect(result.warnings).to eq []
      end
    end

    context 'no context' do
      let(:file_path) { 'spec/examples/one/lib/api/no_context.rb' }

      it 'extract file entities' do
        expect(result).to be_instance_of(AxR::Scanner)

        expect(result.context).to                eq nil
        expect(result.dependecies.size).to       eq 2
        expect(result.dependecies[0]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[0].loc).to     eq '@users = Repo::User.all'
        expect(result.dependecies[0].loc_num).to eq 5
        expect(result.dependecies[1]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[1].loc).to     eq 'Logic::CreateUser.call(params)'
        expect(result.dependecies[1].loc_num).to eq 9

        expect(result.warnings).to eq []
      end
    end

    context 'mid level' do
      let(:file_path) { 'spec/examples/one/lib/logic/logic.rb' }

      it 'extract file entities' do
        expect(result).to be_instance_of(AxR::Scanner)

        expect(result.context).to           be_instance_of(AxR::Scanner::Detection)
        expect(result.context.loc).to       eq 'module Logic'
        expect(result.context.loc_num).to   eq 3
        expect(result.context.name).to      eq 'Logic'

        expect(result.dependecies.size).to       eq 3
        expect(result.dependecies[0]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[0].loc).to     eq 'Repo::User.first'
        expect(result.dependecies[0].loc_num).to eq 6
        expect(result.dependecies[1]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[1].loc).to eq 'Api::Controller.new.call'
        expect(result.dependecies[1].loc_num).to eq 7
        expect(result.dependecies[2]).to         be_instance_of(AxR::Scanner::Detection)
        expect(result.dependecies[2].loc).to eq 'Repo::User.last'
        expect(result.dependecies[2].loc_num).to eq 8

        expect(result.warnings.size).to       eq 1
        expect(result.warnings[0]).to         be_instance_of(AxR::Scanner::Warning)
        expect(result.warnings[0].message).to eq 'Logic layer should not be familiar with Api'
        expect(result.warnings[0].loc).to     eq 'Api::Controller.new.call'
        expect(result.warnings[0].loc_num).to eq 7
      end
    end
  end
end
