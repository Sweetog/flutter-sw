
import {sdAuth} from './lib/sd-auth';
import * as admin from 'firebase-admin';
admin.initializeApp();

const UID = 'SaKBp8JLRMdW2Zo2xrqYirYzEKg2'; //set this betch
const ROLE = 'employee';

const elevateRole = async () => {
    const auth = await sdAuth.getUser(UID);

    if (!auth.email) {
        console.error('no email address');
        return;
    }

    if (!auth.displayName) {
        console.error('no displayName');
        return;
    }



    try {
        await sdAuth.updateUser(UID, auth.email, auth.displayName, ROLE);
    } catch (err) {
        console.error(err);
    }
};


elevateRole();