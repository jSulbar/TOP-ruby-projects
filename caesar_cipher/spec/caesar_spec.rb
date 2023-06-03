require './lib/caesar.rb'

describe 'rollover_shift' do
  it 'works for negative indexes out of range' do
    expect(rollover_shift(-30)).to eql(-4)
  end

  it 'works for positive indexes out of range' do
    expect(rollover_shift(30)).to eql(4)
  end

  it 'works for indexes inside of range' do
    expect(rollover_shift(12)).to eql(12)
  end
end

describe 'get_shifted_index' do
  it 'gets the shifted character' do
    expect(get_shifted_index('A', ('A'..'Z').entries)).to eql('D')
  end
end

describe 'caesar_cipher' do
  it 'correctly encrypts string' do
    expect(caesar_cipher('racecar', ('A'..'Z').entries)).to eql('udfhfdu')
  end

  it 'keeps case' do
    expect(caesar_cipher('RacEcaR', ('A'..'Z').entries)).to eql('UdfHfdU')
  end

  it 'accepts different shift' do
    expect(caesar_cipher('racecar', ('A'..'Z').entries, 8)).to eql('zikmkiz')
  end

  it 'accepts negative shift' do
    expect(caesar_cipher('racecar', ('A'..'Z').entries, -8)).to eql('jsuwusj')
  end
end
