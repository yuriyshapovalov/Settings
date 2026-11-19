-- Commands around the built-in plugin manager (vim.pack has a Lua API only).
-- Plugin revisions live in nvim-pack-lock.json next to init.lua: commit it after updates.

local cmd = vim.api.nvim_create_user_command

-- Fetch updates and open a review buffer: :write applies, :quit discards
cmd("PackUpdate", function() vim.pack.update() end, { desc = "Review and apply plugin updates" })

-- Remove plugins that are on disk but no longer added by any vim.pack.add() call
cmd("PackClean", function()
  local stale = vim.iter(vim.pack.get())
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()
  if #stale == 0 then
    vim.notify("vim.pack: nothing to clean")
    return
  end
  vim.pack.del(stale)
end, { desc = "Delete plugins that are no longer configured" })
