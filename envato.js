// Generated by CoffeeScript 1.10.0
var chalk, colors, envato, envatoAPI, fs, got, path, request;

fs = require('fs');

path = require('path');

request = require('request');

got = require('got');

chalk = require('chalk');

colors = require('colors');

envatoAPI = {
  account: 'https://api.envato.com/v1/market/private/user/account.json',
  authorSales: 'https://api.envato.com/v3/market/author/sales?page=0',
  catalogItem: 'https://api.envato.com/v3/market/catalog/item?id='
};

envato = {
  verify: function(options) {
    var authorAPIKey, authorName, purchaseCode, verifyURL;
    authorName = options.authorName;
    authorAPIKey = options.authorAPIKey;
    purchaseCode = options.verify.toString();
    if (!purchaseCode) {
      return;
    }
    verifyURL = "http://marketplace.envato.com/api/edge/" + authorName + "/" + authorAPIKey + "/verify-purchase:" + purchaseCode + ".json";
    console.log("Verifying " + purchaseCode);
    return new Promise(function(resolve, reject) {
      return request({
        method: 'GET',
        headers: {
          'User-Agent': "request"
        },
        url: verifyURL
      }, function(error, res, body) {
        var details, output;
        if (!error && res.statusCode === 200) {
          body = JSON.parse(body);
          if (body['verify-purchase']) {
            details = body['verify-purchase'];
            output = {
              status: 'USER VERIFIED',
              buyer: details.buyer,
              item: details.item_name,
              item_id: details.item_id,
              date: details.created_at,
              license: details.licence
            };
            return resolve(output);
          }
        } else if (error) {
          return resolve(("Error " + error).red);
        } else {
          console.log("Something went wrong!".red);
          return resolve(res);
        }
      });
    });
  },
  getAccountInfo: function(options) {
    return new Promise(function(resolve, reject) {
      return require('request').get(envatoAPI.account, {
        headers: {
          'Authorization': "Bearer " + options.envatoToken
        }
      }, function(error, response, body) {
        if (error) {
          return reject(error);
        } else {
          return resolve(JSON.parse(body));
        }
      });
    })["catch"](console.log);
  },
  getThemeDetails: function(options) {
    return got(envato.envatoAPI.catalogItem + options.id, {
      headers: {
        'Authorization': "Bearer " + options.envatoToken
      }
    });
  },
  getThemeSales: function(options) {
    var envatoToken;
    envatoToken = options.envatoToken;
    return envato.getThemeDetails({
      id: options.id,
      envatoToken: envatoToken
    }).then(function(res) {
      var itemData, out;
      itemData = JSON.parse(res.body);
      out = {
        number_of_sales: itemData.number_of_sales,
        wordpress_theme_metadata: itemData.wordpress_theme_metadata
      };
      return out;
    });
  },
  getSales: function(options) {
    return got(envatoAPI.authorSales, {
      json: true,
      headers: {
        'Authorization': "Bearer " + options.envatoToken
      }
    });
  }
};

module.exports = envato;
