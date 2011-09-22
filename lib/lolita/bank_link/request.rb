module Lolita::BankLink
  class Request
    attr_reader :crypt, :payment, :transaction
    
    def initialize payment, transaction
      @transaction = transaction
      @payment = payment
      @crypt = Lolita::BankLink::Crypt.new
    end

    def build_form_data(data = {})
      data[:stamp] = self.payment.id
      data[:ref] = self.transaction.id
      data[:snd_id] = Lolita::BankLink.sender
      if need_convert_to_lvl?
        # avoid triple convert
        data[:amount] = amount(self.payment.price.exchange_to('LVL'))
        data[:curr] = 'LVL'
      else
        data[:amount] = amount(self.payment.price)
        data[:curr] = currency(self.payment.currency)
      end
      data[:msg] = self.payment.description
      prepare_for_banklink(data)
    end


    def prepare_for_banklink(data = {})
      data[:service] = '1002'
      data[:version] = '008'
      data[:mac] = self.crypt.calc_mac_signature(data)
      data[:lang] = data[:lang] || Lolita::BankLink.lang
      data[:encoding] = data[:encoding] || "UTF-8"
      data
    end

    private

    def currency value
      value =~ /\d{3}/ ? ISO4217[value] : value
    end

    def amount(money)
      return nil if money.nil?
      cents = money.respond_to?(:cents) ? money.cents : money

      if money.is_a?(String) or cents.to_i < 0
        raise ArgumentError, 'money amount must be either a Money object or a positive integer in cents.'
      end

      sprintf("%.2f", cents.to_f / 100)
    end

    ISO4217 = {
      '971' => 'AFA',
      '533' => 'AWG',
      '036' => 'AUD',
      '032' => 'ARS',
      '944' => 'AZN',
      '044' => 'BSD',
      '050' => 'BDT',
      '052' => 'BBD',
      '974' => 'BYR',
      '068' => 'BOB',
      '986' => 'BRL',
      '826' => 'GBP',
      '975' => 'BGN',
      '116' => 'KHR',
      '124' => 'CAD',
      '136' => 'KYD',
      '152' => 'CLP',
      '156' => 'CNY',
      '170' => 'COP',
      '188' => 'CRC',
      '191' => 'HRK',
      '196' => 'CPY',
      '203' => 'CZK',
      '208' => 'DKK',
      '214' => 'DOP',
      '951' => 'XCD',
      '818' => 'EGP',
      '232' => 'ERN',
      '233' => 'EEK',
      '978' => 'EUR',
      '981' => 'GEL',
      '288' => 'GHC',
      '292' => 'GIP',
      '320' => 'GTQ',
      '340' => 'HNL',
      '344' => 'HKD',
      '348' => 'HUF',
      '352' => 'ISK',
      '356' => 'INR',
      '360' => 'IDR',
      '376' => 'ILS',
      '388' => 'JMD',
      '392' => 'JPY',
      '368' => 'KZT',
      '404' => 'KES',
      '414' => 'KWD',
      '428' => 'LVL',
      '422' => 'LBP',
      '440' => 'LTL',
      '446' => 'MOP',
      '807' => 'MKD',
      '969' => 'MGA',
      '458' => 'MYR',
      '470' => 'MTL',
      '977' => 'BAM',
      '480' => 'MUR',
      '484' => 'MXN',
      '508' => 'MZM',
      '524' => 'NPR',
      '532' => 'ANG',
      '901' => 'TWD',
      '554' => 'NZD',
      '558' => 'NIO',
      '566' => 'NGN',
      '408' => 'KPW',
      '578' => 'NOK',
      '512' => 'OMR',
      '586' => 'PKR',
      '600' => 'PYG',
      '604' => 'PEN',
      '608' => 'PHP',
      '634' => 'QAR',
      '946' => 'RON',
      '643' => 'RUB',
      '682' => 'SAR',
      '891' => 'CSD',
      '690' => 'SCR',
      '702' => 'SGD',
      '703' => 'SKK',
      '705' => 'SIT',
      '710' => 'ZAR',
      '410' => 'KRW',
      '144' => 'LKR',
      '968' => 'SRD',
      '752' => 'SEK',
      '756' => 'CHF',
      '834' => 'TZS',
      '764' => 'THB',
      '780' => 'TTD',
      '949' => 'TRY',
      '784' => 'AED',
      '840' => 'USD',
      '800' => 'UGX',
      '980' => 'UAH',
      '858' => 'UYU',
      '860' => 'UZS',
      '862' => 'VEB',
      '704' => 'VND',
      '894' => 'AMK',
      '716' => 'ZWD'
    }

    def need_convert_to_lvl?
      false
    end
  end
end
