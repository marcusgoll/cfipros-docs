#!/bin/bash

echo "🚀 Setting up CFIPros Documentation Site"
echo "========================================"

# Create placeholder content structure
echo "📁 Creating content structure..."
mkdir -p docs/getting-started
mkdir -p docs/user-guide  
mkdir -p docs/checkride
mkdir -p docs/aktr
mkdir -p docs/api

# Create homepage
cat > docs/intro.md << 'INTRO'
---
slug: /
title: Welcome to CFIPros Documentation
---

# Welcome to CFIPros Documentation

Comprehensive documentation for the CFIPros flight training management platform.

## Quick Links

- [Getting Started](/getting-started/overview) - Setup and onboarding
- [User Guide](/user-guide) - Complete feature documentation
- [Checkride Packets](/checkride) - Preparing for checkrides
- [AKTR Workflow](/aktr) - Knowledge test analysis
- [API Reference](/api) - Developer documentation

## What is CFIPros?

CFIPros is a flight training management platform designed for:
- **CFIs** - Manage students, training plans, and endorsements
- **Students** - Track progress and prepare for checkrides
- **Admins** - Oversee flight school operations and compliance

## Support

Need help? Contact us at support@cfipros.com
INTRO

# Create getting started overview
cat > docs/getting-started/overview.md << 'GSTART'
---
sidebar_position: 1
---

# Getting Started

Welcome to CFIPros! This guide will help you get up and running quickly.

## For CFIs

Learn how to:
- Set up your instructor profile
- Add students to your roster
- Create training plans
- Log flight time

## For Students

Learn how to:
- Access your training materials
- Track your progress
- Prepare for checkrides

## For Admins

Learn how to:
- Manage your flight school
- Configure billing
- Monitor compliance

*Detailed content coming in Sprint 2*
GSTART

# Create user guide placeholder
cat > docs/user-guide/index.md << 'UGUIDE'
---
sidebar_position: 2
---

# User Guide

Complete documentation for all CFIPros features.

*Detailed content coming in Sprint 2*
UGUIDE

# Create checkride placeholder
cat > docs/checkride/index.md << 'CHKRIDE'
---
sidebar_position: 3
---

# Checkride Packets

Learn how to prepare and submit checkride packets.

*Detailed content coming in Sprint 2*
CHKRIDE

# Create AKTR placeholder
cat > docs/aktr/index.md << 'AKTR'
---
sidebar_position: 4
---

# AKTR Workflow

Understanding the Airman Knowledge Test Results workflow.

*Detailed content coming in Sprint 2*
AKTR

# Create API placeholder
cat > docs/api/index.md << 'API'
---
sidebar_position: 5
---

# API Reference

Developer documentation for the CFIPros API.

*Detailed content coming in Sprint 3*
API

echo "✅ Content structure created"

# Create Dockerfile
cat > Dockerfile << 'DOCKERFILE'
# Stage 1: Build
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
DOCKERFILE

echo "✅ Dockerfile created"

# Create nginx config
cat > nginx.conf << 'NGINX'
server {
    listen 80;
    server_name docs.cfipros.com;
    root /usr/share/nginx/html;
    index index.html;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml+rss text/javascript;

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
NGINX

echo "✅ nginx.conf created"

# Create .dockerignore
cat > .dockerignore << 'DOCKERIGNORE'
node_modules
.git
.github
.env
npm-debug.log
.DS_Store
build
.docusaurus
DOCKERIGNORE

echo "✅ .dockerignore created"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update docusaurus.config.ts (replace template values)"
echo "2. Run: npm run build (test build)"
echo "3. Run: docker build -t cfipros-docs ."
echo "4. Deploy to Dokploy"
