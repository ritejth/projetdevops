# Étape 1 : Image de base pour Node.js
FROM node:18-alpine AS development

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier les fichiers de configuration
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier les fichiers source
COPY . .

# Construire l'application
RUN npm run build

# Étape 2 : Image optimisée pour production
FROM node:18-alpine AS production

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production

COPY --from=development /usr/src/app/dist ./dist

# Définir le port exposé
EXPOSE 3000

# Commande pour démarrer l'API
CMD ["node", "dist/main"]
