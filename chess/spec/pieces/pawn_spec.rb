require './lib/pieces/pawn'

describe Pawn do
  describe '#front' do
    context 'with white' do
      subject(:pawn_front) { described_class.new(:white) }

      it 'returns an inverted coordinate' do
        expect(pawn_front.front(3)).to eq(-3)
      end
    end

    context 'with black' do
      subject(:pawn_front) { described_class.new(:black) }

      it 'returns the same coordinate' do
        expect(pawn_front.front(3)).to eq(3)
      end
    end
  end

  describe '#diagonal_pieces' do
    subject(:diagonal_pawn) { described_class.new(:white) }

    context 'with a piece in range' do
      let(:board_range) { double('Board') }

      before do
        allow(board_range).to receive(:enemy_piece?)
          .with(:white, 2, 3).and_return(false)
        allow(board_range).to receive(:enemy_piece?)
          .with(:white, 2, 5).and_return(true)
      end

      it 'returns attack coordinates' do
        expect(
          diagonal_pawn.diagonal_pieces([3, 4], board_range)
        ).to contain_exactly([2, 5])
      end
    end
  end
end
