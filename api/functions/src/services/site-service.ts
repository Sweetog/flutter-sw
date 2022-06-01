import * as express from 'express';
import {siteDb} from '../lib/db/site';
import {Job} from '../interfaces/job';
import {Inlet} from '../interfaces/inlet';
import {GeoPoint} from '@google-cloud/firestore';

class SiteService {
	handleCreate = async (req: express.Request, res: express.Response) => {
		const {name, address, state, zip, contact} = req.body;

		if (!name) {
			res.status(400).end();
			return;
		}

		if (!address) {
			res.status(400).end();
			return;
		}

		if (!state) {
			res.status(400).end();
			return;
		}

		if (!zip) {
			res.status(400).end();
			return;
		}

		if (!contact) {
			res.status(400).end();
			return;
		}

		try {

			var data = {
				name,
				address,
				state,
				zip,
				contact
			};

			const site = await siteDb.create(data);

			if (!site) {
				res.status(404).end();
				return;
			}

			res.status(200).json({id:site.id});
		} catch (err) {
			console.error(err);
			res.status(500).end();
		}
	}

	handleUpdate = async (req: express.Request, res: express.Response) => {
		const {id, name, address, state, zip, contact} = req.body;

		if (!id) {
			res.status(400).end();
			return;
		}

		if (!name) {
			res.status(400).end();
			return;
		}

		if (!address) {
			res.status(400).end();
			return;
		}

		if (!state) {
			res.status(400).end();
			return;
		}

		if (!zip) {
			res.status(400).end();
			return;
		}

		try {
			var data = {
				name,
				address,
				state,
				zip,
				contact
			};

			await siteDb.updateExceptInlets(id, data);
			res.status(204).json({});
		} catch (err) {
			console.error(err);
			res.status(500).end();
		}
	}

    handleGet = async (req: express.Request, res: express.Response) => {
    	const {id} = req.query;

    	if (!id) {
    		res.status(400).end();
    		return;
    	}
        
    	try {
    		const data = await siteDb.get(`${id}`);

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
    }

    handleGetAll = async (req: express.Request, res: express.Response) => {
    	try {
    		const docs = await siteDb.getAll();
    		if (!docs) {
    			console.warn('/jobs get SitesService.handleGetAll no sites', req.query.id);
    			res.status(404).end();
    			return;
    		}

    		const sites = docs.map(doc => {
    			const data = doc.data();
    			var ret: Job = {
    				id: doc.id,
    				address: data.address,
    				completedDate: data.completedDate,
    				location: data.location,
    				name: data.name,
    				startDate: data.startDate,
    				state: data.state,
    				zip: data.zip
    			};
    			return ret;
    		});

    		res.status(200).json(sites);
    	} catch (err) {
    		console.error(err);
    		res.status(500).end();
    	}
    }

	handleUpdateInletsOrder = async (req: express.Request, res: express.Response) => {
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
			const site = await siteDb.get(id);

			if (!site) {
				res.status(404).end();
				return;
			}


			site.inlets = inlets.map(inlet => ({...inlet, location: new GeoPoint(inlet.location.latitude, inlet.location.longitude)}));

			await siteDb.update(id, site);

			res.status(204).json({});
		} catch (err) {
			console.error(err);
			res.status(500).end();
		}
	}

	handleInletCreate = async (req: express.Request, res: express.Response) => {
		const {
			siteId, 
			beforeImgUrl, 
			afterImgUrl, 
			bmpId, 
			type, 
			location,
			service = null,
			material = null,
			volumeUsed = null
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
			const site = await siteDb.get(siteId);

			if (!site) {
				res.status(404).end();
				return;
			}


			if(!site.inlets)
				site.inlets = [];
				
			var inlet: Inlet = {
				beforeImgUrl,
				afterImgUrl,
				bmpId,
				type,
				location: new GeoPoint(location.latitude, location.longitude),
				service,
				material,
				volumeUsed
			};

			site.inlets.push(inlet);

			await siteDb.update(siteId, site);

			res.status(204).json({});
		} catch (err) {
			console.error(err);
			res.status(500).end();
		}
	}

	handleInletUpdate = async (req: express.Request, res: express.Response) => {
		const {
			siteId, 
			beforeImgUrl, 
			afterImgUrl, 
			bmpId, 
			type, 
			location, 
			inletIndex, 
			service = null, 
			material = null,
			volumeUsed = null
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
			const site = await siteDb.get(siteId);

			if (!site) {
				res.status(404).end();
				return;
			}


			if(!site.inlets || !site.inlets.length) {
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
				volumeUsed
			};

			site.inlets[inletIndex] = inlet;

			await siteDb.update(siteId, site);

			res.status(204).json({});
		} catch (err) {
			console.error(err);
			res.status(500).end();
		}
	}

}

export const siteService = new SiteService;