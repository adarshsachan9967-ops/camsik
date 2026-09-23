import fs from 'fs';
import path from 'path';
import { getDatabase } from '@/lib/mongodb';

export interface StoredUser {
  id: string;
  name: string;
  phone: string;
  email: string;
  passwordHash: string;
  createdAt: string;
}

const DATA_DIR = path.join(process.cwd(), 'data');
const USERS_FILE = path.join(DATA_DIR, 'registered_users.json');

function ensureDataFile(): void {
  try {
    if (!fs.existsSync(DATA_DIR)) {
      fs.mkdirSync(DATA_DIR, { recursive: true });
    }
    if (!fs.existsSync(USERS_FILE)) {
      fs.writeFileSync(USERS_FILE, JSON.stringify([]), 'utf-8');
    }
  } catch (err) {
    console.warn('Could not initialize local data file:', err);
  }
}

export function getLocalUsers(): StoredUser[] {
  ensureDataFile();
  try {
    const raw = fs.readFileSync(USERS_FILE, 'utf-8');
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

export function saveLocalUser(user: StoredUser): void {
  ensureDataFile();
  try {
    const existing = getLocalUsers();
    const updated = [
      user,
      ...existing.filter((u) => u.phone !== user.phone && u.email !== user.email),
    ];
    fs.writeFileSync(USERS_FILE, JSON.stringify(updated, null, 2), 'utf-8');
  } catch (err) {
    console.warn('Could not save user locally:', err);
  }
}

export async function findUserByIdentifier(identifier: string): Promise<StoredUser | null> {
  const cleanPhone = identifier.replace(/\D/g, '').slice(-10);
  const cleanEmail = identifier.trim().toLowerCase();

  // 1. Check local file
  const localList = getLocalUsers();
  const localMatch = localList.find(
    (u) =>
      u.phone === cleanPhone ||
      u.email.toLowerCase() === cleanEmail ||
      u.phone === identifier.trim()
  );
  if (localMatch) return localMatch;

  // 2. Check MongoDB
  try {
    const db = await getDatabase();
    const dbMatch = await db.collection('customers').findOne({
      $or: [{ phone: cleanPhone }, { email: cleanEmail }, { phone: identifier.trim() }],
    });
    if (dbMatch) {
      return {
        id: dbMatch.id || dbMatch._id?.toString(),
        name: dbMatch.name,
        phone: dbMatch.phone,
        email: dbMatch.email,
        passwordHash: dbMatch.passwordHash || '',
        createdAt: dbMatch.createdAt || new Date().toISOString(),
      };
    }
  } catch (err) {
    console.warn('MongoDB lookup warning:', err);
  }

  return null;
}
