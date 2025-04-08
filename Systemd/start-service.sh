#!/bin/bash

echo "reloading daemon"
sudo systemctl daemon-reload
echo "enabling service"
sudo systemctl enable minecraft-server
echo "starting service"
sudo systemctl start minecraft-server
