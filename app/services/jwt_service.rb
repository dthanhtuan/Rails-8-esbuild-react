require "jwt"

class JwtService
  DEFAULT_ALGORITHM = "HS256"
  GRACE_PERIOD_SECONDS = 120 # 2 minutes

  def self.encode(payload, secret)
    raise JWT::EncodeError if secret.blank?

    # Encode the payload with the secret key and algorithm
    JWT.encode(payload, secret, DEFAULT_ALGORITHM)
  end

  def self.decode(token, secret)
    raise JWT::DecodeError if secret.blank?


    # JWT.decode return: [{user_id, exp, jti}, {"alg"=>"HS256"}]
    # The `true` flag: verification of the JWT signature and claims such as expiration, issuer, audience, etc
    # The `false` flag: false	Skip verification, useful for debugging or reading payload only
    decoded = JWT.decode(token, secret, true, algorithm: DEFAULT_ALGORITHM).first
    decoded.deep_symbolize_keys
  end

  def self.token_blacklisted?(token)
    Blacklist.exists?(token: token)
  end

  # Check if the token is blacklisted and within the grace period
  #     - If blacklisted and within grace period, allow one last use
  #     - If blacklisted and outside grace period, reject the request
  #     - If not blacklisted, allow the request
  def self.refresh_token_reused_detected?(token)
    blacklist_entry = Blacklist.find_by(token: token)
    return false unless blacklist_entry

    Time.current > blacklist_entry.created_at + GRACE_PERIOD_SECONDS
  end


  # Called when reuse of revoked token is detected
  #     # - Revoke all tokens for the user
  #     # - Notify admins or security team
  #     # - Force user logout or password reset
  def self.detect_reuse(token)
    Rails.logger.warn("Refresh token reuse detected: #{token}")
  end

  def self.blacklist_token(token)
    Blacklist.create!(token: token)
  end

  def self.revoke(refresh_token)
    JwtService.blacklist_token(refresh_token)
  end

  # NOTE: For testing purposes only, use static text
  # This should be a secure secret key stored in credential or a secrets manager
  def self.access_secret
    "test_access_secret_ce30b51d92ac4f98fcf0aa6cac142629"
  end

  # NOTE: For testing purposes only, use static text
  # # This should be a secure secret key stored in credential or a secrets manager
  def self.refresh_secret
    "test_refresh_secret_5ea4d75bd56613cf04a9670b9dfa8a7e"
  end
end
