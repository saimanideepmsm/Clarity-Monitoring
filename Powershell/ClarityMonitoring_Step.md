# Clarity Monitoring PowerShell Automation – Step-by-Step Setup Guide

This guide provides a comprehensive, step-by-step walkthrough to set up and run the Clarity Monitoring automation scripts for Snowflake using PowerShell.

---

## 1. Prerequisites

- **Windows 10/11** with PowerShell 5.x or later
- **SnowSQL** installed ([Download & Docs](https://docs.snowflake.com/en/user-guide/snowsql-install-config))
- **OpenSSL** for key generation ([Download](https://slproweb.com/products/Win32OpenSSL.html) or use [Chocolatey](https://chocolatey.org/install))
- A valid **Snowflake account** and user credentials

---

## 2. Key Pair Generation

1. **Install OpenSSL** (if not present)
   - Using Chocolatey (recommended):
     ```powershell
     choco install openssl
     ```
   - Or download from [slproweb.com](https://slproweb.com/products/Win32OpenSSL.html) and add to PATH.
2. **Generate key pair:**
   ```powershell
   openssl genrsa -out private_key.pem 2048
   openssl rsa -in private_key.pem -pubout -out public_key.pem
   ```
3. **Register your public key in Snowflake:**
   - Copy the contents of `public_key.pem` (including header/footer)
   - In Snowflake (SQL worksheet or SnowSQL):
     ```sql
     alter user <your_user> set rsa_public_key='<paste_entire_public_key_here>';
     ```

---

## 3. Script Configuration

1. **Edit `Generate-Reports-BC.ps1`:**
   - Set your Snowflake `$account`, `$user`, `$warehouse`, `$database`, `$schema`.
   - Ensure `$privateKeyPath` and `$snowsqlPath` are correct.
2. **Place your `private_key.pem`** at the path referenced in the script.

---

## 4. Running the Script

1. Open PowerShell in the `Powershell` directory.
2. Run the script:
   ```powershell
   .\Generate-Reports-BC.ps1
   ```
3. **Outputs:**
   - `snowflake_results.csv`: Parsed query results
   - `snowsql_raw_output.txt`: Raw output from SnowSQL

---

## 5. Troubleshooting & Tips

- Update `$snowsqlPath` if SnowSQL is installed in a different location.
- Ensure all file paths are accessible and you have write permissions.
- Adjust `Select-Object -Skip 2` if your SnowSQL CSV output format differs.
- If you encounter errors, check the output files for details.

---

## 6. Security Best Practices

- **Never share your private key (`private_key.pem`)**
- Store keys securely and restrict file permissions
- Do not commit sensitive data to public repositories
- Use environment variables or vaults for credentials in production

---

## 7. Support

For questions, improvements, or troubleshooting help, open an issue or contact the project maintainer.
