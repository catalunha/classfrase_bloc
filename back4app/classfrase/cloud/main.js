require('./triggers/user.js');
require('./triggers/user_profile.js');

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", (request) => {
	return "Hello world!";
});
