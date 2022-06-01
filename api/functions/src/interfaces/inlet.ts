import {GeoPoint} from '@google-cloud/firestore';

export interface Inlet {
    beforeImgUrl: string, 
    afterImgUrl: string, 
    bmpId: string, 
    type: string, 
    location: GeoPoint,
    service?: any,
    material?: any,
    volumeUsed?: number
}