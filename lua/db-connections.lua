-- Keep passwords out of the URI so libpq/psql can read them from ~/.pgpass
-- or $PGPASSFILE without worrying about URL escaping.
local function postgres_url(opts)
  local query = ""
  if opts.params and next(opts.params) then
    local pairs_list = {}
    for key, value in pairs(opts.params) do
      pairs_list[#pairs_list + 1] = { key = key, value = value }
    end
    table.sort(pairs_list, function(a, b)
      return a.key < b.key
    end)

    local query_parts = {}
    for i = 1, #pairs_list do
      local item = pairs_list[i]
      query_parts[#query_parts + 1] = ("%s=%s"):format(item.key, vim.uri_encode(item.value))
    end
    query = "?" .. table.concat(query_parts, "&")
  end

  return ("postgresql://%s@%s/%s%s"):format(
    vim.uri_encode(opts.user),
    opts.host,
    vim.uri_encode(opts.database),
    query
  )
end

vim.g.dbs = {
  {
    name = "SEIA-DEV",
    url = postgres_url({
      user = "root",
      host = "smartcompliance-prod-datascience-rds-dlux-database-3nypvrwwkodo.clqmqgma84gw.us-east-1.rds.amazonaws.com",
      database = "prodDBsmartcomplianceDataScience",
    }),
  },
  {
    name = "SEIA-PROD",
    url = postgres_url({
      user = "root",
      host = "smartcompliance-prod2-datascience-rds-1pv-database-mrshebsb6obz.ctsocesoy3lm.us-east-2.rds.amazonaws.com",
      database = "prodDBsmartcomplianceDataScience",
      params = {
        sslmode = "require",
      },
    }),
  },
  {
    name = "SNIFA-DEV",
    url = postgres_url({
      user = "root",
      host = "127.0.0.1:8081",
      database = "smartCompliancesSnifa",
      params = {
        sslmode = "require",
      },
    }),
  },
  {
    name = "SNIFA-PERT",
    url = postgres_url({
      user = "root",
      host = "127.0.0.1:8081",
      database = "smartCompliancesSeia",
      params = {
        sslmode = "require",
      },
    }),
  },
  {
    name = "reclamaciones_dev",
    url = postgres_url({
      user = "neondb_owner",
      host = "ep-dark-salad-aagsermr-pooler.westus3.azure.neon.tech",
      database = "neondb",
      params = {
        channel_binding = "require",
        sslmode = "require",
      },
    }),
  },
  {
    name = "reclamaciones_prod",
    url = postgres_url({
      user = "neondb_owner",
      host = "ep-young-cloud-aaipsvch-pooler.westus3.azure.neon.tech",
      database = "neondb",
      params = {
        channel_binding = "require",
        sslmode = "require",
      },
    }),
  },
}
