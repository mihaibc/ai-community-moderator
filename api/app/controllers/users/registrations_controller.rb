class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :ensure_json_request

  # POST /users
  def create
    build_resource(sign_up_params)
    resource.role = :member if resource.respond_to?(:role) && resource.role.nil?

    if resource.save
      # Sign in to trigger Warden JWT hook
      sign_in(resource_name, resource)

      token = request.env["warden-jwt_auth.token"]
      if token.blank?
        encoder = Warden::JWTAuth::UserEncoder.new
        token, _payload = encoder.call(resource, resource_name, nil)
      end

      response.set_header("Authorization", "Bearer #{token}") if token.present?
      render json: { email: resource.email, role: resource.role, token: token }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ensure_json_request
    request.format = :json
  end
end

