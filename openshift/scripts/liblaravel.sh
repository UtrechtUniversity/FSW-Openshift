#!/bin/bash
laravel_validate() {
    info "Validating settings in LARAVEL_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate user inputs
    check_yes_no_value "LARAVEL_SKIP_COMPOSER_UPDATE"
    check_yes_no_value "LARAVEL_SKIP_DATABASE"

    # Database configuration validations
    check_resolved_hostname "$LARAVEL_DATABASE_HOST"
    check_valid_port "LARAVEL_DATABASE_PORT_NUMBER"

    return "$error_code"
}
