#!/usr/bin/env bash
# Battery status script for tmux status bar

get_battery_status() {
    case "$(uname -s)" in
        Darwin)
            # macOS
            pmset -g batt | grep -Eo "\d+%" | cut -d% -f1
            ;;
        Linux)
            # Linux
            if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
                cat /sys/class/power_supply/BAT0/capacity
            elif [[ -f /sys/class/power_supply/BAT1/capacity ]]; then
                cat /sys/class/power_supply/BAT1/capacity
            else
                echo "N/A"
            fi
            ;;
        *)
            echo "N/A"
            ;;
    esac
}

get_battery_icon() {
    local battery_level=$1
    local charging_status=$2

    if [[ $charging_status == "charging" ]]; then
        echo "🔌"
    elif [[ $battery_level -ge 90 ]]; then
        echo "🔋"
    elif [[ $battery_level -ge 60 ]]; then
        echo "🔋"
    elif [[ $battery_level -ge 30 ]]; then
        echo "🔋"
    elif [[ $battery_level -ge 10 ]]; then
        echo "🪫"
    else
        echo "🪫"
    fi
}

get_charging_status() {
    case "$(uname -s)" in
        Darwin)
            pmset -g batt | grep -q "AC Power" && echo "charging" || echo "discharging"
            ;;
        Linux)
            if [[ -f /sys/class/power_supply/BAT0/status ]]; then
                local status=$(cat /sys/class/power_supply/BAT0/status)
                [[ $status == "Charging" ]] && echo "charging" || echo "discharging"
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

main() {
    local battery_level=$(get_battery_status)
    local charging_status=$(get_charging_status)
    local icon=$(get_battery_icon "$battery_level" "$charging_status")

    if [[ $battery_level == "N/A" ]]; then
        echo "⚡ N/A"
    else
        echo "$icon $battery_level%"
    fi
}

main "$@"
