-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	vis:command('set number')
	vis:command('set tw 4')
	vis:command('set layout h')
	vis:command('set showtabs on')
	vis:command('set cc 80')
	vis:command('set cur')
end)
