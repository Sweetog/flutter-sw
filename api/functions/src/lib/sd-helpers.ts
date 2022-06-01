import * as express from 'express';
import { userDb } from './db/user';
import { sdAuth } from './sd-auth';

interface IClaims {
    role: string;
    courseId: string;
};

class SdHelpers {
    createUser = async (email: string, password: string, name: string, role: string) => {
        const uid = await sdAuth.createUser(email, password, name, role);
        return uid;
    }

    validE164 = (num: string) => {
        return /^\+?[1-9]\d{1,14}$/.test(num);
    }

    requestErrorLogger = (req: express.Request, message: string) => {
        const logObj = {
            userId: req.userId
        }

        console.error(message, logObj);
    }

    calculateCustomerBalance = (adjustmentAmount: number, currentBalance?: number | null) => {
        let balance = 0;
        if (currentBalance) {
            balance = currentBalance;
        }
        return balance + adjustmentAmount;
    }

    getUserDocAndAuth = async (userId: any) => {
        const auth = await sdAuth.getUser(userId);
        const uData = await userDb.getUser(userId);

        if (!uData) {
            return null;
        }

        const user = {
            userId: userId,
            phone: uData.phone,
            courseId: '',
            email: auth.email,
            role: 'null',
            accountBalance: uData.accountBalance
        }

        if (!auth.customClaims) {
            return user;
        }

        const claims = <IClaims>auth.customClaims;
        user.role = claims.role;
        user.courseId = claims.courseId;

        return user;
    }

    // Express middleware that validates Firebase ID Tokens passed in the Authorization HTTP header.
    // The Firebase ID token needs to be passed as a Bearer token in the Authorization HTTP header like this:
    // `Authorization: Bearer <Firebase ID Token>`.
    // when decoded successfully, the ID Token content will be added as `req.user`.
    middlewareValidateToken = async (req: any, res: any, next: any) => {
        //anonymous route checks
        if (req.hostname === 'localhost', req.path === '/role/' && req.method === 'GET') {
            return next();
        }

        if (req.hostname === 'localhost', req.path === '/user/' && req.method === 'GET') {
            return next();
        }
        
        if (req.path === '/user' && req.method === 'POST') {
            return next();
        }


        try {
            if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
                !(req.cookies && req.cookies.__session)) {
                console.error('No Firebase ID token was passed as a Bearer token in the Authorization header.',
                    'Make sure you authorize your request by providing the following HTTP header:',
                    'Authorization: Bearer <Firebase ID Token>',
                    'or by passing a "__session" cookie.');
                res.status(403).send('Unauthorized');
                return;
            }

            let idToken;
            if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
                // Read the ID Token from the Authorization header.
                idToken = req.headers.authorization.split('Bearer ')[1];
            } else if (req.cookies) {
                console.log('Found "__session" cookie');
                // Read the ID Token from cookie.
                idToken = req.cookies.__session;
            } else {
                // No cookie
                res.status(403).send('Unauthorized');
                return;
            }

            const decodedIdToken = await sdAuth.verifyToken(idToken);
            req.name = decodedIdToken.name;
            req.userId = decodedIdToken.user_id;
            req.email = decodedIdToken.email;
            req.email_verified = decodedIdToken.email_verified;
            req.role = decodedIdToken.role;
            req.courseId = decodedIdToken.courseId;
            // const userData = await swFirestore.getUser(decodedIdToken.user_id);
            // if (!userData) {
            //     return next();
            // }
            // req.stripeCustomerId = userData.stripeCustomerId;
            return next();
        }
        catch (err) {
            console.error('Error while verifying Firebase ID token:', err);
            res.status(403).send('Unauthorized');
        }
    }
}

export const sdHelpers = new SdHelpers();