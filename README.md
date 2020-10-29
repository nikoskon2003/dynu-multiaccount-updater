# Dynu Multiaccount Updater
A Linux tool to update IP adresses of hostnames/locations on multiple [Dynu](https://dynu.com/) accounts.

## Setup
First of all, choose a directory to put the script.<br>
Afterwards, make sure the script can be executed
```bash
chmod +x /path/to/dynu-updater.sh
```
*(make sure to replace '/path/to/' with the actual path to the script)*.

Once the script can be executed, run it to create the *list file*
```bash
/path/to/dynu-updater.sh
```
and the message `Please configure /path/to/dynu-updater.list file!` should appear.

## Usage
After the *list file* is created, it needs to be configured.<br>
After creation it should look like: 
```bash
#Example update list file
#First user
username=user
password=5F4DCC3B5AA765D61D8327DEB882CF99
hostname=example.com
hostname=otherdomain.com
location=MyLocation

#Second user
username=testuser
password=098F6BCD4621D373CADE4E832627B4F6
hostname=somedomain.com
location=Home
location=Office
```

- **`username`** is the username used by the Dynu account
- **`password`** is the [md5](https://emn178.github.io/online-tools/md5.html) hash used by the Dynu account
- **`hostname`** is a hostname owned by the Dynu account
- **`location`** is a valid location (also known as ***Group***) on the Dynu account

As seen on the example, you can have multiple hostnames or locations per account to be updated.
#### Note:
The script reads the *list file* from top to bottom. Thus each **username** and **password** must come __before__ the hostnames/locations associated with that account.


Once the *list file* is configured correctly, run again:
```bash
/path/to/dynu-updater.sh
```
to update the hostnames/locations to the current ip of the machine.<br>
A message should show up for each hostname/location with its update status, looking something like:
```
Thu 29 Oct 21:48:10 EET 2020 | example.com : nochg
```
where `nochg` is the [response code](https://www.dynu.com/DynamicDNS/IP-Update-Protocol#responsecode) returned by Dynu.

## Logging
If you wish to log the output of the script, you can run the script like this:
```bash
/path/to/dynu-updater.sh >> /path/to/logfile.log
```
recommended
## Automation
The script by itself __does not__ automatically update the IP at regular intervals. For this functionality, you will have to use external means.<br>
For this example, [cron](https://en.wikipedia.org/wiki/Cron) will be used.<br>
Tping `sudo crontab -e` will open the cron jobs. Adding the line
```bash
*/5 * * * * sudo /path/to/dynu-updater.sh >> /path/to/logfile.log
```
to the bottom of the file will run the updater once every 5 minutes and will log the output to `logfile.log`.<br><br>
If you wish to change the frequency, you can go to [crontab.guru](https://crontab.guru/#*/5_*_*_*_*) to help you with cron scheduling.<br>
It is recommended that the update interval is not lower that 5 minutes.<br>
