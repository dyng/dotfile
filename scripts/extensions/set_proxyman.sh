#!/usr/bin/env bash

# List of all environment variables that proxyman sets
PROXYMAN_ENV_VARS=(
    "CARGO_HTTP_CAINFO"
    "CGI_HTTP_PROXY"
    "CURL_CA_BUNDLE"
    "GIT_SSL_CAINFO"
    "GLOBAL_AGENT_HTTP_PROXY"
    "GLOBAL_AGENT_NO_PROXY"
    "GODEBUG"
    "GOFLAGS"
    "GOPROXY"
    "HTTPS_PROXY"
    "HTTP_PROXY"
    "NODE_EXTRA_CA_CERTS"
    "NODE_OPTIONS"
    "NODE_TLS_REJECT_UNAUTHORIZED"
    "NO_PROXY"
    "PATH"
    "PERL_LWP_SSL_CA_FILE"
    "PROXYMAN_INJECTION_ACTIVE"
    "PROXYMAN_INJECTION_OVERRIDE_PATH"
    "PYTHONPATH"
    "REQUESTS_CA_BUNDLE"
    "RUBYLIB"
    "SPACESHIP_PROXY"
    "SPACESHIP_PROXY_SSL_VERIFY_NONE"
    "SSL_CERT_DIR"
    "SSL_CERT_FILE"
    "SSL_VERIFY_NONE"
    "http_proxy"
    "https_proxy"
    "no_proxy"
    "npm_config_https_proxy"
    "npm_config_no_proxy"
    "npm_config_proxy"
    "npm_config_scripts_prepend_node_path"
)

# Enable proxyman by sourcing the setup script
# Backup current environment variables before enabling
enable_proxyman() {
    echo "Backing up current environment variables..."

    # Backup all relevant environment variables to shell variables
    for var in "${PROXYMAN_ENV_VARS[@]}"; do
        backup_var="_PROXYMAN_BACKUP_${var}"
        # Check if variable is set (compatible with bash and zsh)
        if eval "[ -n \"\${${var}+x}\" ]"; then
            # Variable is set, backup its value
            eval "export ${backup_var}=\"\${${var}}\""
        else
            # Variable is not set, mark as unset
            export "$backup_var"="__UNSET__"
        fi
    done

    echo "Enabling Proxyman environment..."
    set -a 2>/dev/null || true
    source "/Users/dingye/Library/Application Support/com.proxyman.NSProxy/app-data/proxyman_env_automatic_setup.sh"
    set +a 2>/dev/null || true

    echo "✅ Proxyman environment enabled"
}

# Disable proxyman by restoring backed up environment variables
disable_proxyman() {
    # Check if any backup exists
    has_backup=false
    for var in "${PROXYMAN_ENV_VARS[@]}"; do
        backup_var="_PROXYMAN_BACKUP_${var}"
        # Check if backup variable is set (compatible with bash and zsh)
        if eval "[ -n \"\${${backup_var}+x}\" ]"; then
            has_backup=true
            break
        fi
    done

    if [ "$has_backup" = false ]; then
        echo "⚠️  No backup found. Please run enable_proxyman first."
        return 1
    fi

    echo "Restoring environment variables..."

    # Restore all backed up environment variables
    for var in "${PROXYMAN_ENV_VARS[@]}"; do
        backup_var="_PROXYMAN_BACKUP_${var}"
        # Check if backup variable is set (compatible with bash and zsh)
        if eval "[ -n \"\${${backup_var}+x}\" ]"; then
            # Get the backup value
            backup_value=$(eval "echo \"\${${backup_var}}\"")
            if [ "$backup_value" = "__UNSET__" ]; then
                # Variable was not set before, unset it
                unset "$var"
            else
                # Restore the original value
                eval "export ${var}=\"${backup_value}\""
            fi
            # Clean up backup variable
            unset "$backup_var"
        fi
    done

    echo "✅ Proxyman environment disabled and original environment restored"
}
