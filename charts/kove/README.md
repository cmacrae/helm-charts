Watch your in cluster Kubernetes manifests for OPA policy violations and export them as Prometheus metrics

## About
[Open Policy Agent](https://www.openpolicyagent.org/) provide the fearsome-but-trustworthy  [gatekeeper](https://github.com/open-policy-agent/gatekeeper), which
allows for [admission control](https://www.openpolicyagent.org/docs/latest/kubernetes-introduction/#how-does-it-work-with-plain-opa-and-kube-mgmt) of Kubernetes
manifests being submitted to the API. This is really nice and allows administrators to control the manifests coming in as fine-grained as they please.  

However, administrators may not always want to take direct action (such as denial) on manifests arriving at the API. This is where kove comes in.  
It allows administrators of Kubernetes clusters to define [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) policies that they want to flag violations for by exposing a [Prometheus](https://prometheus.io/) metric.  

Some example use cases include monitoring the use of deprecated APIs, unwanted docker images, or container vars containing strings like `API_KEY`, etc.  
Administrators can craft dashboards or alerts when such conditions are observed to better expose this information to users.

kove is built on an [informer](https://pkg.go.dev/k8s.io/client-go/informers) model, rather than admission control - so, it works on any existing objects in your cluster, instead of evaluating them when they arrive at the API (upon create/update). This means it'll expose policy violators that may otherwise go unnoticed if they're not updated often.

## Values

| Key                       | Type   | Default                                                                                                                                                   | Description                                                                                                                         |
|:--------------------------|:------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|
| clusterRole               | string | `""`                                                                                                                                                      | ClusterRole to bind the ServiceAccount to use for the Deployment. If none is set, 'view' will be used                               |
| config                    | string | see [values.yaml](https://github.com/cmacrae/helm-charts/blob/master/charts/kove/values.yaml)                                                             | Application configuration. See [the project README](https://github.com/cmacrae/kove/tree/master#config) for more info               |
| deployment.affinity       | object | `{}`                                                                                                                                                      | Affinity configuration for the Deployment                                                                                           |
| deployment.annotations    | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"3000","prometheus.io/scrape":"true"}`                                                             | Annotations for the Deployment                                                                                                      |
| deployment.livenessProbe  | object | `{"enabled": true, "path": "/healthz", "failureThreshold": 3, "initialDelaySeconds": 0, "periodSeconds": 10, "successThreshold": 1, "timeoutSeconds": 1}` | Liveness probe configuration for the Deployment                                                                                     |
| deployment.readinessProbe | object | `{"enabled": false}`                                                                                                                                      | Readiness probe configuration for the Deployment                                                                                    |
| fullnameOverride          | string | `""`                                                                                                                                                      | Overrides the full name for resources created by this chart                                                                         |
| image.pullPolicy          | string | `"IfNotPresent"`                                                                                                                                          | Container image pull policy                                                                                                         |
| image.repository          | string | `"ghcr.io/cmacrae/kove"`                                                                                                                                  | Container image to use for the deployment                                                                                           |
| image.tag                 | string | `""`                                                                                                                                                      | Container image tag. If empty, defaults to `.Chart.AppVersion`                                                                      |
| imagePullSecrets          | list   | `[]`                                                                                                                                                      | If authentication is required for pulling the image from the registry, it can be provided here                                      |
| ingress.annotations       | object | `{}`                                                                                                                                                      | Annotations for the Ingress                                                                                                         |
| ingress.enabled           | bool   | `false`                                                                                                                                                   | Whether to create an Ingress object                                                                                                 |
| ingress.hosts             | list   | `[]`                                                                                                                                                      | Host entries for the Ingress                                                                                                        |
| ingress.tls               | list   | `[]`                                                                                                                                                      | TLS configuration for the Ingress                                                                                                   |
| nameOverride              | string | `""`                                                                                                                                                      | Overrides the short name for resources created by this chart                                                                        |
| namespace                 | string | `"default"`                                                                                                                                               | Namespace to deploy to                                                                                                              |
| nodeSelector              | object | `{}`                                                                                                                                                      | NodeSelector configuration for the Deployment                                                                                       |
| policy                    | string | `""`                                                                                                                                                      | Rego policy to evaluate objects against. See [the project README](https://github.com/cmacrae/kove/tree/master#policy) for more info |
| policyConfigMap           | string | `""`                                                                                                                                                      | Override the ConfigMap containing the Rego policies                                                                                 |
| prometheusOperator        | object | see [values.yaml](https://github.com/cmacrae/helm-charts/blob/master/charts/kove/values.yaml)                                                             | Configures a Prometheus Operator ServiceMonitor object                                                                              |
| replicaCount              | int    | `1`                                                                                                                                                       | Number of replicas for the deployment                                                                                               |
| resources                 | object | `{}`                                                                                                                                                      | Configuration for the Deployment resources                                                                                          |
| service.port              | int    | `3000`                                                                                                                                                    | Configures the Service port                                                                                                         |
| service.type              | string | `"ClusterIP"`                                                                                                                                             | Configures the Service type                                                                                                         |
| serviceAccount            | string | `""`                                                                                                                                                      | ServiceAccount to use for the Deployment. If none is set, one will be created                                                       |
| tolerations               | list   | `[]`                                                                                                                                                      | Toleration configuration for the Deployment                                                                                         |

## Metrics
| Metric                                 | Description                                                                                                                                              |
|:---------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `opa_policy_violation`                 | Represents a Kubernetes object that violates the provided Rego expression. Includes the labels `name`, `namespace`, `kind`, `api_version`, and `ruleset` |
| `opa_policy_violations_total`          | Total number of policy violations observed                                                                                                               |
| `opa_policy_violations_resolved_total` | Total number of policy violation resolutions observed                                                                                                    |
| `opa_object_evaluations_total`         | Total number object evaluations conducted                                                                                                                |

## Usage
`ConfigMap` objects containing the Rego policy/policies and the application configuration can be mounted to configure what you want to evaluate and how you want to evaluate it.

### Options
| Option   | Default | Description                                                                                             |
|:---------|:--------|:--------------------------------------------------------------------------------------------------------|
| `config` | `""`    | Path to the config file. If not set, this will look for the file `config.yaml` in the current directory |

#### `config`
A YAML manifest can be provided in the following format to describe how and what you want to watch for evaluation:
```yaml
namespace: default
ignoreChildren: true
regoQuery: data.pkgname.blah
policies:
  - example/policies
objects:
  - group: apps
    version: v1
    resource: deployments
  - group: apps
    version: v1
    resource: daemonsets
  - group: apps
    version: v1
    resource: replicasets
```

| Option           | Default        | Description                                                                                                                                          |
|:-----------------|:---------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `namespace`      | `""`           | Kubernetes namespace to watch objects in. If empty or omitted, all namespaces will be observed                                                       |
| `ignoreChildren` | `false`        | Boolean that decides if objects spawned as part of a user managed object (such as a ReplicaSet from a user managed Deployment) should be evaluated   |
| `regoQuery`      | `data[_].main` | The Rego query to read evaluation results from. This should match the expression in your policy that surfaces violation data                         |
| `policies`       | none           | A list of files/directories containing Rego policies to evaluate objects against                                                                     |
| `objects`        | none           | A list of [GroupVersionResource](https://pkg.go.dev/k8s.io/apimachinery/pkg/runtime/schema#GroupVersionResource) expressions to observe and evaluate. If empty **all** object kinds will be evaluated (apart from those defined in `ignoreKinds`) |
| `ignoreKinds`    | `[ apiservice, endpoint, endpoints, endpointslice, event, flowschema, lease, limitrange, namespace, prioritylevelconfiguration, replicationcontroller, runtimeclass ]` | A list of object kinds to ignore for evaluation |
| `ignoreDifferingPaths` | `[ metadata/resourceVersion, metadata/managedFields/0/time, status/observedGeneration ]` | A list of JSON paths to ignore for reevaluation when a change in the monitored object is observed |

The above example configuration would instruct the exporter to monitor `apps/v1/Deployment`, `apps/v1/DaemonSet`, and `apps/v1/ReplicaSet` objects in the `default` namespace, but ignore child objects, yielding its results from the `data.pkgname.blah` expression in the provided policy.  

#### `policies`
There are some important semantics to understand when crafting your Rego policies for use with this exporter.  
The expression that you evaluate from your query must return structured data with the following fields:  
- `Name`: The name of the object being evaluated
- `Namespace`: The namespace in which the object you're evaluating resides
- `Kind`: The kind of object being evaluated
- `ApiVersion`: The version of the Kubernetes API the object is using
- `RuleSet`: A short description that describes why this is a violation

The above data are provided by the exporter when it evaluates an object, with the exception of `RuleSet` which should be defined in the Rego expression.
For instance, if we were to evaluate the query `data.example.bad`, our policy may look something like [this](example/policies/bad-stuff.rego):

```rego
package example

# Label matchers we want to look for.
labels["secure"] = ["nope"]

# Kinds of objects we care about evaluating.
# This isn't strictly necessary if you're satisfied with the 'objects' configuration
# option for the exporter; it'll only watch what it's told.
kinds = ["Deployment", "StatefulSet", "DaemonSet"]

bad[stuff] {
	# Assign our object manifest (input) to the variable 'r'
	r := input

	# Does our object's 'kind' field match any in our 'kinds' array?
	r.kind == kinds[_]

	# Does our object's 'secure' label match any in our 'labels.secure' array?
	r.metadata.labels.secure == labels.secure[_]

	# If the above conditions are true, express a set containing various pieces of
	# information about our object. As you can see, we're assigning this to the variable
	# 'stuff', which you may notice in the expression signature is what we're returning.
	# This information is then used to expose a Prometheus metric with labels using this
	# information.
	stuff := {
		"Name": r.metadata.name,
		"Namespace": r.metadata.namespace,
		"Kind": r.kind,
		"ApiVersion": r.apiVersion,
		"RuleSet": "Insecure object", # Explain why this is a violation
	}
}
```

If you have a test cluster (perhaps built on [kind](https://kind.sigs.k8s.io/)), you can try out the evaluation of [this policy](example/policies/bad-stuff.rego) against [a violating Deployment](example/violating-manifests/bad-stuff-deployment.yaml).
