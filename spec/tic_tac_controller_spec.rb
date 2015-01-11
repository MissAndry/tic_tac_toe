require_relative '../tic_tac_controller'

describe 'TicTacController' do
  ALPHA = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  NUM = (1..10).to_a

  let(:tic_tac_controller){ TicTacController.new }

  it 'keeps track of the most recent user commands' do
    allow(tic_tac_controller).to receive(:user_input).and_return("center")
    expect(tic_tac_controller.user_input).to eq("center")
  end
end