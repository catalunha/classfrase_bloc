Parse.Cloud.afterDelete("UserProfile", async (req) => {
  let curObj = req.object;
  //Deletando todas as frases deste userProfile deletado
  const query = new Parse.Query("Phrase");
  query.equalTo("userProfile", curObj);
  
  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      await result.destroy({ useMasterKey: true });
    }
  }
  //Deletando todos os aprendizados deste userProfile deletado
  const query2 = new Parse.Query("Learn");
  query.equalTo("userProfile", curObj);
  
  const otherObjResults2 = await query2.find();
  if (otherObjResults2.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result2 = otherObjResults2[i];
      await result2.destroy({ useMasterKey: true });
    }
  }
});