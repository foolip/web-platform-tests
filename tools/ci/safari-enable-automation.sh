#!/bin/bash

# This script ensures that the "Enable Remote Automation" feature of Apple
# Safari is enabled. If it is not enabled, it attempts to do so using Apple's
# UI scripting language. If this fails, the script exits with a non-zero exit
# code.
#
# While the `safaridriver` binary offers an `--enable` flag [1], that feature
# alone is not sufficient to enable remote automation in fully-automated
# contexts.
#
# [1]  https://developer.apple.com/documentation/webkit/testing_with_webdriver_in_safari

set -e

if [ $1 == "stable" ]; then
  browser_name="Safari"
  safaridriver_binary="/usr/bin/safaridriver"
else
  browser_name="Safari Technology Preview"
  safaridriver_binary="/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver"
fi

toggle_automation() {
  echo Toggling automation in Safari

  osascript - <<SCRIPT
  set developCheckboxLabel to "Show Develop menu in menu bar"
  set applicationName to "$browser_name"

  activate application applicationName

  tell application "System Events"
      set ready to false

      repeat while not ready
          repeat with this_process in every process
              if name of this_process as string is applicationName then
                  set ready to true
              end if
          end repeat
      end repeat

      -- If Apple offers a version of Safari Technology Preview which is newer than
      -- the one under test, the browser will create a modal dialog shortly after
      -- opening. The following block pauses execution until this prompt is expected
      -- to be available. This delay represents an unavoidable race condition as
      -- there is no deterministic method to verify that the prompt will *not* be
      -- displayed.
      tell process applicationName
          log "Waiting for upgrade prompt..."
          delay 2

          repeat with current_window in every window
              if exists button "Not Now" of current_window then
                  log "Found upgrade prompt. Dismissing."
                  click button "Not Now" of current_window
                  exit repeat
              end if
          end repeat

          -- Enable the "Develop" menu
          click menu item "Preferences…" of menu applicationName of menu bar item applicationName of menu bar 1

          -- The window title varies according to type of Prefs initially
          -- selected, so save to a variable
          set currentWindowName to get value of static text 1 of window 1 as string

          click button "Advanced" of toolbar 1 of window currentWindowName
          tell group 1 of group 1 of window "Advanced"
              set checkbox_state to value of checkbox developCheckboxLabel as number

              if checkbox_state = 0 then
                  click checkbox developCheckboxLabel
              end if
          end tell

          -- Close the menu
          click button 1 of window "Advanced"

          click menu item "Allow Remote Automation" of menu "Develop" of menu bar item "Develop" of menu bar 1
      end tell
  end tell

  tell application applicationName to quit
SCRIPT
}

if ! is_automation_enabled; then
  echo Automation not enabled. Attempting to enable. >&2
  toggle_automation >&2

  # This command has been found to function as expected only *after* automation
  # has been enabled via the Safari user interface.
  "$safaridriver_binary" --enable >&2
fi

if ! is_automation_enabled; then
  echo Unable to enable automation >&2
  exit 1
fi

echo $safaridriver_binary
