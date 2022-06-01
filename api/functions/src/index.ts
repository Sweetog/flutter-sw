import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as cors from 'cors';
import {sdHelpers} from './lib/sd-helpers';
import {userService} from './services/user-service';
import {roleService} from './services/role-service';
import {jobService} from './services/job-service';
import {siteService} from './services/site-service';
import {contantService} from './services/contant-service';
//import { inletService } from './services/inlet-service';

//options for cors midddleware
const options: cors.CorsOptions = {
	allowedHeaders: [
		'X-ACCESS_TOKEN',
		'Access-Control-Allow-Origin',
		'Authorization',
		'Origin',
		'x-requested-with',
		'Content-Type',
		'Content-Range',
		'Content-Disposition',
		'Content-Description',
	],
	credentials: true,
	methods: 'GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE',
	origin: [
		'http://macog.local:5001',
		'http://localhost:5001',
		'https://app.sdstormwater.com',
		'http://10.0.2.2:5001',
		'http://localhost:50000',
		'https://stormwater-c643b.web.app',
	],
	preflightContinue: false,
};

admin.initializeApp();
const app = express();

const corsOpts = cors(options);

//add cors middleware
app.use(corsOpts);

//enable pre-flight, allow OPTIONS on all resources
app.options('*', corsOpts);

// [START Middleware]

app.use(sdHelpers.middlewareValidateToken);

// [END Middleware]

// [START Express LIVE App]

//***************API functions*********************** */

// [START users]
app.get('/user', async (req, res) => {
	await userService.handleGetUser(req, res);
});

app.delete('/user', async (req, res) => {
	await userService.handleUserDelete(req, res);
});

app.post('/user', async (req, res) => {
	await userService.handleCreateUser(req, res);
});

app.put('/user', async (req, res) => {
	await userService.handleUserUpdate(req, res);
});
// [END users]

// [START role]
app.get('/role', async (req, res) => {
	await roleService.handleRoleUpdate(req, res);
});
// [END role]

// [START jobs]
app.get('/job', async (req, res) => {
	await jobService.handleGet(req, res);
});

app.get('/jobs', async (req, res) => {
	await jobService.handleGetAll(req, res);
});

app.get('/jobs/incomplete', async (req, res) => {
	await jobService.handleGetIncomplete(req, res);
});


app.get('/jobs/site', async (req, res) => {
	await jobService.handleGetJobsBySiteId(req, res);
});

app.post('/job', async (req, res) => {
	await jobService.handleCreateJob(req, res);
});

app.post('/job/import', async (req, res) => {
	await jobService.handleImportedJob(req, res);
});

app.put('/job', async (req, res) => {
	await jobService.updateJobStatus(req, res);
});

app.delete('/job', async (req, res) => {
	await jobService.handleDeleteJob(req, res);
});

app.put('/job/inlet', async (req, res) => {
	await jobService.handleInletUpdate(req, res);
});

app.put('/job/inlets', async (req, res) => {
	await jobService.handleUpdateInletsOrder(req, res);
});

app.post('/job/inlet', async (req, res) => {
	await jobService.handleInletCreate(req, res);
});

// [END jobs]

// [START sites]
app.post('/site', async (req, res) => {
	await siteService.handleCreate(req, res);
});

app.put('/site', async (req, res) => {
	await siteService.handleUpdate(req, res);
});

app.get('/site', async (req, res) => {
	await siteService.handleGet(req, res);
});

app.get('/sites', async (req, res) => {
	await siteService.handleGetAll(req, res);
});

app.post('/site/inlet', async (req, res) => {
	await siteService.handleInletCreate(req, res);
});

app.put('/site/inlets', async (req, res) => {
	await siteService.handleUpdateInletsOrder(req, res);
});

app.put('/site/inlet', async (req, res) => {
	await siteService.handleInletUpdate(req, res);
});
// [END sites]

// [START constants]
app.get('/constants', async (req, res) => {
	await contantService.handleGet(req, res);
});
// [END constants]

// [START inlets]
// app.post('/inlet', async (req, res) => {
// 	await inletService.handleCreate(req, res);
// });
// [END inlets]

//Expose Express API as a single Cloud Function:
exports.app = functions.https.onRequest(app);

// [END Express LIVE App]
