from flask import Flask
from flask import request
from flask import Flask
import subprocess
import os

app = Flask(__name__)

@app.route('/api/reqhand', methods=['POST'])
def blogrefresh():
    script_path = "~/somewhere_sh_placed/rebuildlat.sh"
    subprocess.call([os.path.expanduser(script_path)])
    return "Success"

if __name__ == "__main__":
    app.run(host='0.0.0.0') #place your server ip here.
