## Generate strong passwords

```bash
( tr -dc '0-9' < /dev/random|head -c 6;
  tr -dc 'a-zA-Z' < /dev/random|head -c 10;
  tr -dc '@#$%&' < /dev/random|head -c 4; ) \
| fold -w1 | shuf | tr -d '\n'
```

Change the numbers in the head command to increase or decrease the number of each type of character.

Example of generated passwords:
- `32$5&q0C1HmI#aQ&Hp9G`
- `eT&%96%2Rn#o6bEE9C2h`
- `8s8LD$@#%NicT15H83Fg`
- `$4mTp4s92@nGgk7&v0H$`
- `2y%oiA1zD2$eE1y6@%9M`

If you intend to use this password in a URL, prefer URL-safe characters such as [`-`, `_`, `.`, `~`](https://developers.google.com/maps/url-encoding?hl=pt-br#special-characters).

## GPG Symmetric Encryption 
```bash
echo "Test 123" > my_secret_file.txt
MY_PASS=$(openssl rand -base64 18)
echo $MY_PASS
echo $MY_PASS|gpg --batch --passphrase-fd 0 -c my_secret_file.txt
ls -l my_secret_file.txt.gpg
cat my_secret_file.txt.gpg
rm -f my_secret_file.txt
echo $MY_PASS|gpg --batch --passphrase-fd 0 -d my_secret_file.txt
```

## GPG + RSA Asymmetric Encryption
Generate key
```bash
gpg --full-gen-key
```

List public keys
```bash
gpg --list-keys
```

Export public key
```bash
gpg --armor --export --output user.key user@server
```

Import public key
```bash
gpg --armor --import user.key
```

Encrypt file
```bash
gpg --encrypt --recipient user@server file
```

Decrypt file
```bash
gpg --decrypt file
```


