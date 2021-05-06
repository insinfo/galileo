#!/usr/bin/env bash
set -e
pub run test --timeout 5s
GALILEO_ENV=production pub run test --timeout 5s
