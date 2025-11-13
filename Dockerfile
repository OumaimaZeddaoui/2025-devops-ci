# ============================
#   1) BUILD STAGE
# ============================
FROM node:20-bullseye AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN npm install -g pnpm

RUN pnpm install

COPY . .

RUN pnpm build


# ============================
#   2) RUNTIME STAGE
# ============================
FROM node:20-bullseye AS runner

# Install pnpm in runtime stage (VERY IMPORTANT)
RUN npm install -g pnpm

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy build files from builder stage
COPY --from=builder /app ./

# Give permissions
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 3000

CMD ["pnpm", "start"]
