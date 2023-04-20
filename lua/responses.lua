local responses = {
  _VERSION = "0.1.0"
}

function responses.kds_error(error)
  local cjson = require "cjson"
  ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
  local detail = {
    { msg = error, type = "kds" }
  }
  setmetatable(detail, cjson.array_mt)
  local error_response = { detail = detail }
  ngx.say(cjson.encode(error_response))
end

return responses
