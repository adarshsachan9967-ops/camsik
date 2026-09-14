import { MongoClient, MongoClientOptions, Db, Collection, Document } from 'mongodb';

const uri = process.env.MONGODB_URI || 'mongodb+srv://adarshsachan9967_db_user:aQCPwwzcilQGVHhU@camsik.oxiqz3o.mongodb.net';
const dbName = process.env.MONGODB_DB_NAME || 'casmik';

const options: MongoClientOptions = {
  maxPoolSize: 10,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
};

let client: MongoClient;
let clientPromise: Promise<MongoClient>;

declare global {
  // eslint-disable-next-line no-var
  var _mongoClientPromise: Promise<MongoClient> | undefined;
}

if (!uri) {
  throw new Error('Please define the MONGODB_URI environment variable inside .env');
}

if (process.env.NODE_ENV === 'development') {
  // In development mode, use a global variable so that the value
  // is preserved across module reloads caused by HMR (Hot Module Replacement).
  if (!global._mongoClientPromise) {
    client = new MongoClient(uri, options);
    global._mongoClientPromise = client.connect();
  }
  clientPromise = global._mongoClientPromise;
} else {
  // In production mode, it's best to not use a global variable.
  client = new MongoClient(uri, options);
  clientPromise = client.connect();
}

/**
 * Returns the connected MongoDB database instance.
 * Defaults to the database name configured in MONGODB_DB_NAME ('casmik').
 */
export async function getDatabase(customDbName?: string): Promise<Db> {
  const connectedClient = await clientPromise;
  return connectedClient.db(customDbName || dbName);
}

/**
 * Returns a typed MongoDB collection from the Casmik database.
 */
export async function getCollection<T extends Document = Document>(collectionName: string): Promise<Collection<T>> {
  const db = await getDatabase();
  return db.collection<T>(collectionName);
}

export default clientPromise;
