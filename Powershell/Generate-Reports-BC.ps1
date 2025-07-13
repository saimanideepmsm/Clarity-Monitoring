# Define your actual credentials and connection details
$account = "" #Account identifier, e.g., xy12345.eu-west
$user = "" # User name for Snowflake account
$privateKeyPath = ".\private_key.pem"  # Update this path to your actual private key file
$warehouse = "COMPUTE_WH" # Warehouse to use for the session
$database = "TESTDB" # Database to connect to
$schema = "TESTSCHEMA" # Schema to use for the session
$query = "select * from TESTTABLE"
# Path to SnowSQL (adjust if installed elsewhere)
$snowsqlPath = "C:\Program Files\Snowflake SnowSQL\snowsql.exe"
# Build argument array for private key authentication
$args = @(
    "-a", $account,
    "-u", $user,
    "--private-key-path", $privateKeyPath,
    "-w", $warehouse,
    "-d", $database,
    "-s", $schema,
    "-q", $query,
    "-o", "log_level=DEBUG",
    "-o", "output_format=csv"
)

$results = & $snowsqlPath @args
$results | Out-File ".\snowsql_raw_output.txt"
Write-Host "Raw output saved to snowsql_raw_output.txt"
# Parse CSV output (skip header lines if needed)
$csv = $results | Select-Object -Skip 2 | ConvertFrom-Csv
#$csv = $results[2..($results.Count-3)] | ConvertFrom-Csv

# Display the parsed CSV results to the console
Write-Host "Parsed CSV Results:"
foreach ($row in $csv) {
    $row.PSObject.Properties.Value -join ", " | Write-Host
}

# Export the parsed CSV results to a local CSV file
$exportPath = ".\snowflake_results.csv"
$csv | Export-Csv -Path $exportPath -NoTypeInformation

# Import the SMTP mail module
Import-Module "${PSScriptRoot}\Modules\Send-MailWithAttachment.psm1"

# SMTP parameters (update or parameterize as needed)
$SmtpServer = "smtp.example.com"      # <-- Set your SMTP server
$From = "sender@example.com"          # <-- Set sender email
$To = "recipient@example.com"         # <-- Set recipient email
$Subject = "BC Report Results"
$Body = "Please find attached the latest BC report results."

# Send email if more than one record exists
if ($csv.Count -gt 1) {
    Send-MailWithAttachment -SmtpServer $SmtpServer -From $From -To $To -Subject $Subject -Body $Body -AttachmentPath $exportPath
} else {
    Write-Host "No email sent: one or zero records found."
}

Write-Host "Results exported to $exportPath"