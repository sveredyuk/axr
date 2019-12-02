# frozen_string_literal: true

require 'axr'

require_relative '../examples/one/one'

RSpec.describe AxR::App do
  context 'with default options' do
    let!(:setup) do
      AxR.app.send(:reset)

      AxR.app.define(isolated: true) do
        layer Api, isolated: false, familiar_with: [Isolated, Logic]
        layer Isolated
        layer Logic, familiar_with: Repo
        layer Repo
      end
    end

    describe 'DSL' do
      it 'compolse layers with default options' do
        expect(AxR.app.layers.size).to eq 4

        expect(AxR.app.layers[0].isolated).to eq false
        expect(AxR.app.layers[1].isolated).to eq true
        expect(AxR.app.layers[2].isolated).to eq true
        expect(AxR.app.layers[3].isolated).to eq true
      end
    end

    describe 'legal?' do
      it 'isolated by defaul but can be familiar_with' do
        expect(AxR.app.legal?(Api, Api)).to eq false
        expect(AxR.app.legal?(Api, Isolated)).to eq true
        expect(AxR.app.legal?(Api, Logic)).to eq true
        expect(AxR.app.legal?(Api, Repo)).to eq true

        expect(AxR.app.legal?(Isolated, Isolated)).to eq false
        expect(AxR.app.legal?(Isolated, Api)).to eq false
        expect(AxR.app.legal?(Isolated, Logic)).to eq false
        expect(AxR.app.legal?(Isolated, Repo)).to eq false

        expect(AxR.app.legal?(Logic, Logic)).to eq false
        expect(AxR.app.legal?(Logic, Api)).to eq false
        expect(AxR.app.legal?(Logic, Isolated)).to eq false
        expect(AxR.app.legal?(Logic, Repo)).to eq true

        expect(AxR.app.legal?(Repo, Repo)).to eq false
        expect(AxR.app.legal?(Repo, Api)).to eq false
        expect(AxR.app.legal?(Repo, Isolated)).to eq false
        expect(AxR.app.legal?(Repo, Logic)).to eq false
      end
    end
  end

  context 'without default options' do
    let!(:setup) do
      AxR.app.send(:reset)

      AxR.app.define do
        layer Api
        layer Isolated, isolated: true
        layer Logic,    familiar_with: Isolated
        layer Repo,     isolated: true
      end
    end

    describe 'DSL' do
      it 'compose layers list' do
        expect(AxR.app.layers.size).to eq 4

        expect(AxR.app.layers[0]).to be_instance_of(AxR::Layer)
        expect(AxR.app.layers[0].name).to eq Api
        expect(AxR.app.layers[0].level).to eq 0
        expect(AxR.app.layers[0].isolated).to eq false
        expect(AxR.app.layers[0].familiar_with).to eq([])

        expect(AxR.app.layers[1]).to be_instance_of(AxR::Layer)
        expect(AxR.app.layers[1].name).to eq Isolated
        expect(AxR.app.layers[1].isolated).to eq true
        expect(AxR.app.layers[1].level).to eq 1
        expect(AxR.app.layers[1].familiar_with).to eq([])

        expect(AxR.app.layers[2]).to be_instance_of(AxR::Layer)
        expect(AxR.app.layers[2].name).to eq Logic
        expect(AxR.app.layers[2].isolated).to eq false
        expect(AxR.app.layers[2].level).to eq 2
        expect(AxR.app.layers[2].familiar_with).to eq [Isolated]

        expect(AxR.app.layers[3]).to be_instance_of(AxR::Layer)
        expect(AxR.app.layers[3].name).to eq Repo
        expect(AxR.app.layers[3].isolated).to eq true
        expect(AxR.app.layers[3].level).to eq 3
        expect(AxR.app.layers[3].familiar_with).to eq([])
      end

      it 'has string names' do
        expect(AxR.app.layer_names).to eq %w[Api Isolated Logic Repo]
      end

      it 'can has layer conflic' do
        expect do
          AxR.app.define do |axr|
            axr.layer Api
          end
        end.to raise_error(AxR::App::LayerConflictError, 'Layer Api is already defined in the app')
      end
    end

    describe 'legal?' do
      it 'isolated' do
        expect(AxR.app.legal?(Isolated, Api)).to eq false
        expect(AxR.app.legal?(Isolated, Logic)).to eq false
        expect(AxR.app.legal?(Isolated, Repo)).to eq false
      end

      it 'familiar_with' do
        expect(AxR.app.legal?(Logic, Api)).to eq false
        expect(AxR.app.legal?(Logic, Isolated)).to eq true
        expect(AxR.app.legal?(Logic, Repo)).to eq true
      end

      it 'true for 0 < 1' do
        expect(AxR.app.legal?(Api, Logic)).to eq true
        expect(AxR.app.legal?('Api', Logic)).to eq true
        expect(AxR.app.legal?('Api', 'Logic')).to eq true
        expect(AxR.app.legal?(Api, 'Logic')).to eq true
      end

      it 'false for 1 < 0' do
        expect(AxR.app.legal?(Logic, Api)).to eq false
        expect(AxR.app.legal?('Logic', Api)).to eq false
        expect(AxR.app.legal?('Logic', 'Api')).to eq false
        expect(AxR.app.legal?(Logic, 'Api')).to eq false
      end

      it 'false for 0 == 0' do
        expect(AxR.app.legal?(Api, Api)).to eq false
        expect(AxR.app.legal?('Api', Api)).to eq false
        expect(AxR.app.legal?('Api', 'Api')).to eq false
        expect(AxR.app.legal?(Api, 'Api')).to eq false
      end

      it 'true for 0 < 2' do
        expect(AxR.app.legal?(Api, Repo)).to eq true
        expect(AxR.app.legal?('Api', Repo)).to eq true
        expect(AxR.app.legal?('Api', 'Repo')).to eq true
        expect(AxR.app.legal?(Api, 'Repo')).to eq true
      end

      it 'false for 2 < 1' do
        expect(AxR.app.legal?(Repo, Logic)).to eq false
        expect(AxR.app.legal?('Repo', Logic)).to eq false
        expect(AxR.app.legal?('Repo', 'Logic')).to eq false
        expect(AxR.app.legal?(Repo, 'Logic')).to eq false
      end

      it 'false for 2 < 0' do
        expect(AxR.app.legal?(Repo, Api)).to eq false
        expect(AxR.app.legal?('Repo', Api)).to eq false
        expect(AxR.app.legal?('Repo', 'Api')).to eq false
        expect(AxR.app.legal?(Repo, 'Api')).to eq false
      end
    end
  end
end
