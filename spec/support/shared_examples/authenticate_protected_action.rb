shared_examples 'authenticate protected action' do
  it { expect(response).to eq 401 }
end
