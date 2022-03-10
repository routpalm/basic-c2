import socket, os
import aiohttp, asyncio

async def update():
    async with aiohttp.ClientSession() as session:
        async with session.get('http://127.0.0.1/initialize/sequence/0') as check:
            if (await check.text() != "OK"):
                quit()
        async with session.get('http://127.0.0.1/') as getcmds:
            
