# commands/verify.py

import sys
import os
import logging

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
libs_dir = os.path.join(parent_dir, 'libs')
if libs_dir not in sys.path:
    sys.path.append(libs_dir)

from telegram import Update
from telegram.ext import ContextTypes

from libs import verification
from libs import config

commandName = 'verify'
ownerOnly = False
aliases = ['verifycode', 'v']
helpText = 'команда: /verify <код> чтобы соеденить свой аккаунт с роблоксом\nкод можно получить из игры в роблоксе'
require_verification = False

import requests
from datetime import datetime
import re

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    try:
        telegram_id = update.effective_user.id
        username = update.effective_user.username or update.effective_user.first_name
        args = context.args

        if verification.is_verified(telegram_id):
            await update.message.reply_text("вы уже верифицированы")
            return

        if len(args) != 1:
            await update.message.reply_text('не вижу кода :(\nкоманда: /verify <код> (без треугольничков)')
            return

        accesscode = args[0]
        if not re.match(r'^\d{4}-[А-ЯЁ]{4}$', accesscode):
            await update.message.reply_text("неверный код")
            return

        if not verification.check_code(accesscode):
            await update.message.reply_text("код недействителен")
            return

        response = requests.get(f'{config.SERVER_URL}/validate', params={'accesscode': accesscode})
        if response.status_code != 200:
            await update.message.reply_text('ошибка соединения с сервером (E1)\nнапишите в поддержку: https://t.me/n_everless')
            logging.error(f"Server responded with status code {response.status_code} for access code validation")
            return

        data = response.json()

        if not data.get('valid'):
            await update.message.reply_text('неверный код (Е15)\nесли вы считаете, что это ошибка - напишите в поддержку: https://t.me/n_everless')
            return

        robloxuserid = data.get('robloxuserid')
        if not robloxuserid:
            await update.message.reply_text('неверный ответ от сервера\nнапишите в поддержку: https://t.me/n_everless')
            logging.error(f"No Roblox User ID returned for access code '{accesscode}'")
            return

        time_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        verification.add_verification(telegram_id, robloxuserid, accesscode, time_str)

        verification_success = verification.verify_user(telegram_id, username, accesscode)

        if not verification_success:
            await update.message.reply_text("ошибка при верификации\nвозможно, этот код уже использован")
            return

        await update.message.reply_text('всё окей! аккаунт успешно связан, можете возвращаться в роблокс')

    except requests.exceptions.RequestException as req_err:
        await update.message.reply_text('произошла сетевая ошибка\nопробуйте позже, или напишите в поддержку: https://t.me/n_everless')
        logging.error(f"Network error during verification: {req_err}")

    except Exception as e:
        await update.message.reply_text('произошла неожиданная ошибка\nопробуйте позже, или напишите в поддержку: https://t.me/n_everless')
        logging.error(f"Unexpected error in /verify command: {e}")
