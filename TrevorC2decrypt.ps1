#This is a powershell script to decrypt a payload that has been sent over TrevorC2. The payload is located in a HTTP response under 'oldcss=<payload>'.

# Define the AES key
$key = "Tr3v0rC2R0x@nd1s@w350m3#TrevorForget"

# Convert the key to a 32-byte hash for AES-256
$keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$hashedKey = $sha256.ComputeHash($keyBytes)

# Helper function to unpad data (PKCS7 padding)
function Unpad-Padding {
    param (
        [byte[]]$data
    )
    $padLength = [byte]$data[-1]
    return $data[0..($data.Length - $padLength - 1)]
}

# Decrypt function
function Decrypt-Aes {
    param (
        [string]$cipherText,
        [byte[]]$keyBytes
    )

    $blockSize = 16
    $cipherBytes = [System.Convert]::FromBase64String($cipherText)
    
    # Extract the IV (first 16 bytes)
    $iv = $cipherBytes[0..($blockSize - 1)]
    
    # Extract the encrypted content (remaining bytes)
    $cipherData = $cipherBytes[$blockSize..($cipherBytes.Length - 1)]

    # Create AES object and set parameters
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $keyBytes
    $aes.IV = $iv
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::None

    # Perform decryption
    $decryptor = $aes.CreateDecryptor()
    $decryptedBytes = $decryptor.TransformFinalBlock($cipherData, 0, $cipherData.Length)
    
    # Remove padding
    $plainBytes = Unpad-Padding -data $decryptedBytes
    $plainText = [System.Text.Encoding]::UTF8.GetString($plainBytes)
    
    return $plainText
}

# Provided Base64-encoded payload
$base64Payload = "<oldcss encoded payload here>"

# Decrypt the payload
$decryptedText = Decrypt-Aes -cipherText $base64Payload -keyBytes $hashedKey
Write-Output "Decrypted: $decryptedText"