load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("//go:def.bzl", "GoLibrary", "GoSource", "go_binary", "go_test")

# The presence of these providers allows a target to be used as `deps` or `embed`.
# go_binary and go_test targets must not be used in this way; their dependencies
# may be built in different modes, resulting in conflicts and opaque errors.
def _providers_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)
    asserts.false(env, GoSource in target, "Should not have GoSource")
    asserts.false(env, GoLibrary in target, "Should not have GoLibrary")

    return analysistest.end(env)

providers_test = analysistest.make(_providers_test_impl)

def provider_test_suite():
    go_binary(
        name = "go_binary",
        tags = ["manual"],
    )

    providers_test(
        name = "go_binary_providers_test",
        target_under_test = ":go_binary",
    )

    go_test(
        name = "go_test",
        tags = ["manual"],
    )

    providers_test(
        name = "go_test_providers_test",
        target_under_test = ":go_test",
    )
