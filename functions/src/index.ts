import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as apiPath from './apipath';
import * as util from './util';
// import * as model from './model';
//
// admin.initializeApp({
//   credential: admin.credential.applicationDefault(),
//   projectId: "timetracker-9d0b4"
// });

var serviceAccount = require("/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/sec.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://timetracker-9d0b4.firebaseio.com"
});

// admin.initializeApp();
const db = admin.firestore();
// console.log(process.env.FIREBASE_CONFIG);
// console.log(window?.location.hostname);
// console.log("process.argv[1]");
// console.log(window.URL);
// db.settings({
//   projectId: "timetracker-9d0b4",
//   keyFilename: "/Users/i309795/Documents/GitHub/time_tracker_flutter_course/functions/timetracker-f6322943c258.json"
// });
const _setSuperAdminCustomClaims =async ()=>await admin.auth().setCustomUserClaims(await _getSuperAdminUID(),{
  isSuperAdmin: true
})
const _getSuperAdminUID = (): Promise<string> => _getUIDFromPhoneNumber("+918971819883");
const _userExists = async (uid: string): Promise<boolean> => (await db.doc(apiPath.user(uid)).get()).exists;
// const _getOrganizationWithOwnerPhoneNumber = async (phoneNumber: string) => await db.collection(apiPath.organizations()).where('ownerPhoneNumber', '==', phoneNumber).get();
const _setUserOTP = async (uid: string) => await db.doc(apiPath.userOTP(uid)).set({
  appOTP: util.getOTP(),
  emailOTP: util.getOTP()
});

export const _getUIDFromPhoneNumber = async function (phoneNumber: string) {
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

export const _createUserWithPhoneNumber = async function (phoneNumber: string) {
  const userUID: string = await _getUIDFromPhoneNumber(phoneNumber);
  if (await _userExists(userUID))
    await db.doc(apiPath.user(userUID)).set({
      phoneNumber: phoneNumber,
    }, { merge: true });
};




export const helloWorld = functions.https.onRequest(async (request, response) => {
  await _setSuperAdminCustomClaims();
  console.log(await admin.auth().getUser(await _getSuperAdminUID()));
  const phoneNumber = '+918971819883';
  const userUID: string = await _getUIDFromPhoneNumber(phoneNumber);
  // console.log(await (await _getOrganizationWithOwnerPhoneNumber(phoneNumber)).docs.forEach(v=>{
  //   console.log(v.data?.ownerPhoneNumber);
  // }));
  console.log('useruid=' + userUID);
  console.log('user = ' + await (await db.doc(apiPath.user(userUID)).get()).exists);
  // var ma = await admin.firestore().collection('mail').add({
  //   to: 'annubajaj05@gmail.com',
  //   message: {
  //     subject: 'Hello from Firebase!',
  //     text: 'This is the plaintext section of the email body.',
  //     html: 'This is the <code>HTML</code> section of the email body.',
  //   }
  // });
  // console.log(ma);
  // let ownerPreviousPhoneNumber = '+918971819883';
  // const u = await db.collection(apiPath.users()).where('phoneNumber', '==', ownerPreviousPhoneNumber).get();
  // console.log(u);
  // const uid = await _getUIDFromPhoneNumber("+918961819879");
  // let v = await db.collection(apiPath.users()).where('phoneNumber', '==', '+918971819883').get();
  // v.forEach(s => {
  //   console.log(s.data());
  // })
  // console.log("UID from function is " + uid);
  // console.log(_getUIDFromPhoneNumber("change.after.id"));
  // let z = { Y: "nipun" };
  // console.log(z);
  // console.log(z.Y);
  // response.send("Hello from Firebasedddd!");
  // let documenetId = "uofPDOfPCBsc99yMwbXn";
  // console.log(db.doc(`organizations/${documenetId}/private/roles`).path);
  // console.log(db.doc(`organizations/${documenetId}/private/roles`).parent.id);
  // // await db.

  // let x = JSON.stringify(await (await db.doc(`organizations/${documenetId}`).get()).data());
  // documenetId = "TYcElzyTyrB5OmZz3Nk5";
  // let y = JSON.stringify(await (await db.doc(`organizations/${documenetId}`).get()).data());
  // console.log("x");
  // console.log(x);
  // console.log("y");
  // console.log(y);
  // if (x === y) {
  //   console.log(true);
  // }
  // console.log(await (await db.doc(`organizations/${documenetId}/private/roles`).get()).exists);
  // console.log(await (await db.doc(`organizations/${documenetId}/private/roles`).get()).data()?.isOwner);

  // console.log(await db.doc(`organizations/${documenetId}/private/roles`).set({
  //   "isOwner": ['dsdsdsds', 'dsfdsf'],
  //   "isManager": ['ddd']
  // }));
  response.send("Hello from Firebasedddd!");
});

exports.setOTP = functions.auth.user().onCreate(async (user) => {
  const userUID = user.uid;
  await db.doc(apiPath.userOTP(userUID)).set({
    appOTP: util.getOTP(),
    emailOTP: util.getOTP()
  })
});

exports.userInitialize = functions.firestore
  .document('users/{userUID}').onWrite(async (change, context) => {
    await _setUserOTP(change.after.id);
  });

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
    const superAdminUID = await _getSuperAdminUID();
    if (await (await db.collection(apiPath.organizations()).where('ownerPhoneNumber', '==', ownerCurrentPhoneNumber).get()).size !== 1) {
      console.log("context.eventId");
      console.log(context.eventId);
      await change.after.ref.set({
        "lastError": 'Phone number already exists'
      }, { merge: true });
      const oldData = change.before.data();
      if (oldData)
        await change.after.ref.set(oldData, { merge: true });
      throw new Error("Phone number not unique");
    }
    console.log(superAdminUID);
    const organizationID = change.after.id;
    console.log("functions.auth.user");
    console.log(functions.auth.user());
    console.log(functions.auth.service);
    console.log("change.after.id");
    console.log(change.after.id);
    console.log("change.before.id");
    console.log(change.before.id);
    console.log("superAdminUID");
    console.log(superAdminUID);
    console.log("context.auth?.uid");
    console.log(context.auth?.uid);
    console.log("context.auth");
    console.log(context.auth);
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
    const organizationOwnerUIDAfter = await _getUIDFromPhoneNumber(ownerCurrentPhoneNumber);
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
    try {
      await db.runTransaction(async (t: admin.firestore.Transaction) => {
        if (ownerPreviousPhoneNumber !== undefined) {
          const u = await t.get(db.collection(apiPath.users()).where('phoneNumber', '==', ownerPreviousPhoneNumber));
          u.forEach(s => {
            t.delete(apiPath.userOrganizationsRef(s.id, organizationID));
          })
        }
        t.set(apiPath.organizationUserRolesRef(organizationID), roleJSON, { merge: true });
        t.set(apiPath.userRef(organizationOwnerUIDAfter), userJSON, { merge: true })
        t.set(apiPath.userOrganizationsRef(organizationOwnerUIDAfter, organizationID), {}, { merge: true })
        await admin.auth().setCustomUserClaims(organizationOwnerUIDAfter, {
          isOwner: true,
          organizationDocId: organizationID
        })
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




// console.log("change.after.id");
// console.log(change.after.id);
// console.log("change.before.id");
// console.log(change.before.id);
// console.log("superAdminUID");
// console.log(superAdminUID);
// console.log("context.auth?.uid");
// console.log(context.auth?.uid);
// console.log("context.authType");
// console.log(context.authType);
// console.log("ownerPhoneNumberBefore");
// console.log(ownerPreviousPhoneNumber);
// console.log("ownerPhoneNumberAfter");
// console.log(ownerCurrentPhoneNumber);