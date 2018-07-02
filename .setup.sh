echo "THEIP=$(ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | tail -1 | cut -d: -f2 | awk '{ print $1}')" >> ~/.bashrc
echo "PS1=\"\[\033[01;31m\]\u@"$THEIP" \w $\[\033[00m\] \";" >> ~/.bashrc
echo \
    'alias empq="ipcrm -q $(ipcs -q | grep 666 | tr -s " " | cut -d " " -f 2)"' \
    >> ~/.bashrc && source ~/.bashrc
