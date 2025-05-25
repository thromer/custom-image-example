#!/usr/bin/env python

import flask

app = flask.Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
@app.route('/<path:path>', methods=['GET', 'POST'])
def main(path=''):
    # flask.request is the current request object
    return 'response\n'

if __name__ == '__main__':
    print('ok')
