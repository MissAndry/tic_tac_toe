require_relative '../tic_tac_controller'

describe 'TicTacController' do
  ALPHA = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  NUM = (1..10).to_a
  
  let(:tic_tac_controller){ TicTacController.new }

  describe '#help?' do
    it 'returns the help screen when passed the argument "help"' do
      expect(tic_tac_controller.help?("help")).to eq(GameView.help)
    end

    it 'returns nothing when it\'s passed anything besides "help"' do
      word = ""
      NUM.sample.times { word += ALPHA.sample }
      expect(tic_tac_controller.help?(word)).to eq nil
    end
  end
end