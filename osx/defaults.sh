# Show the ~/Library folder
chflags nohidden ~/Library

# Enable deprecated samba support
sudo sysctl -w net.smb.fs.kern_deprecatePreXPServers=0
