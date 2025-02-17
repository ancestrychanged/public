import sqlite3
import os
from typing import Final
import logging

DB_PATH: Final = os.path.join(os.path.dirname(__file__), 'verification.db')

verified_users = {} # in-memory cache for verified users: {robloxuserid: telegramid}

def setup_database():
    """инициализирует бд sqlite и создает необходимые таблицы, если их нет"""
    try:
        with sqlite3.connect(DB_PATH) as conn:
            conn.execute("PRAGMA journal_mode = WAL;")
            c = conn.cursor()

            c.execute('''CREATE TABLE IF NOT EXISTS verifications (
                            telegram_id INTEGER PRIMARY KEY,
                            robloxuserid INTEGER NOT NULL,
                            accesscode TEXT NOT NULL UNIQUE,
                            time TEXT NOT NULL
                        )''')
            
            c.execute('''CREATE TABLE IF NOT EXISTS successful_verifications (
                            robloxuserid INTEGER PRIMARY KEY,
                            telegramid INTEGER NOT NULL
                        )''')

            c.execute('''CREATE TABLE IF NOT EXISTS used_codes (
                            accesscode TEXT PRIMARY KEY
                        )''')

            conn.commit()
            logging.info("бд готова")
    except Exception as e:
        logging.error(f"ошибка при настройке бд: {e}")


def load_verified_users():
    """загружает верифицированных пользователей из бд в кэш в памяти"""
    global verified_users
    try:
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()

            c.execute('SELECT robloxuserid, telegramid FROM successful_verifications')
            rows = c.fetchall()
            
            for robloxuserid, telegramid in rows:
                verified_users[robloxuserid] = telegramid

            logging.info("верифицированные пользователи загружены в кэш")
    except Exception as e:
        logging.error(f"ошибка при загрузке верифицированных пользователей: {e}")


def is_verified(user_id: int) -> bool:
    """
    проверяет, является ли пользователь верифицированным, путем запроса таблицы successful_verifications

    :param user_id: telegram id пользователя
    :return: true если верифицирован, false в противном случае
    """
    try:
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute('SELECT robloxuserid FROM successful_verifications WHERE telegramid = ?', (user_id,))
            row = c.fetchone()
            
            if row:
                logging.info(f"пользователь {user_id} верифицирован")
                return True
            else:
                logging.info(f"пользователь {user_id} не верифицирован")
                return False
    except Exception as e:
        logging.error(f"ошибка при проверке верификации пользователя {user_id}: {e}")
        return False


def check_code(accesscode: str) -> bool:
    """
    проверяет, действителен ли код доступа и не был ли он уже использован

    :param accesscode: код доступа (юзер получает его в плейсе роблокса)
    :return: true если действителен и не использован, false в противном случае
    """
    try:
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()

            # check if the access code exists in the codes table
            c.execute('SELECT robloxuserid FROM codes WHERE accesscode = ?', (accesscode,))
            row = c.fetchone()
            if not row:
                logging.info(f"код доступа '{accesscode}' не существует")
                return False

            # check if the access code has already been used
            c.execute('SELECT accesscode FROM used_codes WHERE accesscode = ?', (accesscode,))
            used = c.fetchone()
            if used:
                logging.info(f"код доступа '{accesscode}' уже был использован")
                return False

            logging.info(f"код доступа '{accesscode}' действителен и не использован")
            return True
    except Exception as e:
        logging.error(f"ошибка при проверке кода доступа '{accesscode}': {e}")
        return False


def roblox_id_exists(robloxuserid: int) -> bool:
    """
    проверяет, привязан ли ID юзера в роблоксе к уже верифицированному аккаунту телеграма

    :param robloxuserid: ID юзера в роблоксе
    :return: true если ID уже проверен, false в противном случае
    """
    try:
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute('SELECT telegramid FROM successful_verifications WHERE robloxuserid = ?', (robloxuserid,))
            row = c.fetchone()
            
            exists = row is not None
            logging.info(f"roblox_id_exists('{robloxuserid}') = {exists}")
            return exists
    except Exception as e:
        logging.error(f"ошибка при проверке существования ID в бд: {e}")
        return False


def verify_user(user_id: int, username: str, accesscode: str):
    """
    отмечает юзера как верифицированного и отмечает код доступа как использованный

    :param user_id: id юзера в телеграмек
    :param username: имя юзера в телеграме
    :param accesscode: код, использованный для верификации
    """
    try:
        logging.info(f"попытка верификации юзера '{username}' (тг ID: {user_id}) с кодом '{accesscode}'")

        with sqlite3.connect(DB_PATH) as conn:
            conn.execute("PRAGMA journal_mode = WAL;")
            c = conn.cursor()

            conn.execute('BEGIN TRANSACTION;')

            c.execute('SELECT accesscode FROM used_codes WHERE accesscode = ?', (accesscode,))
            if c.fetchone():
                logging.info(f"код '{accesscode}' уже был использован другим юзером")
                conn.execute('ROLLBACK;')
                return False

            c.execute('SELECT robloxuserid FROM verifications WHERE telegram_id = ?', (user_id,))
            row = c.fetchone()
            if not row:
                logging.warning(f"запись верификации не найдена для ID телеграма {user_id}")
                conn.execute('ROLLBACK;')
                return False
            robloxuserid = row[0]

            if roblox_id_exists(robloxuserid):
                logging.warning(f"ID юзера в роблоксе '{robloxuserid}' уже верифицирован с другим ID в телеграме")
                conn.execute('ROLLBACK;')
                return False

            c.execute('''INSERT OR REPLACE INTO successful_verifications (robloxuserid, telegramid)
                         VALUES (?, ?)''', (robloxuserid, user_id))

            c.execute('DELETE FROM verifications WHERE telegram_id = ?', (user_id,))

            c.execute('INSERT INTO used_codes (accesscode) VALUES (?)', (accesscode,))

            conn.commit()

            verified_users[robloxuserid] = user_id
            logging.info(f"юзер '{username}' (ID в телеграме: {user_id}) успешно верифицирован для ID в роблоксе '{robloxuserid}'")
            logging.info(f"обновленный кэш в памяти: {verified_users}")
            return True

    except sqlite3.IntegrityError as ie:
        logging.warning(f"ошибка целостности при верификации: {ie}")
        return False
    except Exception as e:
        logging.error(f"ошибка при верификации пользователя {user_id}: {e}")
        return False


def add_verification(telegram_id: int, robloxuserid: int, accesscode: str, time_str: str):
    """
    добавляет запись проверки в бд

    :param telegram_id: ID пользователя в телеграме
    :param robloxuserid: ID пользователя в роблоксе
    :param accesscode: код
    :param time_str: временная метка в виде строки
    """
    try:
        with sqlite3.connect(DB_PATH) as conn:
            c = conn.cursor()
            c.execute('''INSERT INTO verifications (telegram_id, robloxuserid, accesscode, time)
                         VALUES (?, ?, ?, ?)''', (telegram_id, robloxuserid, accesscode, time_str))
            conn.commit()
            logging.info(f"верификация добавлена: тг ID {telegram_id}, ID в роблоксе {robloxuserid}, код {accesscode}")
    except sqlite3.IntegrityError:
        logging.warning(f"код '{accesscode}' уже существует в бд верификации")
    except Exception as e:
        logging.error(f"ошибка при добавлении верификации: {e}")
