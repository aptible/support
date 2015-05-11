To deploy from Codeship on Aptible, we recommend the following approach:

1. Create a “Robots” role in your Aptible organization, and grant it “Read” and “Manage” permissions on your production account.
2. Invite a new deploy user to this Robots role. It needs to have a real email address, but can be something like deploy@yourdomain.com.
3. Accept the invitation for deploy@yourdomain.com, activate the account.
4. Get the Codeship SSH public key from your project's general settings tab and add it to the SSH keys for the Robot user from step 3.
5. Add a custom deploy step, following Codeship’s instructions. It should look something like:

`git push git@beta.aptible.com:${APTIBLE_APP}.git ${CI_COMMIT_ID}:master`
