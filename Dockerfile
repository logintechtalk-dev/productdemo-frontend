# ---- Build stage ----
FROM cirrusci/flutter:3.22.0 AS build

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web

# ---- Serve stage ----
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]