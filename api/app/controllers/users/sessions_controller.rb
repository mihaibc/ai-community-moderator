class Users::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :ensure_json_request

  # POST /users/sign_in
  def create
    creds = params.require(:user).permit(:email, :password)
    if creds[:email].blank? || creds[:password].blank?
      return render json: { error: 'email and password required' }, status: :unprocessable_entity
    end

    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    token = request.env['warden-jwt_auth.token']
    if token.blank?
      # Fallback: generate a token if Warden did not populate the env
      encoder = Warden::JWTAuth::UserEncoder.new
      token, _payload = encoder.call(resource, resource_name, nil)
    end

    response.set_header('Authorization', "Bearer #{token}") if token.present?

    render json: { email: resource.email, role: resource.role, token: token }, status: :ok
  rescue ::Warden::NotAuthenticated
    render json: { error: 'Invalid email or password' }, status: :unauthorized
  end

  private

  def respond_to_on_destroy
    head :no_content
  end

  def ensure_json_request
    request.format = :json
  end
end
