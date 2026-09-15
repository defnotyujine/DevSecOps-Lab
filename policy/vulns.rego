package main

import rego.v1

blocking := {"Critical", "High"}

deny contains msg if {
	some m in input.matches
	m.vulnerability.severity in blocking
	m.vulnerability.fix.state == "fixed"
	not m.vulnerability.id in ignored
	msg := sprintf("%s in %s@%s (%s), fixed in %v",
		[m.vulnerability.id, m.artifact.name, m.artifact.version,
		 m.vulnerability.severity, m.vulnerability.fix.versions])
}

warn contains msg if {
	some m in input.matches
	m.vulnerability.severity in blocking
	m.vulnerability.fix.state != "fixed"
	msg := sprintf("%s in %s: no fix yet", [m.vulnerability.id, m.artifact.name])
}

# time-boxed exceptions live here, with a reason and a date, reviewed in PR
ignored := {
	# "CVE-2026-XXXXX",  # false positive in stdlib, expires 2026-10-01
}
