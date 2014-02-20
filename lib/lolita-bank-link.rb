require "digest/md5"
require "openssl"
require "lolita-bank-link/custom_logger"
require "lolita-bank-link/engine"
require "lolita-bank-link/version"
require "lolita-bank-link/bank_link"
require "lolita-bank-link/request"
require "lolita-bank-link/response"
require "lolita-bank-link/crypt"
require "lolita-bank-link/billing"

module LolitaBankLink
  mattr_accessor :custom_logger, :ssl_required

  def self.ssl_required
    @@ssl_required.nil? && true
  end

  def self.logger
    unless @logger
      @logger = custom_logger ? custom_logger : default_logger
    end
    @logger
  end

  protected

  def self.default_logger
    logger = Logger.new(Rails.root.join('log', 'lolita_bank_link.log'))
    logger.formatter = LolitaBankLink::LogFormatter.new
    logger
  end
end
