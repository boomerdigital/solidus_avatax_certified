# frozen_string_literal: true

# Avatax tax calculation API calls
class TaxSvc
  def get_tax(request_hash)
    log(__method__, request_hash)

    req = client.create_or_adjust_transaction(request_hash)
    response = SolidusAvataxCertified::Response::GetTax.new(req)

    handle_response(response)
  end

  def cancel_tax(transaction_code)
    log(__method__, transaction_code)

    req = client.void_transaction(company_code, transaction_code, code: 'DocVoided')
    response = SolidusAvataxCertified::Response::CancelTax.new(req)

    handle_response(response)
  end

  def ping
    log(__method__)

    SolidusAvataxCertified::Response::Base.new(client.list_my_subscriptions)
  end

  def validate_address(address)
    log(__method__, address)

    begin
      request = client.resolve_address(address)
    rescue StandardError => e
      request = { 'error' => { 'message' => e } }
    end

    response = SolidusAvataxCertified::Response::AddressValidation.new(request)
    handle_response(response)
  end

  protected

  def handle_response(response)
    result = response.result
    logger.debug(result, response.description + ' Response')

    if response.error?
      logger.error(result, response.description + ' Error')
      raise SolidusAvataxCertified::RequestError, result if raise_exceptions?
    end

    response
  end

  def logger
    @logger ||= SolidusAvataxCertified::AvataxLog.new('TaxSvc class', 'Call to tax service')
  end

  private

  def tax_calculation_enabled?
    Spree::Avatax::Config.tax_calculation
  end

  def account
    Spree::Avatax::Config.account
  end

  def license_key
    Spree::Avatax::Config.license_key
  end

  def raise_exceptions?
    Spree::Avatax::Config.raise_exceptions
  end

  def company_code
    Spree::Avatax::Config.company_code
  end

  def endpoint
    if Spree::Avatax::Config.environment == 'production'
      'https://rest.avatax.com'
    else
      'https://sandbox-rest.avatax.com'
    end
  end

  def client
    @client ||= AvaTax::Client.new(
      endpoint: endpoint,
      username: account,
      password: license_key,
      connection_options: Spree::Avatax::Config.connection_options,
      faraday_response: true
    )
  end

  def log(method, request_hash = nil)
    return if request_hash.nil?

    logger.debug(request_hash, "#{method} request hash")
  end
end
