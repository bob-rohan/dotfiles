# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/bob.rohan/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle kubectl
#antigen bundle aws
#antigen bundle ansible

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# https://github.com/jenv/jenv
eval "$(jenv init -)"

# personal aliases
alias j='jrnl'
alias jo='jrnl -n 50 | grep -v -e "^$"'
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

# personal - autostart tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# pesonal - kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1

# personal sale ASGs
alias scale='/Users/bob.rohan/git/utils/imp/python/scaling.py'

# personal ip stuff
alias whatsmyip='curl -4 ifconfig.co'

ipcheck() {
  if [ -z $1 ]; then
    echo "project-env-service?"
  else
    echo $(aws ec2 describe-instances --filters Name=tag:Name,Values="*$1*" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text 2>/dev/null)
  fi
}

# personal db stuff
alias rdsconnectgetip='echo $(aws ec2 describe-instances --filters Name=tag:Name,Values="*rdsconnect*" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text 2>/dev/null)'
alias rdsconnect='ssh -i ~/.ssh/prod.pem ec2-user@$(ipcheck rdsconnect)'
alias datafix='. ~/git/devops/local_utils/helpers/datafixRequiredInfoHelper.sh'


# personal aws fiddle
bkaws() {
  if [ -z $1 ]; then
    echo "env?"
  else 
    cp ~/.aws/credentials ~/.aws/credentials.$1
  fi
}

rtaws(){
  if [ -z $1 ]; then
    echo "env?"
  else 
    cp ~/.aws/credentials.$1 ~/.aws/credentials
  fi
}

# personal env exports switch

unsetaws() {

  unset AWS_DEFAULT_REGION AWS_PROFILE TF_VAR_aws_account_num TF_VAR_aws_account

}

prod() {

  unsetaws

  export AWS_DEFAULT_REGION=eu-west-2
  export AWS_PROFILE=prod

  export TF_VAR_aws_account=prod
  export TF_VAR_aws_account_num=510505205118

  tmux set-option status-style fg=black,bg=red

  mawsauth $AWS_PROFILE
}

nonprod() {

  unsetaws

  export AWS_DEFAULT_REGION=eu-west-2
  export AWS_PROFILE=nonprod

  export TF_VAR_aws_account=nonprod
  export TF_VAR_aws_account_num=562370771964

  tmux set-option status-style fg=black,bg=white

  mawsauth $AWS_PROFILE

}

dev() {

  unsetaws

  export AWS_DEFAULT_REGION=eu-west-2
  export AWS_PROFILE=dev

  export TF_VAR_aws_account=dev
  export TF_VAR_aws_account_num=084207842491

  tmux set-option status-style fg=black,bg=green

  mawsauth $AWS_PROFILE

}

mawsauth() {

  # security delete-generic-password -a ${USER} -s azuread
  # security add-generic-password -a ${USER} -s azuread -w 

  export AZURE_DEFAULT_PASSWORD=$(security find-generic-password -a $USER -s azuread -w)
  
  if [ -z $1 ]; then
    aws-azure-login --no-prompt --all-profiles
  else
    AWS_PROFILE=$1
    aws sts get-caller-identity &>/dev/null
    IS_SESSION_VALID=$?
    
    if [ $IS_SESSION_VALID -ne 0 ]; then
      echo "refreshing $1 creds"
      aws-azure-login --no-prompt --profile $1 
    fi
  fi

  unset AZURE_DEFAULT_PASSWORD

}

# hodge aliases
alias awsauth='source /Users/bob.rohan/git/jumpbox-client/client/awsauth.sh'
alias vpn-dev=~/vpn-dev.sh
alias vpn-nonprod=~/vpn-nonprod.sh
alias vpn-prod=~/vpn-prod.sh
alias vpn-mgmt=~/vpn-mgmt.sh

# personal exports
