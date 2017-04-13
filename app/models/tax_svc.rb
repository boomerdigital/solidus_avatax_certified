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

    begin
      response = SolidusAvataxCertified::Response::GetTax.new(request('get', request_hash))

      if response.error?
        raise response.tax_result
      end

      logger.debug(response.tax_result, 'Get Tax Response')
    rescue => e
      logger.error(e, 'Get Tax Error')
    end

    response
  end

  def cancel_tax(request_hash)
    log(__method__, request_hash)

    begin
      response = SolidusAvataxCertified::Response::CancelTax.new(request('cancel', request_hash))
      tax_result = response.tax_result

      if response.error?
        raise tax_result
      end

      logger.debug(tax_result, 'Cancel Tax Response')
    rescue => e
      logger.error e, 'Cancel Tax Error'
    end

    response
  end

  def estimate_tax(coordinates, sale_amount)
    if tax_calculation_enabled?
      log(__method__)

      return nil if coordinates.nil?
      sale_amount = 0 if sale_amount.nil?
      coor = coordinates[:latitude].to_s + ',' + coordinates[:longitude].to_s

      uri = URI(service_url + coor + '/get?saleamount=' + sale_amount.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = 1
      http.read_timeout = 1

      res = http.get(uri.request_uri, 'Authorization' => credential, 'Content-Type' => 'application/json')
      JSON.parse(res.body)
    end
  rescue => e
    logger.error e, 'Estimate Tax Error'
    'Estimate Tax Error'
  end

  def ping
    logger.info 'Ping Call'
    estimate_tax({ latitude: '40.714623', longitude: '-74.006605' }, 0)
  end

  def validate_address(address)
    begin
      uri = URI(address_service_url + address.to_query)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = 1
      http.read_timeout = 1
      res = http.get(uri.request_uri, 'Authorization' => credential)

      logger.debug res, 'Address Validation Response'

      JSON.parse(res.body)
    rescue => e
      logger.error(e, 'Address Validation Error')
      "Address Validation Error: #{e}"
    end
  end

  protected

  def logger
    @logger ||= SolidusAvataxCertified::AvataxLog.new('TaxSvc class', 'Call to tax service')
  end

  private

  def tax_calculation_enabled?
    Spree::AvalaraPreference.tax_calculation.is_true?
  end

  def credential
    'Basic ' + Base64.encode64(account_number + ':' + license_key)
  end

  def service_url
    Spree::AvalaraPreference.endpoint.value + AVATAX_SERVICEPATH_TAX
  end

  def address_service_url
    Spree::AvalaraPreference.endpoint.value + AVATAX_SERVICEPATH_ADDRESS + 'validate?'
  end

  def license_key
    Spree::AvalaraPreference.license_key.value
  end

  def account_number
    Spree::AvalaraPreference.account.value
  end

  def request(uri, request_hash)
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
  end

  def log(method, request_hash = nil)
    return if request_hash.nil?
    logger.debug(request_hash, "#{method.to_s} request hash")
  end
end
