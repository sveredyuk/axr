# frozen_string_literal: true

require 'axr'

require_relative '../examples/one/one'

RSpec.describe AxR::App do
  let!(:setup) do
    AxR.app.send(:reset)

    AxR.app.define do
      layer Api
      layer Logic
      layer Repo, isolated: true
    end
  end

  describe 'define DSL' do
    it 'compose layers list' do
      expect(AxR.app.layers.size).to eq 3
      expect(AxR.app.layers[0]).to be_instance_of(AxR::Layer)
      expect(AxR.app.layers[0].name).to eq Api
      expect(AxR.app.layers[0].isolated).to eq false
      expect(AxR.app.layers[0].level).to eq 0

      expect(AxR.app.layers[1]).to be_instance_of(AxR::Layer)
      expect(AxR.app.layers[1].name).to eq Logic
      expect(AxR.app.layers[1].isolated).to eq false

      expect(AxR.app.layers[2]).to be_instance_of(AxR::Layer)
      expect(AxR.app.layers[2].name).to eq Repo
      expect(AxR.app.layers[2].isolated).to eq true
    end

    it 'has string names' do
      expect(AxR.app.layer_names).to eq %w[Api Logic Repo]
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
