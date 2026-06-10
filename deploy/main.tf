
locals {
  root_path   = dirname(abspath(path.root))
  config_path = format("%s/config", local.root_path)

  is_config_in_yaml = endswith(var.config_file, ".yaml")
  config_file_path  = format("%s/%s", local.config_path, var.config_file)
  config_data       = (fileexists(local.config_file_path) ? local.is_config_in_yaml ? yamldecode(file(local.config_file_path)) : jsondecode(file(local.config_file_path)) : {})

  g_tags = { for k, v in try(local.config_data.landscape.global.tags, {}) : k => v }
}

check "no_config_file" {
  assert {
    condition     = fileexists(local.config_file_path)
    error_message = "Config file: ${local.config_file_path} is not available!"
  }
}
