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
    return nil, "Нет подключения к KDS"
  end
  local redis = self.redis
  local ok, err = redis:get("secret_key")
  if ok == nil or ok == "" or ok == ngx.null then
    self:set_keepalive()
    return nil, "Нет ключа на KDS"
  end
  self:set_keepalive()
  return ok, nil
end

function _M.check_blacklist(self, uuid, type)
  local ok, _ = self:redis_connection()
  if not ok then
    return nil, "Нет подключения к KDS"
  end
  local redis = self.redis
  local ok, err = redis:get("blacklist:" .. type .. ":" .. uuid)
  if ok == nil or ok == ngx.null then
    self:set_keepalive()
    return false, nil
  end
  self:set_keepalive()
  return true, nil
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
