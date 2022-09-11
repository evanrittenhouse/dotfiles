local jdtls = require('jdtls')
local home = os.getenv('HOME')
local javaHome = os.getenv('JAVA_HOME')
local jdtlsHome = home .. '/Desktop/jdtls_config'

local findWorkspaceDirectory = function()
        local resolvedPath = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local projectsFolder = home .. '/Desktop/projects/'

        return projectsFolder .. resolvedPath
end
local cmd = {
        -- or /path/to/java/bin, java v17+ has to be in $PATH
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', jdtlsHome .. '/plugings/org.eclipse.launcher_1.6.400.v20210924-0641.jar',
        '-configuration', jdtlsHome .. '/config_linux',
        '-data', findWorkspaceDirectory()
}

local projectRoot = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' })

local onAttach = function()
        local u = require('utils')
        local keymap = u.keymap
        local options = u.keymap_opts

        require('lsp.init.global_on_attach')
end

local config = {
        cmd = cmd,
        projectRoot = projectRoot
        -- settings = { java = {} }
        -- init_options = {}
}
