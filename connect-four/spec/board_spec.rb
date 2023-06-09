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
    subject(:board_win) { described_class.new }

    context 'with a connect-four present' do
      context 'with diagonal' do
        it 'returns true' do
          allow(board_win).to receive(:four_diagonal).and_return(true)
          expect(board_win).to be_won
        end
      end

      context 'with row' do
        it 'returns true' do
          allow(board_win).to receive(:four_row).and_return(true)
          expect(board_win).to be_won
        end
      end

      context 'with column' do
        it 'returns true' do
          allow(board_win).to receive(:four_column).and_return(true)
          expect(board_win).to be_won
        end
      end
    end

    context 'with no connect-four' do
      it 'returns false' do
        expect(board_win).not_to be_won
      end
    end
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
