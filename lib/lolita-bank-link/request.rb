module LolitaBankLink
  class Request
    attr_reader :crypt, :payment, :transaction
    
    def initialize payment, transaction
      @transaction = transaction
      @payment = payment
      @crypt = LolitaBankLink::Crypt.new
    end

    def build_form_data(data = {})
      data[:stamp] = self.payment.id
      data[:ref] = self.transaction.id
      data[:snd_id] = LolitaBankLink.sender
      data[:amount] = amount(self.payment.price)
      data[:curr] = self.payment.currency
      data[:msg] = self.payment.description
      prepare_for_banklink(data)
    end

    private

    def prepare_for_banklink(data = {})
      data[:service] = "1002"
      data[:version] = "008"
      data[:mac] = self.crypt.calc_mac_signature(data)
      data[:lang] = data[:lang] || LolitaBankLink.lang
      data[:encoding] = data[:encoding] || "UTF-8"
      data
    end

    def amount(money)
      return nil if money.nil?
      cents = money.respond_to?(:cents) ? money.cents : money

      if money.is_a?(String) || cents.to_i < 0
        raise ArgumentError, "money amount must be either a Money object or a positive integer in cents."
      end

      sprintf("%.2f", cents.to_f / 100)
    end

  end
end
