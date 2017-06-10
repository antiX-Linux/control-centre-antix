#!/bin/bash
# File Name: controlcenter.sh
# Purpose: all-in-one control centre for antiX
# Authors: OU812 and minor modifications by anticapitalista
# Latest Change: 20 August 2008
# Latest Change: 11 January 2009 and renamed antixcc.sh
# Latest Change: 15 August 2009 some apps and labels altered.
# Latest Change: 09 March 2012 by anticapitalista. Added Live section.
# Latest Change: 22 March 2012 by anticapitalista. Added jwm config options and edited admin options.
# Latest Change: 18 April 2012 by anticapitalista. mountbox-antix opens as user not root.
# Latest Change: 06 October 2012 by anticapitalista. Function for ICONS. New icon theme.
# Latest Change: 26 October 2012 by anticapitalista. Includes gksudo and ktsuss.
# Latest Change: 12 May 2013 by anticapitalista. Let user set default apps.
# Latest Change: 05 March 2015 by BitJam: Add alsa-set-card, edit excludes, edit bootloader.  Fix indentation.
#                                         Hide live tab on non-live systems.  Use echo instead of gettext.
#                                         Remove unneeded doublequotes between tags.  Use $(...) instead of `...`.
# Latest Change: 01 May 2016 by anticapitalista: Use 1 script and use hides if nor present on antiX-base
# Acknowledgements: Original script by KDulcimer of TinyMe. http://tinyme.mypclinuxos.com
#################################################################################################################################################

TEXTDOMAINDIR=/usr/share/locale
TEXTDOMAIN=antixcc.sh
# Options
ICONS=/usr/share/icons/antiX
ICONS2=/usr/share/pixmaps

EDITOR="geany -i"

Desktop=$"Desktop" System=$"System" Network=$"Network" Shares=$"Shares" Session=$"Session"
Live=$"Live" Disks=$"Disks" Hardware=$"Hardware" Drivers=$"Drivers" Maintenance=$"Maintenance"
dpi_label=$(printf "%s (DPI)" $"Set Font Size")

[ -d $HOME/.fluxbox -a -e /usr/share/xsessions/fluxbox.desktop ] \
    && edit_fluxbox=$(cat <<Edit_Fluxbox
    <hbox>
      <button>
        <input file>$ICONS/gnome-documents.png</input>
        <action>$EDITOR $HOME/.fluxbox/overlay $HOME/.fluxbox/keys $HOME/.fluxbox/init $HOME/.fluxbox/startup $HOME/.fluxbox/apps $HOME/.fluxbox/menu &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit Fluxbox Settings")</label>
      </text>
    </hbox>
Edit_Fluxbox
)

[ -d $HOME/.icewm -a -e /usr/share/xsessions/icewm-session.desktop ] \
    && edit_icewm=$(cat <<Edit_Icewm
    <hbox>
      <button>
        <input file>$ICONS/gnome-documents.png</input>
        <action>$EDITOR $HOME/.icewm/winoptions $HOME/.icewm/preferences $HOME/.icewm/keys $HOME/.icewm/startup $HOME/.icewm/toolbar $HOME/.icewm/menu &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit IceWM Settings")</label>
      </text>
    </hbox>
Edit_Icewm
)

[ -d $HOME/.jwm -a -e /usr/share/xsessions/jwm.desktop ] \
    && edit_jwm=$(cat <<Edit_Jwm
    <hbox>
      <button>
        <input file>$ICONS/cs-desktop-effects.png</input>
        <action>$EDITOR $HOME/.jwm/preferences $HOME/.jwm/keys $HOME/.jwm/tray $HOME/.jwm/startup $HOME/.jwmrc $HOME/.jwm/menu &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit jwm Settings")</label>
      </text>
    </hbox>
Edit_Jwm
)

# Edit syslinux.cfg if the device it is own is mounted read-write
grep -q " /live/boot-dev .*\<rw\>" /proc/mounts \
    && edit_bootloader=$(cat <<Edit_Bootloader
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop.png</input>
        <action>gksu "$EDITOR /live/boot-dev/boot/syslinux/syslinux.cfg /live/boot-dev/boot/syslinux/gfxboot.cfg" &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit Bootloader menu")</label>
      </text>
    </hbox>
Edit_Bootloader
)

excludes_dir=/usr/local/share/excludes
test -d $excludes_dir && edit_excludes=$(cat <<Edit_Excludes
    <hbox>
      <button>
        <input file>$ICONS/remastersys.png</input>
        <action>gksu $EDITOR $excludes_dir/*.list &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit Exclude files")</label>
      </text>
    </hbox>
Edit_Excludes
)

global_dir=/etc/desktop-session
test -d $global_dir  && edit_global=$(cat <<Edit_Global
    <hbox>
      <button>
        <input file>$ICONS/gnome-session.png</input>
        <action>gksu $EDITOR $global_dir/*.conf $global_dir/startup &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Global Desktop-Session")</label>
      </text>
    </hbox>
Edit_Global
)

synaptic_dir=/usr/share/synaptic
test -d $synaptic_dir  && edit_synaptic=$(cat <<Edit_Synaptic
    <hbox>
      <button>
        <input file>$ICONS2/synaptic.png</input>
        <action>gksu synaptic &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Manage Packages")</label>
      </text>
    </hbox>
Edit_Synaptic
)

bootrepair_dir=/usr/share/bootrepair
test -d $bootrepair_dir  && edit_bootrepair=$(cat <<Edit_Bootrepair
    <hbox>
      <button>
        <input file>$ICONS/computer.png</input>
        <action>gksu bootrepair &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Boot Repair")</label>
      </text>
    </hbox>
Edit_Bootrepair
)

wicd_dir=/usr/share/wicd
test -d $wicd_dir  && edit_wicd=$(cat <<Edit_Wicd
    <hbox>
      <button>
        <input file>$ICONS/nm-device-wireless.png</input>
        <action>wicd-gtk &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Connect Wirelessly (wicd)")</label>
      </text>
    </hbox>
Edit_Wicd
)

firewall_dir=/usr/share/gufw
test -d $firewall_dir  && edit_firewall=$(cat <<Edit_Firewall
    <hbox>
      <button>
        <input file>$ICONS/firewall.png</input>
        <action>gksu gufw &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Manage Firewall")</label>
      </text>
    </hbox>
Edit_Firewall
)

backup_dir=/usr/share/luckybackup
test -d $backup_dir  && edit_backup=$(cat <<Edit_Backup
    <hbox>
      <button>
        <input file>$ICONS/luckybackup.png</input>
        <action>gksu luckybackup &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Backup Your System")</label>
      </text>
    </hbox>
Edit_Backup
)

equalizer_dir=/usr/share/doc/alsamixer-equalizer-antix
test -d $equalizer_dir  && edit_equalizer=$(cat <<Edit_Equalizer
    <hbox>
      <button>
        <input file>$ICONS2/alsamixer-equalizer.png</input>
        <action>desktop-defaults-run -t alsamixer -D equal &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Alsamixer Equalizer")</label>
      </text>
    </hbox>
Edit_Equalizer
)

unetbootin_dir=/usr/share/doc/unetbootin
test -d $unetbootin_dir  && edit_unetbootin=$(cat <<Edit_Unetbootin
    <hbox>
      <button>
        <input file>$ICONS/usb-creator.png</input>
        <action>gksu unetbootin &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Install to USB retain partitions (UNetbootin)")</label>
      </text>
    </hbox>
Edit_Unetbootin
)

printer_dir=/usr/share/system-config-printer
test -d $printer_dir  && edit_printer=$(cat <<Edit_Printer
    <hbox>
      <button>
        <input file>$ICONS2/hplj1020_icon.png</input>
        <action>system-config-printer &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Setup a Printer")</label>
      </text>
    </hbox>
Edit_Printer
)

livekernel_dir=/usr/share/doc/live-kernel-updater
test -d $livekernel_dir  && edit_livekernel=$(cat <<Edit_Livekernel
    <hbox>
      <button>
        <input file>$ICONS/usb-creator.png</input>
        <action>desktop-defaults-run -t sudo /usr/local/bin/live-kernel-updater --pause &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Live-usb kernel updater")</label>
      </text>
    </hbox>
Edit_Livekernel
)

lxkeymap_dir=/usr/share/doc/lxkeymap
test -d $lxkeymap_dir  && edit_lxkeymap=$(cat <<Edit_Lxkeymap
    <hbox>
      <button>
        <input file>$ICONS/keyboard.png</input>
        <action>lxkeymap &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Change Keyboard Layout for Session")</label>
      </text>
    </hbox>
Edit_Lxkeymap
)

fskbsetting_dir=/usr/share/doc/fskbsetting
test -d $fskbsetting_dir  && edit_fskbsetting=$(cat <<Edit_Fskbsetting
    <hbox>
      <button>
        <input file>$ICONS/usb-creator.png</input>
        <action>gksu fskbsetting &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set System Keymap")</label>
      </text>
    </hbox>
Edit_Fskbsetting
)

wallpaper_dir=/usr/share/doc/wallpaper-antix
test -d $wallpaper_dir  && edit_wallpaper=$(cat <<Edit_Wallpaper
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop-wallpaper.png</input>
        <action>wallpaper.py &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Choose Wallpaper")</label>
      </text>
    </hbox>
Edit_Wallpaper
)

conky_dir=/usr/share/doc/conky-all
test -d $conky_dir  && edit_conky=$(cat <<Edit_Conky
    <hbox>
      <button>
        <input file>$ICONS/utilities-system-monitor.png</input>
        <action>desktop-defaults-run -te $HOME/.conkyrc &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit System Monitor(conky)")</label>
      </text>
    </hbox>
Edit_Conky
)

lxappearance_dir=/usr/share/doc/lxappearance
test -d $lxappearance_dir  && edit_lxappearance=$(cat <<Edit_Lxappearance
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop-theme.png</input>
        <action>lxappearance &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Change Gtk2 and Icon Themes")</label>
      </text>
    </hbox>
Edit_Lxappearance
)

prefapps_dir=/usr/share/doc/desktop-session-antix
test -d $prefapps_dir  && edit_prefapps=$(cat <<Edit_Prefapps
    <hbox>
      <button>
        <input file>$ICONS/applications-system.png</input>
        <action>desktop-defaults-set &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Preferred Applications")</label>
      </text>
    </hbox>
Edit_Prefapps
)

metapackage_dir=/usr/share/doc/install-meta-antix
test -d $metapackage_dir  && edit_metapackage=$(cat <<Edit_Metapackage
    <hbox>
      <button>
        <input file>$ICONS/applications-system.png</input>
        <action>gksu install-meta &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Meta Package Installer")</label>
      </text>
    </hbox>
Edit_Metapackage
)

svconf_dir=/usr/share/doc/sysv-rc-conf
test -d $sysvconf_dir  && edit_sysvconf=$(cat <<Edit_Sysvconf
    <hbox>
      <button>
        <input file>$ICONS/gnome-settings-default-applications.png</input>
        <action>desktop-defaults-run -t sudo sysv-rc-conf &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Choose Startup Services")</label>
      </text>
    </hbox>
Edit_Sysvconf
)

tzdata_dir=/usr/share/doc/tzdata
test -d $tzdata_dir  && edit_tzdata=$(cat <<Edit_Tzdata
    <hbox>
      <button>
        <input file>$ICONS/time-admin.png</input>
        <action>desktop-defaults-run -t sudo dpkg-reconfigure tzdata &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set Date and Time")</label>
      </text>
    </hbox>
Edit_Tzdata
)

ceni_dir=/usr/share/doc/ceni
test -d $ceni_dir  && edit_ceni=$(cat <<Edit_Ceni
    <hbox>
      <button>
        <input file>$ICONS/network-wired.png</input>
        <action>desktop-defaults-run -t sudo ceni &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Network Interfaces (ceni)")</label>
      </text>
    </hbox>
Edit_Ceni
)

umts_dir=/usr/share/doc/umts-panel2
test -d $umts_dir  && edit_umts=$(cat <<Edit_Umts
    <hbox>
      <button>
        <input file>$ICONS/network-wired.png</input>
        <action>umts-panel &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure GPRS/UMTS")</label>
      </text>
    </hbox>
Edit_Umts
)

connectshares_dir=/usr/share/doc/connectshares-antix
test -d $connectshares_dir  && edit_connectshares=$(cat <<Edit_Connectshares
    <hbox>
      <button>
        <input file>$ICONS/connectshares-config.png</input>
        <action>connectshares-config &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure Connectshares")</label>
      </text>
    </hbox>
Edit_Connectshares
)

disconnectshares_dir=/usr/share/doc/connectshares-antix
test -d $disconnectshares_dir  && edit_disconnectshares=$(cat <<Edit_Disconnectshares
    <hbox>
      <button>
        <input file>$ICONS/connectshares.png</input>
        <action>disconnectshares &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $" Disconnectshares")</label>
      </text>
    </hbox>
Edit_Disconnectshares
)

droopy_dir=/usr/share/doc/droopy-antix
test -d $droopy_dir  && edit_droopy=$(cat <<Edit_Droopy
    <hbox>
      <button>
        <input file>$ICONS2/droopy.png</input>
        <action>droopy.sh &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Share Files via Droopy")</label>
      </text>
    </hbox>
Edit_Droopy
)

gnomeppp_dir=/usr/share/doc/gnome-ppp
test -d $gnomeppp_dir  && edit_gnomeppp=$(cat <<Edit_Gnomeppp
    <hbox>
      <button>
        <input file>$ICONS/internet-telephony.png</input>
        <action>gnome-ppp &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure Dial-Up")</label>
      </text>
    </hbox>
Edit_Gnomeppp
)

wpasupplicant_dir=/usr/share/doc/wpasupplicant
test -d $wpasupplicant_dir  && edit_wpasupplicant=$(cat <<Edit_Wpasupplicant
    <hbox>
      <button>
        <input file>$ICONS/nm-device-wireless.png</input>
        <action>/usr/sbin/wpa_gui &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure wpa_supplicant")</label>
      </text>
    </hbox>
Edit_Wpasupplicant
)

pppoeconf_dir=/usr/share/doc/pppoeconf
test -d $pppoeconf_dir  && edit_pppoeconf=$(cat <<Edit_Pppoeconf
    <hbox>
      <button>
        <input file>$ICONS/internet-telephony.png</input>
        <action>desktop-defaults-run -t /usr/sbin/pppoeconf &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"ADSL/PPPOE configuration")</label>
      </text>
    </hbox>
Edit_Pppoeconf
)

adblock_dir=/usr/share/doc/advert-block-antix
test -d $adblock_dir  && edit_adblock=$(cat <<Edit_Adblock
    <hbox>
      <button>
        <input file>$ICONS2/advert-block.png</input>
        <action>gksu block-advert.sh &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Adblock")</label>
      </text>
    </hbox>
Edit_Adblock
)

slim_dir=/usr/share/doc/slim
test -d $slim_dir  && edit_slim=$(cat <<Edit_Slim
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop-wallpaper.png</input>
        <action>gksu antixccslim.sh &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Change Slim Background")</label>
      </text>
    </hbox>
Edit_Slim
)

grub_dir=/usr/share/doc/grub-common
test -d $grub_dir  && edit_grub=$(cat <<Edit_Grub
    <hbox>
      <button>
        <input file>$ICONS/screensaver.png</input>
        <action>gksu antixccgrub.sh &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Grub Boot Image (jpg only)")</label>
      </text>
    </hbox>
Edit_Grub
)

confroot_dir=/usr/share/doc/geany
test -d $confroot_dir  && edit_confroot=$(cat <<Edit_Confroot
    <hbox>
      <button>
        <input file>$ICONS/gnome-documents.png</input>
        <action>gksu $EDITOR /etc/fstab /etc/default/keyboard /etc/grub.d/* /etc/slim.conf /etc/apt/sources.list.d/*.list &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit Config Files")</label>
      </text>
    </hbox>
Edit_Confroot
)

arandr_dir=/usr/share/doc/arandr
test -d $arandr_dir  && edit_arandr=$(cat <<Edit_Arandr
    <hbox>
      <button>
        <input file>$ICONS/video-display.png</input>
        <action>gksu arandr &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set Screen Resolution")</label>
      </text>
    </hbox>
Edit_Arandr
)

gksu_dir=/usr/share/doc/gksu
test -d $gksu_dir  && edit_gksu=$(cat <<Edit_Gksu
    <hbox>
      <button>
        <input file>$ICONS2/gksu.png</input>
        <action>gksu-properties &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Password Prompt(su/sudo)")</label>
      </text>
    </hbox>
Edit_Gksu
)

slimlogin_dir=/usr/share/doc/slim
test -d $slimlogin_dir  && edit_slimlogin=$(cat <<Edit_Slimlogin
    <hbox>
      <button>
        <input file>$ICONS/preferences-system-login.png</input>
        <action>gksu slim-login &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set auto-login")</label>
      </text>
    </hbox>
Edit_Slimlogin
)

screenblank_dir=/usr/share/doc/set-screen-blank-antix
test -d $screenblank_dir  && edit_screenblank=$(cat <<Edit_Screenblank
    <hbox>
      <button>
        <input file>$ICONS/screensaver.png</input>
        <action>set-screen-blank &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set Screen Blanking")</label>
      </text>
    </hbox>
Edit_Screenblank
)

desktopsession_dir=/usr/share/doc/desktop-session-antix
test -d $desktopsession_dir  && edit_desktopsession=$(cat <<Edit_Desktopsession
    <hbox>
      <button>
        <input file>$ICONS/preferences-system-session.png</input>
        <action>$EDITOR $HOME/.desktop-session/*.conf $HOME/.desktop-session/startup &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"User Desktop-Session")</label>
      </text>
    </hbox>
Edit_Desktopsession
)

automount_dir=/usr/share/doc/automount-antix
test -d $automount_dir  && edit_automount=$(cat <<Edit_Automount
    <hbox>
      <button>
        <input file>$ICONS/mountbox.png</input>
        <action>automount-config &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure Automounting")</label>
      </text>
    </hbox>
Edit_Automount
)

mountbox_dir=/usr/share/doc/mountbox-antix
test -d $mountbox_dir  && edit_mountbox=$(cat <<Edit_Mountbox
    <hbox>
      <button>
        <input file>$ICONS/mountbox.png</input>
        <action>mountbox &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Mount Connected Devices")</label>
      </text>
    </hbox>
Edit_Mountbox
)

liveusb_dir=/usr/share/doc/live-usb-gui-antix
test -d $liveusb_dir  && edit_liveusb=$(cat <<Edit_Liveusb
    <hbox>
      <button>
        <input file>$ICONS/usb-creator.png</input>
        <action>gksu live-usb-maker-gui &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Install to USB")</label>
      </text>
    </hbox>
Edit_Liveusb
)

partimage_dir=/usr/share/doc/partimage
test -d $partimage_dir  && edit_partimage=$(cat <<Edit_Partimage
    <hbox>
      <button>
        <input file>$ICONS/drive-harddisk-system.png</input>
        <action>desktop-defaults-run -t sudo partimage &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Image a Partition")</label>
      </text>
    </hbox>
Edit_Partimage
)

grsync_dir=/usr/share/doc/grsync
test -d $grsync_dir  && edit_grsync=$(cat <<Edit_Grsync
    <hbox>
      <button>
        <input file>$ICONS/grsync.png</input>
        <action>grsync &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Synchronize Directories")</label>
      </text>
    </hbox>
Edit_Grsync
)

gparted_dir=/usr/share/doc/gparted
test -d $gparted_dir  && edit_gparted=$(cat <<Edit_Gparted
    <hbox>
      <button>
        <input file>$ICONS/gparted.png</input>
        <action>gksu gparted &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Partition a Drive")</label>
      </text>
    </hbox>
Edit_Gparted
)

setdpi_dir=/usr/share/doc/set-dpi-antix
test -d $setdpi_dir  && edit_setdpi=$(cat <<Edit_Setdpi
    <hbox>
      <button>
        <input file>$ICONS/fonts.png</input>
        <action>set-dpi &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$dpi_label</label>
      </text>
    </hbox>
Edit_Setdpi
)

inxi_dir=/usr/share/doc/inxi-gui-antix
test -d $inxi_dir  && edit_inxi=$(cat <<Edit_Inxi
    <hbox>
      <button>
        <input file>$ICONS2/info_blue.png</input>
        <action>inxi-gui &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"PC Information")</label>
      </text>
    </hbox>
Edit_Inxi
)

mouse_dir=/usr/share/doc/ds-mouse-antix
test -d $mouse_dir  && edit_mouse=$(cat <<Edit_Mouse
    <hbox>
      <button>
        <input file>$ICONS/input-mouse.png</input>
        <action>ds-mouse &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure Mouse")</label>
      </text>
    </hbox>
Edit_Mouse
)

soundcard_dir=/usr/share/doc/antixgoodies
test -d $soundcard_dir  && edit_soundcard=$(cat <<Edit_Soundcard
    <hbox>
      <button>
        <input file>$ICONS2/soundcard.png</input>
        <action>alsa-set-default-card &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set Default Sound Card")</label>
      </text>
    </hbox>
Edit_Soundcard
)

mixer_dir=/usr/share/doc/alsamixer-equalizer-antix
test -d $mixer_dir  && edit_mixer=$(cat <<Edit_Mixer
    <hbox>
      <button>
        <input file>$ICONS/audio-volume-high-panel.png</input>
        <action>desktop-defaults-run -t alsamixer &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Adjust Mixer")</label>
      </text>
    </hbox>
Edit_Mixer
)

atidriver_dir=/usr/share/doc/ddm-mx
test -d $atidriver_dir  && edit_atidriver=$(cat <<Edit_Atidriver
    <hbox>
      <button>
        <input file>$ICONS2/amd-ddm-mx.png</input>
        <action>desktop-defaults-run -t su-to-root -c "/usr/local/bin/ddm-mx -i ati" &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"AMD/ATI fglrx Driver Installer")</label>
      </text>
    </hbox>
Edit_Atidriver
)

nvdriver_dir=/usr/share/doc/ddm-mx
test -d $nvdriver_dir  && edit_nvdriver=$(cat <<Edit_Nvdriver
    <hbox>
      <button>
        <input file>$ICONS2/nvidia-ddm-mx.png</input>
        <action>desktop-defaults-run -t su-to-root -c "/usr/local/bin/ddm-mx -i nvidia" &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Nvidia Driver Installer")</label>
      </text>
    </hbox>
Edit_Nvdriver
)

ndiswrapper_dir=/usr/share/doc/ndisgtk
test -d $ndiswrapper_dir  && edit_ndiswrapper=$(cat <<Edit_Ndiswrapper
    <hbox>
      <button>
        <input file>$ICONS/computer.png</input>
        <action>gksu /usr/sbin/ndisgtk &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"MS Windows Wireless Drivers")</label>
      </text>
    </hbox>
Edit_Ndiswrapper
)

snapshot_dir=/usr/share/doc/iso-snapshot-antix
test -d $snapshot_dir  && edit_snapshot=$(cat <<Edit_Snapshot
    <hbox>
      <button>
        <input file>$ICONS/preferences-system.png</input>
        <action>gksu isosnapshot &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Create Snapshot(ISO)")</label>
      </text>
    </hbox>
Edit_Snapshot
)

soundtest_dir=/usr/share/doc/alsa-tools
test -d $soundtest_dir  && edit_soundtest=$(cat <<Edit_Soundtest
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop-sound.png</input>
        <action>urxvt -e speaker-test --channels 2 --test wav --nloops 3 &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Test Sound")</label>
      </text>
    </hbox>
Edit_Soundtest
)

menumanager_dir=/usr/share/doc/menu-manager-antix
test -d $menumanager_dir  && edit_menumanager=$(cat <<Edit_Menumanager
    <hbox>
      <button>
        <input file>$ICONS2/menu_manager.png</input>
        <action>sudo menu_manager.sh &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Edit menus")</label>
      </text>
    </hbox>
Edit_Menumanager
)

usermanager_dir=/usr/share/doc/user-management-antix
test -d $usermanager_dir  && edit_usermanager=$(cat <<Edit_Usermanager
    <hbox>
      <button>
        <input file>$ICONS/config-users.png</input>
        <action>gksu user-management &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"User Manager")</label>
      </text>
    </hbox>
Edit_Usermanager
)

galternatives_dir=/usr/share/doc/galternatives
test -d $galternatives_dir  && edit_galternatives=$(cat <<Edit_Galternatives
    <hbox>
      <button>
        <input file>$ICONS2/galternatives.png</input>
        <action>galternatives &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Alternatives Configurator")</label>
      </text>
    </hbox>
Edit_Galternatives
)

codecs_dir=/usr/share/doc/codecs-antix
test -d $codecs_dir  && edit_codecs=$(cat <<Edit_Codecs
    <hbox>
      <button>
        <input file>$ICONS/applications-system.png</input>
        <action>su-to-root -X -c codecs &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Install Restricted Codecs")</label>
      </text>
    </hbox>
Edit_Codecs
)

flash_dir=/usr/share/doc/flash-antix
test -d $flash_dir  && edit_flash=$(cat <<Edit_Flash
    <hbox>
      <button>
        <input file>$ICONS/flash.png</input>
        <action>su-to-root -X -c flash &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Install Flash/PepperFlash")</label>
      </text>
    </hbox>
Edit_Flash
)

broadcom_dir=/usr/share/doc/broadcom-manager-antix
test -d $broadcom_dir  && edit_broadcom=$(cat <<Edit_Broadcom
    <hbox>
      <button>
        <input file>$ICONS/palimpsest.png</input>
        <action>su-to-root -X -c broadcom-manager &</action> 
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Network Troubleshooting")</label>
      </text>
    </hbox>
Edit_Broadcom
)

[ -e /etc/live/config/save-persist -o -e /etc/live/config/persist-save.conf ]  && persist_save=$(cat <<Persist_Save
    <hbox>
      <button>
        <input file>$ICONS/palimpsest.png</input>
        <action>gksu persist-save &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Save root persistence")</label>
      </text>
    </hbox>
Persist_Save
)

[ -e /etc/live/config/remasterable -o -e /etc/live/config/remaster-live.conf ] && live_remaster=$(cat <<Live_Remaster
    <hbox>
      <button>
        <input file>$ICONS/preferences-desktop.png</input>
        <action>gksu live-remaster &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Remaster-Customize Live")</label>
      </text>
    </hbox>
Live_Remaster
)

live_tab=$(cat <<Live_Tab
<vbox> <frame> <hbox>
  <vbox>
    <hbox>
      <button>
        <input file>$ICONS/remastersys.png</input>
        <action>gksu persist-config &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Configure live persistence")</label>
      </text>
    </hbox>
$edit_livekernel
$edit_bootloader
$persist_save
  </vbox>
  <vbox>
    <hbox>
      <button>
        <input file>$ICONS/palimpsest.png</input>
        <action>gksu persist-makefs &</action>
      </button>
      <text use-markup="true" width-chars="32">
        <label>$(echo $"Set up live persistence")</label>
      </text>
    </hbox>
$edit_excludes
$live_remaster
  </vbox>
</hbox> </frame> </vbox>
Live_Tab
)

# If we are on a live system then ...
if grep -q " /live/aufs " /proc/mounts; then
    tab_labels="$Desktop|$System|$Network|$Shares|$Session|$Live|$Disks|$Hardware|$Drivers|$Maintenance"

else
    tab_labels="$Desktop|$System|$Network|$Shares|$Session|$Disks|$Hardware|$Drivers|$Maintenance"
    live_tab=
fi

export ControlCenter=$(cat <<End_of_Text
<window title="antiX Control Center" icon="gnome-control-center" window-position="1">
  <vbox>
<notebook tab-pos="0" labels="$tab_labels">
<vbox> <frame> <hbox>
  <vbox>
$edit_wallpaper
$edit_icewm
$edit_jwm
$edit_conky 
  </vbox>
  <vbox>
$edit_lxappearance
$edit_fluxbox
$edit_prefapps  
  </vbox>
</hbox> </frame> </vbox>
<vbox> <frame> <hbox>
  <vbox>
$edit_synaptic
$edit_metapackage   
$edit_sysvconf
$edit_galternatives
  </vbox>
  <vbox>
$edit_confroot
$edit_fskbsetting
$edit_tzdata  
  </vbox>
</hbox> </frame> </vbox>
<vbox> <frame> <hbox>
  <vbox>  
$edit_ceni
$edit_umts
$edit_wicd
$edit_pppoeconf
  </vbox>
  <vbox>
$edit_gnomeppp
$edit_wpasupplicant
$edit_firewall
$edit_adblock
  </vbox>
</hbox> </frame></vbox>
<vbox> <frame> <hbox>
  <vbox>  
$edit_connectshares 
$edit_droopy 
  </vbox>
  <vbox>
$edit_disconnectshares 
$edit_samba
  </vbox>
</hbox> </frame></vbox>
<vbox> <frame> <hbox>
  <vbox>
$edit_lxkeymap 
$edit_slim  
$edit_arandr
$edit_grub
  </vbox>
  <vbox>
$edit_gksu
$edit_slimlogin   
$edit_screenblank    
$edit_desktopsession
  </vbox>
</hbox> </frame> </vbox>
$live_tab
<vbox> <frame> <hbox>
  <vbox>
$edit_automount
$edit_mountbox   
$edit_unetbootin
  </vbox>
  <vbox>
$edit_liveusb
$edit_partimage
$edit_grsync
$edit_gparted
  </vbox>
</hbox> </frame> </vbox>
<vbox> <frame> <hbox>
  <vbox>
$edit_setdpi  
$edit_printer 
$edit_inxi 
$edit_mouse
  </vbox>
  <vbox>
$edit_soundcard
$edit_soundtest
$edit_mixer
$edit_equalizer
  </vbox>
</hbox> </frame> </vbox>
<vbox> <frame> <hbox>
  <vbox>
$edit_nvdriver
$edit_codecs
  </vbox>
  <vbox>
$edit_ndiswrapper
$edit_flash
  </vbox>
</hbox> </frame> </vbox>
<vbox> <frame> <hbox>
  <vbox>
$edit_snapshot
$edit_backup
$edit_broadcom
  </vbox>
  <vbox>
$edit_bootrepair
$edit_menumanager
$edit_usermanager
  </vbox>
</hbox> </frame> </vbox>
</notebook>
</vbox>
</window>
End_of_Text
)

#echo "$ControlCenter"

gtkdialog --program=ControlCenter
#unset ControlCenter
