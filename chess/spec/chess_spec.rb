require './lib/chess'

describe Chess do
  let(:board_double) { double('Chessboard') }
  subject(:chess_game) { described_class.new(board_double) }

  describe '#process_input' do
    it 'returns the coordinates of piece and its destination' do
      expect(chess_game.process_input('Qh4d8')).to eq([[4, 7], [0, 3]])
    end

    context 'when RESIGN is input' do
      it "returns the player's color symbol" do
        chess_game.turn_queue = [:white, :black]
        expect(chess_game.process_input('RESIGN')).to eq(:white)
      end
    end
  end
end
