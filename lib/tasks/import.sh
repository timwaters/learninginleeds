#!/usr/bin/env bash
cd /home/tim/projects/learninginleeds
source  /home/tim/.rvm/environments/ruby-2.4.1@learninginleeds

RAILS_ENV=production bundle exec rake import:coursefinder
