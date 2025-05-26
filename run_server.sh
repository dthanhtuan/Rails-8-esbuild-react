#!/bin/bash

rm -f tmp/pids/server.pid && bundle && bin/rails server -b 0.0.0.0
