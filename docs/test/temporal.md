Why my docker engine service do not start? I'm using CachyOS Linux Kernel 7.0



❯ systemctl status docker.service × docker.service - Docker Application Container Engine Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: disabled) Active: failed (Result: start-limit-hit) since Wed 2026-04-29 17:12:25 CST; 12s ago Invocation: 0d20155a453a4a7b853034ba81a7a5c6 TriggeredBy: × docker.socket Docs: https://docs.docker.com Process: 61806 ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock (code=exited, status=1/FAILU> Main PID: 61806 (code=exited, status=1/FAILURE) Mem peak: 40.3M CPU: 69ms 

❯ journalctl -xeu docker.service level=info msg="Deleting nftables IPv4 rules" error="exit status 1" output="Error: Could not process rule: No such file or d> Apr 29 17:12:23 pc dockerd[61806]: time="2026-04-29T17:12:23.405989688-06:00" level=info msg="Deleting nftables IPv6 rules" error="exit status 1" output="Error: Could not process rule: No such file or d> Apr 29 17:12:23 pc dockerd[61806]: time="2026-04-29T17:12:23.513161403-06:00" level=info msg="stopping event stream following graceful shutdown" error="<nil>" module=libcontainerd namespace=moby Apr 29 17:12:23 pc dockerd[61806]: time="2026-04-29T17:12:23.513343582-06:00" level=info msg="stopping event stream following graceful shutdown" error="context canceled" module=libcontainerd namespace=p> Apr 29 17:12:23 pc dockerd[61806]: time="2026-04-29T17:12:23.513370291-06:00" level=info msg="Daemon shutdown complete" error="failed to start daemon: Error initializing network controller: error obtain> Apr 29 17:12:23 pc dockerd[61806]: failed to start daemon: Error initializing network controller: error obtaining controller instance: failed to register "bridge" driver: failed to add jump rules to ipv> Apr 29 17:12:23 pc dockerd[61806]: (exit status 4)) Apr 29 17:12:23 pc systemd[1]: docker.service: Main process exited, code=exited, status=1/FAILURE 

❯ iptables --version iptables v1.8.13 (nf_tables) ~/mine/t51 main* 

❯ lsmod | grep br_netfilter ~/mine/t51 main* 

❯ sudo modprobe br_netfilter modprobe: FATAL: Module br_netfilter not found in directory /lib/modules/7.0.1-1-cachyos ~/mine/t51 main* 18s 

❯ sudo iptables -L Chain INPUT (policy DROP) target prot opt source destination

❯ zgrep BRIDGE_NETFILTER /proc/config.gz
CONFIG_BRIDGE_NETFILTER=m

sudo modprobe nf_tables
sudo modprobe nf_nat
sudo modprobe nf_conntrack
sudo modprobe iptable_nat
sudo modprobe ip_tables