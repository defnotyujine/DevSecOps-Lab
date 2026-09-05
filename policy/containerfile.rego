package main

import rego.v1

deny contains msg if {
	some i
	input[i].Cmd == "from"
	not contains(input[i].Value[0], "@sha256:")
	msg := sprintf("FROM must be pinned by digest, got: %s", [input[i].Value[0]])
}

deny contains msg if {
	some i
	input[i].Cmd == "from"
	endswith(input[i].Value[0], ":latest")
	msg := sprintf("FROM must not use the latest tag, got: %s", [input[i].Value[0]])
}

deny contains msg if {
	input[i].Cmd == "add"
	msg := "ADD is not allowed, use COPY instead"
}

deny contains msg if {
	last_stage := max([input[i].Stage | some i; input[i].Cmd == "from"])
	users := [u | some i; input[i].Cmd == "user"; input[i].Stage == last_stage; u := input[i].Value[0]]
	count(users) == 0
	msg := "final stage must set a USER, none found"
}

deny contains msg if {
	last_stage := max([input[i].Stage | some i; input[i].Cmd == "from"])
	some i
	input[i].Cmd == "user"
	input[i].Stage == last_stage
	input[i].Value[0] in {"root", "0", "0:0"}
	msg := sprintf("final stage must not run as root, got USER %s", [input[i].Value[0]])
}
