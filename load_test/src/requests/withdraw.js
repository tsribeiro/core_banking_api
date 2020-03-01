const axios = require('axios')

function withdraw({ accountId, amount, kind }) {
    return axios.post(`${process.env.SERVER}/accounts/${accountId}/balance/withdraw`, {
        amount
    })
        .then(({ data }) => {
            console.log(`Execute ${kind} in account ${accountId}, amount ${data.amount}`)
        })
        .catch((error) => {
            console.error(error)
        })
}

module.exports = withdraw 