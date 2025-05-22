module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, only: [ :current ]

    # POST /api/users/me - login and get tokens
    def me
      user = User.find_by(email: params[:email].to_s.downcase)

      if user&.authenticate(params[:password])
        access_token = generate_access_token(user)
        refresh_token = generate_refresh_token(user)

        # expire_in: tells the client how many seconds from now token is valid
        render json: {
          access_token: access_token,
          refresh_token: refresh_token,
          expires_in: 15.minutes.to_i
        }, status: :ok
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    end

    def current
      render json: @current_user.as_json(only: [ :id, :email, :created_at ])
    end

    # POST /api/users/refresh - refresh access token
    def refresh
      refresh_token = params[:refresh_token]
      return invalid_token_error unless refresh_token

      # Check if token is blacklisted before decoding
      if JwtService.token_blacklisted?(refresh_token)
        return render json: { error: "Refresh token revoked" }, status: :unauthorized
      end

      begin
        decoded = JwtService.decode(refresh_token, JwtService.refresh_secret)
        user = User.find(decoded[:user_id])
        new_access_token = generate_access_token(user)
        new_refresh_token = generate_refresh_token(user)
        JwtService.revoke(refresh_token) # Blacklist the old refresh token
        render json: {
          access_token: new_access_token,
          refresh_token: new_refresh_token,
          expires_in: 15.minutes.to_i
        }, status: :ok
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        invalid_token_error
      end
    end

    private

    def authenticate_user!
      header = request.headers["Authorization"]
      token = header&.split(" ")&.last
      return render json: { error: "Missing token" }, status: :unauthorized unless token

      begin
        decoded = JwtService.decode(token, JwtService.access_secret)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    end

    def generate_access_token(user)
      payload = {
        user_id: user.id,
        exp: 15.minutes.from_now.to_i,
        jti: SecureRandom.uuid
      }
      JwtService.encode(payload, JwtService.access_secret)
    end

    def generate_refresh_token(user)
      payload = {
        user_id: user.id,
        exp: 7.days.from_now.to_i,
        jti: SecureRandom.uuid
      }
      JwtService.encode(payload, JwtService.refresh_secret)
    end

    def invalid_token_error
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    end
  end
end
