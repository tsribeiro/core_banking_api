const axios = require('axios')

function deposit({ accountId, amount, kind }) {
    return axios.post(`${process.env.SERVER}/accounts/${accountId}/balance/deposit`, {
        amount
    })
        .then(({ data }) => {
            console.log(`Execute ${kind} in account ${accountId}, amount ${data.amount}`)
        })
        .catch((error) => {
            console.error(error)
        })
}

module.exports = deposit 