# 🚀 hetzner-harvester-bootstrap

**Unattended, automated bare-metal installation and configuration of [SUSE Harvester](https://harvesterhci.io/) on Hetzner servers – powered by Ansible.**

This project provides a fully automated pipeline to deploy Harvester on Hetzner bare-metal systems without requiring physical access, KVM console, or USB media. It’s designed for reproducibility, customizability, and flexibility in provisioning hyperconverged Kubernetes infrastructure with persistent storage and proper networking out of the box.

---

## ✅ Features

- 📦 **Fully unattended installation** of Harvester
- 🌐 **Custom bridged & NAT networking** for internal and external traffic:
  - Pods and VMs use masquerading to appear as the host
  - Internal VM/pod communication via separate virtual bridge
- ⚙️ **Modular Ansible Playbooks** for clean, reusable automation
- 🔧 **CLI runner script** with support for:
  - Dry-run (`--check`)
  - Step-by-step execution (`--step`)
  - Tags, skip-tags, host limits
  - Custom SSH user (`--user`)
- 🧪 Optional inventory check & logging built in

---

## 📁 Repository Structure

```plaintext
.
├── playbooks/                            # part splited playbooks
│   ├── configure_multus.yml
│   ├── configure_snat.yml
│   ├── harvester_install.yml
│   ├── install_packages.yml
│   └── setup_bridge.yml                  
├── inventory/
│   └── hosts.ini                         # Define your Hetzner target hosts here
├── run-playbooks.sh                      # CLI runner script
├── playbook.yml                          # Master playbook (includes all others)
├── ansible.cfg                           # ansible local config
├── LICENSE
└── README.md
```

---

## ⚡ Quickstart

> Requirements: A remote Hetzner root server (Ubuntu/Debian-based), SSH access, and Ansible on your control machine.

1. **Clone the repo**

```bash
git clone https://github.com/yourusername/hetzner-harvester-bootstrap.git
cd hetzner-harvester-bootstrap
```

2. **Edit your inventory**

```bash
vim inventory/hosts
```

3. **Dry-run (default)**

```bash
./scripts/run-playbooks.sh
```

4. **Apply changes**

```bash
./scripts/run-playbooks.sh --apply
```

5. **Optional: Use tags, user, host filtering**

```bash
./scripts/run-playbooks.sh -a -t disk,network --user root --limit node01
```

---

## 🧠 Why Harvester + Hetzner?

Harvester offers a powerful open-source HCI (hyperconverged infrastructure) solution based on Kubernetes + KubeVirt. Hetzner provides cost-effective, performant bare-metal servers ideal for production or lab deployments. This project bridges the two with automation and repeatability in mind.

---

## 📜 License

MIT License – see [LICENSE](./LICENSE) for full text.

---

## ✨ Credits

Built and maintained with ❤️ by Julian Wolf
Contributions, ideas and improvements welcome!
