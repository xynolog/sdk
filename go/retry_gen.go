// Code generated from protocol/specs/src/retry/rules.json — DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/go_types/retry.ml)

package xynolog

var (
	// RetryRuleBoot is the boot rule of retry/rules.json.
	RetryRuleBoot = RetryRule{Name: "boot", Statuses: []int{429, 503, 504}}

	// RetryRuleJob is the job rule of retry/rules.json.
	RetryRuleJob = RetryRule{Name: "job", Statuses: []int{408, 429}, StatusFrom: new(500)}

	// RetryRuleTransport is the transport rule of retry/rules.json.
	RetryRuleTransport = RetryRule{Name: "transport", Statuses: []int{408, 413, 429, 500, 502, 503, 504}, IdempotentMethods: []string{"GET", "HEAD", "PUT", "DELETE", "OPTIONS", "TRACE"}}

	// RetryRuleRefresh is the refresh rule of retry/rules.json.
	RetryRuleRefresh = RetryRule{Name: "refresh", Statuses: []int{408, 429}, StatusFrom: new(500), NoResponse: true}
)

// RetryRules is every rule of retry/rules.json.
func RetryRules() []RetryRule {
	return []RetryRule{RetryRuleBoot, RetryRuleJob, RetryRuleTransport, RetryRuleRefresh}
}
