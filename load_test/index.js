require('dotenv').config()

const axios = require('axios')
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const { deposit, withdraw } = require('./src/requests')
const { create } = require('./src/transaction')
const { verifyBalance } = require('./src/asserts')


const ACCOUNTS = Array.from({ length: parseInt(process.env.ACCOUNT_TOTAL) }, (x, i) => i + 1)
const TRANSACTIONS_PER_ACCOUNT = Array.from({ length: parseInt(process.env.TRANSACTIONS_PER_ACCOUNT) }, (x, i) => i + 1)
const TRANSACTIONS = []
const TRANSACTIONS_PROMISES = []
const START = new Date().getTime();

const csvWriter = createCsvWriter({
    path: 'transactions.csv',
    header: [
        { id: 'accountId', title: 'Account Id' },
        { id: 'kind', title: 'lKind' },
        { id: 'amountReal', title: 'amount' },
    ]
});

console.log("Init Accounts")

Promise.all(ACCOUNTS.map((accountId) => {
    TRANSACTIONS_PER_ACCOUNT.forEach(() => {
        TRANSACTIONS.push(create(accountId))
    })

    return deposit({
        accountId,
        amount: parseInt(process.env.BALANCE_ACCOUNT),
        kind: 'cash_in'
    })
})).then(() => {
    csvWriter.writeRecords(TRANSACTIONS)
        .then(() => {
            const transactions = TRANSACTIONS.slice(0, TRANSACTIONS.length)
            sendTransaction(transactions)
        })
});;

function sendTransaction(transactions) {
    const transaction = transactions.pop()

    if (!transaction) {
        Promise.all(TRANSACTIONS_PROMISES)
            .then(() => {
                Promise.all(ACCOUNTS.map((accountId) => {
                    return verifyBalance(TRANSACTIONS, accountId)
                })).then(() => {
                    console.log(`Execution time: ${(new Date().getTime() - START) / 1000}s`)
                    console.log("END")
                })
            })

        return
    }

    TRANSACTIONS_PROMISES.push(transaction.kind == 'cash_in' ? deposit(transaction) : withdraw(transaction))

    setTimeout(function () { sendTransaction(transactions); }, 5);
}