require './lib/chessboard'

describe Chessboard do
  let(:black_knight) do
    double(
      available_tiles: [[1, 5], [1, 3], [2, 2], [4, 2],
                        [5, 3], [5, 5], [4, 6], [2, 6]],
      color: :black
    )
  end

  describe '#tiles_covered' do
    let(:black_pawn) { double(available_tiles: [[5, 0], [5, 2]], color: :black) }
    subject(:cover_chessboard) { described_class.new }

    context 'with a populated board' do
      it "returns all the tiles covered by the player's pieces" do
        cover_chessboard[3][4] = black_knight
        cover_chessboard[6][1] = black_pawn
        expect(cover_chessboard.tiles_covered(:black)).to eq(
          black_knight.available_tiles + black_pawn.available_tiles
        )
      end
    end

    context 'with an empty board' do
      it 'returns an empty array' do
        expect(cover_chessboard.tiles_covered(:black)).to eq([])
      end
    end
  end
end
