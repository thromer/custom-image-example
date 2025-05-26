#!/usr/bin/env python

import flask
import sys

print('main.py', file=sys.stderr)

app = flask.Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
@app.route('/<path:path>', methods=['GET', 'POST'])
def main(path=''):
    # flask.request is the current request object
    return 'response\n'

if __name__ == "__main__":
    import os
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
