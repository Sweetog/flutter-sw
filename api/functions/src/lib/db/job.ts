import * as admin from 'firebase-admin';
const TABLE = 'jobs';

class JobDb {
  create = async (job: any) => admin.firestore().collection(TABLE).add(job);

  import = async (job: any) => admin.firestore().collection(TABLE).add(job);

  update = async (id: string, job: any) =>
  	admin.firestore().collection(TABLE).doc(id).update(job);

  updateStatus = async (id: string, status: any) =>
  	admin.firestore().collection(TABLE).doc(id).update({status});

  get = async (id: string) => {
  	const snapShot = await admin.firestore().collection(TABLE).doc(id).get();
  	return snapShot.data();
  };

  getAll = async () => {
  	//const today = admin.firestore.Timestamp.now();
  	const querySortByDate = admin.firestore().collection(TABLE);
  		// .orderBy('startDate', 'desc');
  	const snapShot = await querySortByDate.get();
  	//.where('startDate', '>=', today).get();
  	return snapShot.docs;
  };

  getAllIncomplete = async () => {
  	const querySortByDate = admin.firestore().collection(TABLE)
  		.where('status', '!=', 'Complete');

  	const snapShot = await querySortByDate.get();
  	return snapShot.docs;
  };

  getBySite = async (id: string) => {
  	const snapShot = await admin
  		.firestore()
  		.collection(TABLE)
  		.where('siteId', '==', id)
  		.get();
  	return snapShot.docs;
  };

  delete = async (id: string) =>
  	admin.firestore().collection(TABLE).doc(id).delete();
}

export const jobDb = new JobDb();
