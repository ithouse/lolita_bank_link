module Lolita::BankLink
  class Crypt
    $KCODE="u" unless RUBY_VERSION =~ /^1\.9/
    
    def initialize
      @private_key = read_private_key(Lolita::BankLink.private_key)
      @public_key  = extract_public_key(Lolita::BankLink.bank_certificate)
      @digest = OpenSSL::Digest::SHA1.new
    end

    def sign message
      Base64::encode64(@private_key.sign(@digest, message)).rstrip
    end

    def verify_mac_signature(params, signature)
      mac = prepair_mac_string(params,params[:service])
      return verify(mac, signature)
    end

    def calc_mac_signature(params,service = '1002')
      mac = prepair_mac_string(params,service)
      enc_mac = self.sign(mac)
      return enc_mac
    end

    private

    def verify message, signature_base64
      decoded_signature = Base64::decode64(signature_base64)
      return @public_key.verify(@digest, decoded_signature, message)
    end

    def prepair_mac_string(post, service)
      required_fields = Lolita::BankLink.required_params_by_service(service)
      mac = ""
      required_fields.each{|field|
        post[field] = post[field].to_s.strip
        mac += post[field].to_s.chars.count.to_s.rjust(3,'0') + post[field].to_s
      }
      mac
    end

    def read_private_key key_path
      OpenSSL::PKey::RSA.new File.read(key_path)
    end

    def extract_public_key cert_path
      OpenSSL::X509::Certificate.new(File.read(cert_path).gsub(/  /, '')).public_key
    end

  end
end
