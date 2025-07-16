# Import the Snowflake module
# Import the simple Snowflake CLI module
Import-Module "$PSScriptRoot\SnowflakeCliModule.psm1"

# Define your actual credentials and connection details
# Set your Key Vault name and the secret names for account and user
$KeyVaultName = "<YourKeyVaultName>" #Jenkins keyvault name
$AccountSecretName = "<AccountSecretName>" #Jenkins Snowflake account identifier
$UserSecretName = "<UserSecretName>" #Jenkins Snowflake Service account username

# # Fetch account and user from Key Vault
# $account = Get-KeyVaultSecretWithManagedIdentity -KeyVaultName $KeyVaultName -SecretName $AccountSecretName
# $user = Get-KeyVaultSecretWithManagedIdentity -KeyVaultName $KeyVaultName -SecretName $UserSecretName

# Fetch account and user from Key Vault
$account = "LWKCFKC-PC52532"
$user = "MANIDEEPADMIN"

# Get private key from Key Vault and write to temp file
$privateKeyContent = Get-Content "./private_key.pem" -Raw
$tempPrivateKeyPath = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempPrivateKeyPath -Value $privateKeyContent -NoNewline

$warehouse = "COMPUTE_WH"
$database = "TESTDB"
$schema = "TESTSCHEMA"
$query = "select * from TESTTABLE2"

try {
    # Execute the query using snowsql and private key authentication
    $results = Invoke-SnowflakeCliQuery -Account $account -User $user -PrivateKeyPath $tempPrivateKeyPath -Warehouse $warehouse -Database $database -Schema $schema -Query $query

    Write-Host "Snowflake Query Results (parsed):"
    $results | Format-Table -AutoSize

    # Find rows with STATS = 'FAIL'
    $failRows = $results | Where-Object { $_.STATS -eq "FAIL" }
} finally {
    # Clean up the temp file
    Remove-Item $tempPrivateKeyPath -Force
}

if ($failRows) {
    Write-Host "We have B&C failure"
    $failRows | Format-Table -AutoSize
    exit 1  # Exit with error if failures are found
} else {
    Write-Host "We do not have B&C failure"
    exit 0  # Success
}