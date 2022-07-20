# SPDX-License-Identifier: MIT
# StarkVest Contracts for Cairo v0.0.1 (libary.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_le,
    uint256_lt,
    uint256_eq,
    uint256_add,
    uint256_unsigned_div_rem,
)
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_nn,
    assert_le,
    assert_in_range,
    unsigned_div_rem,
    assert_lt_felt,
)
from starkware.cairo.common.math_cmp import is_le, is_not_zero

# OpenZeppelin dependencies
from openzeppelin.security.safemath import SafeUint256

namespace Pot:
    func _rpow{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        x : Uint256, n : Uint256, base : Uint256
    ) -> (z : Uint256):
        alloc_locals
        let (is_x_null) = uint256_eq(x, Uint256(0, 0))
        let (is_n_null) = uint256_eq(n, Uint256(0, 0))

        if is_x_null == TRUE:
            if is_n_null == TRUE:
                return (z=base)
            else:
                return (z=Uint256(0, 0))
            end
        else:
            let (_, mod_2_n) = uint256_unsigned_div_rem(n, Uint256(2, 0))
            let (is_mod_null) = uint256_eq(mod_2_n, Uint256(0, 0))
            let (_z) = internal.get_z(base, x, is_mod_null)
            let (half, _) = uint256_unsigned_div_rem(base, Uint256(2, 0))
            let (init_n, _) = SafeUint256.div_rem(n, Uint256(2, 0))
            let (end_z) = internal._loop(x, init_n, half, _z, base)
            return (end_z)
        end
    end
end

namespace internal:
    func _loop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        x : Uint256, n : Uint256, half : Uint256, z : Uint256, base : Uint256
    ) -> (new_z : Uint256):
        alloc_locals
        let (local _feltx) = _uint_to_felt(x)
        let (local _feltn) = _uint_to_felt(n)
        let (local _feltz) = _uint_to_felt(z)
        %{ print(f'x${ids._feltx} n${ids._feltn} z${ids._feltz}') %}
        let (stop) = uint256_eq(n, Uint256(0, 0))
        if stop == TRUE:
            return (z)
        end

        let (xx) = SafeUint256.mul(x, x)
        let (xxRound) = SafeUint256.add(xx, half)
        let (new_x, _) = SafeUint256.div_rem(xxRound, base)
        let (new_n, mod_2) = SafeUint256.div_rem(n, Uint256(2, 0))
        let (is_odd) = uint256_eq(mod_2, Uint256(1, 0))
        # let (is_even) = bitwise_and(new_x, Uint256(0, 0))
        if is_odd == TRUE:
            let (zx) = SafeUint256.mul(z, new_x)
            # let (is_x_positive) = uint256_lt(Uint256(0, 0), new_x)
            # let (check_overflow, _) = SafeUint256.div_rem(zx, x)
            # let (has_not_overflow) = uint256_eq(check_overflow, z)
            # with_attr error_message("overflow"):
            #     assert and(is_x_positive, 1 - has_not_overflow) = TRUE
            # end
            let (zxRound) = SafeUint256.add(zx, half)
            let (new_z, _) = SafeUint256.div_rem(zxRound, base)
            return _loop(new_x, new_n, half, new_z, base)
        else:
            return _loop(new_x, new_n, half, z, base)
        end
    end

    func and{syscall_ptr : felt*}(lhs : felt, rhs : felt) -> (res : felt):
        if lhs + rhs == 2:
            return (1)
        end
        return (0)
    end

    func get_z{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        base : Uint256, x : Uint256, condition
    ) -> (z : Uint256):
        if condition == TRUE:
            return (z=base)
        else:
            return (z=x)
        end
    end

    func _uint_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        value : Uint256
    ) -> (value : felt):
        assert_lt_felt(value.high, 2 ** 123)
        return (value.high * (2 ** 128) + value.low)
    end
end
