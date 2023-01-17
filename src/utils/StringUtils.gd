extends Node
class_name StringUtils

static func get_date_time_string():
	var time = OS.get_datetime()
	return str(time.day) + "." + str(time.month) + "." + str(time.year) + " " +\
		str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)

static func begins_with_one_of(string: String, subsequences: Array) -> bool:
	for subsequence in subsequences:
		if string.begins_with(subsequence):
			return true
	return false

static func last_symbol(string: String) -> String:
	return string.substr(string.length() - 1)
