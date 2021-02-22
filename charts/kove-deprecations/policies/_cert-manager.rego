package deprek8ion

# Based on https://github.com/jetstack/cert-manager/releases/tag/v0.11.0
main[return] {
	kinds := ["Certificate", "Issuer", "ClusterIssuer", "CertificateRequest"]
	input.apiVersion == "certmanager.k8s.io/v1alpha1"
	input.kind == kinds[_]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API certmanager.k8s.io/v1alpha1 is obsolete, use cert-manager.io/v1alpha2 instead.",
	}
}

main[return] {
	kinds := ["Order", "Challenge"]
	input.apiVersion == "certmanager.k8s.io/v1alpha1"
	input.kind == kinds[_]
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API certmanager.k8s.io/v1alpha1 is obsolete, use acme.cert-manager.io/v1alpha2 instead.",
	}
}
