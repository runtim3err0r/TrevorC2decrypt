This is just a small powershell script that can be used to decode TrevorC2 payload. The payload is usually located in 'oldcss=<payload>' tag and it is base64 encrypted along with AES key. If the key used by the adversary is unchanged, its going to be: "Tr3v0rC2R0x@nd1s@w350m3#TrevorForget" by default, therefore this script can be used as is.


In other cases you will have to change the value of key in the script to decode the payload. Replace the contents of $base64payload in the script with your value and run it in powershell.
