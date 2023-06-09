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
  subject(:tictactoe_test) { described_class.new }

  describe '#match_winner' do
    context 'when player 1 has won' do
      before do
        allow(tictactoe_test.boards[:p1]).to receive(:match_end?).and_return(true)
      end

      it 'returns the appropiate string' do
        expect(tictactoe_test.match_winner).to eq('P1')
      end
    end

    context 'when player 2 has won' do
      before do
        allow(tictactoe_test.boards[:p2]).to receive(:match_end?).and_return(true)
      end

      it 'returns the appropiate string' do
        expect(tictactoe_test.match_winner).to eq('P2')
      end
    end

    context 'when no player has won' do
      it 'returns false' do
        expect(tictactoe_test.match_winner).to be false
      end
    end
  end

  describe '#advance_turn' do
    before do
      tictactoe_test.current_turn = :p1
      tictactoe_test.next_turn = :p2
    end

    it 'changes current_turn' do
      expect { tictactoe_test.advance_turn }.to change(tictactoe_test, :current_turn).to(:p2)
    end

    it 'changes next_turn' do
      expect { tictactoe_test.advance_turn }.to change(tictactoe_test, :next_turn).to(:p1)
    end
  end

  describe '#process_turn' do
    before do
      allow(tictactoe_test).to receive(:mark_space).and_return(true)
      allow(tictactoe_test).to receive(:get_ply_input)
    end

    it 'sends #mark_space' do
      expect(tictactoe_test).to receive(:mark_space)
      tictactoe_test.process_turn
    end

    it 'sends #get_ply_input' do
      expect(tictactoe_test).to receive(:get_ply_input)
      tictactoe_test.process_turn
    end

    context 'when #mark_space returns true' do
      before do
        allow(tictactoe_test).to receive(:match_winner)
        allow(tictactoe_test).to receive(:moves_possible?)
      end

      it 'sends #match_winner' do
        expect(tictactoe_test).to receive(:match_winner)
        tictactoe_test.process_turn
      end

      it 'sends #moves_possible?' do
        expect(tictactoe_test).to receive(:moves_possible?)
        tictactoe_test.process_turn
      end
    end
  end

  describe '#process_input' do
    it 'converts user string into int tuple' do
      user_input = '3 4'
      expect(tictactoe_test.process_input(user_input)).to contain_exactly(2, 3)
    end
  end

  describe '#game_over?' do
    context 'when no moves are possible' do
      context 'when a player has won' do
        before do
          allow(tictactoe_test).to receive(:match_winner).and_return('P1')
          allow(tictactoe_test).to receive(:moves_possible?).and_return(false)
        end

        it 'returns true' do
          expect(tictactoe_test).to be_game_over
        end
      end

      context 'when no player has won' do
        before do
          allow(tictactoe_test).to receive(:match_winner)
          allow(tictactoe_test).to receive(:moves_possible?).and_return(false)
        end

        it 'returns true' do
          expect(tictactoe_test).to be_game_over
        end
      end
    end

    context 'when moves are possible' do
      context 'when a player has won' do
        before do
          allow(tictactoe_test).to receive(:match_winner).and_return('P1')
          allow(tictactoe_test).to receive(:moves_possible?).and_return(true)
        end

        it 'returns true' do
          expect(tictactoe_test).to be_game_over
        end
      end

      context 'when no player has won' do
        before do
          allow(tictactoe_test).to receive(:match_winner)
          allow(tictactoe_test).to receive(:moves_possible?).and_return(true)
        end

        it 'returns false' do
          expect(tictactoe_test).not_to be_game_over
        end
      end
    end
  end

  describe '#mark_space' do
    context 'when an empty space is selected' do
      it 'increases turn count' do
        expect { tictactoe_test.mark_space(0, 0) }.to change(tictactoe_test, :turns).by(1)
      end

      it 'marks space' do
        current_turn = :p1
        tictactoe_test.mark_space(0, 0)
        expect(tictactoe_test.boards[current_turn].spaces[0][0]).to be true
      end
    end

    context 'when an occupied space is selected' do
      before do
        next_turn = :p2
        busy_board = Array.new(3) { Array.new(3, true) }
        tictactoe_test.boards[next_turn].spaces = busy_board
      end

      it 'returns false' do
        expect(tictactoe_test.mark_space(0, 0)).to be false
      end
    end
  end

  describe '#moves_possible?' do
    context 'when no moves are possible' do
      before do
        allow(tictactoe_test.boards[:p1]).to receive(:spaces_taken).and_return(4)
        allow(tictactoe_test.boards[:p2]).to receive(:spaces_taken).and_return(5)
      end

      it 'returns false' do
        expect(tictactoe_test.moves_possible?).to be false
      end
    end

    context 'when moves are possible' do
      it 'returns true' do
        expect(tictactoe_test.moves_possible?).to be true
      end
    end
  end

  describe '#get_ply_input' do
    xit 'sends process_input' do
    end
  end
end
