#!/bin/bash
#
# SeaBIOS & SeaVGABIOS compile script for QEMU
# (because 1.7.4 that came with QEMU2.0.0 had an annoying bug...)
# 
# Author:       Steven Honeyman <stevenhoneyman at gmail com>
# Instructions: Put this script in an empty dir and then run it.
#               Output goes into ./OUTPUT
# 

[ -f ./seabios-1.7.5.tar.gz ] || wget -nv http://code.coreboot.org/p/seabios/downloads/get/seabios-1.7.5.tar.gz
tar zxf seabios-1.7.5.tar.gz
mv seabios-1.7.5 seabios

# Create BIOS configs
echo 'CONFIG_QEMU=y' | tee -a config.seabios-{128k,256k}
echo 'CONFIG_ROM_SIZE=256' >> config.seabios-256k
echo 'CONFIG_ROM_SIZE=128' >> config.seabios-128k
echo 'CONFIG_XEN=n'        >> config.seabios-128k
echo 'CONFIG_USB_XHCI=n'   >> config.seabios-128k
echo 'CONFIG_USB_UAS=n'    >> config.seabios-128k

# Create VGABIOS configs
echo 'CONFIG_BUILD_VGABIOS=y'   | tee -a config.vga-{isavga,cirrus,qxl,stdvga,vmware}
echo 'CONFIG_VGA_BOCHS=y'       | tee -a config.vga-{isavga,qxl,stdvga,vmware}
echo 'CONFIG_VGA_CIRRUS=y'     >> config.vga-cirrus
echo 'CONFIG_VGA_PCI=y'         | tee -a config.vga-{cirrus,qxl,stdvga,vmware}
echo 'CONFIG_VGA_PCI=n'        >> config.vga-isavga
echo 'CONFIG_OVERRIDE_PCI_ID=y' | tee -a config.vga-{qxl,vmware}
echo 'CONFIG_VGA_VID=0x1b36'   >> config.vga-qxl
echo 'CONFIG_VGA_DID=0x0100'   >> config.vga-qxl
echo 'CONFIG_VGA_VID=0x15ad'   >> config.vga-vmware
echo 'CONFIG_VGA_DID=0x0405'   >> config.vga-vmware

mkdir -p seabios/builds

for _CFG in config.*
do
  make -j1 -C seabios clean distclean
  cp $_CFG seabios/.config
  make -j1 -C seabios olddefconfig
  make -j1 -C seabios
    if echo $_CFG|grep -q vga; then
      cp seabios/out/vgabios.bin seabios/builds/vgabios-$(echo $_CFG|cut -d'-' -f2).bin
    else
      cp seabios/out/bios.bin seabios/builds/bios-$(echo $_CFG|cut -d'-' -f2).bin
      cp seabios/out/src/fw/*.aml seabios/builds/
    fi
done

mkdir -p OUTPUT
mv -v seabios/builds/* OUTPUT/
mv -v OUTPUT/vgabios-isavga.bin OUTPUT/vgabios.bin
mv -v OUTPUT/bios-128k.bin OUTPUT/bios.bin

# Clean up
rm -r ./seabios
rm config.*
