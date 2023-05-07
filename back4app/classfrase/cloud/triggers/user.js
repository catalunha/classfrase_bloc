
Parse.Cloud.afterSave(Parse.User, async (req) => {
  let userObj = req.object;
  // //console.log(`afterSave User with ${user.email}. Create userProfile.`);
  if (userObj.get('userProfile') === undefined) {
    const userProfileObj = new Parse.Object("UserProfile");
    userProfileObj.set('email', userObj.get('email'));
    let userProfileResult = await userProfileObj.save(null, { useMasterKey: true });
    userObj.set('userProfile', userProfileResult);
    await userObj.save(null, { useMasterKey: true });
  }
});

Parse.Cloud.afterDelete(Parse.User, async (req) => {
  let userObj = req.object;
  //Apagar user de UserProfile
  //console.log(`afterDelete user ${user.id}`);
  let userProfileId = userObj.get('userProfile').id;
  //console.log(`deleting userProfile ${userProfileId}`);
  const userProfileObj = new Parse.Object("UserProfile");
  userProfileObj.id = userProfileId;
  await userProfileObj.destroy({ useMasterKey: true });

});
