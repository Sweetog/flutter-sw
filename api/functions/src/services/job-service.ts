import * as express from 'express';
import {jobDb} from '../lib/db/job';
import {siteDb} from '../lib/db/site';
import {Job} from '../interfaces/job';
import * as admin from 'firebase-admin';
import {Inlet} from '../interfaces/inlet';
import {GeoPoint} from '@google-cloud/firestore';

const startDateComparator = (a: Job, b: Job) => {
	if(a.startDate < b.startDate)
		return -1; //sort a before b
	if(b.startDate < a.startDate)
		return 1; //sort b before A
	return 0;
};

class JobService {
  updateJobStatus = async (req: express.Request, res: express.Response) => {
  	const {id, status} = req.body;

  	if (id === null || status === null) {
  		console.warn('/jobs can not update', req.query.id);
  		res.status(404).end();
  		return;
  	}

  	await jobDb.updateStatus(id, status);
  	res.status(200).end();
  };

  handleGetAll = async (req: express.Request, res: express.Response) => {
  	try {
  		const docs = await jobDb.getAll();
  		if (!docs) {
  			console.warn(
  				'/jobs get JobsService.handleGetAll no jobs',
  				req.query.id
  			);
  			res.status(404).end();
  			return;
  		}

  		const jobs = docs.map(doc => {
  			const data = doc.data();
  			var ret: Job = {
  				id: doc.id,
  				address: data.address,
  				completedDate: data.completedDate,
  				location: data.location,
  				name: data.name,
  				startDate: data.startDate,
  				state: data.state,
  				zip: data.zip,
  				Route: data.Route,
  				serviceCode: data.serviceCode,
  				serviceNote: data.serviceNote,
		  status: data.status,
  			};
  			return ret;
  		});

  		res.status(200).json(jobs.sort(startDateComparator).reverse()); //sorted by startDate descending
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };


  handleGetIncomplete = async (req: express.Request, res: express.Response) => {
  	try {
  		const docs = await jobDb.getAllIncomplete();
  		if (!docs) {
  			console.warn(
  				'/jobs get JobsService.handleGetAll no jobs',
  				req.query.id
  			);
  			res.status(404).end();
  			return;
  		}

  		const jobs = docs.map(doc => {
  			const data = doc.data();
  			var ret: Job = {
  				id: doc.id,
  				address: data.address,
  				completedDate: data.completedDate,
  				location: data.location,
  				name: data.name,
  				startDate: data.startDate,
  				state: data.state,
  				zip: data.zip,
  				Route: data.Route,
  				serviceCode: data.serviceCode,
  				serviceNote: data.serviceNote,
  				status: data.status,
  			};
  			return ret;
  		});

  		res.status(200).json(jobs.sort(startDateComparator).reverse()); //sorted by startDate descending
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleGetJobsBySiteId = async (
  	req: express.Request,
  	res: express.Response
  ) => {
  	const {id} = req.query;

  	if (!id) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const docs = await jobDb.getBySite(`${id}`);
  		if (!docs) {
  			console.warn(
  				'/jobs get JobsService.handleGetJobsBySiteId no jobs',
  				req.query.id
  			);
  			res.status(404).end();
  			return;
  		}

  		const jobs = docs.map(doc => {
  			const data = doc.data();
  			var ret: Job = {
  				id: doc.id,
  				address: data.address,
  				completedDate: data.completedDate,
  				location: data.location,
  				name: data.name,
  				startDate: data.startDate,
  				state: data.state,
  				zip: data.zip,
  			};
  			return ret;
  		});

  		res.status(200).json(jobs);
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleCreateJob = async (req: express.Request, res: express.Response) => {
  	const {siteId} = req.body;

  	if (!siteId) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const siteData = await siteDb.get(`${siteId}`);
  		if (!siteData) {
  			console.warn(
  				`/jobs get JobsService.handleCreateJob no side for siteId: ${siteId}`,
  				req.query.id
  			);
  			res.status(404).end();
  			return;
  		}

  		//add startDate and siteId
  		siteData.siteId = siteId;
  		siteData.startDate = admin.firestore.Timestamp.now();

  		const job = await jobDb.create(siteData);

  		if (!job) {
  			res.status(404).end();
  			return;
  		}

  		res.status(200).json({id: job.id});
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleImportedJob = async (req: express.Request, res: express.Response) => {
  	const jobData = req.body;

  	if (!jobData) {
  		res.status(400).end();
  		return;
  	}
    
  	//this isn't working Date is 12/28/1899 in the datebase
  	// jobData.startDate is NOT null either, bad date format being sent in or something
  	// jobData.startDate = admin.firestore.Timestamp.fromDate(
  	// 	new Date(jobData.startDate) MAYBE SOME STRING PARSING NEEDS DONE FIRST
  	// );
  	jobData.startDate = admin.firestore.Timestamp.now();
  	jobData.status = 'In progress'; //DO NOT CHANGE THIS, "In progress" is tied to mobile app dropdown list

  	const job = await jobDb.import(jobData);

  	if (!job) {
  		res.status(404).end();
  		return;
  	}
  	res.status(200).json({id: job.isEqual});
  };

  handleInletCreate = async (req: express.Request, res: express.Response) => {
  	const {
  		jobId,
  		beforeImgUrl,
  		afterImgUrl,
  		bmpId,
  		type,
  		location,
  		service = null,
  		material = null,
  		volumeUsed = null,
  	} = req.body;

  	if (!beforeImgUrl) {
  		res.status(400).end();
  		return;
  	}

  	if (!type) {
  		res.status(400).end();
  		return;
  	}

  	if (!location) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const job = await jobDb.get(jobId);

  		if (!job) {
  			res.status(404).end();
  			return;
  		}

  		if (!job.inlets) job.inlets = [];

  		var inlet: Inlet = {
  			beforeImgUrl,
  			afterImgUrl,
  			bmpId,
  			type,
  			location: new GeoPoint(location.latitude, location.longitude),
  			service,
  			material,
  			volumeUsed,
  		};

  		job.inlets.push(inlet);

  		await jobDb.update(jobId, job);

  		res.status(204).json({});
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleUpdateInletsOrder = async (
  	req: express.Request,
  	res: express.Response
  ) => {
  	const {id, inlets} = req.body;

  	if (!id) {
  		res.status(400).end();
  		return;
  	}

  	if (!inlets || !inlets.length) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const job = await jobDb.get(id);

  		if (!job) {
  			res.status(404).end();
  			return;
  		}

  		job.inlets = inlets.map(inlet => ({
  			...inlet,
  			location: new GeoPoint(
  				inlet.location.latitude,
  				inlet.location.longitude
  			),
  		}));

  		await jobDb.update(id, job);

  		res.status(204).json({});
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleGet = async (req: express.Request, res: express.Response) => {
  	const {id} = req.query;

  	if (!id) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const data = await jobDb.get(`${id}`);

  		if (!data) {
  			res.status(404).end();
  			return;
  		}

  		data.id = id;
  		res.status(200).json(data);
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleDeleteJob = async (req: express.Request, res: express.Response) => {
  	const {id} = req.body;

  	console.log('dbg-handleDeleteJob', id);
  	if (!id) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		await jobDb.delete(id);
  		res.status(204).json({});
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };

  handleInletUpdate = async (req: express.Request, res: express.Response) => {
  	const {
  		jobId,
  		beforeImgUrl,
  		afterImgUrl,
  		bmpId,
  		type,
  		location,
  		inletIndex,
  		service = null,
  		material = null,
  		volumeUsed = null,
  	} = req.body;

  	if (!beforeImgUrl) {
  		res.status(400).end();
  		return;
  	}

  	if (!type) {
  		res.status(400).end();
  		return;
  	}

  	if (!location) {
  		res.status(400).end();
  		return;
  	}

  	if (inletIndex === null || inletIndex === undefined) {
  		res.status(400).end();
  		return;
  	}

  	try {
  		const job = await jobDb.get(jobId);

  		if (!job) {
  			res.status(404).end();
  			return;
  		}

  		if (!job.inlets || !job.inlets.length) {
  			res.status(404).end();
  			return;
  		}

  		var inlet: Inlet = {
  			beforeImgUrl,
  			afterImgUrl,
  			bmpId,
  			type,
  			location: new GeoPoint(location.latitude, location.longitude),
  			service,
  			material,
  			volumeUsed,
  		};

  		job.inlets[inletIndex] = inlet;

  		await jobDb.update(jobId, job);

  		res.status(204).json({});
  	} catch (err) {
  		console.error(err);
  		res.status(500).end();
  	}
  };
}

export const jobService = new JobService();
