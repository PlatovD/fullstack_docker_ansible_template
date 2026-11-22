FROM gradle:8.10-jdk21 AS builder
WORKDIR /workspace

COPY app/settings.gradle.kts app/build.gradle.kts app/gradlew ./
COPY app/gradle ./gradle
RUN chmod +x ./gradlew

COPY app/src ./src
RUN ./gradlew --no-daemon clean jar -x test

FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app

RUN addgroup -g 1000 -S appgroup \
    && adduser -u 1000 -S appuser -G appgroup

COPY --from=builder --chown=appuser:appgroup /workspace/build/libs/*.jar /app/app.jar
COPY --chown=appuser:appgroup app/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER appuser

ENTRYPOINT ["/app/entrypoint.sh"]