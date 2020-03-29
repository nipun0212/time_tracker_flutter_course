import * as functions from 'firebase-functions';
<<<<<<< Updated upstream
=======
import * as admin from 'firebase-admin';
import * as apiPath from './apipath';
import * as util from './util';
// import * as model from './model';
//
// admin.initializeApp({
//   credential: admin.credential.applicationDefault(),
//   projectId: "timetracker-9d0b4"
// });

// var serviceAccount = require("/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/tie.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://timetracker-9d0b4.firebaseio.com"
// });

admin.initializeApp();
const db = admin.firestore();
// console.log(process.env.FIREBASE_CONFIG);
// console.log(window?.location.hostname);
// console.log("process.argv[1]");
// console.log(window.URL);
// db.settings({
//   projectId: "timetracker-9d0b4",
//   keyFilename: "/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/timetracker-f6322943c258.json"
// });
const getSuperAdminUID = () => getUIDFromPhoneNumber("+918971819883");

export const getUIDFromPhoneNumber = async function (phoneNumber: string) {
  console.log("Fetching UID for phone number " + phoneNumber);
  let uid;
  try {
    uid = (await admin.auth().getUserByPhoneNumber(phoneNumber)).uid;
  } catch (e) {
    if (e.errorInfo.code === 'auth/user-not-found') {
      try {
        await admin.auth().createUser({
          phoneNumber: phoneNumber
        })
      } catch (e) {
        throw new Error(e);
      }
    }
  } finally {
    if (uid === undefined)
      uid = (await admin.auth().getUserByPhoneNumber(phoneNumber)).uid;
  }
  return uid;
};
>>>>>>> Stashed changes

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

<<<<<<< Updated upstream
exports.helloNipun = functions.https.onCall((data, context) => {
    return {
        name:'nipun'
    };
});
=======

exports.userInitialize = functions.firestore
  .document('users/{uid}').onCreate(async (change, context) => {
    const userUID = change.id;
    await db.doc(apiPath.userOTP(userUID)).set({
      "otp": util.getOTP()
    }, { merge: true });
  });


exports.organizationInitialize = functions.firestore
  .document('organizations/{oraganizationId}').onWrite(async (change, context) => {
    const ownerPreviousPhoneNumber = change.before.data()?.ownerPhoneNumber;
    const ownerCurrentPhoneNumber = change.after.data()?.ownerPhoneNumber;
    const superAdminUID = await getSuperAdminUID();
    const organizationID = change.after.id;
    console.log("change.after.id");
    console.log(change.after.id);
    console.log("change.before.id");
    console.log(change.before.id);
    console.log("superAdminUID");
    console.log(superAdminUID);
    console.log("context.auth?.uid");
    console.log(context.auth?.uid);
    console.log("context.authType");
    console.log(context.authType);
    console.log("ownerPhoneNumberBefore");
    console.log(ownerPreviousPhoneNumber);
    console.log("ownerPhoneNumberAfter");
    console.log(ownerCurrentPhoneNumber);

    if (ownerPreviousPhoneNumber === ownerCurrentPhoneNumber) {
      console.log("There is no change");
      return;
    }
    const organizationOwnerUIDAfter = await getUIDFromPhoneNumber(ownerCurrentPhoneNumber);
    // const organizationOwnerUIDBefore = await getUIDFromPhoneNumber(ownerPreviousPhoneNumber);

    console.log("organizationOwnerUID");
    console.log(organizationOwnerUIDAfter);
    // const roleRef = db.doc(`organizations/${documenetId}/private/roles`);
    const roleJSON = {
      "isOwner": organizationOwnerUIDAfter
    }
    const userJSON = {
      "phoneNumber": ownerCurrentPhoneNumber
    }

    const organizationJSON = {
      "organizationID": admin.firestore.FieldValue.arrayUnion(organizationID)
    }
    try {
      await db.runTransaction(async (t: admin.firestore.Transaction) => {
        if (ownerPreviousPhoneNumber !== undefined) {
          let u = await t.get(db.collection(apiPath.users()).where('phoneNumber', '==', ownerPreviousPhoneNumber));
          u.forEach(s => {
            t.update(apiPath.userOrganizationsRef(s.id), {
              "organizationID": admin.firestore.FieldValue.arrayRemove(organizationID)
            })
          })
          u = await t.get(db.collection(apiPath.users()).where('phoneNumber', '==', ownerCurrentPhoneNumber));
          u.forEach(s => {
            t.update(apiPath.userOrganizationsRef(s.id), {
              "organizationID": admin.firestore.FieldValue.arrayRemove(organizationID)
            })
          })
        }
        t.set(apiPath.organizationUserRolesRef(organizationID), roleJSON, { merge: true });
        t.set(apiPath.userRef(organizationOwnerUIDAfter), userJSON, { merge: true })
        t.set(apiPath.userOrganizationsRef(organizationOwnerUIDAfter), organizationJSON, { merge: true })
      });
    } catch (e) {
      throw new Error(e);
    }
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
})




>>>>>>> Stashed changes
