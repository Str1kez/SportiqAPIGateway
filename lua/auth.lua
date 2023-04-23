local auth = {
  _VERSION = "0.1.0"
}

local function check_bearer(header)
  local t = {}
  for str in string.gmatch(header, "%S+") do
    table.insert(t, str)
  end
  if t[1] ~= "Bearer" then
    return nil
  end
  return t[2]
end

local function validate_jwt(jwt_token, secret_key)
  local jwt = require "resty.jwt"
  local response = require "responses"

  local jwt_obj = jwt:verify(secret_key, jwt_token)
  if not jwt_obj["verified"] then
    if jwt_obj["reason"] == "invalid jwt string" then
      response.token_signature_failed()
    end
    if string.find(jwt_obj["reason"], "signature mismatch") ~= nil then
      response.token_signature_failed()
    end
    if string.find(jwt_obj["reason"], "'exp' claim expired") ~= nil then
      response.token_expired()
    end
    response.token_signature_failed()
  end
  if jwt_obj["payload"]["exp"] == nil then
    response.token_exp_upcent()
  end
  if jwt_obj["payload"]["type"] ~= "access" then
    response.token_type_invalid()
  end
  return jwt_obj
end

local function check_jwt(jwt_obj)
  local kds_db = require "key"
  local response = require "responses"

  if jwt_obj["payload"]["user"] == nil then
    response.token_user_upcent()
  end
  if jwt_obj["payload"]["jti"] == nil then
    response.token_id_upcent()
  end

  local kds = kds_db:new()

  local ok = kds:check_blacklist(jwt_obj["payload"]["user"], "user")
  if ok then
    response.user_deleted()
  end

  ok = kds:check_blacklist(jwt_obj["payload"]["jti"], "key")
  if ok then
    response.token_in_blacklist()
  end
  return jwt_obj
end

function auth.check_token(header, secret_key)
  local response = require "responses"

  if header["Authorization"] == nil then
    response.token_not_found()
  end

  local jwt_token = check_bearer(header["Authorization"])
  if not jwt_token then
    response.token_not_found()
  end

  local jwt_obj = validate_jwt(jwt_token, secret_key)

  local valid_jwt = check_jwt(jwt_obj)

  return valid_jwt
end

return auth
