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

#### Notes:
1) When you run the script, it will prompt you to decide if you want pull the latest `master` branch of `platformrecipe`.
You can use the `-p` flag to make it automatic.
i.e.,
```
./runRecipeUpdate.sh -p
```

2) After pulling the latest `master` branch, the script checks out the last commit that was deployed on `platformrecipe` (which essentially allows you to continue using the same version while the new docker images are being pulled). As such, after pulling of docker images complete, **remember to** `git checkout master` **to deploy the updated version**.

3) This script makes use of the `sbt` tasks in `platformrecipe` to determine the docker images to pull. Consequently, that will incorporate overrides you have specified in `overrides.conf` (i.e., if you have given a specific tag/snapshot version for a particular service, a new image will not get pulled)