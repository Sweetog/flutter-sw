import * as express from 'express';
import { sdAuth } from '../lib/sd-auth';
import { userDb } from '../lib/db/user'
import { sdHelpers } from '../lib/sd-helpers';

interface IClaims {
    role: string;
};

class UserService {
    handleGetUser = async (req: express.Request, res: express.Response) => {
        const uid = '' + req.query.uid;

        if (!uid) {
            res.status(400).end();
            return;
        }

        try {
            const auth = await sdAuth.getUser(uid);

            if (!auth) {
                res.status(404).end();
                return;
            }

            const user = {
                userId: uid,
                email: auth.email,
                role: 'null'
            }

            if (!auth.customClaims) {
                res.status(200).json(user);
                return;
            }

            const claims = <IClaims>auth.customClaims;
            user.role = claims.role;

            res.status(200).json(user);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleCreateUser = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const email = req.body.email;
        const password = req.body.password
        const name = req.body.name;
        const role = req.body.role;

        if (!email) {
            res.status(400).end();
            return;
        }

        if (!password) {
            res.status(400).end();
            return;
        }

        if (!role) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        try {
            await sdHelpers.createUser(email, password, name, role);
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUserUpdate = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const uid = req.body.uid;
        const email = req.body.email;
        //const phone = req.body.phone;
        const name = req.body.name;
        const role = req.body.role;

        if (!uid) {
            res.status(400).end();
            return;
        }

        if (!email) {
            res.status(400).end();
            return;
        }


        if (!role) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        try {
            await sdAuth.updateUser(uid, email, name, role);
            //await swFirestore.setUser(uid, phone);
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUserDelete = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const id = req.body.id;

        if (!id) {
            res.status(400).end();
            return;
        }

        try {
            await userDb.deleteUser(id);
            await sdAuth.deleteUser(id);
            console.log('delete user complete');
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const userService = new UserService;