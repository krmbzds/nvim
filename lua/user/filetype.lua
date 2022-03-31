local status_ok, filetype = pcall(require, "filetype")
if not status_ok then
  return
end

filetype.setup({
  overrides = {
    literal = {
      [".gitignore"] = "conf",
      [".chezmoiignore"] = "conf",
    },
    extensions = {
      tf = "terraform",
      tfvars = "terraform",
      hcl = "hcl",
      tfstate = "json",
    },
  },
})
