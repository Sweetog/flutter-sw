declare namespace Express {
    export interface Request {
       userId?: string
       uid?: string,
       source?: string
       amount?: number
       currency?: string
       email?: string
       name?: string
       email_verified?: boolean,
       role?: string,
       rawBody: any
    }
 }
 
 declare namespace auth {
    export interface UserRecord {
       foo?: string
    }
 }