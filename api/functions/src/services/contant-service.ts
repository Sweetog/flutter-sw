import * as express from 'express';
import {constantDb} from '../lib/db/constant';

class ConstantService {
    handleGet = async (req: express.Request, res: express.Response) => {
    	try {
    		const doc = await constantDb.get();
    		if (!doc) {
    			console.warn('/contants get ConstantService.handleGet no constants');
    			res.status(404).end();
    			return;
    		}

    		res.status(200).json(doc);
    	} catch (err) {
    		console.error(err);
    		res.status(500).end();
    	}
    }
}

export const contantService = new ConstantService;