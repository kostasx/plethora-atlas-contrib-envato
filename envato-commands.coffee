colors = require 'colors'

initCommands = (program)->

	program
	  .command('envato')
	  .description('Envato related utilities')
	  .option('-v, --verify <code>', 'Verify purchase code')
	  .action (options) ->

		Envato = require('./envato')

		if options.verify
			Envato.verify({

				verify       : options.verify
				authorName   : config.keys.envato.authorName
				authorAPIKey : config.keys.envato.authorAPIKey

			})
			.then((res)->

				console.log res

			).catch(console.log)

module.exports = initCommands