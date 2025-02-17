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
from libs import config

commandName = 'name' 
ownerOnly = False
aliases = ['alias 1', 'alias 2']
helpText = 'информация как использовать команду'
require_verification = True # всегда должно быть True

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    try:
        user_id = update.effective_user.id
        args = context.args 

        # send message back
        await update.message.reply_text(f"всё норм, аргументы: {' '.join(args)}")
    except Exception as e:
        await update.message.reply_text(f"ошибка: {e}")
