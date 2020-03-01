const axios = require('axios')
const createCsvWriter = require('csv-writer').createObjectCsvWriter;


const ONE_MILLION = 100000000
const HUNDRED_THOUSAND = 10000000
const ACCOUNT_TOTAL = 1000
const TRANSACTIONS_PER_ACCOUNT = 10
const MAX_AMOUNT = HUNDRED_THOUSAND
const BALANCE_ACCOUNT = ONE_MILLION
const TRANSACTIONS = []
const TRANSACTIONS_FINAL = []
const TRANSACTIONS_PROMISES = []

const csvWriter = createCsvWriter({
    path: 'transactions.csv',
    header: [
        { id: 'accountId', title: 'Account Id' },
        { id: 'kind', title: 'lKind' },
        { id: 'amountReal', title: 'amount' },
    ]
});

console.log("Init Accounts")

Promise.all(Array.from({ length: ACCOUNT_TOTAL }, (x, i) => i + 1).map((accountId) => {
    Array.from({ length: TRANSACTIONS_PER_ACCOUNT }, (x, i) => i + 1).forEach(() => {
        const amount = Math.floor(Math.random() * MAX_AMOUNT);
        const kind = Math.floor(Math.random() * 100) % 2 == 0 ? 'cash_in' : 'cash_out';
        const amountReal = kind == 'cash_in' ? amount : -1 * amount
        const transaction = { accountId, kind, amount, amountReal }
        TRANSACTIONS.push(transaction)
        TRANSACTIONS_FINAL.push(transaction)
    })

    return axios.post(`http://localhost:8080/accounts/${accountId}/balance/deposit`, {
        "amount": BALANCE_ACCOUNT
    })
        .then(({ data }) => {
            console.log(`First deposit in account ${accountId}, amount ${data.amount}`)
        })
        .catch((error) => {
            console.error(error)
        })

})).then(() => {
    csvWriter.writeRecords(TRANSACTIONS)
        .then(() => {
            sendTransaction()
        })
});;

function sendTransaction() {
    const transaction = TRANSACTIONS.pop()

    if (!transaction) {
        Promise.all(TRANSACTIONS_PROMISES).then(() => {
            Promise.all(Array.from({ length: ACCOUNT_TOTAL }, (x, i) => i + 1).map((id) => {
                const transations = TRANSACTIONS_FINAL
                    .filter(({ accountId }) => accountId == id)
                    .reduce((total, { amountReal }) => amountReal + total, 0)

                const balance = BALANCE_ACCOUNT + transations
                return axios.get(`http://localhost:8080/accounts/${id}/balance/`)
                    .then(({ data }) => {
                        if (data.balance == balance) {
                            console.log(`OK account ${id}`)
                        }
                        else {
                            console.log(`ERROR account ${id}`)
                        }
                    })
                    .catch((error) => {
                        console.error(error)
                    })
            })).then(() => {
                console.log("END")
            })
        })

        return
    }

    const { accountId, amount, kind } = transaction
    const action = kind == 'cash_in' ? 'deposit' : 'withdraw'

    TRANSACTIONS_PROMISES.push(axios.post(`http://localhost:8080/accounts/${accountId}/balance/${action}`, {
        amount
    })
        .then(({ data }) => {
            console.log(`Execute ${kind} in account ${accountId}, amount ${data.amount}`)
        })
        .catch((error) => {
            console.error(error)
            throw error
        }))

    setTimeout(function () { sendTransaction(); }, 5);
}