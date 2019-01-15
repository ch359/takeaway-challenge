require 'takeaway'

describe Takeaway do

  subject(:takeaway) { described_class.new }

  # As a customer
  # So that I can check if I want to order something
  # I would like to see a list of dishes with prices

  context 'customers should be able to view the menu' do

    it 'should show customers a menu' do
      menu = ""
      expect(subject.menu).to eq(menu)
    end
  end
end
