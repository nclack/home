Whorl is [UTM] ([QEMU]) based `aarch64-linux` virtual machine.

[UTM]: https://mac.getutm.app/
[QEMU]: https://www.qemu.org/

## Installation in UTM (Apple Silicon)

### Building the Installer ISO

From the repository root:
```bash
nix build .#whorl.iso
```

The ISO will be available at `result/iso/whorl-utm.iso`

#### Building via GitHub Actions

The ISO is automatically built when a new version tag is pushed. To trigger a build:

1. Create and push a new version tag:
   ```bash
   git tag v1.0.0  # Use appropriate version
   git push origin v1.0.0
   ```

2. The GitHub Actions workflow will:
   - Build the ISO for aarch64-linux
   - Create a new release with the ISO
   - Name the ISO file as `whorl-utm-YYYYMMDD-vX.X.X.iso`

3. Once complete, download the ISO from the Releases page

### VM Setup
1. Create a new UTM VM with:
   - Architecture: ARM64 (AArch64)
   - Memory: 4GB minimum recommended
   - Storage: 64GB minimum recommended
   - Network: Enabled
   - Display: Default
   - Sharing: Optional

2. In VM Settings:
   - Boot ISO: Select the `whorl-utm.iso` file
   - UEFI Boot: Enabled

3. Start the VM and wait for it to boot

4. Run the automated installer:
   ```bash
   install-whorl
   ```
   This will:
   - Create and format partitions
   - Set up the system configuration
   - Install NixOS with the Whorl configuration

5. Once installation completes:
   - Run `reboot`
   - Remove the ISO from the VM settings
   - Boot into your new system
   - Login as root with password: `whorl`
   - Change the root password using `passwd`

### Post-Installation

After installation, you may want to:
1. Create user accounts
2. Configure networking
3. Update your system with `nixos-rebuild switch`
