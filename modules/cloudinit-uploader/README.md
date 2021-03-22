**Be careful when creating this graph from scratch!**

After the LX container was created, this needs to run on it, so the mount is correct.
There currently is a race-condition when we try to write a cloudinit config before this has run, because it will cause the mount dir to be create in the rootfs, preventing the mount.

```sh
pct set 111 -mp0 /mnt/pve/cloud-init-custom/snippets/,mp=/mnt/cloudinit/
```
