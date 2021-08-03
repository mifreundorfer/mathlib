const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

pub const Vector3 = packed struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vector3 {
        return .{ .x = x, .y = y, .z = z };
    }

    pub fn set(value: f32) Vector3 {
        return .{ .x = value, .y = value, .z = value };
    }

    pub fn normalize(v: Vector3) Vector3 {
        return multiplyScalar(v, 1.0 / length(v));
    }

    pub fn length(v: Vector3) f32 {
        return std.math.sqrt(dot(v, v));
    }

    pub fn squaredLength(v: Vector3) f32 {
        return dot(v, v);
    }

    pub fn dot(a: Vector3, b: Vector3) f32 {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    pub fn add(a: Vector3, b: Vector3) Vector3 {
        return init(a.x + b.x, a.y + b.y, a.z + b.z);
    }

    pub fn subtract(a: Vector3, b: Vector3) Vector3 {
        return init(a.x - b.x, a.y - b.y, a.z - b.z);
    }

    pub fn multiply(a: Vector3, b: Vector3) Vector3 {
        return init(a.x * b.x, a.y * b.y, a.z * b.z);
    }

    pub fn divide(a: Vector3, b: Vector3) Vector3 {
        return init(a.x / b.x, a.y / b.y, a.z / b.z);
    }

    pub fn addScalar(a: Vector3, b: f32) Vector3 {
        return init(a.x + b, a.y + b, a.z + b);
    }

    pub fn subtractScalar(a: Vector3, b: f32) Vector3 {
        return init(a.x - b, a.y - b, a.z - b);
    }

    pub fn multiplyScalar(a: Vector3, b: f32) Vector3 {
        return init(a.x * b, a.y * b, a.z * b);
    }

    pub fn divideScalar(a: Vector3, b: f32) Vector3 {
        return init(a.x / b, a.y / b, a.z / b);
    }
};

test "Vector3" {
    var v1 = Vector3.init(1, 2, 3);
    var v2 = Vector3.init(5, 6, 7);
    var v: Vector3 = undefined;
    var s: f32 = undefined;

    v = Vector3.init(1, 2, 3);
    try expectEqual(@as(f32, 1.0), v.x);
    try expectEqual(@as(f32, 2.0), v.y);
    try expectEqual(@as(f32, 3.0), v.z);

    v = Vector3.set(4);
    try expectEqual(@as(f32, 4.0), v.x);
    try expectEqual(@as(f32, 4.0), v.y);
    try expectEqual(@as(f32, 4.0), v.z);

    v = v1.add(v2);
    try expectEqual(Vector3.init(6, 8, 10), v);

    v = v1.addScalar(14);
    try expectEqual(Vector3.init(15, 16, 17), v);

    v = v1.subtract(v2);
    try expectEqual(Vector3.init(-4, -4, -4), v);

    v = v1.subtractScalar(-4);
    try expectEqual(Vector3.init(5, 6, 7), v);

    v = v1.multiply(v2);
    try expectEqual(Vector3.init(5, 12, 21), v);

    v = v1.multiplyScalar(-4);
    try expectEqual(Vector3.init(-4, -8, -12), v);

    v = v1.divide(v2);
    try expectApproxEqRel(@as(f32, 1.0/5.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/6.0), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/7.0), v.z, 0.0001);

    v = v1.divideScalar(2);
    try expectApproxEqRel(@as(f32, 1.0/2.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/2.0), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/2.0), v.z, 0.0001);

    s = Vector3.dot(v1, v2);
    try expectApproxEqRel(@as(f32, 38.0), s, 0.0001);

    s = Vector3.squaredLength(v1);
    try expectApproxEqRel(@as(f32, 14.0), s, 0.0001);

    s = Vector3.length(v1);
    try expectApproxEqRel(@as(f32, 3.742), s, 0.0001);

    v = Vector3.normalize(v1);
    try expectApproxEqRel(@as(f32, 1.0/3.742), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/3.742), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/3.742), v.z, 0.0001);
}