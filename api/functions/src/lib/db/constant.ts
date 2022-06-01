import * as admin from 'firebase-admin';
const TABLE = 'constants';

class ConstantDb {
    get = async () => {
    	const snapShot = await admin.firestore().collection(TABLE).get();
    	return snapShot.docs[0].data();
    }
}

export const constantDb = new ConstantDb();