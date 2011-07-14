module Lolita::BankLink
  class Crypt
    
    def initialize
      @private_key = read_private_key(Lolita::BankLink.private_key)
      @public_key  = extract_public_key(Lolita::BankLink.bank_certificate)
      @digest = OpenSSL::Digest::SHA1.new
    end

    def sign message
      Base64::encode64(@my_private.sign(@digest, message)).rstrip
    end

    def verify message, signature_base64
      decoded_signature = Base64::decode64(signature_base64)
      return @bank_public.verify(@digest, decoded_signature, message)
    end

    def prepair_mac_string(post, service)
      required_fields = required_params_by_service(service)
      mac = ""
      required_fields.each{|field|
        raise ArgumentError, "BankLinkGateway a required field #{field.to_s} for signing is not available or service: #{service}" if !post[field]
        post[field] = post[field].to_s.strip
        mac += post[field].to_s.size.to_s.rjust(3,'0') + post[field].to_s
      }
      mac
    end

    def calc_mac_signature(post,service = '1002')
      mac = prepair_mac_string(post,service)
      enc_mac = Lolita::BankLink::Crypt.new.sign(mac)
      return enc_mac
    end

    def verify_mac_signature(post, signature)
      mac = prepair_mac_string(post,post[:service])
      return Lolita::BankLink::Crypt.new.verify(mac, signature)
    end

    private

    def read_private_key key_path
      OpenSSL::PKey::RSA.new File.read(key_path)
    end

    def extract_public_key cert_path
      OpenSSL::X509::Certificate.new(File.read(cert_path).gsub(/  /, '')).public_key
    end

  end
end