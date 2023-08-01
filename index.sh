#!/bin/bash

API_URL="https://rpc.ankr.com/http/zetachain_athens_testnet/cosmos"
response=$(curl -s "$API_URL"/staking/v1beta1/validators | tr -d '\n')

if [ -z "$response" ]; then
	echo "Failed to fetch data from the API. Please check your connection or the API endpoint."
	exit 1
fi

validator_info=$(echo "$response" | jq --raw-output '.validators | map({name: .description.moniker, operator_address: .operator_address, status: .status, voting_power: .tokens})')

if [ -z "$validator_info" ]; then
	echo "No validators found in the response."
	exit 0
fi

echo "Validators Information:"
echo "======================"
echo
echo "$validator_info" | jq -c '.[]' | while read -r object; do
	name=$(echo "$object" | jq -r '.name')
	operator_address=$(echo "$object" | jq -r '.operator_address')
	status=$(echo "$object" | jq -r '.status')
	voting_power=$(bc <<< "scale=6; $(echo "$object" | jq -r '.voting_power') / 1000000000000000000")
	echo "Name: $name"
	echo "Operator Address: $operator_address"
	echo "Status: $status"
	echo "Voting Power: $voting_power ZETA"
	echo "----------------------"
done
echo
echo "======================"
