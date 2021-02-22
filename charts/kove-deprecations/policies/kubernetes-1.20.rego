package deprek8ion

# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.16.md

# Ingress resources will no longer be served from extensions/v1beta1 in v1.20. Migrate use to the networking.k8s.io/v1beta1 API, available since v1.14.
main[return] {
	input.apiVersion == "extensions/v1beta1"
	input.kind == "Ingress"
	return := {
		"Name": input.metadata.name,
		"Namespace": get_default(input.metadata, "namespace", "<undefined>"),
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API extensions/v1beta1 for Ingress is deprecated from Kubernetes 1.20, use networking.k8s.io/v1beta1 instead.",
	}
}

# All resources will no longer be served from rbac.authorization.k8s.io/v1alpha1 and rbac.authorization.k8s.io/v1beta1 in 1.20. Migrate to use rbac.authorization.k8s.io/v1 instead
main[return] {
	apis := ["rbac.authorization.k8s.io/v1alpha1", "rbac.authorization.k8s.io/v1beta1"]
	input.apiVersion == apis[_]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": sprintf("API %s is deprecated from Kubernetes 1.20, use rbac.authorization.k8s.io/v1 instead.", [input.apiVersion]),
	}
}
