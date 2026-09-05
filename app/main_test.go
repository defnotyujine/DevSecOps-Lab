package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthz(t *testing.T) {
	rec := httptest.NewRecorder()
	newMux().ServeHTTP(rec, httptest.NewRequest(http.MethodGet, "/healthz", nil))

	if rec.Code != http.StatusOK {
		t.Errorf("status = %d, want %d", rec.Code, http.StatusOK)
	}
	if got := rec.Body.String(); got != "ok\n" {
		t.Errorf("body = %q, want %q", got, "ok\n")
	}
}

func TestVersion(t *testing.T) {
	t.Setenv("GIT_SHA", "deadbeef")
	t.Setenv("IMAGE_DIGEST", "sha256:cafe")

	rec := httptest.NewRecorder()
	newMux().ServeHTTP(rec, httptest.NewRequest(http.MethodGet, "/version", nil))

	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d, want %d", rec.Code, http.StatusOK)
	}

	var got versionInfo
	if err := json.Unmarshal(rec.Body.Bytes(), &got); err != nil {
		t.Fatalf("response is not valid JSON: %v", err)
	}
	if got.SHA != "deadbeef" {
		t.Errorf("sha = %q, want %q", got.SHA, "deadbeef")
	}
	if got.Digest != "sha256:cafe" {
		t.Errorf("digest = %q, want %q", got.Digest, "sha256:cafe")
	}
}
