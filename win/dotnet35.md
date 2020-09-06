# install at win2012

```

DISM /Online /Enable-Feature /FeatureName:NetFx3 /Source:c:\windows\winsxs

# if not work, reboot and try again after restore image:
dism /online /cleanup-image /restorehealth




```
