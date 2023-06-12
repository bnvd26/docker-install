#!/bin/bash

cat ascii.txt

# Vérifier si Docker est déjà installé
#if command -v docker &>/dev/null; then
#    echo "Docker est déjà installé sur votre système."
#    exit 0
#fi

# Vérifier si l'utilisateur a les privilèges sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté avec les privilèges sudo ou en tant qu'utilisateur root."
    exit 1
fi

# Mise à jour des paquets existants
apt update

# Installation des dépendances pour Docker
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajout du référentiel Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des paquets pour inclure Docker
apt update

# Installation de Docker
apt install -y docker-ce docker-ce-cli containerd.io

# Vérification de l'installation de Docker
if command -v docker &>/dev/null; then
    echo "Docker a été installé avec succès."
else
    echo "Une erreur s'est produite lors de l'installation de Docker."
fi

# Demander le nom d'utilisateur pour Docker
read -p "Entrez le nom d'utilisateur pour Docker: " username

# Vérifier si l'utilisateur existe déjà
if id "$username" &>/dev/null; then
    echo "L'utilisateur $username existe déjà."
else
    # Créer un utilisateur sans privilèges sudo
    useradd -m -s /bin/bash "$username"
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/docker-user

    # Ajouter l'utilisateur au groupe docker
    usermod -aG docker "$username"
    echo "L'utilisateur $username a été créé avec succès et ajouté au groupe docker."
fi