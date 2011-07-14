class LolitaBankLinkGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
    usage if @args.first == "help"
  end

  def manifest
    record do |m|
      m.migration_template "bank_link_transactions.erb", "db/migrate", :migration_file_name => "create_bank_link_transactions"
    end
  end
end