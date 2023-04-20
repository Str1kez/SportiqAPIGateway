local responses = {
  _VERSION = "0.1.0"
}

function responses.kds_error(error)
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
  local detail = {
    { msg = error, type = "server.kds" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.say(cjson.encode(error_response))
end

function responses.token_not_found()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Токен не передан", type = "token.upcent" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_signature_failed()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Неверная подпись токена", type = "token.unverified" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_expired()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Время токена истекло", type = "token.expired" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_in_blacklist()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Tокен утилизирован", type = "token.blacklist" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_id_upcent()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "JTI отсутствует", type = "token.jti_upcent" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_user_upcent()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Пользователя нет в токене", type = "token.user_upcent" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.token_exp_upcent()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Время жизни не указано", type = "token.exp_upcent" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

function responses.user_deleted()
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_UNAUTHORIZED
  local detail = {
    { msg = "Пользователь удален", type = "user.deleted" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.header["WWW-Authenticate"] = "Bearer"
  ngx.say(cjson.encode(error_response))
end

return responses
