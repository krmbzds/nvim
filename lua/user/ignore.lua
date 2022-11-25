local ignore = {

  file_ignore_patterns = {
    "%.7z",
    "%.bz2",
    "%.cache",
    "%.class",
    "%.dll",
    "%.docx",
    "%.dylib",
    "%.epub",
    "%.exe",
    "%.flac",
    "%.ico",
    "%.ipynb",
    "%.jar",
    "%.jpeg",
    "%.jpg",
    "%.lock",
    "%.mkv",
    "%.mp4",
    "%.otf",
    "%.pdb",
    "%.pdf",
    "%.png",
    "%.rar",
    "%.sqlite3",
    "%.svg",
    "%.tar",
    "%.tar.gz",
    "%.ttf",
    "%.webp",
    "%.zip",
    "*.git/*",
    "*/tmp/*",
    ".dart_tool/",
    ".DS_Store",
    ".git/",
    ".github/",
    ".gradle/",
    ".idea/",
    ".settings/",
    ".vale/",
    ".vscode/",
    "__pycache__/*",
    "build/",
    "docs/",
    "env/",
    "gradle/",
    "node_modules/*",
    "target/",
    "thumbs.db",
    "vendor/*",
  },

  lualine_disabled_filetypes = {
    "dashboard",
    "neo-tree",
    "toggleterm",
  },

  illuminate_filetypes_denylist = {
    "dashboard",
    "DressingSelect",
    "neo-tree",
    "neogitstatus",
    "packer",
    "TelescopePrompt",
    "toggleterm",
  },

  undotree_ignore_filetype = {
    "qf",
    "TelescopePrompt",
    "Undotree",
    "UndotreeDiff",
  },
}

return ignore