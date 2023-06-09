require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    subject(:board_init) { described_class.new }

    it 'creates a 7x6 size 2d array' do
      slot_count = board_init.slots.flatten.length
      expect(slot_count).to eq(7 * 6)
    end
  end

  describe '#won?' do
  end

  describe '#four_diagonal' do
  end

  describe '#four_row' do
  end

  describe '#four_column' do
  end

  describe '#drop' do
  end

  describe '#full?' do
  end

  describe '#empty?' do
  end
end
