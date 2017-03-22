colors = require 'colors'

creds = 
	authorName   : config.keys.envato.authorName
	authorAPIKey : config.keys.envato.authorAPIKey
	token  		 : config.keys.envato.token

initCommands = (program)->

	program
	  .command('envato')
	  .description('Envato related utilities')
	  .option('-v, --verify <code>', 'Verify purchase code')
	  .option('--get-sales [options]', 'Get sales information')
	  .action (options) ->

		Envato = require('./envato')

		if options.getSales

			Envato.init(creds)
			.getSales()
			.then(console.log)
			.catch(console.log)

		if options.verify
			Envato
			.init(creds)
			.verify({ verify: options.verify })
			.then(console.log)
			.catch(console.log)

module.exports = initCommands