return {
  "nvim-treesitter/nvim-treesitter", 
  branch = "master",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs"):setup({
      ensure_installed = {"c", "cpp", "java", "javadoc", "lua", "luadoc", "vim", "vimdoc", "markdown", "markdown_inline", "html", "css", "python"}
    })
  end
}
