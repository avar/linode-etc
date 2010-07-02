# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

# Evaluate v-specific profile scripts
if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/v-*.sh; do
        if [ -r $i ]; then
            . $i
        fi
    done
    unset i
fi
