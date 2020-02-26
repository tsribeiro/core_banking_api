# CoreBankingApi

CoreBankingApi is a system for controlling bank accounts balance.



## Usage

```shell
#Get Balance
curl -X GET 'http://localhost:8080/accounts/5/balance'

#Deposit
curl -X POST 'http://localhost:8080/accounts/5/balance/deposit' \
-H 'Content-Type: application/json' \
-d '{
    "amount": 1000
}'

#Withdraw
curl -X POST 'http://localhost:8080/accounts/5/balance/withdraw' \
-H 'Content-Type: application/json' \
-d '{
    "amount": 500
}'
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
