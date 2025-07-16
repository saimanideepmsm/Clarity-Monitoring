function Invoke-SnowflakeCliQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Account,
        [Parameter(Mandatory)] [string]$User,
        [Parameter(Mandatory)] [string]$PrivateKeyPath,
        [Parameter(Mandatory)] [string]$Warehouse,
        [Parameter(Mandatory)] [string]$Database,
        [Parameter(Mandatory)] [string]$Schema,
        [Parameter(Mandatory)] [string]$Query,
        [string]$SnowSqlPath = "C:\\Program Files\\Snowflake SnowSQL\\snowsql.exe",
    )

    $args = @(
        "-a", $Account,
        "-u", $User,
        "--private-key-path", $PrivateKeyPath,
        "-w", $Warehouse,
        "-d", $Database,
        "-s", $Schema,
        "-q", $Query,
        "-o", "log_level=ERROR",
        "-o", "output_format=csv"
    )

    $results = & $SnowSqlPath @args
    if ($LASTEXITCODE -ne 0) {
        throw "SnowSQL execution failed. Check your parameters and SnowSQL installation."
    }
    # # Parse CSV output (skip header lines if needed)
    # $csv = $results | Select-Object -Skip 2 | ConvertFrom-Csv
    # return $csv
    return $results
}

function Get-KeyVaultSecretWithManagedIdentity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$KeyVaultName,
        [Parameter(Mandatory)] [string]$SecretName
    )
    # Fetch the access token
    $Response = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -Method GET -Headers @{Metadata="true"}
    $KeyVaultToken = $Response.access_token
    # Fetch the secret
    $SecretUri = "https://$KeyVaultName.vault.azure.net/secrets/$SecretName?api-version=2016-10-01"
    $SecretResponse = Invoke-RestMethod -Uri $SecretUri -Method GET -Headers @{Authorization="Bearer $KeyVaultToken"}
    return $SecretResponse.value
}

Export-ModuleMember -Function Invoke-SnowflakeCliQuery, Get-KeyVaultSecretWithManagedIdentity