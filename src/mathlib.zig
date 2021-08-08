const std = @import("std");
const testing = std.testing;

pub const Vector2 = @import("vector2.zig").Vector2;
pub const Vector2Int = @import("vector2_int.zig").Vector2Int;
pub const Vector3 = @import("vector3.zig").Vector3;
pub const Vector4 = @import("vector4.zig").Vector4;
pub const Quaternion = @import("quaternion.zig").Quaternion;
pub const Matrix4x4 = @import("matrix4x4.zig").Matrix4x4;

pub usingnamespace @import("math.zig");

test {
    testing.refAllDecls(@This());
}