const { balance } = require('../requests')
const { getBalance } = require('../transaction')

function verifyBalance(transactions, accountId) {
    return balance(accountId)
        .then(({ data }) => {
            if (data.balance == getBalance(transactions, accountId)) {
                console.log(`OK account ${accountId}`)
            }
            else {
                console.log(`ERROR account ${accountId}`)
            }
        })
}

module.exports = verifyBalance