require 'test_helper'

class PairingTest < ActiveSupport::TestCase
  def test_it_can_be_marked_as_paired
    pairing = Pairing.create!
    refute pairing.paired_before
    pairing.mark_as_paired
    assert pairing.paired_before
  end

  def test_it_can_be_marked_as_interested
    pairing = Pairing.create!
    refute pairing.interested
    pairing.mark_as_interested
    assert pairing.interested
  end
end

