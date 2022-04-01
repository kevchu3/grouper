#!/bin/bash

### DO NOT EDIT OR OVERLAY THIS FILE
# These definitions are here to define the functions.
# You can overlay the grouperScriptHooks.sh file with any definitions of these functions

# called at the beginning of the container startup
# after logging is setup
grouperScriptHooks_prepConfPost() {
  return
}

# called after the component command has been prepped
grouperScriptHooks_prepComponentPost() {
  return
}

# called after the finishPrep is called before the setupFiles
grouperScriptHooks_finishPrepPost() {
  return
}

# called after the setupFiles functions is called, almost before the process starts
grouperScriptHooks_setupFilesPost() {
  return
}

# called after the chown at end of setupFiles, right before the process starts
grouperScriptHooks_setupFilesPostChown() {
  return
}

grouperScriptHooks_unsetAll() {

  unset -f grouperScriptHooks_finishPrepPost
  unset -f grouperScriptHooks_prepComponentPost
  unset -f grouperScriptHooks_prepConfPost
  unset -f grouperScriptHooks_setupFilesPost
  unset -f grouperScriptHooks_setupFilesPostChown
  unset -f grouperScriptHooks_unsetAll
  unset -f grouperScriptHooks_exportAll
}

grouperScriptHooks_exportAll() {

  export -f grouperScriptHooks_finishPrepPost
  export -f grouperScriptHooks_prepComponentPost
  export -f grouperScriptHooks_prepConfPost
  export -f grouperScriptHooks_setupFilesPost
  export -f grouperScriptHooks_setupFilesPostChown
  export -f grouperScriptHooks_unsetAll
  export -f grouperScriptHooks_exportAll
}

# export everything
grouperScriptHooks_exportAll

