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
      return nil, "token invalid"
    end
    if string.find(jwt_obj["reason"], "signature mismatch") ~= nil then
      response.token_signature_failed()
      return nil, "token invalid"
    end
    if string.find(jwt_obj["reason"], "'exp' claim expired") ~= nil then
      response.token_expired()
      return nil, "token expired"
    end
    response.token_signature_failed()
    return nil, "undefined error"
  end
  if jwt_obj["payload"]["exp"] == nil then
    response.token_exp_upcent()
    return nil, "exp upcent"
  end
  return jwt_obj, nil
end

local function check_jwt(jwt_obj)
  local kds_db = require "key"
  local response = require "responses"

  if jwt_obj["payload"]["user"] == nil then
    response.token_user_upcent()
    return nil, "user not found in token"
  end
  if jwt_obj["payload"]["jti"] == nil then
    response.token_id_upcent()
    return nil, "jti not found"
  end

  local kds = kds_db:new()

  local ok, err = kds:check_blacklist(jwt_obj["payload"]["user"], "user")
  if err then
    response.kds_error(err)
    return nil, err
  end
  if ok then
    response.user_deleted()
    return nil, "user deleted"
  end

  ok, err = kds:check_blacklist(jwt_obj["payload"]["jti"], "key")
  if err then
    response.kds_error(err)
    return nil, err
  end
  if ok then
    response.token_in_blacklist()
    return nil, "token in blacklist"
  end
  return jwt_obj, nil
end

function auth.check_token(header, secret_key)
  local response = require "responses"
  local cjson = require "cjson"

  if header["Authorization"] == nil then
    response.token_not_found()
    return nil, "token not found"
  end

  local jwt_token = check_bearer(header["Authorization"])
  if not jwt_token then
    response.token_not_found()
    return nil, "token not found"
  end

  local jwt_obj, err = validate_jwt(jwt_token, secret_key)
  if err then
    return nil, err
  end

  local valid_jwt, err = check_jwt(jwt_obj)
  if err then
    return nil, err
  end

  ngx.say(cjson.encode(valid_jwt))
end

return auth
