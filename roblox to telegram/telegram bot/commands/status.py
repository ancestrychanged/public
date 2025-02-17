# commands/status.py

import sys
import os

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
libs_dir = os.path.join(parent_dir, 'libs')
if libs_dir not in sys.path:
    sys.path.append(libs_dir)

from telegram import Update
from telegram.ext import ContextTypes

from libs import verification
from libs import command_list

commandName = 'status'
ownerOnly = False
aliases = ['stat']
helpText = 'узнать, соединили ли вы телеграм с роблоксом или нет'
require_verification = False

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    try:
        user_id = update.effective_user.id
        if verification.is_verified(user_id):
            await update.message.reply_text("да, всё норм")
        else:
            await update.message.reply_text("не, вы не верифицированы")
    except Exception as e:
        await update.message.reply_text(f"всё плохо. пишите в поддержку немедленно https://t.me/n_everless ({e})")
        print(f"Error in /status command: {e}")
