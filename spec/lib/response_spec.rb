require 'spec_helper'

describe LolitaBankLink::Response do
  let(:params) { { 'VK_T_NO' => '109', 'encoding' => 'UTF-8', 'VK_SND_NAME' => 'MAX PAYNE', 'VK_REF' => '1', 'VK_REC_ID' => 'TEST', 'VK_SND_ACC' => 'LV12HABA0000000000000', 'VK_STAMP' => '68', 'VK_T_DATE' => '01.01.2000', 'VK_AMOUNT' => '20.00', 'VK_REC_NAME' => 'Some INC', 'VK_SERVICE' => '1101', 'VK_LANG' => 'LAT', 'VK_AUTO' => 'N', 'VK_MSG' => 'SomeSite - R07007973', 'VK_ENCODING' => 'UTF-8', 'VK_VERSION' => '008', 'VK_SND_ID' => 'HP', 'locale' => 'lv', 'VK_MAC' => '', 'VK_CURR' => 'LVL', 'VK_REC_ACC' => 'LV12HABA0000000000000' } }
  subject(:response) { described_class.new(params) }

  it 'validates params' do
    params['VK_MAC'] = response.crypt.calc_mac_signature(response.params, '1101')
    described_class.any_instance.stub(transaction: double(status: 'processing'))
    expect(described_class.new(params)).to be_valid
  end

  describe '#update_transaction' do
    let(:transaction) { double(status: 'processing') }
    before do
      LolitaBankLink::Transaction.stub(where: double(first: transaction))
    end

    context 'with status processing' do
      context 'when success response' do
        it 'updates transaction with status completed' do
          params['VK_MAC'] = response.crypt.calc_mac_signature(response.params, '1101')
          transaction.should_receive(:update_attributes!).with(service: '1101', version: '008', snd_id: 'HP', rec_id: 'TEST', stamp: '68', t_no: '109', amount: '20.00', curr: 'LVL', rec_acc: 'LV12HABA0000000000000', rec_name: 'Some INC', snd_acc: 'LV12HABA0000000000000', snd_name: 'MAX PAYNE', ref: '1', msg: 'SomeSite - R07007973', t_date: '01.01.2000', status: 'completed')
          described_class.new(params).update_transaction
        end
      end

      context 'when failed response' do
        let(:params) { super().merge('VK_SERVICE' => '1901') }
        it 'updates transaction with status failed' do
          params['VK_MAC'] = response.crypt.calc_mac_signature(response.params, '1901')
          transaction.should_receive(:update_attributes!).with(service: '1901', version: '008', snd_id: 'HP', rec_id: 'TEST', stamp: '68', ref: '1', msg: 'SomeSite - R07007973', status: 'failed')
          described_class.new(params).update_transaction
        end
      end
    end

    context 'with status other than processing' do
      let(:transaction) { double(status: 'completed') }

      it 'does not update transaction' do
        transaction.should_not_receive(:update_attributes!)
        response.update_transaction
      end
    end
  end

  describe '#return_path' do
    let(:paymentable) { double(bank_link_return_path: '/done') }
    before do
      LolitaBankLink::Transaction.stub(where: double(first: double(paymentable: paymentable)))
    end

    it 'returns bank_link_return_path from paymentable' do
      paymentable.should_receive(:bank_link_return_path)
      response.return_path
    end
  end

  describe '#completed?' do
    context 'with VK_SERVICE == 1101' do
      it 'is true' do
        expect(subject.completed?).to be_true
      end
    end

    context 'with other VK_SERVICE' do
      let(:params) { super().merge('VK_SERVICE' => '19019') }

      it 'is false' do
        expect(subject.completed?).to be_false
      end
    end
  end

  describe '#transaction_completed?' do
    before do
      LolitaBankLink::Transaction.stub(where: double(first: transaction))
    end

    context 'is completed' do
      let(:transaction) { double('transaction', completed?: true) }
      it 'returns true' do
        expect(subject.transaction_completed?).to be_true
      end
    end

    context 'is not completed' do
      let(:transaction) { double('transaction', completed?: false) }
      it 'returns false' do
        expect(subject.transaction_completed?).to be_false
      end
    end
  end
end
