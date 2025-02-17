# core.py

import os
import re
import sys
import importlib.util
import logging

from typing import Final
from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes

from libs import verification
from libs import config
from libs import command_list

current_dir = os.path.abspath(os.path.dirname(__file__))
libs_dir = os.path.join(current_dir, 'libs')
sys.path.append(libs_dir)
owner_filter = filters.User(user_id=config.owner_id)

class VerifiedUserFilter(filters.BaseFilter):
    async def filter(self, message):
        user_id = message.from_user.id
        return verification.is_verified(user_id)

verified_user_filter = VerifiedUserFilter()

logging.basicConfig(level=logging.WARNING)

with open("token.txt", "r") as file:
    token: Final = file.read().strip()

username: Final = "@testingrobloxbot"

async def verify_command_with_quotes(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    # проверка на долбоёба
    logging.info("сообщение: %s", update.message.text)

    match = re.match(r'^"/verify\s+(.+)"$', update.message.text)
    if match:
        await update.message.reply_text(f"вы забрыли убрать кавычки! пишите вот так:\n/verify код")


def load_commands(app):
    commands_dir = os.path.join(os.path.dirname(__file__), 'commands')
    for filename in os.listdir(commands_dir):
        if filename.endswith('.py') and not filename.startswith('__'):
            # setup for the help.py cmd
            filepath = os.path.join(commands_dir, filename)
            module_name = os.path.splitext(filename)[0]
            spec = importlib.util.spec_from_file_location(module_name, filepath)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)

            if libs_dir not in sys.path:
                sys.path.append(libs_dir)

            # attributes for the help.py cmd
            command_name = getattr(module, 'commandName', None)
            owner_only = getattr(module, 'ownerOnly', False)
            require_verification = getattr(module, 'require_verification', True)
            aliases = getattr(module, 'aliases', [])
            callback = getattr(module, 'callback', None)
            help_text = getattr(module, 'helpText', '')

            if command_name and callback:
                commands_list = [command_name] + aliases

                if owner_only:
                    filters_to_apply = owner_filter
                elif require_verification:
                    filters_to_apply = verified_user_filter
                else:
                    filters_to_apply = None

                handler = CommandHandler(commands_list, callback, filters=filters_to_apply)
                app.add_handler(handler)
                logging.info(f"loaded command: {command_name} (aliases: {aliases})")

                command_list.commands_info[command_name] = {
                    'helpText': help_text,
                    'aliases': aliases,
                    'ownerOnly': owner_only,
                    'require_verification': require_verification
                }
            else:
                logging.warning(f"module {module_name} is missing required attributes")

if __name__ == '__main__':
    verification.setup_database()
    verification.load_verified_users()
    
    app = Application.builder().token(token).build()
    load_commands(app)

    verify_handler = MessageHandler(filters.TEXT & filters.Regex(r'^"/verify\s+.+?"$'), verify_command_with_quotes)
    app.add_handler(verify_handler)

    print('бот активен')
    app.run_polling(poll_interval=3)
