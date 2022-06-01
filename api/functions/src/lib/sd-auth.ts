
import * as admin from 'firebase-admin';

class SdAuth {
    getUserByEmail = async (email: string) => {
    	try {
    		return await admin.auth().getUserByEmail(email);
    	} catch (error) {
    		return null;
    	}
    }

    getUser = async (userId: string) => admin.auth().getUser(userId)

    verifyToken = async (token: string) => admin.auth().verifyIdToken(token)

    listUsers = async (pageSize: number, nextPageToken?: any) => {
    	const users: any[] = [];
    	const result = await admin.auth().listUsers(pageSize, nextPageToken);
    	result.users.forEach(user => {
    		users.push(user.toJSON());
    	});
    	return {users, nextPageToken: result.pageToken};
    }

    deleteUser = async (uid: string) => admin.auth().deleteUser(uid)

    createUser = async (email: string, password: string, name: string, role: string) => {
    	const userData = {
    		email,
    		emailVerified: false,
    		password,
    		displayName: name,
    		disabled: false
    	};
    	const result = await admin.auth().createUser(userData);

    	const claims = {
    		role
    	};

    	await admin.auth().setCustomUserClaims(result.uid, claims);
    	return result.uid;
    }

    updateUser = async (uid: string, email: string, name: string, role: string) => {
    	const userData = {
    		email,
    		displayName: name,
    	};

    	await admin.auth().updateUser(uid, userData);

    	const claims = {
    		role
    	};

    	return admin.auth().setCustomUserClaims(uid, claims);
    }
}

export const sdAuth = new SdAuth();