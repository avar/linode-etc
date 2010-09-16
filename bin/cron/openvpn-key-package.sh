#!/bin/sh

# Exit on errors
trap 'fail' ERR
fail () {
    code=$?
    echo "Failed with exit code $code"
    exit 1
}

OPENVPN=/etc/openvpn
SERVER_KEYS=/etc/openvpn/keys
USER_KEYS=$OPENVPN/easy-rsa-2.0/keys
INDEX=$USER_KEYS/index.txt
TO_TMP=$(mktemp -d /tmp/openvpn-keys-XXXX)
TO=/etc/openvpn/user-keys

chown root:root $TO_TMP
chmod 700 $TO_TMP

for user in $(ack 'CN=([^/]+)' --output='$1' $INDEX | grep -v ^server$)
do
    to_user=v-openvpn-keys-$user
    to_user_dir=$TO_TMP/$to_user
    mkdir $to_user_dir

    ## Copy the keys we need
    # server keys
    cp -v $SERVER_KEYS/ca.crt $to_user_dir/
    cp -v $SERVER_KEYS/ta.key $to_user_dir/
    # user keys
    cp -v $USER_KEYS/$user.crt $to_user_dir/
    cp -v $USER_KEYS/$user.key $to_user_dir/

    # Make the destination
    if ! test -d $TO
    then
        mkdir $TO
    fi

    # Tar them up for the user
    (
        cd $TO_TMP
        chown -R $user $to_user
        tar czvf $user-keys.tar.gz $to_user
        chown $user $user-keys.tar.gz
        chmod 400 $user-keys.tar.gz
        mv -v $user-keys.tar.gz $TO/
    )
done

rm -rfv $TO_TMP
