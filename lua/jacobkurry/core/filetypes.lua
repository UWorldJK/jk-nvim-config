-- Helm chart detection: Neovim reads chart templates as plain yaml, so yamlls
-- reports Go-template syntax as errors and helm_ls never attaches.
local function in_chart(path)
  return vim.fs.root(path, "Chart.yaml") ~= nil
end

vim.filetype.add({
  pattern = {
    -- templates/*.yaml, templates/**/*.yaml, templates/*.tpl inside a chart
    [".*/templates/.*%.ya?ml"] = function(path)
      if in_chart(path) then
        return "helm"
      end
    end,
    [".*/templates/.*%.tpl"] = "helm",
    -- values*.yaml next to Chart.yaml (helm_ls + yamlls both attach to this filetype)
    [".*/values.*%.ya?ml"] = function(path)
      if vim.uv.fs_stat(vim.fs.joinpath(vim.fs.dirname(path), "Chart.yaml")) then
        return "yaml.helm-values"
      end
    end,
  },
})

-- highlight helm values files with the yaml parser
vim.treesitter.language.register("yaml", "yaml.helm-values")
