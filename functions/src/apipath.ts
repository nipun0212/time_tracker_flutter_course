import admin = require("firebase-admin");
export const users = () => 'users';
export const usersRef = () => admin.firestore().doc('users');
export const user = (userUID: string) => `users/${userUID}`;
export const userRef = (userUID: string) => admin.firestore().doc(`users/${userUID}`);
export const userOTP = (userUID: string) => `users/${userUID}/private/otp`;
export const userOTPRef = (userUID: string) => admin.firestore().doc(`users/${userUID}/private/otp`);
export const userOrganizations = (userUID: string) => `users/${userUID}/organizations`;
export const userOrganizationsRef = (userUID: string,organizationID: string) => admin.firestore().doc(`users/${userUID}/organizations/${organizationID}`);
export const organizations = () => `organizations`;
export const organizationsRef = () => admin.firestore().doc(`organizations`);
export const organization = (organizationID: string) => `organizations/${organizationID}`;
export const organizationRef = (organizationID: string) => admin.firestore().doc(`organizations/${organizationID}`);
export const organizationUserRoles = (organizationID: string) => `organizations/${organizationID}/private/roles`;
export const organizationUserRolesRef = (organizationID: string) => admin.firestore().doc(`organizations/${organizationID}/private/roles`);


