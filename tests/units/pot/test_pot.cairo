# SPDX-License-Identifier: MIT

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero, assert_lt_felt
from starkware.cairo.common.uint256 import Uint256

# Project dependencies
from pot.library import Pot

const VESTING_TOKEN_ADDRESS = 'vesting-token-address'
const ADMIN = 'starkvest-admin'
const ANYONE_1 = 'user-1'
const ANYONE_2 = 'user-2'
const ANYONE_3 = 'user-3'

# -------
# STRUCTS
# -------

struct Signers:
    member admin : felt
    member anyone_1 : felt
    member anyone_2 : felt
    member anyone_3 : felt
end

@external
func test_rpow_null_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let x = Uint256(0, 0)
    let n = Uint256(1, 0)
    let base = Uint256(10, 0)
    let (z : Uint256) = Pot._rpow(x, n, base)
    assert z = Uint256(0, 0)
    return ()
end

@external
func test_rpow_null_values{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let x = Uint256(0, 0)
    let n = Uint256(0, 0)
    let base = Uint256(10, 0)
    let (z : Uint256) = Pot._rpow(x, n, base)
    assert z = base
    return ()
end

@external
func test_rpow1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let x = Uint256(8, 0)
    let n = Uint256(6, 0)
    let base = Uint256(1, 0)
    let (z : Uint256) = Pot._rpow(x, n, base)
    let (felt_z) = _uint_to_felt(z)
    %{ print(ids.felt_z) %}
    assert z = Uint256(262144, 0)
    return ()
end

@external
func test_rpow2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let x = Uint256(3, 0)
    let n = Uint256(4, 0)
    let base = Uint256(1, 0)
    let (z : Uint256) = Pot._rpow(x, n, base)
    let (felt_z) = _uint_to_felt(z)
    %{ print(ids.felt_z) %}
    assert z = Uint256(81, 0)
    return ()
end

@external
func test_rpow3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let x = Uint256(8, 0)
    let n = Uint256(12, 0)
    let base = Uint256(1, 0)
    let (z : Uint256) = Pot._rpow(x, n, base)
    let (felt_z) = _uint_to_felt(z)
    %{ print(ids.felt_z) %}
    assert z = Uint256(68719476736, 0)
    return ()
end

func _uint_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    value : Uint256
) -> (value : felt):
    assert_lt_felt(value.high, 2 ** 123)
    return (value.high * (2 ** 128) + value.low)
end
