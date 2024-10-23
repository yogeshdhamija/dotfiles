local statusjdtls, jdtls = pcall(require, 'jdtls')
local statusnullls, null_ls = pcall(require,"null-ls")
if(statusjdtls and statusnullls) then
	local checkstyle_cmd = vim.fn.stdpath('data') .. '/mason/packages/checkstyle/checkstyle'
	null_ls.setup({sources = {
		null_ls.builtins.diagnostics.checkstyle.with({
			extra_args = { "-c", "/google_checks.xml" },
			command = checkstyle_cmd,
		}),
	}})

	local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
	local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
	local lombok_jar = vim.fn.glob(jdtls_path .. '/lombok.jar')
	local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

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
			'/Users/eia768/.sdkman/candidates/java/17.0.12-amzn/bin/java',
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
			'-data', vim.fn.expand('~/.cache/jdtls-workspace/') .. workspace_dir
		},
		root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" }),
		settings = {
			java = {
				format = {
					settings = {
						profile = "GoogleStyle",
						url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml"
					}
				},
				eclipse = {
					downloadSources = true,
				},
				configuration = {
					updateBuildConfiguration = "interactive",
					runtimes = {
						{
							name = "JavaSE-21",
							path = "/Users/eia768/.sdkman/candidates/java/21.0.5-amzn/"
						},
						{
							name = "JavaSE-17",
							path = "/Users/eia768/.sdkman/candidates/java/17.0.12-amzn/"
						},
						{
							name = "JavaSE-11",
							path = "/Users/eia768/.sdkman/candidates/java/11.0.24-amzn/"
						},
					}
				}
			},
		},
		init_options = {
			bundles = {}
		},
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	jdtls.start_or_attach(config)
end
