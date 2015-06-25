require 'pairr_state_machine'

RSpec.describe PairrStateMachine do
  def explode!(start_state, event)
    expect { PairrStateMachine.new(start_state).__send__ event }
      .to raise_error PairrStateMachine::EventNotValidForState
  end

  def transition!(start_state, event, end_state)
    expect(PairrStateMachine.new(start_state).__send__ event).to eq end_state
  end

  specify 'initial state is :infinite_potential' do
    expect(PairrStateMachine.new.state).to eq :infinite_potential
  end

  specify 'blows up if initialized with an invalid state' do
    expect { PairrStateMachine.new :lol_wut }.to raise_error PairrStateMachine::UnknownState
  end

  describe ':infinite_potential' do
    specify 'you_like_me! -> :secret_admirer' do
      transition! :infinite_potential, :you_like_me!, :secret_admirer
    end
    specify 'you_hate_me! -> :secret_detractor' do
      transition! :infinite_potential, :you_hate_me!, :secret_detractor
    end
    specify 'i_like_you!  -> explode' do
      explode! :infinite_potential, :i_like_you!
    end
    specify 'i_hate_you!  -> explode' do
      explode! :infinite_potential, :i_hate_you!
    end
  end

  describe ':secret_admirer' do
    specify 'you_like_me! -> explode' do
      explode! :secret_admirer, :you_like_me!
    end

    specify 'you_hate_me! -> explode' do
      explode! :secret_admirer, :you_hate_me!
    end

    specify 'i_like_you!  -> :true_love' do
      transition! :secret_admirer, :i_like_you!, :true_love
    end

    specify 'i_hate_you!  -> :not_you_its_me' do
      transition! :secret_admirer, :i_hate_you!, :not_you_its_me
    end
  end

  describe ':secret_detractor' do
    specify 'you_like_me! -> explode' do
      explode! :secret_detractor, :you_like_me!
    end

    specify 'you_hate_me! -> explode' do
      explode! :secret_detractor, :you_hate_me!
    end
  end

  describe 'final states' do
    [:true_love, :not_you_its_me].each do |final_state|
      specify "#{final_state.inspect}... all events explode" do
        explode! final_state, :you_like_me!
        explode! final_state, :you_hate_me!
        explode! final_state, :i_like_you!
        explode! final_state, :i_hate_you!
      end
    end
  end
end
