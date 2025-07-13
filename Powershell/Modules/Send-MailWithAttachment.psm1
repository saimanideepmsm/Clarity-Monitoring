function Send-MailWithAttachment {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SmtpServer,
        [Parameter(Mandatory=$true)]
        [string]$From,
        [Parameter(Mandatory=$true)]
        [string]$To,
        [Parameter(Mandatory=$true)]
        [string]$Subject,
        [Parameter(Mandatory=$true)]
        [string]$Body,
        [string]$AttachmentPath
    )

    $mailParams = @{
        SmtpServer = $SmtpServer
        From       = $From
        To         = $To
        Subject    = $Subject
        Body       = $Body
        BodyAsHtml = $false
    }

    if ($AttachmentPath -and (Test-Path $AttachmentPath)) {
        $mailParams.Attachment = $AttachmentPath
    }

    try {
        Send-MailMessage @mailParams
        Write-Host "Email sent successfully."
    } catch {
        Write-Host "Failed to send email: $_"
    }
}

Export-ModuleMember -Function Send-MailWithAttachment
