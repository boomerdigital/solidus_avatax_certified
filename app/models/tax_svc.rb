require 'json'
require 'net/http'
require 'addressable/uri'
require 'base64'
require 'rest-client'
require 'logging'

# Avatax tax calculation API calls
class TaxSvc
  def get_tax(request_hash)
    log(__method__, request_hash)
    RestClient.log = logger.logger

    response = SolidusAvataxCertified::Response::GetTax.new(request('get', request_hash))

    handle_response(response)
  end

  def cancel_tax(transaction_code)
    log(__method__, transaction_code)

    req = client.transactions.void(company_code, transaction_code)
    response = SolidusAvataxCertified::Response::CancelTax.new(req.body)

    handle_response(response)
  end

  def ping
    logger.info 'Ping Call'

    # Testing if configuration is set up properly, ping will fail if it is not
    client.tax_rates.get(:by_postal_code, { country: 'US', postalCode: '07801' })
  end

  def validate_address(address)
    begin
      request = client.addresses.validate(address).body
    rescue => e
      logger.error(e)

      request = { 'error' => { 'message' => e } }
    end

    response = SolidusAvataxCertified::Response::AddressValidation.new(request)
    handle_response(response)
  end

  protected

  def handle_response(response)
    result = response.result
    begin
      if response.error?
        raise SolidusAvataxCertified::RequestError.new(result)
      end

      logger.debug(result, response.description + ' Response')

    rescue SolidusAvataxCertified::RequestError => e
      logger.error(e.message, response.description + ' Error')
      raise if raise_exceptions?
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

  def credential
    'Basic ' + Base64.encode64(account_number + ':' + license_key)
  end

  def service_url
    Spree::Avatax::Config.endpoint + AVATAX_SERVICEPATH_TAX
  end

  def address_service_url
    Spree::Avatax::Config.endpoint + AVATAX_SERVICEPATH_ADDRESS + 'validate?'
  end

  def license_key
    Spree::Avatax::Config.license_key
  end

  def raise_exceptions?
    Spree::Avatax::Config.raise_exceptions
  end

  def account_number
    Spree::Avatax::Config.account
  end

  def username
    Spree::Avatax::Config.username
  end

  def password
    Spree::Avatax::Config.password
  end

  def company_code
    Spree::Avatax::Config.company_code
  end

  def client
    @client ||= Avatax::Client.new(
      username: username,
      password: password,
      env: Spree::AvataxConfiguration.environment
    )
  end

  def request(uri, request_hash)
    begin
      res = RestClient::Request.execute(method: :post,
                                  timeout: 1,
                                  open_timeout: 1,
                                  url: service_url + uri,
                                  payload:  JSON.generate(request_hash),
                                  headers: {
                                    authorization: credential,
                                    content_type: 'application/json'
                                  }
      )  do |response, request, result|
        response
      end

      JSON.parse(res)
    rescue => e
      logger.error(e, 'RestClient')
      e
    end
  end

  def log(method, request_hash = nil)
    return if request_hash.nil?
    logger.debug(request_hash, "#{method.to_s} request hash")
  end
end
