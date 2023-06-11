require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    subject(:board_init) { described_class.new }

    it 'creates a 7x6 size 2d array' do
      slot_count = board_init.slots.flatten.length
      expect(slot_count).to eq(7 * 6)
    end
  end

  describe '#check_slot' do
    subject(:slot_board) { described_class.new }

    before do
      slot_board.slots = Array.new(6) { Array.new(7, 'P1') }
    end

    context 'with an invalid index' do
      it 'returns nil with column index out of range' do
        expect(slot_board.check_slot(0, 9)).to be_nil
      end

      it 'returns nil with row index out of range' do
        expect(slot_board.check_slot(8, 0)).to be_nil
      end

      it 'returns nil when under zero' do
        expect(slot_board.check_slot(-2, -3)).to be_nil
      end
    end

    context 'with a valid index' do
      it 'returns the value in position' do
        slot_board.slots[3][4] = 'Fart'
        expect(slot_board.check_slot(3, 4)).to eq('Fart')
      end

      it 'returns the value in edge of board' do
        slot_board.slots[5][6] = 'Fart'
        expect(slot_board.check_slot(5, 6)).to eq('Fart')
      end

      it 'returns the value at minimum indexes' do
        slot_board.slots[0][0] = 'Fart'
        expect(slot_board.check_slot(0, 0)).to eq('Fart')
      end
    end
  end

  describe '#won?' do
    subject(:board_win) { described_class.new }

    before do
      @winner = 'P1'
    end

    context 'with a connect-four present' do
      context 'with diagonal' do
        it 'returns true' do
          allow(board_win).to receive(:four_diagonal).and_return(true)
          expect(board_win.won?(@winner)).to be true
        end
      end

      context 'with row' do
        it 'returns true' do
          allow(board_win).to receive(:four_row).and_return(true)
          expect(board_win.won?(@winner)).to be true
        end
      end

      context 'with column' do
        it 'returns true' do
          allow(board_win).to receive(:four_column).and_return(true)
          expect(board_win.won?(@winner)).to be true
        end
      end
    end

    context 'with no connect-four' do
      it 'returns false' do
        expect(board_win.won?(@winner)).to be false
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
        expect(diagonal_board.four_diagonal('P1')).to be true
      end
    end

    context 'with right-leaning diagonal' do
      before do
        diagonal_board.slots = Array.new(6) do |i|
          Array.new(7) { |j| 'P1' if i == j && i < 4 }
        end.reverse
      end

      it 'returns true' do
        expect(diagonal_board.four_diagonal('P1')).to be true
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
        expect(row_board.four_row('P1')).to be true
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
        expect(column_board.four_column('P1')).to be true
      end
    end
  end

  describe '#drop' do
    subject(:drop_board) { described_class.new }

    before do
      @player = 'P1'
    end

    context 'with no other tokens in the column' do
      it 'drops into the bottom slot' do
        drop_board.drop(5, @player)
        expect(drop_board.slots.transpose[5]).to eq([nil, nil, nil, nil, nil, @player])
      end
    end

    context 'with other tokens in the column' do
      context "with another player's token" do
        it 'drops into the slot above it' do
          drop_board.slots[-1][5] = 'P2'
          drop_board.drop(5, @player)
          expect(drop_board.slots.transpose[5]).to eq([nil, nil, nil, nil, @player, 'P2'])
        end
      end

      context "with the same player's token" do
        it 'drops into slot above it' do
          drop_board.slots[-1][5] = @player
          drop_board.drop(5, @player)
          expect(drop_board.slots.transpose[5]).to eq([nil, nil, nil, nil, @player, @player])
        end
      end

      context 'when column has only the top slot empty' do
        before do
          -5.upto(-1) do |i|
            drop_board.slots[i][5] = 'P2'
          end
        end

        it 'drops onto the first slot' do
          drop_board.drop(5, @player)
          expect(drop_board.slots.transpose[5]).to eq([@player, 'P2', 'P2', 'P2', 'P2', 'P2'])
        end
      end
    end
  end

  describe '#full?' do
    subject(:board_full) { described_class.new }

    it 'returns true with a full board' do
      board_full.slots = Array.new(6) { Array.new(7, 'P1') }
      expect(board_full.full?).to be true
    end

    it 'returns false without a full board' do
      board_full.slots = Array.new(6) { Array.new(7) { |i| 'P1' if i.zero? } }
      expect(board_full.full?).to be false
    end
  end

  describe '#empty?' do
    subject(:board_empty) { described_class.new }

    it 'returns true with an empty board' do
      expect(board_empty.empty?).to be true
    end

    it 'returns false with a populated board' do
      board_empty.slots = Array.new(6) { Array.new(7) { |i| 'P1' if i.zero? } }
      expect(board_empty.empty?).to be false
    end
  end
end
