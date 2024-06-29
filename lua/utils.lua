local M = {}


M.load_secret = function(sectret_key)
  local secrets = {}
  local secrets_file = vim.fn.stdpath("config") .. "/secret.lua"
  local f = io.open(secrets_file, "r")

  if f then
    f:close()
    secrets = dofile(secrets_file)

    if secrets[sectret_key] then
      return secrets[sectret_key]
    else
      print("Warning: Key '" .. sectret_key .. "' not found in secrets file")
      return nil
    end
  else
    print("Warning: secrets file not found at " .. secrets_file)
    return nil
  end
end

return M

