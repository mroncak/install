#!/bin/bash

for f in *.xls ; do xls2csv "$f" "${f%.xls}.csv" ; done

