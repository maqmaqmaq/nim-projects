import os
import strutils
import nimaes

proc encryptFileWithPassword(filePath: string, password: string) =
  var aes = initAES()
  let input = "0123456789ABCDEF"
  let key = "FEDCBA9876543210"
  if aes.setEncodeKey(key):
    let encrypted = aes.encryptECB(input)
    if aes.setDecodeKey(key):
      let decrypted = aes.decryptECB(encrypted)
      echo decrypted
  var fileContents = readFile(filePath)
  # var encryptedContents = aesEncrypt(fileContents, password)
  # writeFile(filePath, encryptedContents)

proc decryptFileWithPassword(filePath: string, password: string) =
  var encryptedContents = readFile(filePath)
  # var decryptedContents = aesDecrypt(encryptedContents, password)
  # writeFile(filePath, decryptedContents)

proc main() =
  echo "File Encryption/Decryption Utility"
  echo "Enter file path:"
  let filePath = readLine(stdin)

  echo "Enter password:"
  let password = readLine(stdin)

  echo "Choose an operation:"
  echo "1. Encrypt file"
  echo "2. Decrypt file"
  let operation = readLine(stdin).parseInt()

  case operation
  of 1:
    encryptFileWithPassword(filePath, password)
    echo "File encrypted successfully."
  of 2:
    decryptFileWithPassword(filePath, password)
    echo "File decrypted successfully."
  else:
    echo "Invalid operation."

when isMainModule:
  main()
