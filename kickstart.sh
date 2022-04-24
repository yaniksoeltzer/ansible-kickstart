set -e

dpkg -l ansible &>/dev/null || sudo apt-get install ansible
dpkg -s sshpass &>/dev/null || sudo apt-get install sshpass


ANSIBLE_CREDENTIALS_FILE='./ansible-credentials.yml'


echo -n "remote machine name: "
read REMOTE_MACHINE

echo -n "Username: "
read REMOTE_USER


if ! [ -f ./ansible-credentials.yml ]
then
	echo -e "\033[0;35mNo ansible credantials ($ANSIBLE_CREDENTIALS_FILE) found.\033[0m"
	echo -e "Creating one now."
	echo -n "- ansible user name: "
	read ANSIBLE_USER_NAME
	echo -n "- ansible user "
	ANSIBLE_PASSWORD_HASH=$(mkpasswd)
	cat <<EOF > $ANSIBLE_CREDENTIALS_FILE
ansible_user_name: $ANSIBLE_USER_NAME
ansible_password_hash: $ANSIBLE_PASSWORD_HASH
EOF
fi

ansible-playbook --ask-become-pass --inventory $REMOTE_MACHINE, --user $REMOTE_USER --become-method=su --extra-vars=@./$ANSIBLE_CREDENTIALS_FILE site.yml

