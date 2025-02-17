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

commandName = 'exit'
ownerOnly = True
aliases = []
helpText = 'вы не можете использовать эту команду :)'
require_verification = False

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("вырубаем")
    await context.application.stop()