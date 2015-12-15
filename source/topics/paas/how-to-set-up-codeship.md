To deploy from Codeship on Aptible, we recommend the following approach:

1. Create a “Robots” role in your Aptible organization, and grant it “Read” and “Manage” permissions on your production account.
2. Invite a new deploy user to this Robots role. It needs to have a real email address, but can be something like deploy@yourdomain.com.
3. Accept the invitation for deploy@yourdomain.com, activate the account, and upload the public key from your Codeship projects _General_ settings page on your Aptible User Settings page.
4. Add an environment variable called `APTIBLE_APP` with your application handle as the value.
5. Add a custom script based deployment with the following commands. (You can also find this script in the [codeship/scripts repository](https://github.com/codeship/scripts/blob/master/deployments/aptible.sh))

```
git push git@beta.aptible.com:$ENVIRONMENT_HANDLE/$APP_HANDLE.git $CI_COMMIT_ID:master
```
