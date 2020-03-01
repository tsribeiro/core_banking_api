
function create(accountId) {
    const amount = Math.floor(Math.random() * parseInt(process.env.MAX_AMOUNT));
    const kind = Math.floor(Math.random() * 100) % 2 == 0 ? 'cash_in' : 'cash_out';
    const amountReal = kind == 'cash_in' ? amount : -1 * amount
    return { accountId, kind, amount, amountReal }
}

module.exports = create