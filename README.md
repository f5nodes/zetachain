# Zetachain Information Script

This script provides information about the Zetachain network, validators, and proposals by interacting with the Zetachain RPC API.

## Usage

Run the script:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/f5nodes/zetachain/main/index.sh)
```
Follow the menu options to view network status, validators list, proposals list, or quit the script.

## Script Details

The script allows you to perform the following actions:

- Show network status: Displays information about the Zetachain network's current block.

- Show validators list: Displays a list of Zetachain validators, including their names, addresses, status, and voting power.

- Show proposals list: Displays a list of Zetachain governance proposals, including their IDs, titles, descriptions, statuses, submission times, and deposit amounts.

- Quit: Exits the script.

The script uses the Zetachain RPC API to fetch and display information.

## Note

Make sure to replace `API_URL` with the actual URL of the Zetachain RPC API.
