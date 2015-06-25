require 'pairr_state_machine'

RSpec.describe PairrStateMachine do
  def self.explode!(start_state, event)
    specify "#{event} -> EXPLODE!!" do
      expect { PairrStateMachine.new(start_state).__send__ event }
        .to raise_error PairrStateMachine::EventNotValidForState
    end
  end

  def self.transition!(start_state, event, end_state)
    specify "#{event} -> #{end_state}" do
      expect(PairrStateMachine.new(start_state).__send__ event).to eq end_state
    end
  end

  specify 'initial state is :infinite_potential' do
    expect(PairrStateMachine.new.state).to eq :infinite_potential
  end

  specify 'blows up if initialized with an invalid state' do
    expect { PairrStateMachine.new :lol_wut }.to raise_error PairrStateMachine::UnknownState
  end

  describe ':infinite_potential' do
    transition! :infinite_potential, :like!, :secret_admirer
    transition! :infinite_potential, :hate!, :secret_detractor
  end

  describe ':secret_admirer' do
    transition! :secret_admirer, :like!, :true_love
    transition! :secret_admirer, :hate!, :not_you_its_me
  end

  describe ':secret_detractor' do
    explode! :secret_detractor, :like!
    explode! :secret_detractor, :hate!
  end

  describe 'final states' do
    [:true_love, :not_you_its_me].each do |final_state|
      describe "#{final_state.inspect}" do
        explode! final_state, :like!
        explode! final_state, :hate!
      end
    end
  end
end
