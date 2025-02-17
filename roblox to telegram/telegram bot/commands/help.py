import sys
import os

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
libs_dir = os.path.join(parent_dir, 'libs')
if libs_dir not in sys.path:
    sys.path.append(libs_dir)

from libs import verification
from libs import command_list
from libs import config

from telegram import Update
from telegram.ext import ContextTypes

commandName = 'help'
ownerOnly = False
require_verification = True
aliases = []
helpText = 'даёт информацию какие команды есть и как их использовать'

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_id = update.effective_user.id

    if not verification.is_verified(user_id):
        await update.message.reply_text("вы ещё не связали аккаунт с роблоксом! команда: /verify <код>")
        return

    help_messages = []
    for cmd_name, cmd_info in command_list.commands_info.items():
        if cmd_info['ownerOnly'] and user_id != config.owner_id:
            continue

        aliases = ', '.join(cmd_info['aliases']) if cmd_info['aliases'] else 'no aliases'
        help_text = cmd_info['helpText']
        help_messages.append(f"/{cmd_name} - {help_text}\naliases: {aliases}")

    if help_messages:
        help_text_full = "\n\n".join(help_messages)
        await update.message.reply_text(help_text_full)
    else:
        await update.message.reply_text("всё плохо. пишите в поддержку немедленно https://t.me/n_everless")
