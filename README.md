# CoreBankingApi

CoreBankingApi is a system for controlling bank accounts balance.



## Usage

```shell

$ mix deps.get
$ iex -S mix

#Get Balance

$ curl -X GET 'http://localhost:8080/accounts/<id>/balance'

#Perform Deposit

$ curl -X POST 'http://localhost:8080/accounts/<id>/balance/deposit' \
-H 'Content-Type: application/json' \
-d '{
    "amount": <amunt>
}'

#Perform Withdraw

$ curl -X POST 'http://localhost:8080/accounts/<id>/balance/withdraw' \
-H 'Content-Type: application/json' \
-d '{
    "amount": <amunt>
}'
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
