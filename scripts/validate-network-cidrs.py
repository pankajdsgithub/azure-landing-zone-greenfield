#!/usr/bin/env python3
"""Validate Terraform hub/spoke CIDRs and test invalid network layouts."""

import argparse
import ipaddress
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TF_DIR = ROOT / "terraform/environments/networking"


def networks(values, label):
    if not values:
        raise ValueError(f"{label} must not be empty")

    try:
        result = [ipaddress.ip_network(value, strict=True) for value in values]
    except ValueError as exc:
        raise ValueError(f"{label}: invalid CIDR: {exc}") from exc

    if len({net.version for net in result}) != 1:
        raise ValueError(f"{label} must not mix IPv4 and IPv6")

    for i, current in enumerate(result):
        for other in result[i + 1:]:
            if current.overlaps(other):
                raise ValueError(
                    f"{label} contains overlapping prefixes: {current}, {other}"
                )
    return result


def check_subnets(subnets, address_spaces, label):
    for subnet in subnets:
        if not any(
            subnet.version == vnet.version and subnet.subnet_of(vnet)
            for vnet in address_spaces
        ):
            raise ValueError(
                f"{label} subnet {subnet} is outside its VNet address space"
            )


def validate(config):
    hub = networks(config["hub_address_space"], "hub_address_space")
    spoke = networks(config["spoke_address_space"], "spoke_address_space")
    hub_subnets = networks(config["hub_subnet_prefixes"], "hub_subnet_prefixes")
    spoke_subnets = networks(config["spoke_subnet_prefixes"], "spoke_subnet_prefixes")

    for h in hub:
        for s in spoke:
            if h.overlaps(s):
                raise ValueError(f"Hub and spoke overlap: {h}, {s}")

    check_subnets(hub_subnets, hub, "hub")
    check_subnets(spoke_subnets, spoke, "spoke")

    subnets = [("hub", n) for n in hub_subnets]
    subnets += [("spoke", n) for n in spoke_subnets]

    for i, (label, current) in enumerate(subnets):
        for other_label, other in subnets[i + 1:]:
            if current.overlaps(other):
                raise ValueError(
                    f"Subnet overlap: {label} {current}, "
                    f"{other_label} {other}"
                )


def read_terraform_values(var_file):
    expression = (
        'jsonencode({'
        'hub_address_space=var.hub_address_space,'
        'hub_subnet_prefixes=var.hub_subnet_prefixes,'
        'spoke_address_space=var.spoke_address_space,'
        'spoke_subnet_prefixes=var.spoke_subnet_prefixes'
        '})'
    )
    command = [
        "terraform", f"-chdir={TF_DIR}", "console",
        f"-var-file={var_file}",
    ]
    result = subprocess.run(
        command, input=expression + "\n", text=True,
        capture_output=True, check=False,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or "terraform console failed")
    try:
        parsed = json.loads(result.stdout.strip())

        # Terraform console may return JSON encoded as a quoted string.
        if isinstance(parsed, str):
            parsed = json.loads(parsed)

        if not isinstance(parsed, dict):
            raise ValueError("Expected a JSON object from terraform console")

        return parsed
    except (json.JSONDecodeError, ValueError) as exc:
        raise RuntimeError(
            f"Could not parse terraform console output: {result.stdout!r}"
        ) from exc


def self_test():
    valid = {
        "hub_address_space": ["10.40.0.0/16"],
        "hub_subnet_prefixes": ["10.40.1.0/24"],
        "spoke_address_space": ["10.41.0.0/16"],
        "spoke_subnet_prefixes": ["10.41.1.0/24"],
    }
    validate(valid)
    print("PASS: valid layout")

    cases = [
        ("hub-spoke overlap", {
            **valid, "spoke_address_space": ["10.40.0.0/16"]
        }),
        ("hub subnet outside VNet", {
            **valid, "hub_subnet_prefixes": ["10.99.1.0/24"]
        }),
        ("spoke subnet outside VNet", {
            **valid, "spoke_subnet_prefixes": ["10.99.1.0/24"]
        }),
        ("overlapping subnets", {
            **valid, "spoke_subnet_prefixes": ["10.40.1.0/24"]
        }),
        ("overlapping VNet prefixes", {
            **valid, "hub_address_space": ["10.40.0.0/16", "10.40.1.0/24"]
        }),
    ]

    for label, config in cases:
        try:
            validate(config)
        except ValueError:
            print(f"PASS: rejected {label}")
        else:
            raise AssertionError(f"FAIL: accepted invalid case: {label}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--var-file",
        default=str(TF_DIR / "terraform.tfvars.example"),
        help="Terraform variable file to validate (defaults to the example file)",
    )
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    try:
        if args.self_test:
            self_test()

        config = read_terraform_values(Path(args.var_file).resolve())
        validate(config)
        print(f"PASS: CIDR validation for Terraform inputs in {args.var_file}")
        return 0
    except (ValueError, RuntimeError, AssertionError) as exc:
        print(f"CIDR validation failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
