require 'spec_helper'
describe LolitaBankLink::TransactionsController do
  render_views
  let(:reservation) { Fabricate(:reservation) }

  describe '#checkout' do
    before do
      session[:payment_data] = {
        billing_class: 'Reservation',
        billing_id: reservation.id
      }
    end

    context 'with paid payment' do
      before do
        Reservation.any_instance.stub(paid?: true)
      end

      it 'returns error' do
        get :checkout
        expect(response.status).to eq(400)
      end
    end

    context 'with unpaid payment' do
      it 'renders form' do
        get :checkout
        expect(response).to render_template('lolita_bank_link/payment_form')
      end
    end
  end

  describe '#answer' do
    let(:params) { { 'VK_T_NO' => '109', 'encoding' => 'UTF-8', 'VK_SND_NAME' => 'MAX PAYNE', 'VK_REF' => transaction.id, 'VK_REC_ID' => ENV['BANK_LINK_SENDER'], 'VK_SND_ACC' => 'LV95HABA9000000900009', 'VK_STAMP' => '68', 'VK_T_DATE' => '01.01.2000', 'VK_AMOUNT' => '20.00', 'VK_REC_NAME' => 'Some INC', 'VK_SERVICE' => '1101', 'VK_LANG' => 'LAT', 'VK_AUTO' => 'N', 'VK_MSG' => 'webstore.com - R07111973', 'VK_ENCODING' => 'UTF-8', 'VK_VERSION' => '008', 'VK_SND_ID' => 'HP', 'locale' => 'lv', 'VK_CURR' => 'EUR', 'VK_REC_ACC' => 'LV12HABA0111111111111' } }
    let(:transaction) { Fabricate(:transaction, paymentable: reservation) }

    context 'user request via return button' do
      it 'fails with wrong request' do
        get :answer
        expect(response.body).to eq('Wrong request')
      end

      it 'successfullies handle transaction' do
        transaction
        get :answer, params.merge('VK_MAC' => get_vk_mac(params))

        expect(transaction.reload.status).to eq('completed')
        expect(transaction.reload.paymentable.paid?).to be_true
        expect(response).to redirect_to('/reservation/done')
      end

      it 'successfullies redirect if transaction is already completed' do
        transaction.update_attribute(:status, 'completed')
        get :answer, params.merge('VK_MAC' => get_vk_mac(params))
        expect(response).to redirect_to('/reservation/done')
      end
    end

    context 'when bank makes request' do
      it 'fails with wrong request' do
        get :answer, params.merge('VK_AUTO' => 'Y')
        expect(response.body).to eq('Wrong request')
      end

      it 'successfullies handle transaction' do
        transaction
        get :answer, params.merge('VK_MAC' => get_vk_mac(params), 'VK_AUTO' => 'Y')

        expect(transaction.reload.status).to eq('completed')
        expect(transaction.reload.paymentable.paid?).to be_true
        expect(response.code).to eq('200')
      end
    end
  end
end
