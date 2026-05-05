# PHP Docker Base Image

The official PHP image doesn't include any extensions, database drivers, tools (composer), etc.

This image includes all that so yours doesn't have to!

Extensions:
- gd
- mcrypt
- opcache
- pdo
- zip

Database drivers:
- MySQL
- MS SQL Server

Tools:
- composer
- postfix

## Build and push both amd64 + arm64 under the same tag

docker buildx build \
--platform linux/amd64,linux/arm64 \
-t americanboardofurology/php:8.5 \
--no-cache \
--push .
