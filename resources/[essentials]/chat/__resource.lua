resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'vrp'

description 'chat management stuff'

ui_page 'html/index.html'

client_scripts { 
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'cl_chat.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'sv_chat.lua'
}

files {
    'html/index.html',
    'html/index.css',
    'html/config.default.js',
    'html/config.js',
    'html/App.js',
    'html/Message.js',
    'html/Suggestions.js',
    'html/vendor/vue.2.3.3.min.js',
    'html/vendor/flexboxgrid.6.3.1.min.css',
    'html/vendor/animate.3.5.2.min.css',
    'html/vendor/latofonts.css',
    'html/vendor/fonts/LatoRegular.woff2',
    'html/vendor/fonts/LatoRegular2.woff2',
    'html/vendor/fonts/LatoLight2.woff2',
    'html/vendor/fonts/LatoLight.woff2',
    'html/vendor/fonts/LatoBold.woff2',
    'html/vendor/fonts/LatoBold2.woff2'
}
