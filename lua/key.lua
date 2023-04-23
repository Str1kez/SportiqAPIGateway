local _M = {
  _VERSION = "0.1.0",
}


local mt = { __index = _M }

function _M.new(_)
  local _r = require "resty.redis"
  local redis = _r:new()
  redis:set_timeouts(1000, 100, 100)
  return setmetatable({ redis = redis }, mt)
end

function _M.redis_connection(self)
  local redis = self.redis
  -- return redis:connect("127.0.0.1", 6379) -- Заменить на env
  return redis:connect(os.getenv("KDS_DB_URL"), os.getenv("KDS_DB_PORT"))
end

function _M.get_secret(self)
  local ok, _ = self:redis_connection()
  if not ok then
    return require "responses".kds_error("Нет подключения к KDS")
  end
  local redis = self.redis
  local ok, _ = redis:get("secret_key")
  self:set_keepalive()
  if ok == nil or ok == "" or ok == ngx.null then
    return require "responses".kds_error("Нет ключа на KDS")
  end
  return ok
end

function _M.check_blacklist(self, uuid, type)
  local ok, _ = self:redis_connection()
  if not ok then
    return require "responses".kds_error("Нет подключения к KDS")
  end
  local redis = self.redis
  local token = redis:get("blacklist:" .. type .. ":" .. uuid)
  self:set_keepalive()
  if token == nil or token == ngx.null then
    return false
  end
  return true
end

function _M.close(self)
  local redis = self.redis
  if not redis then
    return nil, "not initialized"
  end

  return redis:close()
end

function _M.set_keepalive(self)
  -- в пул на 10 секунд
  local redis = self.redis
  return redis:set_keepalive(10000, 100)
end

return _M
