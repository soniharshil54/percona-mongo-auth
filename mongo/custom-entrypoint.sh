#!/bin/bash
set -e

# Function to wait for MongoDB to start
waitForMongo() {
    echo "Waiting for MongoDB to start..."
    while ! mongo --eval "db.stats()" > /dev/null 2>&1; do
        sleep 1
    done
}

# Check if MongoDB needs to start with authentication enabled

# Ensure MongoDB starts without authentication to run the user creation script
echo "Starting MongoDB without authentication to create users..."
mongod --enableEncryption --encryptionKeyFile /mongodb-keyfile --bind_ip_all &

# Wait for MongoDB to be ready
waitForMongo

echo "MongoDB started. Creating users..."
# Run the script to create users
/create-mongo-users.sh
echo "Users created. Stopping MongoDB..."

# Now, stop MongoDB to restart it with authentication enabled
mongod --shutdown
echo "MongoDB stopped."

echo "Starting MongoDB with authentication..."
# Start MongoDB with authentication enabled
exec mongod --auth --enableEncryption --encryptionKeyFile /mongodb-keyfile --bind_ip_all
echo "MongoDB started with authentication."
