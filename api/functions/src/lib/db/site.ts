import * as admin from 'firebase-admin';
const TABLE = 'sites';

class SiteDb {
    create = async (site:any) => admin.firestore().collection(TABLE).add(site);

	update = async (id: string, site: any) => admin.firestore().collection(TABLE).doc(id).update(site);

	updateExceptInlets = async (id: string, site:any) => {
		const clone = {...site};
		const cur = await (await admin.firestore().collection(TABLE).doc(id).get()).data();
		if(cur === null){
			console.error(`site does not exist!: ${id}`);
			return;
		}
		clone.inlets = cur?.inlets;
    	return admin.firestore().collection(TABLE).doc(id).update(clone);
	}

    get = async (id: string) => {
    	const snapShot = await admin.firestore().collection(TABLE).doc(id).get();
    	return snapShot.data();
    }

    getAll = async () => {
    	const snapShot = await admin.firestore().collection(TABLE).get();
    	return snapShot.docs;
    }

	getJobs

}

export const siteDb = new SiteDb();