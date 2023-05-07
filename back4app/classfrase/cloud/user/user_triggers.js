
Parse.Cloud.beforeSave(Parse.User,async(req)=>{
  let user = req.object;
  console.log(`beforeSave User with ${user.email}. Create profile.`);

  if(user.get('profile')===undefined){
    const userProfile = new Parse.Object("UserProfile");
    userProfile.set('email',user.get('email'));
    let userProfileResult = await userProfile.save(null,{ useMasterKey: true });
    user.set('profile',userProfileResult);
  }
});

Parse.Cloud.afterDelete(Parse.User,async(req)=>{
  let user = req.object;

  console.log(`afterDelete user ${user.id}`);
  let userProfileId = user.get('profile').id;
  console.log(`delete UserProfile ${userProfileId}`);
  const userProfile = new Parse.Object("UserProfile");
  userProfile.id = userProfileId;
  await userProfile.destroy({ useMasterKey: true });
});
