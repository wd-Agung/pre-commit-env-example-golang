#!/bin/bash

# Path to the config.go file
CONFIG_FILE=$(find $(pwd) -name "config.go" | head -n 1)

# Check if the config.go file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "config.go file not found."
    exit 1
fi

# Path to the .env_example file
ENV_FILE=".env_example"
touch "$ENV_FILE"

# Remove the existing .env_example file if it exists
if [ -f "$ENV_FILE" ]; then
    rm "$ENV_FILE"
fi

# Extract lines containing 'env' and 'envDefault' tags
grep -o 'env:"[^"]*"\(\s\+envDefault:"[^"]*"\)\?' "$CONFIG_FILE" | while read -r line ; do
    # Extract the environment variable name and default value
    ENV_VAR=$(echo "$line" | grep -o 'env:"[^"]*"' | cut -d '"' -f 2)
    DEFAULT_VALUE=$(echo "$line" | grep -o 'envDefault:"[^"]*"' | cut -d '"' -f 2)

    # Write to the .env_example file
    echo "$ENV_VAR=$DEFAULT_VALUE" >> "$ENV_FILE"
done

touch -m "$ENV_FILE"

echo ".env_example file has been created successfully."
