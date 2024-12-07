# CK's Firejail profile for chromium-common

# Persistent local customizations
include chromium-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

#ck#
noexec ${HOME} 
#?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki
noblacklist /usr/lib/chromium/chrome-sandbox

# Add the next line to your chromium-common.local if you want Google Chrome/Chromium browser
# to have access to Gnome extensions (extensions.gnome.org) via browser connector
#include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
whitelist /usr/share/mozilla/extensions
whitelist /usr/share/webext
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Add the next line to your chromium-common.local if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.inc.profile

apparmor
#ck#
# caps.keep sys_admin,sys_chroot
caps.drop all
nonewprivs
protocol unix,inet,inet6,netlink
seccomp !chroot
netfilter
nodvd
nogroups
noinput
notv
#ck#
#?BROWSER_DISABLE_U2F: nou2f

disable-mnt
private-cache
#ck#
#?BROWSER_DISABLE_U2F: private-dev
#private-tmp - issues when using multiple browser sessions

blacklist ${PATH}/curl
blacklist ${PATH}/wget
blacklist ${PATH}/wget2

#dbus-user none - prevents access to passwords saved in GNOME Keyring and KWallet, also breaks Gnome connector.
dbus-system none

# The file dialog needs to work without d-bus.
?HAS_NODBUS: env NO_CHROME_KDE_FILE_DIALOG=1
