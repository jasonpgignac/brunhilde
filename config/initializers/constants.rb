PLATFORMS = ["Mac", "PC"]
DEPLOYMENT_STAGES = [0,1]
RULE_TYPES = ["ExecRunning","FileExists","Custom"]
DESCRIPTION_FOR_RULE_TYPE = {
  "ExecRunning" => "a running executable named",
  "FileExists"  => "a file at the path",
  "Custom"      => "a positive outcome to the custom test executable"
}
COMMAND_TYPES = ["wait","repeat","fatalerror","log","custom"]
DESCRIPTION_FOR_COMMAND_TYPE = {
  "wait"        => 'Wait for this many seconds:',
  "repeat"      => 'Loop back and test again this many times:',
  "fatalerror"  => 'Throw a fatal error:',
  "log"         => 'Write a message to the log:',
  "custom"      => 'Run the following executable:'
}