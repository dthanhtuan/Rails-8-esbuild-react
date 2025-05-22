require "jwt"

class JwtService
  DEFAULT_ALGORITHM = "HS256"

  def self.encode(payload, secret)
    raise JWT::EncodeError if secret.blank?

    # Encode the payload with the secret key and algorithm
    JWT.encode(payload, secret, DEFAULT_ALGORITHM)
  end

  def self.decode(token, secret)
    raise JWT::DecodeError if secret.blank?


    # JWT.decode return: [{user_id, exp, jti}, {"alg"=>"HS256"}]
    decoded = JWT.decode(token, secret, true, algorithm: DEFAULT_ALGORITHM).first
    decoded.deep_symbolize_keys
  end

  def self.token_blacklisted?(token)
    Blacklist.exists?(token: token)
  end

  def self.blacklist_token(token)
    Blacklist.create!(token: token)
  end

  def self.ban(refresh_token)
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
