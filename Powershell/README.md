<div align="center">

# 🚀 Clarity Monitoring PowerShell Automation

![PowerShell](https://img.shields.io/badge/PowerShell-0078d4?logo=powershell&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)
![Automation](https://img.shields.io/badge/Automation-Enabled-brightgreen)

Automate your Snowflake data monitoring, export results, and streamline reporting with this easy-to-use PowerShell solution!

</div>

---

## ✨ Features

- 🔑 Secure key pair authentication with Snowflake
- 📦 Exports query results to CSV
- 📝 Easily configurable connection and query
- ⚡ Simple, fast, and scriptable for Windows environments

---

## 📁 Project Structure

```
Powershell/
├── Generate-Reports-BC.ps1 # Main PowerShell automation script
├── Modules/
│   └── Send-MailWithAttachment.psm1 # PowerShell module for sending emails with attachments
├── private_key.pem      # Your generated private key (keep safe!)
├── public_key.pem       # Your public key (register in Snowflake)
├── README.md            # This file
├── Generate-Keys.md     # Step-by-step guide for key generation
└── ClarityMonitoring_Step.md # Full setup & troubleshooting guide
```

> **Note:** The `Generate-Keys.md` file provides detailed, step-by-step instructions for generating your key pair using OpenSSL. Refer to it if you need help with the key generation process.


---

## 🛠️ Prerequisites

- **Windows 10/11** with PowerShell 5.x or later
- **SnowSQL** installed ([Download & Docs](https://docs.snowflake.com/en/user-guide/snowsql-install-config))
- **OpenSSL** for key generation ([Download](https://slproweb.com/products/Win32OpenSSL.html) or use [Chocolatey](https://chocolatey.org/install))
- A valid **Snowflake account** and user credentials

---

## 🔐 Key Pair Generation & Configuration

### 1. Install OpenSSL (if not present)
```powershell
# Using Chocolatey (recommended)
choco install openssl
```
Or download from [slproweb.com](https://slproweb.com/products/Win32OpenSSL.html) and add to PATH.

### 2. Generate Keys
```powershell
openssl genrsa -out private_key.pem 2048
openssl rsa -in private_key.pem -pubout -out public_key.pem
```

### 3. Register Public Key in Snowflake
- Copy the contents of `public_key.pem` (including the header/footer)
- In Snowflake (SQL worksheet or SnowSQL):
```sql
alter user <your_user> set rsa_public_key='<paste_entire_public_key_here>';
```

---

## ⚙️ Script Setup & Usage

1. **Edit `Generate-Reports-BC.ps1`:**
   - Set your Snowflake `$account`, `$user`, `$warehouse`, `$database`, `$schema`
   - Ensure `$privateKeyPath` and `$snowsqlPath` are correct
   - **Configure SMTP email parameters:**
     - `$SmtpServer`: Your SMTP server address
     - `$From`: Sender email address
     - `$To`: Recipient email address
     - `$Subject`/`$Body`: Email subject and body (customizable)
2. **Place your `private_key.pem`** at the path referenced in the script
3. **Run the script in PowerShell:**
   ```powershell
   .\Generate-Reports-BC.ps1
   ```
4. **Check outputs:**
   - `snowflake_results.csv` (parsed results)
   - `snowsql_raw_output.txt` (raw output)

---

## 📧 Email Notification Feature

- The script automatically imports the `Send-MailWithAttachment` module from the `Modules` folder.
- **If the report contains more than one record, an email will be sent** with the CSV attached to the recipient you specify.
- You can customize SMTP settings and recipient details in the script.

**Example Email Parameters:**
```powershell
$SmtpServer = "smtp.example.com"
$From = "sender@example.com"
$To = "recipient@example.com"
$Subject = "BC Report Results"
$Body = "Please find attached the latest BC report results."
```

**Note:**
- No email will be sent if there is only one or zero records in the report.
- Make sure your SMTP server allows relaying and the credentials are correct if authentication is required.

---

## 🧩 Troubleshooting & Tips

- Update `$snowsqlPath` if SnowSQL is installed in a different location
- Ensure all file paths are accessible and you have write permissions
- Adjust `Select-Object -Skip 2` if your SnowSQL CSV output format differs
- For full setup and troubleshooting, see [`ClarityMonitoring_Step.md`](./ClarityMonitoring_Step.md)

---

## 🛡️ Security Best Practices

- **Never share your private key (`private_key.pem`)**
- Store keys securely and restrict file permissions
- Do not commit sensitive data to public repositories
- Use environment variables or vaults for credentials in production

---

## 🙌 Contributing & Support

Pull requests and issues are welcome! For questions or improvements, contact the project maintainer.

---

<div align="center">
  <strong>Happy Monitoring! 🚦</strong>
</div>