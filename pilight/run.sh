#!/usr/bin/with-contenv bashio

bashio::log Here we would like to adapt the pilight config with values from the configuration of the addon

GPIO_PLATFORM="$(bashio::config 'gpio_platform')"

if bashio::config.has_value "gpio_platform"; then GPIO_PLATFORM=$(bashio::config 'gpio_platform');
else
bashio::log.error "No Platform specified - using none instead"
GPIO_PLATFORM="none"
fi

if bashio::config.has_value "hardware.sender"; then SENDER=$(bashio::config 'hardware.sender'); else SENDER=-1; fi
if bashio::config.has_value "hardware.receiver"; then RECEIVER=$(bashio::config 'hardware.receiver'); else RECEIVER=-1; fi


bashio::log.info "GPIO Platform used: $GPIO_PLATFORM"
if $SENDER!=-1; then bashio::log.info "SENDER Pin is: $SENDER"; else bashio::log.warning "SENDER Pin is disabled"; fi
if $RECEIVER!=-1; then bashio::log.info "RECEIVER Pin is: RECEIVER"; else bashio::log.warning "RECEIVER Pin is disabled"; fi

# Update pilight config
sed -i 's/\("gpio-platform"\): \?".*"\(.*\)/\1: "'"$GPIO_PLATFORM"'"\2/' /etc/pilight/config.json
sed -i 's/\("sender"\): \?".*"\(.*\)/\1: "'$SENDER'"\2/' /etc/pilight/config.json
sed -i 's/\("receiver"\): \?".*"\(.*\)/\1: "'$RECEIVER'"\2/' /etc/pilight/config.json

bashio::log.green "Starting pilight daemon"

/usr/local/sbin/pilight-daemon -F
