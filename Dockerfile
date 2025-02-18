# Utilisation de l'image Frappe officielle
FROM frappe/bench:latest

# Définition du dossier de travail
WORKDIR /home/frappe

# Installation de ERPNext et ses dépendances
RUN bench init --frappe-branch version-14 frappe-bench && \
    cd frappe-bench && \
    bench get-app erpnext --branch version-14 && \
    bench new-site erp.monsite.com --admin-password=admin --mariadb-root-password=root && \
    bench --site erp.monsite.com install-app erpnext

# Exposer le port 8000 pour accéder à ERPNext
EXPOSE 8000

# Commande de démarrage
CMD ["bench", "start"]
