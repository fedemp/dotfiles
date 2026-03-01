# Function to detect if inside a container (distrobox/toolbx)
function container_icon() {
    if [ -n "$DISTROBOX_NAME" ] || [ -n "$TOOLBOX_PATH" ]; then
        echo -e "\001\033[35m\002⬢\001\033[0m\002 "
    fi
}

# Function to detect background jobs
function bg_jobs_icon() {
    if [ $(jobs -p | wc -l) -gt 0 ]; then
        echo -e "\001\033[36m\002🠷\001\033[0m\002 "
    fi
}

# Function to show exit status if not 0
function exit_status() {
    if [ $? -ne 0 ]; then
        echo -e "\001\033[33m\002⚠ $?\001\033[0m\002 "
    fi
}

# Function to set prompt color based on exit status
function prompt_color() {
    if [ $? -eq 0 ]; then
        echo -e "\001\033[32m\002"
    else
        echo -e "\001\033[31m\002"
    fi
}

# Set PS1
PS1='$(container_icon)$(bg_jobs_icon)\[\033[1;34m\]\w\[\033[0m\]$(exit_status)$(prompt_color)❯\[\033[0m\] '
