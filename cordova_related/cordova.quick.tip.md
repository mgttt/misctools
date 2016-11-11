

https://cordova.apache.org/docs/en/latest/guide/cli/

Updating Cordova and Your Project
After installing the cordova utility, you can always update it to the latest version by running the following command:
```
    $ sudo npm update -g cordova
```    
Use this syntax to install a specific version:
```
    $ sudo npm install -g cordova@3.1.0-0.2.0
```    
Run cordova -v to see which version is currently running. Run the npm info command for a longer listing that includes the current version along with other available version numbers:
```
    $ npm info cordova
```    
Cordova 3.0 is the first version to support the command-line interface described in this section. If you are updating from a version prior to 3.0, you need to create a new project as described above, then copy the older application's assets into the top-level www directory. Where applicable, further details about upgrading to 3.0 are available in the Platform Guides. Once you upgrade to the cordova command-line interface and use npm update to stay current, the more time-consuming procedures described there are no longer relevant.

Cordova 3.0+ may still require various changes to project-level directory structures and other dependencies. After you run the npm command above to update Cordova itself, you may need to ensure your project's resources conform to the latest version's requirements. Run a command such as the following for each platform you're building:
```
    $ cordova platform update android
    $ cordova platform update ios
    ...etc.
```
