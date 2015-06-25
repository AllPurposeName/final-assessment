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

  def like!
    transitions[:like]
  end

  def hate!
    transitions[:hate]
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
                   like: :secret_admirer,
                   hate: :secret_detractor
  add_transition :secret_admirer,
                   like: :true_love,
                   hate: :not_you_its_me
  add_transition :secret_detractor # not sure what the right thing is here
  add_transition :true_love
  add_transition :not_you_its_me
end
