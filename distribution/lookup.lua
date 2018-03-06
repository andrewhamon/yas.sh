local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)

local ok, err = red:connect(ngx.var.redis_host, tonumber(ngx.var.redis_port))
if not ok then
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

times, err = red:get_reused_times()

if not times then
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Only auth if its a new connection
if times == 0 then
  local ok, err = red:auth(ngx.var.redis_password)
  if not ok then
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
end

function join(left, right)
  result, _ = string.gsub(tostring(left) .. "/" .. tostring(right), "/+", "/")
  return result
end

function hget(key, hkey)
  local result, err = red:hget(tostring(key), tostring(hkey))
  if not result then
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end

  if result == ngx.null then
    return nil
  end

  return tostring(result)
end


-- Get revision key in redis, i.e. "example.com-v1"
local revision_key = hget(ngx.var.host, "revision_key")
if not revision_key then
  ngx.exit(ngx.HTTP_NOT_FOUND)
  return
end

-- Don't attempt fallbacks unless html requested
if not(string.find(ngx.var.http_accept, "html")) then
  -- Try getting the unmodified path
  local upstream_path = hget(revision_key, ngx.var.uri)
  if upstream_path then
    ngx.var.upstream_path = upstream_path
    return
  end

  red:set_keepalive(10, 100)

  return ngx.exit(ngx.HTTP_NOT_FOUND)
end

local unmodified           = ngx.var.uri
local html_index_fallback  = join(ngx.var.uri, "/index.html")
local htm_index_fallback   = join(ngx.var.uri, "/index.htm")
local html_fallback        = ngx.var.uri .. ".html"
local htm_fallback         = ngx.var.uri .. ".htm"
local two_hundred_fallback = "/200.html"
local not_found_fallback   = "/404.html"

res, err = red:hmget(revision_key,
  unmodified,
  html_index_fallback,
  htm_index_fallback,
  html_fallback,
  htm_fallback,
  two_hundred_fallback,
  not_found_fallback
)

red:set_keepalive(10, 100)

if err then
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

if not res then
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

if res == ngx.null then
  return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Try getting the unmodified path
if res[1] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[1])
  return
end

-- Fall back to index.html
if res[2] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[2])
  return
end

-- Fall back to index.htm
if res[3] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[3])
  return
end

-- Fall back to .html
if res[4] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[4])
  return
end

-- Fall back to .htm
if res[5] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[5])
  return
end

-- Fall back to /200.html
if res[6] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[6])
  return
end

-- Fall back to /404.html and set status
if res[7] ~= ngx.null then
  ngx.var.upstream_path = tostring(res[7])
  return ngx.exit(ngx.HTTP_NOT_FOUND)
end

-- Set status, will use global /404.html
return ngx.exit(ngx.HTTP_NOT_FOUND)
