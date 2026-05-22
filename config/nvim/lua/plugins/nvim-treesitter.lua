-- ~/.config/nvim/lua/plugins/nvim-treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",                  -- ensure parsers build on install/update
    event = { "BufReadPost", "BufNewFile" }, -- load on first real buffer (safe)

    opts = {
      ensure_installed = {
        "awk",
        "bash",
        "c",
        "cpp",
        "jsonnet",
      },
      highlight = { enable = true },

      -- IMPORTANT: install settings belong INSIDE opts
      install = {
        prefer_git = true,
        use_bundler = false,
        compilers = { "clang", "gcc" },
      },
    },
  },
}

--return {
  --"nvim-treesitter/nvim-treesitter",

  ---- Make sure parsers are (re)built on install/update
  --build = ":TSUpdate",

  --opts = {
    --ensure_installed = {
      --"awk",
      --"bash",
      --"c",
      --"cpp",
      --"jsonnet",
    --},
    --highlight = { enable = true },
    --install = {
      ---- force building from grammar repos
      --prefer_git = true,
      --use_bundler = false,
      --compilers = { "clang", "gcc" },
    --},
  --},

  ---- Use config() to apply opts and also set install globals as fallback
  --config = function(_, opts)
    ---- Set global install preferences (used by nvim-treesitter.install API)
    --local ts_install = require("nvim-treesitter.install")
    --ts_install.prefer_git = true
    --ts_install.compilers = { "clang", "gcc" } -- keep in sync with opts.install

    ---- Apply the full config
    --require("nvim-treesitter.configs").setup(opts)
  --end,

--}

