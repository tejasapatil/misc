# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\w \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
export GIT_PS1_SHOWDIRTYSTATE=1

# User specific aliases and functions
export GREP_COLOR='1;37;43'
alias grep='grep --color=auto'

function srch() {
  grep -nri --include=*.{scala,java} "$@" .
}

function srch2() {
  grep -lnri --include=*.{scala,java} "$@" .
}

function die() { 
  jps | grep -i $1 | awk '{print $1}' | xargs -I {} kill -9 {}  
}

function die2() { 
  jps | grep -i $1 | awk '{print $1}' | xargs -I {} kill -15 {}  
}

alias dieall="die consumer; die producer; die kafka; die quorum"
alias com="./sbt package"
alias clearLogs="rm -rf *.log* /tmp/zookeeper/* /tmp/kafka_metrics* /tmp/kafka-logs*"
alias zk="bin/zookeeper-server-start.sh config/zookeeper.properties"
alias zkc="clearLogs; zk" 
alias rld="dieall; com; zkc"
alias zkins="export ZK_HOME=/home/tpatil/zookeeper-3.3.5; cd $ZK_HOME/contrib/ZooInspector; java -cp zookeeper-3.3.5-ZooInspector.jar:lib/*:$ZK_HOME/zookeeper-3.3.5.jar:$ZK_HOME/lib/* org.apache.zookeeper.inspector.ZooInspector"

alias 1bro="bin/kafka-server-start.sh ../config/server.properties"
alias 2bro="JMX_PORT=9997 bin/kafka-server-start.sh ../config/server1.properties"
alias 3bro="JMX_PORT=9998 bin/kafka-server-start.sh ../config/server2.properties"

alias pro="bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic test --replication-factor 2 --partitions 6; bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test"
alias con="bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --group 123 --from-beginning"
alias rld="dieall; com; 1zk"

function 1yarn {
  export HADOOP_HOME=/home/tejas/Desktop/apache/hadoop-2.0.3-alpha
  export HADOOP_MAPRED_HOME=$HADOOP_HOME
  export HADOOP_COMMON_HOME=$HADOOP_HOME
  export HADOOP_HDFS_HOME=$HADOOP_HOME
  export YARN_HOME=$HADOOP_HOME
  export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
  export JAVA_HOME=$JAVA6_HOME
  export PATH=usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$JAVA6_HOME/bin:$ANT_HOME/bin:$HADOOP_HOME/bin

  $HADOOP_HOME/sbin/hadoop-daemon.sh start namenode
  $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
  $HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager
  $HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
}

function 0yarn {
  $HADOOP_HOME/sbin/hadoop-daemon.sh stop namenode
  $HADOOP_HOME/sbin/hadoop-daemon.sh stop datanode
  $HADOOP_HOME/sbin/yarn-daemon.sh stop resourcemanager
  $HADOOP_HOME/sbin/yarn-daemon.sh stop nodemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh stop historyserver
 
  unset HADOOP_MAPRED_HOME
  unset HADOOP_COMMON_HOME
  unset HADOOP_HDFS_HOME
  unset YARN_HOME
  
  export HADOOP_HOME=/home/tejas/Desktop/apache/hadoop-1.1.2
  export HADOOP_CONF_DIR=$HADOOP_HOME/conf
  export HADOOP_CMD=$HADOOP_HOME/bin/hadoop
  export HADOOP_STREAMING=$HADOOP_HOME/contrib/streaming/hadoop-streaming-1.1.2.jar

  export JAVA_HOME=$JAVA7_HOME
  export PATH=$PIG_HOME/bin:$M3:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$JAVA_HOME/bin:$JAVA_HOME/db/bin:$JAVA7_HOME/jre/bin:$ANT_HOME/bin:$FORREST_HOME/bin:$HADOOP_HOME/bin
}

export JAVA6_HOME=/home/tejas/Desktop/dev/java6/jdk1.6.0_38
export JAVA7_HOME=/usr/lib/jvm/java-7-oracle
export JAVA_HOME=$JAVA7_HOME
export ANT_HOME=/home/tejas/Desktop/apache/ant-1.8.4
export FORREST_HOME=/home/tejas/Desktop/apache/forrest-0.9
export PATH=$JAVA_HOME/bin:$PATH:$ANT_HOME/bin:$FORREST_HOME/bin

export M3_HOME=/home/tejas/Desktop/apache/apache-maven-3.0.5
export M3=$M3_HOME/bin
export PATH=$M3:$PATH

export HADOOP_HOME=/home/tejas/Desktop/apache/hadoop-1.1.2
export HADOOP_CONF_DIR=$HADOOP_HOME/conf
alias 1hadoop='sh $HADOOP_HOME/bin/start-all.sh'
alias 0hadoop='sh $HADOOP_HOME/bin/stop-all.sh'
alias 2hadoop='rm -rf $HADOOP_HOME/logs'
export PATH=$PATH:$HADOOP_HOME/bin

export HBASE_HOME=/home/tejas/Desktop/apache/hbase-0.90.6
export HBASE_CONF_DIR=$HBASE_HOME/conf
alias 1hbase='cd $HBASE_HOME; sh bin/start-hbase.sh'
alias 0hbase='sh $HBASE_HOME/bin/stop-hbase.sh'
export PATH=$PATH:$HBASE_HOME/bin

export PIG_HOME=/home/tejas/Desktop/apache/pig-0.11.1
alias lpig='$PIG_HOME/bin/pig -x local'
alias hpig='$PIG_HOME/bin/pig'
export PATH=$PIG_HOME/bin:$PATH

export SOLR_HOME=/home/tejas/Desktop/apache/solr-3.6.2/
export SOLR_URL="http://127.0.0.1:8983/solr/"
alias 1solr='cd $SOLR_HOME/example;java -jar start.jar'

export HIVE_HOME=/home/tejas/Desktop/apache/hive-0.11.0-bin
export PATH=$PATH:$HIVE_HOME/bin

export MANAGIX_HOME=/home/tejas/Desktop/Asterix/curr_asterix
export PATH=$PATH:$MANAGIX_HOME/bin

export SBT_HOME=/home/tejas/Desktop/Scala/sbt
export PATH=$PATH:$SBT_HOME/bin

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
