require 'error/base_error'
require 'error/helpers/render'

module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e.to_s)
        end
        rescue_from ::Error::BaseError do |e|
          respond(e.error, e.status, e.message.to_s)
        end
      end
    end

    private

    def respond(_error, _status, _message)
      json = Error::Helpers::Render.json(_error, _status, _message)
      render json: json, status: _status
    end
  end
end
