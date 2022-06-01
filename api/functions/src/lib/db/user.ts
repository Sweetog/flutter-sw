import * as admin from 'firebase-admin';

class UserDb {
    getUser = async (userId: string) => {
    	const userSnapShot = await admin.firestore().collection('users').doc(userId).get();
    	return userSnapShot.data();
    }

    setUser = async (userId: string, phone?: string) => {
    	const vals = {
    		phone: (phone) ? phone : null,
    	};
    	return admin.firestore().collection('users').doc(userId).set(vals);
    }

    deleteUser = async (id: string) => admin.firestore().collection('users').doc(id).delete()
}

export const userDb = new UserDb();