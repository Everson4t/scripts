#!/bin/bash
printf "Compartment\tVCN\tSubnet\tAddress\tName\n"
for c in $(oci iam compartment list --compartment-id-in-subtree true --all --raw-output --query 'join(`\n`, data[*]."compartment-id")')
do
printf "Compartment-$c\n"
   for v in $(oci network vcn list --compartment-id $c --raw-output --query 'join(`\n`, data[*].id)')
   do
   printf "  └─VCN-$v\n"
      for s in $(oci network subnet list --compartment-id $c --vcn-id $v --raw-output --query 'join(`\n`, data[*].id)')
      do
      printf "    └─Subnet-$s\n"
      oci network private-ip list --subnet-id $s --raw-output --query "data[*].join(\`\\t\`, [\`$c\`, \`$v\`, \`$s\`, \"ip-address\", \"display-name\"]) | join(\`\\n\`, @)"
      done
   done
done
