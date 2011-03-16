/* MIT licensed */
// (c) 2011 OxygenComputing Inc.

function SuddenlybuntCmd() {
}


SuddenlybuntCmd.prototype.debug = function(msg) {
  PhoneGap.exec("SuddenlybuntCommand.debug", msg);
}

SuddenlybuntCmd.install = function() {
	if(!window.plugins) {
		window.plugins = {};
	}
	
	window.plugins.suddenlybuntCmd = new SuddenlybuntCmd();
	return window.plugins.suddenlybuntCmd;
}

