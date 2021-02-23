package kove.deprecations

# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.16.md
# Based on https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.19.md

# The apiextensions.k8s.io/v1beta1 version of CustomResourceDefinition is deprecated in 1.19. Migrate to use apiextensions.k8s.io/v1 instead
main[return] {
	input.apiVersion == "apiextensions.k8s.io/v1beta1"
	input.kind == "CustomResourceDefinition"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API apiextensions.k8s.io/v1beta1 for CustomResourceDefinition is deprecated in 1.19, use apiextensions.k8s.io/v1 instead.",
	}
}

# The apiregistration.k8s.io/v1beta1 version is deprecated in 1.19. Migrate to use apiregistration.k8s.io/v1 instead
main[return] {
	input.apiVersion == "apiregistration.k8s.io/v1beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API apiregistration.k8s.io/v1beta1 is deprecated in Kubernetes 1.19, use apiregistration.k8s.io/v1 instead.",
	}
}

# The authentication.k8s.io/v1beta1 version is deprecated in 1.19. Migrate to use authentication.k8s.io/v1 instead
main[return] {
	input.apiVersion == "authentication.k8s.io/v1beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API authentication.k8s.io/v1beta1 is deprecated in Kubernetes 1.19, use authentication.k8s.io/v1 instead.",
	}
}

# The authorization.k8s.io/v1beta1 version is deprecated in 1.19. Migrate to use authorization.k8s.io/v1 instead
main[return] {
	input.apiVersion == "authorization.k8s.io/v1beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API authorization.k8s.io/v1beta1 is deprecated in Kubernetes 1.19, use authorization.k8s.io/v1 instead.",
	}
}

# The autoscaling/v2beta1 version is deprecated in 1.19. Migrate to use autoscaling/v2beta2 instead
main[return] {
	input.apiVersion == "autoscaling/v2beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API autoscaling/v2beta1 is deprecated in Kubernetes 1.19, use autoscaling/v2beta2 instead.",
	}
}

# The coordination.k8s.io/v1beta1 version is deprecated in 1.19. Migrate to use coordination.k8s.io/v1 instead
main[return] {
	input.apiVersion == "coordination.k8s.io/v1beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API coordination.k8s.io/v1beta1 is deprecated in Kubernetes 1.19, use coordination.k8s.io/v1 instead.",
	}
}

# The storage.k8s.io/v1beta1 version is deprecated in 1.19. Migrate to use storage.k8s.io/v1 instead
main[return] {
	input.apiVersion == "storage.k8s.io/v1beta1"
	return := {
		"Name": input.metadata.name,
		"Namespace": input.metadata.namespace,
		"Kind": input.kind,
		"ApiVersion": input.apiVersion,
		"RuleSet": "API storage.k8s.io/v1beta1 is deprecated in Kubernetes 1.19, use storage.k8s.io/v1 instead.",
	}
}
