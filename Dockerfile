# Utilisation de l'image officielle de Frappe
FROM frappe/bench:latest

# Définir le dossier de travail
WORKDIR /home/frappe

# Création de l'utilisateur frappe
RUN useradd -m -s /bin/bash frappe

# Changer le propriétaire du dossier de travail
RUN chown -R frappe:frappe /home/frappe

# Initialiser le bench
RUN su frappe -c "bench init --frappe-branch version-14 frappe-bench"

# Installer l'application ERPNext
RUN cd /home/frappe/frappe-bench && su frappe -c "bench get-app erpnext --branch version-14"

# Configuration de la base de données (à adapter si Render ne propose pas MariaDB)
ENV DB_PORT=3306
ENV DB_USER=root
ENV DB_PASSWORD=123
ENV DB_NAME=erpnext_db

# Création du site ERPNext
RUN cd /home/frappe/frappe-bench && \
    su frappe -c "bench new-site bouz-f9af.onrender.com --admin-password=admin --mariadb-root-password=root" && \
    su frappe -c "bench --site bouz-f9af.onrender.com install-app erpnext"

# Exposer le port par défaut de ERPNext
EXPOSE 8000

# Commande de démarrage
CMD cd /home/frappe/frappe-bench && su frappe -c "bench start"
