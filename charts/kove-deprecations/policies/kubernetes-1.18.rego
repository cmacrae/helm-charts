package kove.deprecations

# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.18.md

# Within Ingress resources spec.ingressClassName replaces the deprecated kubernetes.io/ingress.class annotation.
main[return] {
	resources := ["Ingress"]
	input.kind == resources[_]
	input.metadata.annotations["kubernetes.io/ingress.class"]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "Ingress annotation kubernetes.io/ingress.class has been deprecated in 1.18, use spec.IngressClassName instead.",
	}
}
