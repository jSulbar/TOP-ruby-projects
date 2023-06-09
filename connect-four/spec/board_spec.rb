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
    subject(:diagonal_board) { described_class.new }

    context 'with left-leaning diagonal' do
      before do
        diagonal_board.slots = Array.new(6) { |i| Array.new(7) { |j| 'P1' if i == j && i > 1 } }
      end

      it 'returns true' do
        expect(diagonal_board.four_diagonal).to be true
      end
    end

    context 'with right-leaning diagonal' do
      before do
        diagonal_board.slots = Array.new(6) do |i|
          Array.new(7) { |j| 'P1' if i == j && i < 4 }
        end.reverse
      end

      it 'returns true' do
        expect(diagonal_board.four_diagonal).to be true
      end
    end
  end

  describe '#four_row' do
    subject(:row_board) { described_class.new }

    context 'with a complete row' do
      before do
        row_board.slots = Array.new(6) { |i| Array.new(7) { |j| 'P1' if i == 5 && j < 4 } }
      end

      it 'returns true' do
        expect(row_board.four_row).to be true
      end
    end
  end

  describe '#four_column' do
    subject(:column_board) { described_class.new }

    context 'with a complete column' do
      before do
        column_board.slots = Array.new(6) { Array.new(7) { |i| 'P1' if i.zero? } }
      end

      it 'returns true' do
        expect(column_board.four_column).to be true
      end
    end
  end

  describe '#drop' do
  end

  describe '#full?' do
  end

  describe '#empty?' do
  end
end
