# docker-mailserver configuration

This directory is mounted into the container at `/tmp/docker-mailserver`.

Add optional files such as:
- postfix-accounts.cf  → user@domain|password
- postfix-virtual.cf   → aliases
- opendkim/            → DKIM keys
- dovecot.conf         → overrides

Docs: https://github.com/docker-mailserver/docker-mailserver/wiki/Configuration

### SSH & Deploy to RunPod

Connect to your RunPod pod and deploy the mail server using these steps:

1. SSH (no SCP/SFTP):
```powershell
ssh qlgr4lgnahxnep-64411b24@ssh.runpod.io -i ~/.ssh/id_ed25519
```

2. SSH over TCP (supports SCP/SFTP):
```powershell
ssh root@103.27.233.182 -p 11292 -i ~/.ssh/id_ed25519
```

3. Clone repository and deploy:
```powershell
git clone https://github.com/myissues247/myissues-mta.git ~/myissues-mta
cd ~/myissues-mta
docker compose up -d --build
chmod +x generate_dkim_keys.sh create_user.sh
./generate_dkim_keys.sh
./create_user.sh admin@myissuesinc.com StrongAdmin!23
```

4. Public SSH key (for pod access):
```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDuk7xcPXU3QZy42qvlGxvPI+cKZShA4eGEksQjOeeob kamran ali shah@LAPTOP-U0LS36KT
```

---
## RunPod Pod Access

**Pod Name:** Myissues-mta-server

### Connect Details

**SSH (no SCP/SFTP)**
```powershell
ssh qlgr4lgnahxnep-64411b24@ssh.runpod.io -i ~/.ssh/id_ed25519
```

**SSH over TCP (supports SCP/SFTP)**
```powershell
ssh root@103.27.233.182 -p 11292 -i ~/.ssh/id_ed25519
```

### Web Terminal

Use the browser-based terminal in RunPod dashboard:

- **Enable Web Terminal**: Port 19123
- **Open Web Terminal**: Available via RunPod UI

### Direct TCP Ports

Connect directly to exposed ports:

- `103.27.233.182:11292`
- `103.27.233.182:22`
