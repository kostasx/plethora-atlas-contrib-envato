fs      = require 'fs'
path    = require 'path'
request = require 'request'
got     = require 'got'
chalk   = require 'chalk'
colors  = require 'colors'

envatoAPI =

    account     : 'https://api.envato.com/v1/market/private/user/account.json'
    authorSales : 'https://api.envato.com/v3/market/author/sales?page=0'
    catalogItem : 'https://api.envato.com/v3/market/catalog/item?id='

envato =

    init: (options)->

        @authorName   = options.authorName or ""
        @authorAPIKey = options.authorAPIKey or ""
        @token        = options.token or ""
        return this

    verify: (options)->

        authorName   = @authorName
        authorAPIKey = @authorAPIKey
        purchaseCode = options.verify.toString()

        if !purchaseCode then return

        verifyURL = "http://marketplace.envato.com/api/edge/#{authorName}/#{authorAPIKey}/verify-purchase:#{purchaseCode}.json"

        console.log "Verifying #{purchaseCode}"

        new Promise((resolve, reject)->

            request {
                method    : 'GET'
                headers : 'User-Agent' : "request"
                url       : verifyURL
            }, (error, res, body)->

                if !error and res.statusCode is 200

                    body = JSON.parse body          
                    if body['verify-purchase']
                        details = body['verify-purchase']
                        output = 
                            status  : 'USER VERIFIED'
                            buyer   : details.buyer
                            item    : details.item_name
                            item_id : details.item_id
                            date    : details.created_at
                            license : details.licence
                        resolve output 
                else if error
                    resolve "Error #{error}".red
                else 
                    console.log "Something went wrong!".red
                    resolve res
        )

    getAccountInfo: (options)->

        token = @token
        new Promise((resolve,reject)->

            require('request')
            .get( envatoAPI.account, 
                { headers: { 'Authorization' : "Bearer #{token}"  } },
                (error, response, body) ->

                    if error
                        reject(error)
                    else
                        resolve( JSON.parse(body) )

            )
        ).catch(console.log)

    getThemeDetails: (options)->

        return got(
            envatoAPI.catalogItem + options.id, 
            { headers: { 'Authorization' : "Bearer #{options.envatoToken}"  } })

    getThemeSales: (options)->

        envatoToken = @token
        envato.getThemeDetails({ id: options.id, envatoToken: envatoToken })
        .then((res)->

            itemData = JSON.parse(res.body)
            out = 
                number_of_sales          : itemData.number_of_sales
                wordpress_theme_metadata : itemData.wordpress_theme_metadata

            return out
        )

    getSales: (options)->

        token = @token

        return got(
            envatoAPI.authorSales,
            {
                json    : true 
                headers : { 'Authorization' : "Bearer #{token}"  }
            })

module.exports = envato

