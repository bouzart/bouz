# Utiliser l’image officielle de Frappe Bench
FROM frappe/bench:latest

# Définir le répertoire de travail
WORKDIR /home/frappe

# Installer les dépendances requises
RUN apt-get clean && apt-get update --allow-releaseinfo-change && \
    apt-get install -y --no-install-recommends \
    python3-pip python3-dev libmysqlclient-dev \
    mariadb-client redis curl && \
    rm -rf /var/lib/apt/lists/*

# Initialiser le bench
RUN bench init --frappe-branch version-14 frappe-bench

# Passer dans le dossier bench
WORKDIR /home/frappe/frappe-bench

# Installer ERPNext
RUN bench get-app erpnext --branch version-14

# Définir les variables de connexion à la base de données
ENV DB_PORT=3306
ENV DB_USER=root
ENV DB_PASSWORD=123
ENV DB_NAME=DBbouz

# Créer un site ERPNext et installer l’application
RUN bench new-site bouz-f9af.onrender.com --admin-password=admin --mariadb-root-password=root && \
    bench --site bouz-f9af.onrender.com install-app erpnext

# Exposer le port 8000
EXPOSE 8000

# Commande de démarrage
CMD ["bench", "start"]
