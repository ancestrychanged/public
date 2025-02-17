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
import sqlite3

commandName = 'addcodes'
ownerOnly = True
require_verification = False
aliases = []
helpText = 'вы не можете использовать эту команду :)'
# /addcodes <code1> <code2> ...

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    codes = context.args
    if not codes:
        await update.message.reply_text("where code")
        return

    conn = sqlite3.connect("verification.db")
    cursor = conn.cursor()
    cursor.executemany(
        "INSERT OR IGNORE INTO codes (code) VALUES (?)",
        [(code,) for code in codes]
    )
    conn.commit()
    conn.close()
    
    await update.message.reply_text(f"добавлен(-о) {len(codes)} код(-ов/-а)")
