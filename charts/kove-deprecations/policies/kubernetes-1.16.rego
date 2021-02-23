package kove.deprecations

# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.16.md

# All resources under apps/v1beta1 and apps/v1beta2 - use apps/v1 instead
main[return] {
	apis := ["apps/v1beta1", "apps/v1beta2"]
	input.apiVersion == apis[_]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API has been deprecated, use apps/v1 instead.",
	}
}

# daemonsets, deployments, replicasets resources under extensions/v1beta1 - use apps/v1 instead
main[return] {
	resources := ["DaemonSet", "Deployment", "ReplicaSet"]
	input.apiVersion == "extensions/v1beta1"
	input.kind == resources[_]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API extensions/v1beta1 has been deprecated, use apps/v1 instead.",
	}
}

# networkpolicies resources under extensions/v1beta1 - use networking.k8s.io/v1 instead
main[return] {
	input.apiVersion == "extensions/v1beta1"
	input.kind == "NetworkPolicy"
	msg := sprintf("%s/%s: API extensions/v1beta1 for NetworkPolicy has been deprecated, use networking.k8s.io/v1 instead.", [input.kind, input.metadata.name])
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API extensions/v1beta1 has been deprecated, use networking.k8s.io/v1 instead.",
	}
}

# podsecuritypolicies resources under extensions/v1beta1 - use policy/v1beta1 instead
main[return] {
	input.apiVersion == "extensions/v1beta1"
	input.kind == "PodSecurityPolicy"
	msg := sprintf("%s/%s: API extensions/v1beta1 for PodSecurityPolicy has been deprecated, use policy/v1beta1 instead.", [input.kind, input.metadata.name])
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API extensions/v1beta1 has been deprecated, use policy/v1beta1 instead.",
	}
}

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
