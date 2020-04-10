import admin = require("firebase-admin");
export const users = () => 'users';
export const usersRef = () => admin.firestore().doc('users');
export const user = (userUID: string) => `users/${userUID}`;
export const userRef = (userUID: string) => admin.firestore().doc(`users/${userUID}`);
export const userOTP = (userUID: string) => `users/${userUID}/private/otp`;
export const userOTPRef = (userUID: string) => admin.firestore().doc(`users/${userUID}/private/otp`);
export const userOrganizations = (userUID: string) => `users/${userUID}/organizations`;
export const userOrganizationsRef = (userUID: string, organizationId: string) => admin.firestore().doc(`users/${userUID}/organizations/${organizationId}`);
export const userCustomerOf = (userUID: string, organizationId: string) => `users/${userUID}/customerOf/${organizationId}`;
export const organizations = () => `organizations`;
export const organizationsRef = () => admin.firestore().doc(`organizations`);
export const organization = (organizationId: string) => `organizations/${organizationId}`;
export const organizationRef = (organizationId: string) => admin.firestore().doc(`organizations/${organizationId}`);
export const organizationUserRoles = (organizationId: string) => `organizations/${organizationId}/private/roles`;
export const organizationUserRolesRef = (organizationId: string) => admin.firestore().doc(`organizations/${organizationId}/private/roles`);
export const RewardSettings = (organizationId: string) => `organizations/${organizationId}/private/rewardSetting`;
export const RewardSettingsRef = (organizationId: string) => admin.firestore().doc(`organizations/${organizationId}/private/rewardSetting`);
export const billCounterTotal = (organizationId: string) => `organizations/${organizationId}/billCounter/total`;
export const billCounterTotalRef = (organizationId: string) => admin.firestore().doc(`organizations/${organizationId}/billCounter/total`);
export const billCounterCollection = (organizationId: string) => `organizations/${organizationId}/billCounter`;
export const billCounterCollectionRef = (organizationId: string) => admin.firestore().collection(`organizations/${organizationId}/billCounter`);
export const bill = (organizationId: string, billId: string) => `organizations/${organizationId}/bill/${billId}`;
export const customer = (organizationId: string, customerUID: string) => `organizations/${organizationId}/customers/${customerUID}`;
export const customers = (organizationId: string, customerUID: string) => `organizations/${organizationId}/customers`;


