require 'rubygems'
require 'active_support'
require 'action_view'
require 'active_record'
require 'action_pack'
require 'action_controller'
require 'digest'
require 'digest/md5'
require 'openssl'
require "lolita/bank_link/bank_link"
require "lolita/bank_link/version"
require "lolita/bank_link/crypt"
require "lolita/bank_link/billing"
require "lolita/bank_link/rails"

require File.join(File.dirname(__FILE__), '../', 'app', 'helpers', 'bank_link_helper')
ActionView::Base.send :include, BankLinkHelper
