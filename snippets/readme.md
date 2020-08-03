## how to generate code snippets
1. run [generate_snippets.sh](../scripts/generate_snippets.sh)

The [generate_snippets.sh](../scripts/generate_snippets.sh) script calls the following scripts:  
* [parse_ansible.py](../scripts/parse_ansible.py) parses ansible document and generates ansible-data.json.
* [generate_codesnippets.ts](../scripts/generate_codesnippets.ts) generates code snippets based on module doc in ansible-data.json.