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
        expect(connect_input.process_input(3, @player)).to eq([3, @player])
      end
    end

    context 'with invalid input' do
      it 'returns nil when column out of range' do
        expect(connect_input.process_input(9, @player)).to be_nil
      end

      it 'returns nil when column is negative' do
        expect(connect_input.process_input(-4, @player)).to be_nil
      end
    end
  end
end
