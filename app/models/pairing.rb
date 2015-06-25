require 'pairr_state_machine'

class Pairing < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :pair, class_name: "User"

  after_initialize do
    self.state ||= Pairing.initial_state
  end

  def self.secret_detractors
    where state: 'secret_detractor'
  end

  def self.secret_admirers
    where state: 'secret_admirers'
  end

  def self.infinite_potentials(user)
    User.find_by_sql([
      'select * from users where
        ( id not in (select user_id from pairings where pair_id = ?)
          and id not in (select pair_id from pairings where user_id = ?)
        )
      ', user.id, user.id
    ])
  end

  def self.for(user1, user2)
    where(user_id: user1.id, pair_id: user2.id).first   ||
      where(user_id: user2.id, pair_id: user1.id).first ||
      new(user: user1, pair: user2, state: initial_state)
  end

  def self.initial_state
    @initial_state ||= PairrStateMachine.new.state
  end

  def true_love?
    state == 'true_love'
  end

  def like
    self.state = PairrStateMachine.new(state.to_sym).like!
    self
  end

  def hate
    self.state = PairrStateMachine.new(state.to_sym).hate!
    self
  end

  def decide(decision)
    decision ? like : hate
  end
end
