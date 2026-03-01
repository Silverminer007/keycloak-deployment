FROM quay.io/keycloak/keycloak:26.5.4 as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange,admin-fine-grained-authz,http-optimized-serializers
ENV KC_DB=postgres

# Install custom providers

# Apple Social Identity Provider - https://github.com/klausbetz/apple-identity-provider-keycloak
ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.17.0/apple-identity-provider-1.17.0.jar /opt/keycloak/providers/apple-identity-provider-1.17.0.jar

# build optimized image
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.5.4

COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]