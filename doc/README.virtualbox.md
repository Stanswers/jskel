# VirtualBox 5.1

Tips for installing VirtualBox 5.1 with SecureBoot on Fedora

## Install VirtaulBox 5.1

  1. Import the [Oracle public key](https://www.virtualbox.org/download/oracle_vbox.asc).

  ```
  sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
  ```

  2. Install the [Fedora VirtualBox repo file](http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo) to /etc/yum.repos.d/

  ```
  sudo wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
  ```

  3. Install requirements for building kernel modules

  ```
  sudo dnf install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms
  ```

  3. Install VirtualBox 5.1

  ```
  sudo dnf install VirtualBox-5.1
  ```

  4. Add your user to the vboxusers group

  ```
  usermod -a -G vboxusers user_name
  ```

  see [virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads) and [if-not-true-then-false](http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/)

## Sign Kernel Modules for SecureBoot

  1. Generate certificate

  ```
  openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=Stanswers/"
  ```

  2. Import module in MOKManager of UEFI

  ```
  sudo mokutil --import MOK.der
  ```
  note: you will be propmted to provide a password make sure to remember this you will be prompted for it when enrolling MOK in the next step

  3.  Reboot and follow the "Perform MOK management" dialogue.

      Enroll MOK -> Continue -> Yes -> (provide your password) -> Ok
  4.  Sign VirtualBox Modules

  ```
  for module in vboxdrv vboxnetflt vboxnetadp vboxpci; do
    echo sudo /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n $module)
  done
  ```
  note: each time "/sbin/rcvboxdrv setup" is called the VirtualBox Modules will have to be signed again.

  5.  Finall restart the vboxdrv

  ```
  systemctl restart vboxdrv
  ```

  see [tejasbarot](http://www.tejasbarot.com/2016/07/09/virtualbox-5-x-with-secureboot-on-fedora-24-ubuntu-16-04/)
