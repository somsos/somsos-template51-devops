# Virtual Machine Config


## Set Static IP for Cable

Add this file

```shell
sudo nano /etc/systemd/network/10-cable-static.network
```

Add this content

```ini
ini[Match]
Name=enp0s3

[Network]
Address=192.168.50.49/24
Gateway=192.168.50.1
DNS=8.8.8.8
DNS=8.8.4.4
```




## Set Static IP for WiFi

Add this file

```shell
sudo nano /etc/systemd/network/10-wifi-static.network
```

Add this content

```ini
ini[Match]
Name=enp0s3

[Network]
Address=192.168.1.135/24
Gateway=192.168.1.1
DNS=8.8.8.8
DNS=8.8.4.4
```




Get sure the service is running and restart it

```shell
sudo systemctl enable --now systemd-networkd
sudo systemctl restart systemd-networkd
```

Disable cloud-init network management (prevents it overwriting your config)

```shell
sudo bash -c 'echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network.cfg'
```