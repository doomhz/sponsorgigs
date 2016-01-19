#!/bin/bash
date
git pull
NODE_ENV=production npm install
NODE_ENV=production gulp digest_assets
NODE_ENV=production gulp coffee
NODE_ENV=production gulp styles
NODE_ENV=production gulp scripts
NODE_ENV=production gulp digest_assets
pm2 restart all -m
date
