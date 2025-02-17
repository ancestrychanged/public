
import sys
import os

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
libs_dir = os.path.join(parent_dir, 'libs')
if libs_dir not in sys.path:
    sys.path.append(libs_dir)

from libs import verification
from telegram import Update
from telegram.ext import ContextTypes

commandName = 'start'
ownerOnly = False
require_verification = False
aliases = []
helpText = 'стартуем'

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if verification.is_verified(update.effective_user.id):
        await update.message.reply_text("с возвращением!")
    else:
        await update.message.reply_text("привет! пройдите верификацию через \"/verify код\" чтобы пользоваться ботом")
