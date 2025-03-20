local M = {}

M.init = function()
  local handle =
    io.popen("SHELL=zsh keychain --eval --quiet --agents ssh,gpg FE09FD0729375918 id_ed25519 google_compute_engine")
  if handle then
    local result = handle:read("*a")
    handle:close()

    for match in result:gmatch("SSH_AUTH_SOCK=([^;]*);") do
      vim.env["SSH_AUTH_SOCK"] = match
    end

    for match in result:gmatch("SSH_AGENT_PID=([^;]*);") do
      vim.env["SSH_AGENT_PID"] = match
    end

    for match in result:gmatch("GPG_AGENT_INFO=([^;]*);") do
      vim.env["GPG_AGENT_INFO"] = match
    end
  end
end

return M
