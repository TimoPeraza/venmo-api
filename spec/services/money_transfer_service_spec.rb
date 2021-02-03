describe MoneyTransferService do
  let!(:user) { create(:user) }
  let!(:payment_account) { create(:payment_account, user: user) }
  let!(:external_payment_source) { create(:external_payment_source, user: user) }
  let(:amount) { 50 }

  subject(:money_transfer_service) do
    MoneyTransferService.new(external_payment_source, user.payment_account).transfer(amount)
  end

  it 'adds amount to balance' do
    expect { money_transfer_service }.to change { user.payment_account.reload.balance }.from(500)
                                                                                       .to(550)
  end
end
