import * as express from 'express';
import {sdAuth} from '../lib/sd-auth';


class RoleService {
    handleRoleUpdate =  async (req: express.Request, res: express.Response) => {
    	const uid = `${  req.query.uid}`;
    	const role = `${  req.query.role}`;
    
    	if (!uid) {
    		res.status(400).end();
    		return;
    	}
    
    	if (!role) {
    		res.status(400).end();
    		return;
    	}
    
    	const auth = await sdAuth.getUser(uid);
    
    	if (!auth.email) {
    		console.error('no email address');
    		return;
    	}
    
    	if (!auth.displayName) {
    		console.error('no displayName');
    		return;
    	}
    
    	try {
    		await sdAuth.updateUser(uid, auth.email, auth.displayName, role);
    		res.status(204).end();
    	} catch (err) {
    		console.error(err);
    		res.status(500).end();
    	}
    }
}

export const roleService = new RoleService;