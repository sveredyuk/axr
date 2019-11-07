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

  it 'compose layers list' do
    expect(AxR.app.layers.size).to eq 3
    expect(AxR.app.layers[0]).to be_instance_of(AxR::Layer)
    expect(AxR.app.layers[0].name).to eq Api
    expect(AxR.app.layers[0].isolated).to eq false

    expect(AxR.app.layers[1]).to be_instance_of(AxR::Layer)
    expect(AxR.app.layers[1].name).to eq Logic
    expect(AxR.app.layers[1].isolated).to eq false

    expect(AxR.app.layers[2]).to be_instance_of(AxR::Layer)
    expect(AxR.app.layers[2].name).to eq Repo
    expect(AxR.app.layers[2].isolated).to eq true
  end

  it 'can has layer conflic' do
    expect do
      AxR.app.define do |axr|
        axr.layer Api
      end
    end.to raise_error(AxR::App::LayerConflictError, 'Layer Api is already defined in the layout')
  end
end
