-- Keep connection metadata in public-safe service names.
-- Real host/db settings live in ~/.pg_service.conf and passwords in ~/.pgpass
-- (or $PGSERVICEFILE / $PGPASSFILE) so Neovim never has to embed secrets.
local function postgres_service_url(service)
  return ("postgresql:///?service=%s"):format(vim.uri_encode(service))
end

vim.g.dbs = {
  {
    name = "SEIA-DEV",
    url = postgres_service_url("seia_dev"),
  },
  {
    name = "SEIA-PROD",
    url = postgres_service_url("seia_prod"),
  },
  {
    name = "SNIFA-DEV",
    url = postgres_service_url("snifa_dev"),
  },
  {
    name = "SNIFA-PERT",
    url = postgres_service_url("snifa_pert"),
  },
  {
    name = "reclamaciones_dev",
    url = postgres_service_url("reclamaciones_dev"),
  },
  {
    name = "reclamaciones_prod",
    url = postgres_service_url("reclamaciones_prod"),
  },
}
