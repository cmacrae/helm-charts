package deprek8ion

# Based on https://github.com/kubernetes/kubernetes/issues/47198
# Warn about the deprecated serviceAccount field in podSpec.
main[return] {
	resources := ["Pod"]
	input.kind == resources[_]
	input.spec.serviceAccount
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "The serviceAccount field in the podSpec will be deprecated soon, use serviceAccountName instead.",
	}
}

main[return] {
	resources := ["CronJob"]
	input.kind == resources[_]
	input.spec.jobTemplate.spec.template.spec.serviceAccount
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "The serviceAccount field in the podSpec will be deprecated soon, use serviceAccountName instead.",
	}
}

main[return] {
	resources := ["Deployment", "DaemonSet", "Job", "ReplicaSet", "ReplicationController", "StatefulSet"]
	input.kind == resources[_]
	input.spec.template.spec.serviceAccount
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "The serviceAccount field in the podSpec will be deprecated soon, use serviceAccountName instead.",
	}
}
