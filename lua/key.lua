local _M = {
  _VERSION = "0.1.0",
}


local mt = { __index = _M }

function _M.new(_)
  local _r = require "resty.redis"
  local redis = _r:new()
  return setmetatable({ redis = redis }, mt)
end

function _M.redis_connection(self)
  local redis = self.redis
  -- return redis:connect("127.0.0.1", 6379) -- Заменить на env
  return redis:connect(os.getenv("KDS_DB_URL"), os.getenv("KDS_DB_PORT"))
end

function _M.get_secret(self)
  self:redis_connection()
  local redis = self.redis
  return redis:get("secret_key")
end

function _M.close(self)
  local redis = self.redis
  if not redis then
    return "DEBIL", "not initialized"
  end

  return redis:close()
end

return _M
