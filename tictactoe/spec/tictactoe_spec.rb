require_relative '../lib/tictactoe'

describe Board do
  subject(:board_test) { described_class.new }

  describe '#match_end?' do
    context 'when a player is winning' do
      context 'with horizontal marks' do
        it 'returns true when top row is marked' do
          board_test.spaces = Array.new(3) { |i| Array.new(3, i.zero?) }
          expect(board_test.match_end?).to be true
        end

        it 'returns true when middle row is marked' do
          board_test.spaces = Array.new(3) { |i| Array.new(3, i == 1) }
          expect(board_test.match_end?).to be true
        end

        it 'returns true when bottom row is marked' do
          board_test.spaces = Array.new(3) { |i| Array.new(3, i == 2) }
          expect(board_test.match_end?).to be true
        end
      end

      context 'with vertical marks' do
        it 'returns true when left column is marked' do
          board_test.spaces = Array.new(3) { Array.new(3, &:zero?) }
          expect(board_test.match_end?).to be true
        end

        it 'returns true when middle column is marked' do
          board_test.spaces = Array.new(3) { Array.new(3) { |i| i == 1 } }
          expect(board_test.match_end?).to be true
        end

        it 'returns true when right column is marked' do
          board_test.spaces = Array.new(3) { Array.new(3) { |i| i == 2 } }
          expect(board_test.match_end?).to be true
        end
      end

      context 'with diagonal marks' do
        it 'returns true with slash pattern' do
          board_test.spaces = Array.new(3) { |i| Array.new(3) { |j| i == j } }
          expect(board_test.match_end?).to be true
        end

        it 'returns true with backslash pattern' do
          board_test.spaces = [[false, false, true], [false, true, false], [true, false, false]]
          expect(board_test.match_end?).to be true
        end
      end
    end

    context 'when no player is winning' do
      it 'does not return true' do
        board_test.spaces = Array.new(3) { Array.new(3, false) }
        expect(board_test.match_end?).not_to be true
      end
    end
  end

  describe '#spaces_taken' do
    context 'when no spaces are taken' do
      it 'returns 0' do
        board_test.spaces = Array.new(3) { Array.new(3, false) }
        expect(board_test.spaces_taken).to eq(0)
      end
    end

    context 'when all spaces are taken' do
      it 'returns 9' do
        board_test.spaces = Array.new(3) { Array.new(3, true) }
        expect(board_test.spaces_taken).to eq(9)
      end
    end
  end
end

describe TicTacToe do
  describe '#match_winner' do
    context 'when a player has won' do
      xit 'returns true' do
      end
    end

    context 'when no player has won' do
      xit 'returns false' do
      end
    end
  end

  describe '#advance_turn' do
    xit 'switches the player turn' do
    end
  end

  describe '#process_input' do
    before do
      # This needs method stubs
    end

    context 'with invalid use input' do
    end

    context 'with valid user input' do
    end
  end

  describe '#game_over?' do
    context 'when no moves are possible' do
    end

    context 'when a player has won' do
    end
  end

  describe '#mark_space' do
    xit 'marks an unoccupied space' do
    end

    xit "doesn't mark an occupied space" do
    end
  end

  describe '#moves_possible?' do
    context 'when no moves are possible' do
      xit 'returns false' do
      end
    end

    context 'when moves are possible' do
      xit 'returns true' do
      end
    end
  end

  describe '#get_ply_input' do
    xit 'sends process_input' do
    end
  end
end
