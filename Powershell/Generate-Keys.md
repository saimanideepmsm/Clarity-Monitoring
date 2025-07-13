# How to Create Public and Private Keys for Snowflake Authentication

This guide explains how to generate a public/private key pair for use with Snowflake key pair authentication on Windows.

## Prerequisites
- OpenSSL installed on your PC ([Download here](https://slproweb.com/products/Win32OpenSSL.html))
- Access to your Snowflake account as a user or admin

## Steps

### 1. Generate a Private Key
Open PowerShell or Command Prompt and run:

```
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out private_key.pem -nocrypt
```
- This creates `private_key.pem` in your current directory.

### 2. Generate a Public Key
Run:
```
openssl rsa -in private_key.pem -pubout -out public_key.pem
```
- This creates `public_key.pem` in your current directory.

### 3. Register the Public Key in Snowflake
1. Open `public_key.pem` in a text editor.
2. Copy the contents (excluding the `-----BEGIN PUBLIC KEY-----` and `-----END PUBLIC KEY-----` lines).
3. In the Snowflake web UI or SnowSQL, run:
   ```sql
   alter user <your_user> set rsa_public_key='<paste_public_key_here>';
   ```
   Replace `<your_user>` with your Snowflake username and `<paste_public_key_here>` with the copied key (all on one line).

### 4. Use the Private Key in Your Script
- Set the path to `private_key.pem` in your script or SnowSQL command using the `--private-key-path` option.

## Example PowerShell Usage
```powershell
$privateKeyPath = "C:\Path\To\private_key.pem"
$args = @(
    "-a", $account,
    "-u", $user,
    "--private-key-path", $privateKeyPath,
    # ...other args...
)
& $snowsqlPath @args
```

## Security Note
- Keep your private key secure and never share it.
- Only the public key should be registered in Snowflake.

---
For more details, see the [Snowflake documentation](https://docs.snowflake.com/en/user-guide/key-pair-auth).
