#!/bin/bash
set -e

echo "create-mongo-users.sh script run";

mongo <<EOF
use admin 

// Create an administrative user to manage database users:
var rootUserExists = db.getUser('rootUser');
if (!rootUserExists) {
    db.createUser({ user: 'rootUser', pwd: 'z336RW6exk', roles: ['root'] })
    print('rootUser created');
} else {
    print('rootUser already exists');
}

// Authorize as that user to verify the password:
db.auth({ user: 'rootUser', pwd: 'z336RW6exk' })

// Create a service user for Repository (to be used in code):
var nexusUserExists = db.getUser('nexusUser');
if (!nexusUserExists) {
    db.createUser(
        {
            user: 'nexusUser',
            pwd: 'X3H44wQA8c',
            roles: [
                { role: "dbOwner", db: "nexusDB" },
                { role: "dbOwner", db: "auditLogs" }
            ]
        }
    )
    print('nexusUser created');
} else {
    print('nexusUser already exists');
}

// Create a read only user for reporting uses:
var nexusClientExists = db.getUser('nexusClient');
if (!nexusClientExists) {
    db.createUser(
        {
            user: 'nexusClient',
            pwd: 'f57QJmj2Vm',
            roles: [
                { role: "read", db: "nexusDB" },
                { role: "read", db: "auditLogs" }
            ]
        }
    )
    print('nexusClient created');
} else {
    print('nexusClient already exists');
}

// Create an operations user:
var operationsUserExists = db.getUser('operationsUser');
if (!operationsUserExists) {
    db.createUser(
        {
            user: 'operationsUser',
            pwd: 'Y3H55wQA8c',
            roles: [
                "root"
            ]
        }
    )
    print('operationsUser created');
} else {
    print('operationsUser already exists');
}

EOF