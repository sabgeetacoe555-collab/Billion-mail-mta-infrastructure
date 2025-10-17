# MyIssues MTA (Billion Mail)

Production-like MTA deployment using `docker-mailserver`.

## Domain
**myissuesinc.com**

## Admin email
`admin@myissuesinc.com`

## Quick Deploy (RunPod)
```bash
apt update -y && apt upgrade -y
apt install -y git curl ca-certificates
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install -y docker-compose-plugin
systemctl enable --now docker
```

Clone repo:
```bash
git clone https://github.com/myissues247/myissues-mta.git
cd myissues-mta
docker compose up -d --build
```

Generate DKIM and users:
```bash
chmod +x generate_dkim_keys.sh create_user.sh
./generate_dkim_keys.sh
./create_user.sh admin@myissuesinc.com StrongAdmin!23
./create_user.sh abdul@myissuesinc.com StrongTempPass!23
```

## DNS Setup
| Type | Name            | Value                                      |
|------|-----------------|-------------------------------------------|
| A    | mail            | <Your RunPod Public IP>                   |
| MX   | @               | mail.myissuesinc.com                      |
| TXT  | @               | v=spf1 mx a ip4:<Your RunPod IP> ~all     |
| TXT  | mail._domainkey | (from config/opendkim/mail.public.txt)    |

## Test

Check container status:
```bash
docker ps
docker compose logs -f
```

🟢 **When Christian adds DNS records:**
After A/MX/SPF are live → Let's Encrypt SSL verification will pass and Postfix/Dovecot will start with certificates.

---

## 🧩 How to deploy
1. **Copy this folder into your local machine or RunPod pod** (`~/myissues-mta`).
2. **SSH into your RunPod:**
   ```bash
   ssh root@<your-pod-ip> -p <port> -i ~/.ssh/id_ed25519
   ```

3. Install Docker (if not installed) and run:
```bash
cd ~/myissues-mta
docker compose up -d --build
```

4. Create users & generate DKIM keys:
```bash
./generate_dkim_keys.sh
./create_user.sh admin@myissuesinc.com StrongAdmin!23
./create_user.sh abdul@myissuesinc.com StrongTempPass!23
```

5. Send Christian the Public IP (shown in RunPod under Connection Details).
   He'll set up the A, MX, and SPF DNS entries.

6. After DNS propagation, SSL/Let's Encrypt verification will succeed.
