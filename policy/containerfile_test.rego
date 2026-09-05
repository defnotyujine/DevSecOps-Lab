package main

import rego.v1

compliant_dockerfile := [
	{"Cmd": "from", "Value": ["golang@sha256:abc123"], "Stage": 0},
	{"Cmd": "copy", "Value": ["go.mod", "main.go", "./"], "Stage": 0},
	{"Cmd": "from", "Value": ["distroless@sha256:def456"], "Stage": 1},
	{"Cmd": "copy", "Value": ["/out/app", "/app"], "Stage": 1},
	{"Cmd": "user", "Value": ["65532:65532"], "Stage": 1},
]

test_compliant_dockerfile_has_no_denies if {
	count(deny) == 0 with input as compliant_dockerfile
}

test_unpinned_from_is_denied if {
	bad := [{"Cmd": "from", "Value": ["golang"], "Stage": 0}]
	deny["FROM must be pinned by digest, got: golang"] with input as bad
}

test_latest_tag_is_denied if {
	bad := [{"Cmd": "from", "Value": ["golang@sha256:abc:latest"], "Stage": 0}]
	deny["FROM must not use the latest tag, got: golang@sha256:abc:latest"] with input as bad
}

test_add_instruction_is_denied if {
	bad := [{"Cmd": "add", "Value": ["http://example.com/f", "/tmp/"], "Stage": 0}]
	deny["ADD is not allowed, use COPY instead"] with input as bad
}

test_missing_user_is_denied if {
	bad := [{"Cmd": "from", "Value": ["golang@sha256:abc123"], "Stage": 0}]
	deny["final stage must set a USER, none found"] with input as bad
}

test_root_user_is_denied if {
	bad := [
		{"Cmd": "from", "Value": ["golang@sha256:abc123"], "Stage": 0},
		{"Cmd": "user", "Value": ["root"], "Stage": 0},
	]
	deny["final stage must not run as root, got USER root"] with input as bad
}
