FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY . .

# Render가 PORT 환경변수를 자동으로 주입하고, server.js가 이를 그대로 사용합니다.
EXPOSE 3000

CMD ["npm", "start"]
