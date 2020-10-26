#!/bin/bash
# shellcheck disable=SC2034,SC2153,SC2155,SC2164

# Copyright Istio Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####################################################################################################
# WARNING: THIS IS AN AUTO-GENERATED FILE, DO NOT EDIT. PLEASE MODIFY THE ORIGINAL MARKDOWN FILE:
#          docs/setup/install/multicluster/multi-primary_multi-network/index.md
####################################################################################################

snip_set_the_default_network_for_cluster1_1() {
kubectl --context="${CTX_CLUSTER1}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
}

snip_configure_cluster1_as_a_primary_1() {
cat <<EOF > cluster1.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: cluster1
      network: network1
EOF
}

snip_configure_cluster1_as_a_primary_2() {
istioctl install --context="${CTX_CLUSTER1}" -f cluster1.yaml
}

snip_install_the_eastwest_gateway_in_cluster1_1() {
MESH=mesh1 CLUSTER=cluster1 NETWORK=network1 \
    samples/multicluster/gen-eastwest-gateway.sh | \
    istioctl manifest generate -f - | \
    kubectl apply --context="${CTX_CLUSTER1}" -f -
}

snip_install_the_eastwest_gateway_in_cluster1_2() {
kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system
}

! read -r -d '' snip_install_the_eastwest_gateway_in_cluster1_2_out <<\ENDSNIP
NAME                    TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)   AGE
istio-eastwestgateway   LoadBalancer   10.80.6.124   34.75.71.237   ...       51s
ENDSNIP

snip_expose_services_in_cluster1_1() {
kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml
}

snip_set_the_default_network_for_cluster2_1() {
kubectl --context="${CTX_CLUSTER2}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER2}" label namespace istio-system topology.istio.io/network=network2
}

snip_configure_cluster2_as_a_primary_1() {
cat <<EOF > cluster2.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: cluster2
      network: network2
EOF
}

snip_configure_cluster2_as_a_primary_2() {
istioctl install --context="${CTX_CLUSTER2}" -f cluster2.yaml
}

snip_install_the_eastwest_gateway_in_cluster2_1() {
MESH=mesh1 CLUSTER=cluster2 NETWORK=network2 \
    samples/multicluster/gen-eastwest-gateway.sh | \
    istioctl manifest generate -f - | \
    kubectl apply --context="${CTX_CLUSTER2}" -f -
}

snip_install_the_eastwest_gateway_in_cluster2_2() {
kubectl --context="${CTX_CLUSTER2}" get svc istio-eastwestgateway -n istio-system
}

! read -r -d '' snip_install_the_eastwest_gateway_in_cluster2_2_out <<\ENDSNIP
NAME                    TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)   AGE
istio-eastwestgateway   LoadBalancer   10.0.12.121   34.122.91.98   ...       51s
ENDSNIP

snip_expose_services_in_cluster2_1() {
kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml
}

snip_enable_endpoint_discovery_1() {
istioctl x create-remote-secret \
  --context="${CTX_CLUSTER1}" \
  --name=cluster1 | \
  kubectl apply -f - --context="${CTX_CLUSTER2}"
}

snip_enable_endpoint_discovery_2() {
istioctl x create-remote-secret \
  --context="${CTX_CLUSTER2}" \
  --name=cluster2 | \
  kubectl apply -f - --context="${CTX_CLUSTER1}"
}
