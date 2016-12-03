describe 'factories' do
  FactoryGirl.factories.map(&:name).each do |factory|
    describe factory do
      let(:record) { build(factory) }

      it 'is valid' do
        expect(record).to be_valid
      end
    end
  end
end
