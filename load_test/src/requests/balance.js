const axios = require('axios')

function balance(accountId) {
    return axios.get(`${process.env.SERVER}/accounts/${accountId}/balance`)
        .catch((error) => {
            console.error(error)
        })
}

module.exports = balance 