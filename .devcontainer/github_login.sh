if ! gh auth status >/dev/null 2>&1; then 
  git config --global credential.helper '!gh auth git-credential'
  gh auth login
  read -p "Enter your name: " name
  read -p "Enter your email: " email
  git config --global user.name "$name"
  git config --global user.email "$email"
else
  echo 'Already logged in'
fi