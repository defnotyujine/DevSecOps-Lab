package main

import rego.v1

test_critical_fixed_is_denied if {
	bad := {"matches": [{
		"vulnerability": {"id": "CVE-2026-0001", "severity": "Critical", "fix": {"state": "fixed", "versions": ["1.2.3"]}},
		"artifact": {"name": "openssl", "version": "1.2.2"},
	}]}
	deny["CVE-2026-0001 in openssl@1.2.2 (Critical), fixed in [\"1.2.3\"]"] with input as bad
}

test_high_unfixed_is_warned_not_denied if {
	bad := {"matches": [{
		"vulnerability": {"id": "CVE-2026-0002", "severity": "High", "fix": {"state": "not-fixed", "versions": []}},
		"artifact": {"name": "libfoo", "version": "2.0.0"},
	}]}
	count(deny) == 0 with input as bad
	warn["CVE-2026-0002 in libfoo: no fix yet"] with input as bad
}

test_low_severity_is_ignored if {
	bad := {"matches": [{
		"vulnerability": {"id": "CVE-2026-0003", "severity": "Low", "fix": {"state": "fixed", "versions": ["3.0.0"]}},
		"artifact": {"name": "libbar", "version": "2.9.0"},
	}]}
	count(deny) == 0 with input as bad
	count(warn) == 0 with input as bad
}

test_explicitly_ignored_cve_is_not_denied if {
	bad := {"matches": [{
		"vulnerability": {"id": "CVE-2026-9999", "severity": "Critical", "fix": {"state": "fixed", "versions": ["9.9.9"]}},
		"artifact": {"name": "stdlib", "version": "1.0.0"},
	}]}
	count(deny) == 0 with input as bad with ignored as {"CVE-2026-9999"}
}

test_clean_scan_has_no_findings if {
	clean := {"matches": []}
	count(deny) == 0 with input as clean
	count(warn) == 0 with input as clean
}
