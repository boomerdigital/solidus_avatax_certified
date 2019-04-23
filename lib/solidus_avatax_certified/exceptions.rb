# frozen_string_literal: true

module SolidusAvataxCertified
  class ClientError < ::StandardError; end
  class RequestError < ClientError; end
end
