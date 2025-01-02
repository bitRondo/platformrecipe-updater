Platform Recipe Updater
=======================

This is a simple script that allows you to update the platformrecipe and pull up-to-date docker images, while using the current version of the platformrecipe to deploy.

#### Instructions:
> [!IMPORTANT]
> Please change `paths.config` to provide the path to the location of `platformrecipe` on your environment.

Then run the script.
```
chmod +x ./runRecipeUpdate.sh
./runRecipeUpdate.sh
```

#### Note:
When you run the script, it will prompt you to decide if you want pull the latest `master` branch of `platformrecipe`.
You can use the `-p` flag to make it automatic.
i.e.,
```
./runRecipeUpdate.sh -p
```