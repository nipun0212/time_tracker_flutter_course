import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';
// import * as model from './model';
//
// admin.initializeApp({
//   credential: admin.credential.applicationDefault(),
//   projectId: "timetracker-9d0b4"
// });
var admin = require("firebase-admin");

var serviceAccount = require("/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/timetracker-f6322943c258.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://timetracker-9d0b4.firebaseio.com"
});
// console.log(process.env.FIREBASE_CONFIG);
// console.log(window?.location.hostname);
// console.log("process.argv[1]");
// console.log(window.URL);
// admin.firestore().settings({
//   projectId: "timetracker-9d0b4",
//   keyFilename: "/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/timetracker-f6322943c258.json"
// });
export const getUIDFromPhoneNumber = async function (phoneNumber: string) {
  console.log(phoneNumber);
  console.log("inside getUIDFromPhoneNumber");
  let uid;
  try {
    uid = (await admin.auth().getUserByPhoneNumber(phoneNumber)).uid;
  }catch (e) {
    if (e.errorInfo.code === 'auth/user-not-found') {
      try {
        await admin.auth().createUser({
          phoneNumber: phoneNumber
        })
      } catch (e) {
        throw new Error(e);
      }
    }
  }finally{
    uid = (await admin.auth().getUserByPhoneNumber(phoneNumber)).uid;
  }
  return uid;
};

export const helloWorld = functions.https.onRequest(async (request, response) => {
  let uid = await getUIDFromPhoneNumber("+918961819883");
  console.log("UID from function is "+uid);
  console.log(getUIDFromPhoneNumber("change.after.id"));
  let z = { Y: "nipun" };
  console.log(z);
  console.log(z.Y);
  response.send("Hello from Firebasedddd!");
  let documenetId = "uofPDOfPCBsc99yMwbXn";
  console.log(await admin.firestore().doc(`organizations/${documenetId}/private/roles`).path);
  console.log(await admin.firestore().doc(`organizations/${documenetId}/private/roles`).parent.id);
  // await admin.firestore().

  let x = JSON.stringify(await (await admin.firestore().doc(`organizations/${documenetId}`).get()).data());
  documenetId = "TYcElzyTyrB5OmZz3Nk5";
  let y = JSON.stringify(await (await admin.firestore().doc(`organizations/${documenetId}`).get()).data());
  console.log("x");
  console.log(x);
  console.log("y");
  console.log(y);
  if (x === y) {
    console.log(true);
  }
  // console.log(await (await admin.firestore().doc(`organizations/${documenetId}/private/roles`).get()).exists);
  // console.log(await (await admin.firestore().doc(`organizations/${documenetId}/private/roles`).get()).data()?.isOwner);

  // console.log(await admin.firestore().doc(`organizations/${documenetId}/private/roles`).set({
  //   "isOwner": ['dsdsdsds', 'dsfdsf'],
  //   "isManager": ['ddd']
  // }));
});

exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
  console.log(user);
});

exports.organizationInitialize = functions.firestore
  .document('organizations/{oraganizationId}').onWrite(async (change, context) => {
    console.log("change.after.id");
    console.log(change.after.id);
    console.log("change.before.id");
    console.log(change.before.id);
    const documenetId = change.after.id;
    const superAdminUID = (await admin.auth().getUserByPhoneNumber('+918971819883')).uid;
    console.log("superAdminUID");
    console.log(superAdminUID);
    console.log("context.auth?.uid");
    console.log(context.auth?.uid);
    console.log("context.authType");
    console.log(context.authType);
    const ownerPhoneNumberBefore = change.before.data()?.ownerPhoneNumber;
    const ownerPhoneNumberAfter = change.after.data()?.ownerPhoneNumber;
    console.log("ownerPhoneNumberBefore");
    console.log(ownerPhoneNumberBefore);
    console.log("ownerPhoneNumberAfter");
    console.log(ownerPhoneNumberAfter);

    if (ownerPhoneNumberBefore === ownerPhoneNumberAfter) {
      console.log("There is no change");
      return;
    }
    let ownerUID;
    try {
      ownerUID = (await admin.auth().getUserByPhoneNumber(change.after.data()?.ownerPhoneNumber)).uid;
    } catch (e) {
      console.log(e);
      console.log(e.errorInfo.code);
      if (e.errorInfo.code === 'auth/user-not-found') {
        try {
          await admin.auth().createUser({
            phoneNumber: change.after.data()?.ownerPhoneNumber
          })
          ownerUID = (await admin.auth().getUserByPhoneNumber(change.after.data()?.ownerPhoneNumber)).uid;
        } catch (e) {
          console.log(e);
        }
      }
      else
        throw new Error("Onwer Phone Number missing");
    }
    console.log("ownerUID");
    console.log(ownerUID);
    // if (context.auth?.uid === superAdminUID) {
    await admin.firestore().doc(`organizations/${documenetId}/private/roles`).set({
      "isOwner": ownerUID
    }, { merge: true });
    // if(!(await admin.firestore().doc(`users/${ownerUID}`).get()).exists)
    await admin.firestore().doc(`users/${ownerUID}`).set({
      "phoneNumber": ownerPhoneNumberAfter,
    }, { merge: true });

    await admin.firestore().doc(`users/${ownerUID}/private/organizationDetails`).set({
      "organizationID": change.after.id
    }, { merge: true });
    await admin.firestore().doc(`users/${ownerUID}/private/organizationDetails`).set({
      "organizationID": change.after.id
    }, { merge: true });
  });

exports.addMessage = functions.https.onCall((data, context) => {
  console.log("addmessage");
  console.log("data is");
  console.log(data);
  console.log("context is");
  console.log(context);
  console.log("addmessagedone");
  // admin.auth().verifyIdToken(context.auth.)
  return [{
    "nipun": "data",
    "madan": "u"
  }]

});

