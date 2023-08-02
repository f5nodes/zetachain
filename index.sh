#!/bin/bash

API_URL="https://rpc.ankr.com/http/zetachain_athens_testnet/cosmos"

PS3='Enter your option: '
options=("Show network status" "Show validators list" "Show proposals list" "Quit")
selected="You choose the option"

select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            echo "$selected $opt"
            sleep 1
				function="show_network_status"
            break
            ;;
        "${options[1]}")
            echo "$selected $opt"
            sleep 1
				function="show_validators_list"
            break
            ;;
			"${options[2]}")
            echo "$selected $opt"
            sleep 1
				function="show_proposals_list"
            break
            ;;
        "${options[3]}")
			echo "$selected $opt"
            break
            ;;
        *) echo "unknown option $REPLY";;
    esac
done

function show_network_status() {
	network_response=$(curl -s "$API_URL"/base/tendermint/v1beta1/blocks/latest | tr -d '\n')

	if [ -z "$network_response" ]; then
		echo "Failed to fetch data from the API. Please check your connection or the API endpoint."
		exit 1
	fi

	network_info=$(echo "$network_response" | jq --raw-output '.block | {chain: .header.chain_id, height: .header.height, block_time: .header.time}')

	if [ -z "$network_info" ]; then
		echo "No network info found in the response."
		exit 1
	fi

	echo
	echo "Zetachain Network Information:"
	echo "================================"
	echo
	chain=$(echo "$network_info" | jq -r '.chain')
	height=$(echo "$network_info" | jq -r '.height')
	block_time=$(echo "$network_info" | jq -r '.block_time')
	echo "Chain: $chain"
	echo
	echo "Block Height: $height"
	echo "Block Time: $block_time"
	echo
	echo "================================"
}

function show_validators_list() {
	validators_response=$(curl -s "$API_URL"/staking/v1beta1/validators | tr -d '\n')

	if [ -z "$validators_response" ]; then
		echo "Failed to fetch data from the API. Please check your connection or the API endpoint."
		exit 1
	fi

	validators_info=$(echo "$validators_response" | jq --raw-output '.validators | map({name: .description.moniker, operator_address: .operator_address, jailed: .jailed, status: .status, voting_power: .tokens})')

	if [ -z "$validators_info" ]; then
		echo "No validators found in the response."
		exit 1
	fi

	echo
	echo "Zetachain Validators Information:"
	echo "================================="
	echo
	echo "$validators_info" | jq -c '.[]' | while read -r object; do
		name=$(echo "$object" | jq -r '.name')
		operator_address=$(echo "$object" | jq -r '.operator_address')
		jailed=$(echo "$object" | jq -r '.jailed')
		status=$(echo "$object" | jq -r '.status')
		voting_power=$(bc <<< "scale=6; $(echo "$object" | jq -r '.voting_power') / 1000000000000000000")
		echo "Name: $name"
		echo "Operator Address: $operator_address"
		echo "Jailed: $jailed"
		echo "Status: $status"
		echo "Voting Power: $voting_power ZETA"
		echo "----------------------"
	done
	echo
	echo "================================="
}

function show_proposals_list() {
	proposals_response=$(curl -s "$API_URL"/gov/v1beta1/proposals | tr -d '\n')

	if [ -z "$proposals_response" ]; then
		echo "Failed to fetch data from the API. Please check your connection or the API endpoint."
		exit 1
	fi

	proposals_info=$(echo "$proposals_response" | jq --raw-output '.proposals | map({id: .proposal_id, title: .content.title, description: .content.description, status: .status, submit_time: .submit_time, deposit: .total_deposit[0].amount, denom: .total_deposit[0].denom})')

	if [ -z "$proposals_info" ]; then
		echo "No proposals found in the response."
		exit 1
	fi

	echo
	echo "Zetachain Proposals Information:"
	echo "================================"
	echo
	echo "$proposals_info" | jq -c '.[]' | while read -r object; do
		id=$(echo "$object" | jq -r '.id')
		title=$(echo "$object" | jq -r '.title')
		description=$(echo "$object" | jq -r '.description')
		status=$(echo "$object" | jq -r '.status')
		submit_time=$(echo "$object" | jq -r '.submit_time')
		deposit=$(echo "$object" | jq -r '.deposit')
		denom=$(echo "$object" | jq -r '.denom')
		echo "ID: $id"
		echo "Title: $title"
		echo "Description: $description"
		echo "Status: $status"
		echo "Submit Time: $submit_time"
		echo "Deposit: $deposit $denom"
		echo "----------------------"
	done
	echo
	echo "================================"
}

$function