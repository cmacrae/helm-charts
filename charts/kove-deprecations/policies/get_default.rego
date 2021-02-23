package kove.deprecations

get_default(val, key, _) = val[key]

get_default(val, key, fallback) = fallback {
	not val[key]
}
