#!/usr/bin/env bash
# CPU usage script for tmux status bar

get_cpu_usage() {
    case "$(uname -s)" in
        Darwin)
            # macOS
            top -l 1 -n 0 | awk '/CPU usage/ {print $3}' | sed 's/%//'
            ;;
        Linux)
            # Linux
            grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'
            ;;
        *)
            echo "N/A"
            ;;
    esac
}

get_load_average() {
    case "$(uname -s)" in
        Darwin|Linux)
            uptime | awk '{print $NF}' | sed 's/,//'
            ;;
        *)
            echo "N/A"
            ;;
    esac
}

get_cpu_icon() {
    local cpu_usage=$1
    
    if [[ $cpu_usage == "N/A" ]]; then
        echo "💻"
    elif (( $(echo "$cpu_usage > 80" | bc -l) )); then
        echo "🔥"
    elif (( $(echo "$cpu_usage > 50" | bc -l) )); then
        echo "⚡"
    else
        echo "💻"
    fi
}

format_cpu_usage() {
    local usage=$1
    if [[ $usage == "N/A" ]]; then
        echo "N/A"
    else
        printf "%.1f%%" "$usage"
    fi
}

main() {
    local cpu_usage=$(get_cpu_usage)
    local load_avg=$(get_load_average)
    local icon=$(get_cpu_icon "$cpu_usage")
    local formatted_usage=$(format_cpu_usage "$cpu_usage")
    
    echo "$icon $formatted_usage"
}

main "$@"