# CK's Firejail profile for brave

# Persistent local customizations
include brave.local
# Persistent global definitions
include globals.local

# noexec /tmp is included in chromium-common.profile and breaks Brave
#ck#
# ignore noexec /tmp
# TOR is installed in ${HOME}.
# NOTE: chromium-common.profile enables apparmor. To keep that intact
# you will need to uncomment the 'brave + tor' rule in /etc/apparmor.d/local/firejail-default.
# Alternatively you can add 'ignore apparmor' to your brave.local.
#ck#
# ignore noexec ${HOME}
# Causes slow starts (#4604)
#ck#
private-cache

noblacklist ${HOME}/.cache/BraveSoftware
noblacklist ${HOME}/.config/BraveSoftware
noblacklist ${HOME}/.config/brave
noblacklist ${HOME}/.config/brave-flags.conf
# brave uses gpg for built-in password manager
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.cache/BraveSoftware
mkdir ${HOME}/.config/BraveSoftware
#ck#
# mkdir ${HOME}/.config/brave
whitelist ${HOME}/.cache/BraveSoftware
whitelist ${HOME}/.config/BraveSoftware
whitelist ${HOME}/.config/brave
whitelist ${HOME}/.config/brave-flags.conf
whitelist ${HOME}/.gnupg

# Brave sandbox needs read access to /proc/config.gz
noblacklist /proc/config.gz

# Redirect
include chromium-common.profile
