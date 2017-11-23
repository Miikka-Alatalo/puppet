echo "git config --global user.email, gimme email"
read email
echo "git config --global user.name, gimme name"
read name
git config --global user.email $email
git config --global user.name $name
