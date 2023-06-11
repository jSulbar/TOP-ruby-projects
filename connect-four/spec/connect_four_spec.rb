require_relative '../lib/connect_four'

describe ConnectFour do
  describe '#game_over?' do
    context 'with a winning player' do
      let(:win_board) { double(won?: true, full?: false) }
      subject(:connect_end_win) { described_class.new(win_board) }

      it 'returns true' do
        expect(connect_end_win).to be_game_over
      end
    end

    context 'with no winning player' do
      context 'when the board is full' do
        let(:full_board) { double(full?: true, won?: false) }
        subject(:connect_end_full) { described_class.new(full_board) }

        it 'returns true' do
          expect(connect_end_full).to be_game_over
        end
      end

      context 'when slots are still available' do
        let(:even_board) { double(full?: false, won?: false) }
        subject(:connect_end) { described_class.new(even_board) }

        it 'returns false' do
          expect(connect_end).not_to be_game_over
        end
      end
    end
  end

  describe '#process_input' do
    subject(:connect_input) { described_class.new }

    before do
      @player = 'P1'
    end

    context 'with valid input' do
      it 'returns the chosen column and current player' do
        expect(connect_input.process_input('3')).to eq([2, @player])
      end
    end

    context 'with invalid input' do
      it 'returns nil when column out of range' do
        expect(connect_input.process_input('9')).to be_nil
      end

      it 'returns nil when column is negative' do
        expect(connect_input.process_input('-4')).to be_nil
      end
    end
  end

  describe '#advance_turn' do
    subject(:advance_board) { described_class.new }

    it "switches the players' turns" do
      advance_board.turn_queue = %w[P1 P2]
      expect { advance_board.advance_turn }.to change(advance_board, :turn_queue).to(%w[P2 P1])
    end
  end

  describe '#process_turn' do
    subject(:connect_process) { described_class.new }

    context 'with invalid user input' do
      before do
        allow(connect_process).to receive(:get_ply_input)
        allow(connect_process).to receive(:gets).and_return("9\n", "4\n", "3\n")
      end

      it 'calls get_player_input until valid input is given' do
        expect(connect_process).to receive(:gets).exactly(3).times
        connect_process.process_turn
      end
    end

    it 'calls process_input' do
      allow(connect_process.board).to receive(:process_input)
      expect(connect_process.board).to receive(:process_input)
      connect_process.process_turn
    end

    it 'drops the token onto the board' do
      allow(connect_process.board).to receive(:drop)
      expect(connect_process.board).to receive(:drop)
      connect_process.process_turn
    end
  end

  describe '#match_winner' do
    subject(:connect_winner) { described_class.new }

    context 'when a player has won' do
      it 'returns name of the winner' do
        allow(connect_winner).to receive(:won?).with('P1').and_return(true)
        expect(connect_winner.match_winner).to eq('P1')
      end
    end
  end
end
