# frozen_string_literal: true

module SolidusAvataxCertified
  module Response
    class Base
      attr_accessor :result, :faraday

      def initialize(faraday)
        @faraday = faraday
      end

      def result
        @result ||= faraday.try(:body)
      end

      def success?
        faraday.try(:success?)
      end

      def error?
        !success?
      end

      def description
        raise 'Method needs to be implemented in subclass.'
      end
    end
  end
end
