#!/bin/bash
# A bot to run ledger-autosync and submit PR with results.
# Copyright (C) 2017 Scott Weldon
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ -z "$FILE" ]
then
  echo "Error: file not defined."
  exit 1
fi

if [ -z "$OUTFILE" ]
then
  echo "Error: outfile not defined."
  exit 2
fi

if [ -z "$UNKNOWN" ]
then
  UNKNOWN="Expenses:Unknown"
fi

# Optionally allow adding given tag/value to all transactions.
tag='/[0-9][0-9][0-9][0-9]\/[0-9][0-9]\/[0-9][0-9].*/a\ \ \ \ ;; '$TAG': '$TAGVAL
function tag() {
  if [ -z "$TAG" ] || [ -z "$TAGVAL" ]
  then
    cat
  else
    sed "$tag"
  fi
}

flip_neg='s/-\$/\$-/g'
double_comment='s/^    ;/    ;;/'
empty_line='/^$/d'

git checkout autobot-updates

ledger-autosync -l $FILE --unknown-account "$UNKNOWN" | sed "$flip_neg" | sed "$double_comment" | sed "$empty_line" | tag >> $OUTFILE

git-sync
