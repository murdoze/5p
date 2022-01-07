local nonnull = {}

nonnull.value = function(v, nnv)
  if v ~= nil then
    return v
  else
    return nnv
  end
end

nonnull.list = function(l)
  return nonnull.value(l, {})
end

return nonnull
