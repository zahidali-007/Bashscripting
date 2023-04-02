#!/bin/bash

# Install SpamAssassin
sudo apt-get install spamassassin

# Configure SpamAssassin
cat << EOF > /etc/spamassassin/local.cf
required_hits 5
report_safe 0
EOF

# Create folder for spam emails
mkdir -p ~/Maildir/.Junk

# Create procmail script to move spam emails to the spam folder
cat << EOF > ~/.procmailrc
:0
* ^X-Spam-Status: Yes
$HOME/Maildir/.Junk/
EOF

# Run sa-learn to train SpamAssassin on the spam folder
/usr/bin/sa-learn --spam ~/Maildir/.Junk/cur/

# Set up cron job to run the procmail script every hour
(crontab -l 2>/dev/null; echo "0 * * * * /usr/bin/formail -s procmail < ~/.procmailrc") | crontab -

# Restart SpamAssassin to apply changes
sudo service spamassassin restart
