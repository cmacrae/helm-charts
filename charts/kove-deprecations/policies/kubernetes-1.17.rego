package kove.deprecations

# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.16.md

# PriorityClass resources will no longer be served from scheduling.k8s.io/v1beta1 and scheduling.k8s.io/v1alpha1 in v1.17.
main[return] {
	apis := ["scheduling.k8s.io/v1beta1", "scheduling.k8s.io/v1alpha1"]
	input.apiVersion == apis[_]
	input.kind == "PriorityClass"
	msg := sprintf("%s/%s: API %s for PriorityClass has been deprecated, use scheduling.k8s.io/v1 instead.", [input.kind, input.metadata.name, input.apiVersion])
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": sprintf("API %s has been deprecated, use scheduling.k8s.io/v1 instead.", [input.apiVersion]),
	}
}
