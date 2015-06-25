class PairrStateMachine
  PairrError = Class.new StandardError

  class UnknownState < PairrError
    attr_reader :state, :known_states
    def initialize(state, known_states)
      @state        = state
      @known_states = known_states
      super "Don't know state #{state.inspect}, only know #{known_states.inspect}"
    end
  end

  class EventNotValidForState < PairrError
    attr_reader :state, :event
    def initialize(state, event)
      @state, @event = state, event
      super "State #{state.inspect} should never receive the #{event.inspect} event!"
    end
  end

  attr_reader :state, :transitions

  def initialize(initial_state=:infinite_potential)
    @transitions = TRANSITIONS[initial_state]
    @state       = initial_state
  end

  def you_like_me!
    transitions[:you_like_me]
  end

  def you_hate_me!
    transitions[:you_hate_me]
  end

  def i_like_you!
    transitions[:i_like_you]
  end

  def i_hate_you!
    transitions[:i_hate_you]
  end

  private

  def self.add_transition(state, transitions={})
    transitions.default_proc = lambda do |_, event|
      raise EventNotValidForState.new state, event
    end
    TRANSITIONS[state] = transitions.freeze
  end

  TRANSITIONS = Hash.new do |transitions, initial_state|
    raise UnknownState.new initial_state, transitions.keys
  end
  add_transition :infinite_potential,
                   you_like_me: :secret_admirer,
                   you_hate_me: :secret_detractor
  add_transition :secret_admirer,
                   i_like_you: :true_love,
                   i_hate_you: :not_you_its_me
  add_transition :secret_detractor # not sure what the right thing is here
  add_transition :true_love
  add_transition :not_you_its_me
end

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
