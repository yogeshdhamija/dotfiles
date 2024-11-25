local statusjdtls, jdtls = pcall(require, 'jdtls')
local statusnullls, null_ls = pcall(require, "null-ls")
if (statusjdtls and statusnullls) then
	local checkstyle_cmd = vim.fn.stdpath('data') .. '/mason/packages/checkstyle/checkstyle'
	null_ls.setup({
		sources = {
			null_ls.builtins.diagnostics.checkstyle.with({
				extra_args = { "-c", "/google_checks.xml" },
				command = checkstyle_cmd,
			}),
		}
	})

	local java_path = vim.fn.expand('~/.sdkman/candidates/java/')
	local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
	local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
	local lombok_jar = vim.fn.glob(jdtls_path .. '/lombok.jar')
	local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
	local data_dir = vim.fn.expand('~/.cache/jdtls-workspace/') .. workspace_dir
	local maven_settings_path = vim.fn.expand('~/.m2/settings.xml')

	local javadbg_path = vim.fn.stdpath('data') .. '/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'

	local function get_config_dir()
		if vim.fn.has('linux') == 1 then
			return 'config_linux'
		elseif vim.fn.has('mac') == 1 then
			return 'config_mac'
		else
			return 'config_win'
		end
	end


	local config = {
		cmd = {
			java_path .. '21.0.5-amzn/bin/java',
			'-Declipse.application=org.eclipse.jdt.ls.core.id1',
			'-Dosgi.bundles.defaultStartLevel=4',
			'-Declipse.product=org.eclipse.jdt.ls.core.product',
			'-Dlog.protocol=true',
			'-Dlog.level=ALL',
			'-Xmx1g',
			'--add-modules=ALL-SYSTEM',
			'--add-opens', 'java.base/java.util=ALL-UNNAMED',
			'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
			'-javaagent:' .. lombok_jar,
			'-jar', launcher_jar,
			'-configuration', vim.fs.normalize(jdtls_path .. '/' .. get_config_dir()),
			'-data', data_dir
		},
		root_dir = vim.fs.root(0, { ".git", "mvnw" }),
		settings = {
			java = {
				autobuild = {
					enabled = false
				},
				maven = {
					downloadSources = true,
					updateSnapshots = true,
				},
				format = {
					settings = {
						profile = "GoogleStyle",
						url =
						"https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml"
					}
				},
				eclipse = {
					downloadSources = true,
				},
				inlayhints = {
					parameterNames = {
						enabled = "all"
					}
				},
				configuration = {
					updateBuildConfiguration = "automatic",
					maven = {
						userSettings = maven_settings_path
					},
					runtimes = {
						{
							name = "JavaSE-21",
							path = java_path .. "21.0.5-amzn/"
						},
						{
							name = "JavaSE-17",
							path = java_path .. "17.0.12-amzn/"
						},
						{
							name = "JavaSE-11",
							path = java_path .. "11.0.24-amzn/"
						},
					}
				}
			},
		},
		init_options = {
			bundles = { javadbg_path }
		},
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	jdtls.start_or_attach(config)
end

local dapstatus, dap = pcall(require, 'dap')
if (dapstatus) then
	if(dap.configurations.java == nil) then
	dap.configurations.java = {
		{
			type = 'java',
			request = 'attach',
			name = "Debug (Attach) - Remote",
			hostName = "127.0.0.1",
			port = 9998,
		},
	}
	end
end
