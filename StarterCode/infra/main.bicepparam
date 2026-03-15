using 'main.bicep'

param appName = 'todoapp'
param environment = 'dev'
param location = 'norwayeast'
param dbPassword = readEnvironmentVariable('DB_PASSWORD', '')