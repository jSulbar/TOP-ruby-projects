require_relative '../lib/connect_four'

describe ConnectFour do
  describe '#game_over?' do
    context 'with a winning player' do
      let(:win_board) { double(won?: true) }
      subject(:connect_end_win) { described_class.new(win_board) }

      it 'returns true' do
        expect(connect_end_win).to be_game_over
      end
    end

    context 'with no winning player' do
      context 'when the board is full' do
        let(:full_board) { double(full?: true) }
        subject(:connect_end_full) { described_class.new(full_board) }

        it 'returns true' do
          expect(connect_end_full).to be_game_over
        end
      end

      context 'when slots are still available' do
        subject(:connect_end) { described_class.new }

        it 'returns false' do
          expect(connect_end).not_to be_game_over
        end
      end
    end
  end
end
