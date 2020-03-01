
function getBalance(transactions, id) {
    return parseInt(process.env.BALANCE_ACCOUNT) +
        transactions.filter(({ accountId }) => accountId == id)
            .reduce((total, { amountReal }) => amountReal + total, 0)
}

module.exports = getBalance